/*
 * uart.c
 *
 * Implementation of UART functionality for the system
 */

#include <stdbool.h>
#include <string.h>
#include <limits.h>
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
dword_t uart_rx_timeout = URX_TIMEOUT_DEFAULT;

/*
 * UART settings
 */

char uart_eol = DEFAULT_UART_EOL;

/*
 * UART buffers
 */

char uart_rx_buf[UART_RX_BUFSZ];
dword_t uart_rx_bufsz;
static bool eol = false;

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
	case UartErrorInvalidArg:
		return "UartErrorInvalidArg";
	default:
		return "UartUnknownError"; // Uh-oh. Shouldn't hit this.
	}
}

int uart_open(uart_dbit dbit, uart_sbit sbit, uart_parity pbit, dword_t baud)
{
	int rc = 0;
	byte_t os_tick = 16;
	byte_t sb_tick;
	word_t dvsr;

	switch (sbit)
	{
	case UART_SBIT_HALF:
		sb_tick = os_tick / 2;
		break;
	case UART_SBIT_ONE:
		sb_tick = os_tick;
		break;
	case UART_SBIT_TWO:
		sb_tick = 2 * os_tick;
		break;
	default:
		rc = UartErrorInvalidArg;
		goto exit;
	}

	dvsr = CLOCK_SPEED_HZ / (os_tick * baud);

	if (0 == dbit)
	{
		rc = UartErrorInvalidArg;
		goto exit;
	}

	alt_printf("uart1_init: dbit=%x pbit=%x sb_tick=%x os_tick=%x dvsr=%x\n", dbit, pbit, sb_tick, os_tick, dvsr);
	uart1_init(dbit, pbit, sb_tick, os_tick, dvsr);
	uart_rx_bufsz = 0;
	eol = false;

exit:

	return rc;
}

void uart_close(uart_flags flags)
{
	uart_flush(flags);
	status_led_off(UTX_STATUS_LED);
	status_led_off(URX_STATUS_LED);
	uart_error = uart1_read_status();
	uart1_shutdown();
}

void uart_flush(uart_flags flags)
{
	if (flags & UART_FLAG_SYNC)
	{
		while ((uart1_read_status() & UART1_STATUS_TX_EMPTY) == 0);
	}

	uart_error = uart1_read_status();
}

int uart_sendline(const char* str, uart_flags flags)
{
	int i;
	int len = strlen(str);

	status_led_off(URX_STATUS_LED);
	status_led_on(UTX_STATUS_LED);

	if (flags & UART_FLAG_SYNC)
	{
		// Determine if the transmitter has stopped sending before sending another one
		while ((uart1_read_status() & UART1_STATUS_TX_EMPTY) == 0)
		{
			nop();
		}
	}

	for (i = 0; i < len; ++i)
	{
		uart1_tx(str[i]);
	}

	// Set the synchronous RX timeout
	tc_set_max(TC_URX_COUNTER, 1000000U / CLOCK_PERIOD_NS);
	uart_error = uart1_read_status();
	return len;
}

int uart_readline(char* str, dword_t bufsz, uart_flags flags)
{
	int rc = 0;

	status_led_off(UTX_STATUS_LED);
	status_led_on(URX_STATUS_LED);

	if (flags & UART_FLAG_SYNC)
	{
		// Set the synchronous timeout.
		tc_set_max(TC_URX_COUNTER, 1000000U / CLOCK_PERIOD_NS);
	}

	for (;;)
	{
		if (eol)
		{
			if (uart_rx_bufsz > 0)
			{
				int size = uart_rx_bufsz;
				if (size > bufsz - 1)
				{
					size = bufsz - 1;
				}

				// We found EOL in the last loop, so copy our buffer out and reset it.
				memset(str, 0, bufsz);
				strncpy(str, uart_rx_buf, size);
			}

			// Reset the UART status
			eol = false;
			rc = uart_rx_bufsz;
			uart_rx_bufsz = 0;
			memset(uart_rx_buf, 0, UART_RX_BUFSZ);
			break;
		}
		else if (!(uart1_read_status() & UART1_STATUS_RX_EMPTY))
		{
			if (UART_RX_BUFSZ == uart_rx_bufsz)
			{
				// Overflow condition
				eol = true;
				continue;
			}

			// Read a character
			uart_rx_buf[uart_rx_bufsz] = uart1_rx();
			if (uart_rx_buf[uart_rx_bufsz] == uart_eol)
			{
				eol = true;
			}

			++uart_rx_bufsz;
			if (eol)
			{
				// Were done
				continue;
			}

			rc = UartErrorRxBusy;
		}
		else if (tc_get_ticks(TC_URX_COUNTER) > uart_rx_timeout)
		{
			// Timeout condition.
			rc = UartErrorTimeout;
			break;
		}
		else if (!(flags & UART_FLAG_SYNC))
		{
			// Coroutine returns to caller.
			break;
		}
		else
		{
			nop();
		}
	}

	uart_error = uart1_read_status();
	return rc;
}
