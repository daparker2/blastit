/* 
 * Controller entry point.
 * 
 * Implements OBD2 gauge controller state machine.
 *
 */

#include "sys/alt_stdio.h"
#include "system.h"
#include "altera_avalon_pio_regs.h"
#include "controller_system.h"
#include "controller.h"
#include "obd2.h"
#include "display.h"
#include <stdbool.h>
#include <string.h>

#define REGW(X, Y) IOWR_ALTERA_AVALON_PIO_DATA(X, Y)

// Comment this out for normal functionality
#define TEST

/*
 * Timer counter support
 */

#define TC_TICK_COUNTER Tc1
#define TC_FRAME_COUNTER Tc2

/*
 * UART support
 */

char uart_tx_buf[UART_TX_BUFSZ], uart_rx_buf[UART_RX_BUFSZ];
dword_t uart_tx_bufsz, uart_rx_bufsz;
char* rx_ptr;

// Reset the UART buffers
void uart_bufclr(void);

static void init();
static void shutdown();
#ifdef TEST
static void test();
#endif // TEST

int main()
{
	init();
	alt_putstr("Entering event loop\n");
#ifdef TEST
	test();
#else
//	for (;;)
//	{
//		if (is_frame())
//		{
//			display_update();
//		}
//		else if (obd2_update())
//		{
//			// Send the response and clear the RX and TX buf
//			char* tx_ptr = uart_tx_buf;
//			while (*tx_ptr)
//			{
//				uart1_tx(*tx_ptr++);
//			}
//
//			uart_bufclr();
//		}
//		else
//		{
//			// Update the RX buf
//			int ch = uart1_rx();
//			if (ch > 0)
//			{
//				if (!(rx_ptr < uart_rx_buf + UART_RX_BUFSZ - 1))
//				{
//					// The response was too big so we aren't able to parse it.
//					uart_bufclr();
//				}
//
//				*rx_ptr++ = ch;
//				++uart_rx_bufsz;
//			}
//			else
//			{
//				wait_tick(1);
//			}
//		}
//	}
#endif // TEST

	alt_putstr("Shutting down\n");
	shutdown();
	return 0;
}

void wait_tick(dword_t ticks)
{
	if (ticks > 0)
	{
		tc_reset(TC_TICK_COUNTER);
		do
		{
			nop();
		}
		while (tc_get_ticks(TC_TICK_COUNTER) < ticks);
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
	uart_rx_bufsz = 0;
	rx_ptr = uart_rx_buf;
}

void init()
{
	bcd_init();
	sseg_init();
	leds_init();
	tc_init();
	warn_init();

	// Should give us 115200 baud
	uart1_init(8, 0, 48, 48, 8);
	uart_bufclr();

	// Configure the timer counters TC1 and TC2 for tick and frame, respectively
	tc_set_max(TC_TICK_COUNTER, CLOCK_MILLIS_TO_TICKS(1)); // 1 ms per tick
	tc_set_max(TC_FRAME_COUNTER, CLOCK_MILLIS_TO_TICKS(8)); // 8 ms per tick

#ifndef TEST
	obd2_init();
	display_init();
#endif // TEST
}

void shutdown()
{
	static const dword_t ResetTicks = CLOCK_MILLIS_TO_TICKS(5000);

#ifndef TEST
	obd2_shutdown();
	display_shutdown();
#endif // TEST

	// Shutdown everything and go into a low power state for a few MS.
	bcd_shutdown();
	sseg_shutdown();
	leds_shutdown();
	tc_shutdown();
	warn_shutdown();
	uart1_shutdown();
	rc_reset(ResetTicks);
}

void test()
{
	dword_t i;
	dword_t status = 0;
	bool daylight = false;

	// Dan's test function
	warn_set_brightness(WARN_BRIGHTNESS_MAX >> 4);
	warn_set_en(true);

	status_led_en(STATUS_LED_0 | STATUS_LED_1 | STATUS_LED_2 | STATUS_LED_3);

	leds_set_brightness(LEDS_BRIGHTNESS_MAX);
	for (i = 0; i < LEDS_MAX; ++i)
	{
		leds_enable_led(i, true);
	}

	sseg_set_brightness(SSEG_BRIGHTNESS_MAX);
	for (i = 0; i < SSEG_MAX; ++i)
	{
		sseg_set_bcd(i, SSEG_VAL_EN | SSEG_DP, i);
	}

	uart1_tx('a'); uart1_tx('t'); uart1_tx('i'); uart1_tx('\r');

	for (;;)
	{
		bool new_daylight = is_daylight();
		int ch;
		dword_t new_status;
		bool rd = false;

		if (daylight != new_daylight)
		{
			daylight = new_daylight;
			if (daylight)
			{
				alt_putstr("daylight\n");
			}
			else
			{
				alt_putstr("not daylight\n");
			}
		}

		if ((new_status = uart1_read_status()) != status)
		{
			status = new_status;
			alt_printf("UART status: %x\n", status);
		}

		while ((ch = uart1_rx()) > 0)
		{
			alt_putchar(ch);
			rd = true;
		}

		if (rd)
		{
			alt_putstr("\n");
		}

		wait_tick(10);
	}
}
