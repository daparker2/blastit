/*
 * test.c
 *
 * Firmware test panel
 *
 */

#include "sys/alt_stdio.h"
#include "system.h"
#include "altera_avalon_pio_regs.h"
#include "controller_system.h"
#include "controller.h"
#include "uart.h"
#include "obd2.h"
#include "display.h"
#include <stdbool.h>
#include <string.h>

#ifdef TEST
void test()
{
	dword_t i, j, k, l;
	dword_t status = 0;
	dword_t new_status;
	bool daylight = false;
	bool sent = false;
	const char test[] = "ati\r";
	char test_rx[(1 << 8)] = {};
	byte_t bcd_out[BCD_MAX] = {};

	// Dan's test function
	warn_set_brightness(WARN_BRIGHTNESS_MAX >> 4);
	warn_set_en(true);

	status_led_en(STATUS_LED_0 | STATUS_LED_1 | STATUS_LED_2 | STATUS_LED_3);

	leds_set_brightness(LedArray1, LEDS_BRIGHTNESS_MAX);
	leds_set_brightness(LedArray2, LEDS_BRIGHTNESS_MAX);
	for (i = 0; i < LEDS_MAX; ++i)
	{
		leds_enable_led(LedArray1, i, true);
		leds_enable_led(LedArray2, i, true);
	}

	sseg_set_brightness(SSEG_BRIGHTNESS_MAX);
	for (i = 0; i < SSEG_MAX; ++i)
	{
		sseg_set_bcd(i, SSEG_VAL_EN | SSEG_DP, i);
	}

	wait_tick(1000);

	if ((new_status = uart1_read_status()) != status)
	{
		status = new_status;
		uart1_print_status(status);
	}

	bcd_convert(1234, bcd_out);
	alt_printf("1234 -> %x %x %x %x\n", bcd_out[0], bcd_out[1], bcd_out[2], bcd_out[3]);
	bcd_convert(-1234, bcd_out);
	alt_printf("-1234 -> -%x %x %x %x\n", bcd_out[0], bcd_out[1], bcd_out[2], bcd_out[3]);

	i = 0;
	k = 0;
	for (;;)
	{
		bool new_daylight = is_daylight();

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

		if (i % 2 == 0)
		{
			status_led_en(STATUS_LED_0 | STATUS_LED_2);

			for (j = 0; j < LEDS_MAX; ++j)
			{
				leds_enable_led(LedArray1, j, (j % 2) == 0);
				leds_enable_led(LedArray2, j, (j % 2) == 0);
			}

			for (j = 0; j < SSEG_MAX; ++j)
			{
				sseg_set_bcd(j, SSEG_VAL_EN | SSEG_DP, i);
			}
		}
		else
		{
			status_led_en(STATUS_LED_1 | STATUS_LED_3);

			for (j = 0; j < LEDS_MAX; ++j)
			{
				leds_enable_led(LedArray1, j, (j % 2) != 0);
				leds_enable_led(LedArray2, j, (j % 2) != 0);
			}

			for (j = 0; j < SSEG_MAX; ++j)
			{
				if (j % 2 == 0)
				{
					sseg_set_bcd(j, SSEG_VAL_EN | SSEG_SIGN, 0);
				}
				else
				{
					sseg_set_bcd(j, 0, 0);
				}
			}
		}

		if (!sent)
		{
			sent = true;
			alt_printf("tx -> %s\n", test);
			for (l = 0; l < strlen(test); ++l)
			{
				if ((new_status = uart1_read_status()) != status)
				{
					status = new_status;
					uart1_print_status(status);
				}

				uart1_tx(test[l]);

				if ((new_status = uart1_read_status()) != status)
				{
					status = new_status;
					uart1_print_status(status);
				}
			}
		}

		wait_tick(250);

		if (sent)
		{
			while (uart1_read_status() & UART1_STATUS_RX_READY)
			{
				test_rx[k] = uart1_rx();
				if ((new_status = uart1_read_status()) != status)
				{
					status = new_status;
					uart1_print_status(status);
				}

				if (test_rx[k] == '\r')
				{
					alt_printf("rx -> %s\n", test_rx);
					k = 0;
					break;
				}

				++k;
			}

			sent = false;
		}

		++i;
	}
}

#endif // TEST
