/*
 * uart.c
 *
 * Implementation of UART functionality for the system
 */

#include <stdbool.h>
#include <string.h>
#include "sys/alt_stdio.h"
#include "system.h"
#include "altera_avalon_pio_regs.h"
#include "controller_system.h"
#include "controller.h"
#include "uart.h"

/*
 * UART status
 */

// This stores the last UART error, or OK
UartError uart_error = UartReady;
dword_t uart_status = 0;

/*
 * UART settings
 */

char uart_eol = DEFAULT_UART_EOL;
dword_t uart_timeout_clocks = DEFAULT_UART_TIMEOUT_CLOCKS;

/*
 * UART buffers
 */

char uart_tx_buf[UART_TX_BUFSZ], uart_rx_buf[UART_RX_BUFSZ];
dword_t uart_tx_bufsz, uart_rx_bufsz;
static char *uart_next_tx, *uart_cur_rx;

/*
 * UART coroutine support
 */

static dword_t uart_tx_clocks, uart_rx_clocks;

/*
 * UART functions
 */

const char* uart_etos(UartError error)
{
	switch (error)
	{
	case UartReady:
		return "UartReady";
	case UartErrorTxBusy:
		return "UartErrorTxBusy";
	case UartErrorRxBusy:
		return "UartErrorRxBusy";
	case UartErrorTimeout:
		return "UartErrorTimeout";
	case UartErrorRemaining:
		return "UartErrorRemaining";
	case UartErrorBufferOverflow:
		return "UartErrorBufferOverflow";
	default:
		return "UartUnknownError"; // Uh-oh. Shouldn't hit this.
	}
}

void uart_bufclr(void)
{
	memset(uart_rx_buf, 0, UART_RX_BUFSZ);
	memset(uart_tx_buf, 0, UART_TX_BUFSZ);
	uart_rx_bufsz = uart_tx_bufsz = 0;
	uart_next_tx = uart_cur_rx = 0;
	uart_tx_clocks = uart_rx_clocks = uart_timeout_clocks;
	uart1_reset();
}

int uart_putstr(const char* str)
{
	status_led_on(UTX_STATUS_LED);
	uart_error = UartReady;

	if (uart_tx_bufsz > 0)
	{
		uart_error = UartErrorTxBusy;
		return uart_error;
	}

	uart_tx_bufsz = strlen(str);
	if (uart_tx_bufsz >= UART_TX_BUFSZ)
	{
		uart_tx_bufsz = 0;
		uart_error = UartErrorBufferOverflow;
		return uart_error;
	}

	memset(uart_tx_buf, 0, UART_TX_BUFSZ);
	strcpy(uart_tx_buf, str);
	uart_tx_clocks = uart_timeout_clocks;
	uart_next_tx = &uart_tx_buf[0];

	return uart_error;
}

int uart_start_getline()
{
	memset(uart_rx_buf, 0, UART_RX_BUFSZ);
	uart_tx_clocks = uart_timeout_clocks;
	uart_cur_rx = &uart_rx_buf[0];
	uart_error = UartReady;
	return uart_error;
}

int uart_end_getline(char** str)
{
	uart_error = UartReady;

	if (*uart_cur_rx == uart_eol)
	{
		*str = uart_rx_buf;
	}
	else if (uart_timeout_clocks == 0)
	{
		uart_error = UartErrorTimeout;
		return uart_error;
	}
	else
	{
		uart_error = UartErrorRxBusy;
		return uart_error;
	}

	return uart_error;
}

// This just wraps start/get endline in a blocking mode
int uart_getline(char** str)
{
	int error;

	*str = 0;
	error = uart_start_getline();

	if (UartReady == error)
	{
		do
		{
			uart_update();
			error = uart_end_getline(str);
		}
		while (error == UartErrorRxBusy);
	}

	return error;
}

int uart_update()
{
	// Read UART status
	dword_t status = uart1_read_status();
	UartError txError = UartReady, rxError = UartReady;

	if (status != uart_status)
	{
#ifdef UART_DEBUG
		//uart1_print_status(status);
#endif // UART_DEBUG
		uart_status = status;
	}

	// TX update
	if (uart_tx_bufsz > 0)
	{
		if (uart_tx_clocks > 0)
		{
			--uart_tx_clocks;
		}
		else
		{
			txError = UartErrorTimeout;
		}

		if (txError == UartReady)
		{
			if (uart_status & UART1_STATUS_TX_READY)
			{
#ifdef UART_DEBUG
				char buf[2] = { *uart_next_tx, 0 };
				alt_putstr(buf);
#endif // UART_DEBUG

				uart1_tx(*uart_next_tx++);
				wait_tick(100); // This is a hack. Something is wrong with the transmitter. :(
				--uart_tx_bufsz;
			}
			else
			{
				txError = UartErrorTxBusy;
			}
		}
	}

	// RX update
	if (uart_rx_bufsz < UART_RX_BUFSZ - 1)
	{
		if (uart_rx_clocks > 0)
		{
			--uart_rx_clocks;
		}
		else
		{
			rxError = UartErrorTimeout;
		}

		if (rxError == UartReady)
		{
			if (uart_status & UART1_STATUS_RX_READY)
			{
				++uart_rx_bufsz;
				++uart_cur_rx;
				*uart_cur_rx = uart1_rx();
				wait_tick(100); // This is a hack. Something is wrong with the transmitter. :(

#ifdef UART_DEBUG
				char buf[2] = { *uart_cur_rx, 0 };
				alt_putstr(buf);
#endif // UART_DEBUG
			}

			if (*uart_cur_rx != uart_eol)
			{
				rxError = UartErrorRxBusy;
			}
		}
	}
	else
	{
		rxError = UartErrorBufferOverflow;
	}

	if (0 == uart_rx_bufsz)
	{
		status_led_off(URX_STATUS_LED);
	}
	else
	{
		status_led_on(URX_STATUS_LED);
	}

	if (0 == uart_tx_bufsz)
	{
		status_led_off(UTX_STATUS_LED);
	}

	uart_error = (txError > rxError) ? txError : rxError;
	return uart_error;
}

int uart_flush()
{
	int error = UartReady;

	// Loop until RX and TX buffers are empty or we timeout.
	// If we can't empty them in time, set a timeout status.
	while ((uart_tx_bufsz > 0 || uart_tx_bufsz > 0) && (uart_tx_clocks > 0 || uart_rx_clocks > 0))
	{
		error = uart_update();
	}

	return error;
}
