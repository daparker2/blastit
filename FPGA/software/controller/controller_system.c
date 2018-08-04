/*
 * controller_system.c
 *
 * Definitions fro system routines for the soft MCU. Mostly contains C
 * implementations of testbench functionality.
 *
 */

#include "sys/alt_stdio.h"
#include "altera_avalon_pio_regs.h"
#include "controller_system.h"
#include "system.h"

#define REGW(X, Y) IOWR_ALTERA_AVALON_PIO_DATA(X, Y)
#define REGR(X) IORD_ALTERA_AVALON_PIO_DATA(X)

#define _min(X,Y) (((X) < (Y)) ? (X) : (Y))

static const dword_t TcMMap[] =
{
	TC1_M_BASE,
	TC2_M_BASE,
	TC3_M_BASE,
	TC4_M_BASE
};

static const dword_t TcStatusMap[] =
{
	TC1_STATUS_BASE,
	TC2_STATUS_BASE,
	TC3_STATUS_BASE,
	TC4_STATUS_BASE
};

static const dword_t TcResetMap[] =
{
	TC1_STATUS_BASE,
	TC2_STATUS_BASE,
	TC3_STATUS_BASE,
	TC4_STATUS_BASE
};

void bcd_convert(dword_t bin, byte_t bcd[BCD_MAX])
{
	dword_t orig_control = REGR(BCD1_CONTROL_BASE);
	REGW(BCD1_BIN_BASE, bin);
	REGW(BCD1_CONTROL_BASE, orig_control | BCD1_CONTROL_START);
	nop();
	REGW(BCD1_CONTROL_BASE, orig_control);
	while (!(REGR(BCD1_STATUS_BASE) & BCD1_STATUS_READY));
	dword_t t = REGR(BCD1_BCD_BASE);
	bcd[0] = t & 0xf;
	bcd[1] = t & 0xf0;
	bcd[2] = t & 0xf00;
	bcd[3] = t & 0xf000;
}

void bcd_init(void)
{
	// Reset BCD and TC and wait for ready to go high
	REGW(BCD1_CONTROL_BASE, 0x0);
	nop();
	REGW(BCD1_CONTROL_BASE, BCD1_CONTROL_TC_RESET | BCD1_CONTROL_RESET);
	nop();
	while (!(REGR(BCD1_STATUS_BASE) & BCD1_STATUS_READY));
}

void bcd_shutdown(void)
{
	REGW(BCD1_CONTROL_BASE, 0);
}

bool is_daylight(void)
{
	return REGR(DAYLIGHT_BASE) > 0;
}

void leds_set_brightness(byte_t brightness)
{
	REGW(LEDS_BRIGHTNESS_BASE, brightness);
}

void leds_enable_led(dword_t addr, bool en)
{
	dword_t wr_val = LEDS_CONTROL_SEL | (en ? LEDS_CONTROL_EN : 0) | (addr & LEDS_ADDR_MASK);
	REGW(LEDS_WR_VAL_BASE, wr_val);
	nop();
	REGW(LEDS_WR_VAL_BASE, 0);
	nop();
}

void leds_init(void)
{
	int i;
	REGW(LEDS_RESET_CONTROL_BASE, 0);
	nop();
	REGW(LEDS_RESET_CONTROL_BASE, LEDS_COUNTER_EN | LEDS_EN);
	nop();

	for (i = 0; i < LEDS_MAX; ++i)
	{
		leds_enable_led(i, false);
	}
}

void leds_shutdown(void)
{
	REGW(LEDS_RESET_CONTROL_BASE, 0);
}

void sseg_set_brightness(byte_t brightness)
{
	REGW(SSEG_BRIGHTNESS_BASE, brightness);
}

void sseg_init(void)
{
	dword_t i;

	REGW(SSEG_RESET_CONTROL_BASE, 0);
	nop();
	REGW(SSEG_RESET_CONTROL_BASE, SSEG_COUNTER_EN | SSEG_EN);
	nop();

	for (i = 0; i < SSEG_MAX; ++i)
	{
		sseg_set_bcd(i, 0, 0);
	}
}

void sseg_shutdown(void)
{
	REGW(SSEG_RESET_CONTROL_BASE, 0);
}

void sseg_set_bcd(dword_t addr, dword_t flags, dword_t val)
{
	dword_t command = SSEG_WR | ((addr & SSEG_SEL_MASK) << SSEG_SEL_IDX) | flags | (val & SSEG_VAL_MASK);
	REGW(SSEG_WR_VAL_BASE, command);
	nop();
	REGW(SSEG_WR_VAL_BASE, 0);
	nop();
}

void status_led_en(dword_t mask)
{
	REGW(STATUS_LED_EN_BASE, mask);
}

void tc_set_max(TcArray tc, dword_t m)
{
	dword_t orig = REGR(TC_RESET_CONTROL_BASE);
	REGW(TC_RESET_CONTROL_BASE, orig & ~TcResetMap[tc]);
	REGW(TcMMap[tc], m);
	nop();
	REGW(TC_RESET_CONTROL_BASE, orig | TcResetMap[tc]);
}

dword_t tc_get_ticks(TcArray tc)
{
	return REGR(TcStatusMap[tc]) & 0xffffff;
}

bool tc_get_of(TcArray tc)
{
	return (REGR(TcStatusMap[tc]) & TC_STATUS_OF) != 0;
}

void tc_reset(TcArray tc)
{
	dword_t orig = REGR(TC_RESET_CONTROL_BASE);
	REGW(TC_RESET_CONTROL_BASE, orig & ~TcResetMap[tc]);
	nop();
	REGW(TC_RESET_CONTROL_BASE, orig | TcResetMap[tc]);
	nop();
}

void tc_init(void)
{
	REGW(TC_RESET_CONTROL_BASE, 0);
	nop();
	REGW(TC_RESET_CONTROL_BASE, TC_EN_TC1 | TC_EN_TC2 | TC_EN_TC3 | TC_EN_TC4);
	nop();
}

void tc_shutdown(void)
{
	REGW(TC_RESET_CONTROL_BASE, 0);
}

void uart1_init(byte_t dbit, byte_t pbit, byte_t sb_tick, byte_t os_tick, word_t dvsr)
{
	dword_t baud = ((dbit & 0xf) << 18) | ((pbit & 0x3) << 16) | (sb_tick << 8) | (os_tick << 0);
	REGW(UART1_RESET_CONTROL_BASE, 0);
	nop();
	REGW(UART1_RESET_CONTROL_BASE, UART1_EN | UART1_EN_TX_TC | UART1_EN_RX_TC);
	REGW(UART1_BAUD_CONTROL_BASE, baud);
	REGW(UART1_DVSR_BASE, dvsr);
	nop();
}

void uart1_shutdown(void)
{
	REGW(UART1_RESET_CONTROL_BASE, 0);
}

int uart1_rx(void)
{
	if ((REGR(UART1_STATUS_CONTROL_BASE) & UART1_STATUS_RX_EMPTY) == 0)
	{
		REGW(UART1_WR_CONTROL_BASE, UART1_WR_CONTROL_RD);
		nop();
		REGW(UART1_WR_CONTROL_BASE, 0);
		return REGR(UART1_R_DATA_BASE);
	}

	return -1;
}

void uart1_tx(char data)
{
	while ((REGR(UART1_STATUS_CONTROL_BASE) & UART1_STATUS_TX_FULL) != 0);
	REGW(UART1_W_DATA_BASE, data);
	REGW(UART1_WR_CONTROL_BASE, UART1_WR_CONTROL_WR);
	nop();
	REGW(UART1_WR_CONTROL_BASE, 0);
}

dword_t uart1_read_status(void)
{
	return REGR(UART1_STATUS_CONTROL_BASE);
}

void warn_set_brightness(byte_t brightness)
{
	REGW(WARN_PWM_BRIGHTNESS_BASE, brightness);
}

void warn_set_en(bool en)
{
	dword_t orig = REGR(WARN_PWM_CONTROL_BASE);
	REGW(WARN_PWM_CONTROL_BASE, orig | (en ? WARN_PWM_CONTROL_EN1 : 0));
}

void warn_init(void)
{
	REGW(WARN_PWM_CONTROL_BASE, 0);
	nop();
	REGW(WARN_PWM_CONTROL_BASE, WARN_PWM_CONTROL_EN2);
	nop();
}

void warn_shutdown(void)
{
	REGW(WARN_PWM_CONTROL_BASE, 0);
}

void rc_reset(dword_t counts)
{
	if (counts > 0)
	{
		REGW(RC1_CONTROL_BASE, RC_CONTROL_START | (counts & (1 << (RC_M_BITS - 1))));
		for (;;); // Bye. See you next time!
	}
}
