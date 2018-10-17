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

static void init();
#ifndef TEST
static void coroutine_entry();
#endif // TEST
static void shutdown();

int main() {
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

void wait_tick(dword_t ticks) {
	if (ticks > 0) {
		dword_t start = tc_get_ticks(TC_TICK_COUNTER);
		dword_t end = start + ticks;
		if (end < start) {
			// Overflow wrap
			while (tc_get_ticks(TC_TICK_COUNTER) < TC_MAX) {
				nop();
			}
		}

		while (tc_get_ticks(TC_TICK_COUNTER) < end) {
			nop();
		}
	}
}

bool is_frame() {
	// Meant to be called once per event loop iteration, otherwise you will see weird behavior.
	dword_t frame = tc_get_ticks(TC_FRAME_COUNTER);
	if (frame > 0) {
		tc_reset(TC_FRAME_COUNTER);
		return true;
	} else {
		return false;
	}
}

void init() {
	int rc;

	led_set_period(8000);
	status_led_enable(true);
	bcd_init();
	sseg_init();
	leds_init(LedArray1);
	leds_init(LedArray2);
	tc_init();
	warn_init();

	// Configure the timer counters for the controller
	tc_set_max(TC_TICK_COUNTER, 1000000U / CLOCK_PERIOD_NS); // 1 ms per tick
	tc_set_max(TC_FRAME_COUNTER, 8000000U / CLOCK_PERIOD_NS); // 8 ms per tick

	// The OBD2 UART is 3.3v, 115200, 8 data, 1 stop, no parity check
	rc = uart_open(UART_DBIT_8, UART_SBIT_ONE, UART_PARITY_NONE, 115200);
	if (0 > rc) {
		alt_printf("uart_config failed: %d (%s)\n", rc, uart_etos(rc));
	}

	status_led_on(POWER_STATUS_LED);

#ifndef TEST
	// Init business logic coroutines.
	obd2_init();
#endif // TEST
}

void shutdown() {
	static const dword_t ResetTicks = CLOCK_MILLIS_TO_TICKS(5000);

#ifndef TEST
	// Shutdown business logic coroutines.
	obd2_shutdown();
#endif // TEST
	// Shutdown everything and go into a low power state for a few thousand MS.
	bcd_shutdown();
	sseg_shutdown();
	leds_shutdown(LedArray2);
	leds_shutdown(LedArray1);
	tc_shutdown();
	warn_shutdown();
	uart_close(UART_FLAG_SYNC);
	status_led_off(STATUS_LED_0 | STATUS_LED_1 | STATUS_LED_2 | STATUS_LED_3);
	status_led_enable(false);
	rc_reset(ResetTicks);
}

#ifndef TEST

void coroutine_entry() {
	// Entry point for coroutine manager.

	bool display_initialized = false;

	for (;;) {
		// OBD2 update.
		if (!obd2_update()) {
			alt_putstr("Terminating coroutines based on OBD2 state.\n");
			break;
		}

		if (Obd2StateReset == obd2_state) {

		} else {
			if (!display_initialized) {
				display_initialized = true;
				status_led_on(OBD2_STATUS_LED);
				display_init();
			}

			if (is_frame()) {
				display_update();
			}
		}

		wait_tick(1);
	}
}

#endif // TEST
