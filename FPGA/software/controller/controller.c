/* 
 * Controller entry point.
 * 
 * Implements OBD2 gauge controller state machine.
 *
 */

#include "sys/alt_stdio.h"
#include "controller_system.h"
#include "obd2.h"
#include "display.h"
#include <stdbool.h>
#include <string.h>

/*
 * Timer counter support
 */

#define TC_TICK_COUNTER Tc1
#define TC_FRAME_COUNTER Tc2

void wait_tick(dword_t ticks); // Wait for ticks
bool is_frame();               // Determine if we have entered a frame interval

/*
 * UART support
 */

#define UART_TX_BUFSZ (1 << 8)
#define UART_RX_BUFSZ (1 << 8)

static char uart_tx_buf[UART_TX_BUFSZ], uart_rx_buf[UART_RX_BUFSZ];
char* rx_ptr;

// Reset the UART buffers
void uart_bufclr(void);

int main()
{
	bcd_init();
	sseg_init();
	tc_init();
	warn_init();

	// Configure UART for 9600 baud
	uart1_init(8, 1, 8, 8, 651);

	// Configure the timer counters TC1 and TC2 for tick and frame, respectively
	tc_set_max(TC_TICK_COUNTER, CLOCK_MILLIS_TO_TICKS(1)); // 1 ms per tick
	tc_set_max(TC_FRAME_COUNTER, CLOCK_MILLIS_TO_TICKS(8)); // 8 ms per tick

	// Initialize the OBD2 state machine and display
	uart_bufclr();
	obd2_init(uart_rx_buf, UART_RX_BUFSZ, uart_tx_buf, UART_TX_BUFSZ);
	memset(&display_params, 0, sizeof(display_params));

	alt_putstr("Entering event loop\n");
	for (;;)
	{
		if (is_frame())
		{
			display_update();
		}
		else if (obd2_update())
		{
			// Send the response and clear the RX and TX buf
			char* tx_ptr = uart_tx_buf;
			while (*tx_ptr)
			{
				uart1_tx(*tx_ptr++);
			}

			uart_bufclr();
		}
		else
		{
			// Update the RX buf
			int ch = uart1_rx();
			if (ch > 0)
			{
				if (rx_ptr >= uart_rx_buf + UART_RX_BUFSZ)
				{
					// The response was too big so we aren't able to parse it.
					uart_bufclr();
				}

				*rx_ptr++ = ch;
			}
			else
			{
				wait_tick(1);
			}
		}
	}

	return 0;
}

void wait_tick(dword_t ticks)
{
	if (ticks > 0)
	{
		dword_t end = tc_get_ticks(TC_TICK_COUNTER) + ticks;
		do
		{
			nop();
		}
		while (tc_get_ticks(TC_TICK_COUNTER) < end);
	}
}

bool is_frame()
{
	// Meant to be called once per event loop iteration, otherwise you will see weird behavior.
	dword_t frame = tc_get_ticks(TC_FRAME_COUNTER);
	if (frame > 0)
	{
		tc_reset(TC_FRAME_COUNTER);
		return true;
	}
	else
	{
		return false;
	}
}

void uart_bufclr(void)
{
	memset(uart_rx_buf, 0, UART_RX_BUFSZ);
	memset(uart_tx_buf, 0, UART_TX_BUFSZ);
	rx_ptr = uart_rx_buf;
}
