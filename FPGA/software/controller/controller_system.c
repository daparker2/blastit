/*
 * controller_system.c
 *
 * Definitions fro system routines for the soft MCU. Mostly contains C
 * implementations of testbench functionality.
 *
 */

#include "altera_avalon_pio_regs.h"
#include "controller_system.h"
#include "system.h"

#define REGW(X, Y) IOWR_ALTERA_AVALON_PIO_DATA(X, Y)
#define REGR(X) IORD_ALTERA_AVALON_PIO_DATA(X)

#define _min(X,Y) (((X) < (Y)) ? (X) : (Y))

static const dword_t LedsBrightnessMap[] =
{
		LEDS_AFR_BRIGHTNESS_BASE,
		LEDS_BOOST_BRIGHTNESS_BASE
};

static const dword_t LedsControlMap[] =
{
		LEDS_AFR_CONTROL_BASE,
		LEDS_BOOST_CONTROL_BASE
};

static const dword_t LedsAddrMap[] =
{
		LEDS_AFR_SEL_ADDR_BASE,
		LEDS_BOOST_SEL_ADDR_BASE
};

static const dword_t SsegBrightnessMap[] =
{
	SSEG_BRIGHTNESS_AFR_BASE,
	SSEG_BRIGHTNESS_BOOST_BASE,
	SSEG_BRIGHTNESS_OIL_BASE,
	SSEG_BRIGHTNESS_COOLANT_BASE
};

static const dword_t SsegWrMap[] =
{
	SSEG_WR_CONTROL_AFR,
	SSEG_WR_CONTROL_BOOST,
	SSEG_WR_CONTROL_OIL,
	SSEG_WR_CONTROL_COOLANT
};

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

void nop(void)
{
	__asm__ ("nop");
}

void delay(dword_t n)
{
	dword_t i;
	for (i = 0; i < _min(1, n >> 1); ++i)
	{
		__asm__ ("nop");
	}
}

void bcd_convert(dword_t bin, byte_t bcd[BCD_MAX])
{
	REGW(BCD1_BIN_BASE, bin);
	REGW(BCD1_CONTROL_BASE, BCD1_CONTROL_START);
	nop();
	REGW(BCD1_CONTROL_BASE, 0x0);
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
	REGW(BCD1_CONTROL_BASE, BCD1_CONTROL_TC_RESET | BCD1_CONTROL_RESET);
	nop();
	REGW(BCD1_CONTROL_BASE, 0x0);
	while (!(REGR(BCD1_STATUS_BASE) & BCD1_STATUS_READY));
}

void bcd_shutdown(void)
{
	REGW(BCD1_CONTROL_BASE, BCD1_CONTROL_TC_RESET | BCD1_CONTROL_RESET);
}

bool is_daylight(void)
{
	return REGR(DAYLIGHT_BASE) > 0;
}

void leds_set_brightness(LedArray ledArray, byte_t brightness)
{
	REGW(LedsBrightnessMap[ledArray], brightness);
}

void leds_enable_led(LedArray ledArray, dword_t addr, bool en)
{
	REGW(LedsAddrMap[ledArray], addr);
	REGW(LedsControlMap[ledArray], LEDS_CONTROL_SEL | (en ? LEDS_CONTROL_EN : 0));
	nop();
	REGW(LedsControlMap[ledArray], 0);
}

void leds_init(void)
{
	int i;
	REGW(LEDS_RESET_CONTROL_BASE, LEDS_RESET_CONTROL_AFR_COUNTER | LEDS_RESET_CONTROL_BOOST_COUNTER | LEDS_RESET_CONTROL_AFR | LEDS_RESET_CONTROL_BOOST);
	nop();
	REGW(LEDS_RESET_CONTROL_BASE, 0);

	for (i = 0; i < LEDS_MAX; ++i)
	{
		leds_enable_led(LedArrayAfr, i, false);
		leds_enable_led(LedArrayBoost, i, false);
	}
}

void leds_shutdown(void)
{
	REGW(LEDS_RESET_CONTROL_BASE, LEDS_RESET_CONTROL_AFR_COUNTER | LEDS_RESET_CONTROL_BOOST_COUNTER | LEDS_RESET_CONTROL_AFR | LEDS_RESET_CONTROL_BOOST);
}

void sseg_set_brightness(SsegArray ssegArray, byte_t brightness)
{
	REGW(SsegBrightnessMap[ssegArray], brightness);
}

void sseg_init(void)
{
	int i;

	REGW(SSEG_RESET_CONTROL_BASE, SSEG_RESET_CONTROL_TC | SSEG_RESET_CONTROL_COOLANT | SSEG_RESET_CONTROL_OIL | SSEG_RESET_CONTROL_AFR | SSEG_RESET_CONTROL_BOOST);
	nop();
	REGW(SSEG_RESET_CONTROL_BASE, 0);

	for (i = 0; i < SSEG_MAX; ++i)
	{
		sseg_set_bcd(SsegArrayAfr, i, 0);
		sseg_set_bcd(SsegArrayBoost, i, 0);
		sseg_set_bcd(SsegArrayOil, i, 0);
		sseg_set_bcd(SsegArrayCoolant, i, 0);
	}
}

void sseg_shutdown(void)
{
	REGW(SSEG_RESET_CONTROL_BASE, SSEG_RESET_CONTROL_TC | SSEG_RESET_CONTROL_COOLANT | SSEG_RESET_CONTROL_OIL | SSEG_RESET_CONTROL_AFR | SSEG_RESET_CONTROL_BOOST);
}

void sseg_set_bcd(SsegArray ssegArray, dword_t addr, byte_t val)
{
	REGW(SSEG_SEL_ADDR_BASE, addr);
	REGW(SSEG_WR_VAL_BASE, val);
	REGW(SSEG_WR_CONTROL_BASE, SsegWrMap[ssegArray]);
	nop();
	REGW(SSEG_WR_CONTROL_BASE, 0);
}

void status_led_en(dword_t mask)
{
	REGW(STATUS_LED_EN_BASE, mask);
}

void tc_set_max(TcArray tc, dword_t m)
{
	REGW(TC_RESET_BASE, TcResetMap[tc]);
	REGW(TcMMap[tc], m);
	nop();
	REGW(TC_RESET_BASE, 0);
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
	REGW(TC_RESET_BASE, TcResetMap[tc]);
	nop();
	REGW(TC_RESET_BASE, 0);
}

void tc_init(void)
{
	REGW(TC_RESET_BASE, TC_RESET_TC1 | TC_RESET_TC2 | TC_RESET_TC3 | TC_RESET_TC4);
	nop();
	REGW(TC_RESET_BASE, 0);
}

void tc_shutdown(void)
{
	REGW(TC_RESET_BASE, TC_RESET_TC1 | TC_RESET_TC2 | TC_RESET_TC3 | TC_RESET_TC4);
}

void uart1_init(byte_t dbit, byte_t pbit, byte_t sb_tick, byte_t os_tick, word_t dvsr)
{
	dword_t baud = ((dbit & 0x7) << 18) | ((pbit & 0x3) << 16) | (sb_tick << 8) | (os_tick << 0);
	REGW(UART1_RESET_CONTROL_BASE, UART1_RESET);
	REGW(UART1_BAUD_CONTROL_BASE, baud);
	REGW(UART1_DVSR_BASE, dvsr);
	nop();
	REGW(UART1_RESET_CONTROL_BASE, 0);
}

void uart1_shutdown(void)
{
	REGW(UART1_RESET_CONTROL_BASE, UART1_RESET_TX_TC | UART1_RESET_RX_TC | UART1_RESET);
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
	REGW(WARN_PWM_CONTROL_BASE, (en ? WARN_PWM_CONTROL_EN : 0));
}

void warn_init(void)
{
	REGW(WARN_PWM_CONTROL_BASE, WARN_PWM_CONTROL_RESET);
	nop();
	REGW(WARN_PWM_CONTROL_BASE, 0);
}

void warn_shutdown(void)
{
	REGW(WARN_PWM_CONTROL_BASE, WARN_PWM_CONTROL_RESET);
}
