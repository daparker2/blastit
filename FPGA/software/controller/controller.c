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
#include "uart.h"
#include "obd2.h"
#include "display.h"
#include <stdbool.h>
#include <string.h>

// Comment this out for normal functionality
//#define TEST

static void init();
static void coroutine_entry();
static void shutdown();

int main()
{
	init();

	alt_putstr("Entering event loop\n");

#ifdef TEST
	test();
#else
	coroutine_entry();
#endif // TEST

	alt_putstr("Shutting down\n");
	shutdown();
	return 0;
}

void wait_tick(dword_t ticks)
{
	if (ticks > 0)
	{
		dword_t start = tc_get_ticks(TC_TICK_COUNTER);
		dword_t end = start + ticks;
		if (end < start)
		{
			// Overflow wrap
			while (tc_get_ticks(TC_TICK_COUNTER) < TC_MAX)
			{
				nop();
			}
		}

		while (tc_get_ticks(TC_TICK_COUNTER) < end)
		{
			nop();
		}
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

void init()
{
	led_set_period(8000);
	bcd_init();
	sseg_init();
	leds_init();
	tc_init();
	warn_init();

	// The OBD2 UART is 3.3v, 115200, 8 data, 1 stop, no parity check
	uart1_init(8, 0, 32, 32, 13);
	uart_bufclr();

	// Configure the timer counters TC1 and TC2 for tick and frame, respectively
	tc_set_max(TC_TICK_COUNTER, 1000000U / CLOCK_PERIOD_NS); // 1 ms per tick
	tc_set_max(TC_FRAME_COUNTER, 8000000U / CLOCK_PERIOD_NS); // 8 ms per tick

	// Init business logic coroutines.
	obd2_init();
}

void shutdown()
{
	static const dword_t ResetTicks = CLOCK_MILLIS_TO_TICKS(5000);

	// Shutdown business logic coroutines.
	obd2_shutdown();

	// Shutdown everything and go into a low power state for a few thousand MS.
	bcd_shutdown();
	sseg_shutdown();
	leds_shutdown();
	tc_shutdown();
	warn_shutdown();
	uart1_shutdown();
	rc_reset(ResetTicks);
}

void coroutine_entry()
{
	// Entry point for coroutine manager.

	bool display_initialized = false;

	for (;;)
	{
		// OBD2 update.
		if (!obd2_update())
		{
			alt_putstr("Terminating coroutines based on OBD2 state.\n");
			break;
		}

		if (Obd2StateReset == obd2_state)
		{

		}
		else
		{
			if (!display_initialized)
			{
				display_initialized = true;

				// Turn on the display.
			}

			if (is_frame())
			{
				// Update the display.
			}
		}

		wait_tick(1);
	}
}
