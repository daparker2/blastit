/*
 * controller_system.h
 * 
 * Header file for system routines for the soft MCU. Mostly contains C 
 * implementations of testbench functionality.
 *
 */

#pragma once

#include <stdbool.h>

typedef unsigned char byte_t;
typedef unsigned short word_t;
typedef unsigned int dword_t;

// Defines the clock period
#define CLOCK_PERIOD_NS ((dword_t)20) // 20ns per 50ms clock
#define CLOCK_MILLIS_TO_TICKS(X) (((dword_t)X * 1000000U) / CLOCK_PERIOD_NS)

// Delays for one clock period
void nop(void);

// Delays for n clock periods
void delay(dword_t n);

/*
 * BCD module control
 */

#define BCD_MAX 4

#define BCD1_CONTROL_START    (1 << 0)
#define BCD1_CONTROL_TC_RESET (1 << 1)
#define BCD1_CONTROL_RESET    (1 << 2)

#define BCD1_STATUS_COUNTER_OF (1 << 0)
#define BCD1_STATUS_READY      (1 << 1)

// Converts a binary value into BCD
void bcd_convert(dword_t bin, byte_t bcd[BCD_MAX]);

// Initialize and reset the BCD module
void bcd_init(void);

// Shutdown the BCD module, holding it in reset
void bcd_shutdown(void);

/*
 * Daylight sensor control
 */

// Returns true if daylight is detected
bool is_daylight(void);

/*
 * LED array control
 */

#define LEDS_MAX 50 // Maximum LED strip LEDs

#define LEDS_RESET_CONTROL_AFR_COUNTER   (1 << 0)
#define LEDS_RESET_CONTROL_BOOST_COUNTER (1 << 1)
#define LEDS_RESET_CONTROL_AFR           (1 << 2)
#define LEDS_RESET_CONTROL_BOOST         (1 << 3)

#define LEDS_CONTROL_EN  (1 << 0)
#define LEDS_CONTROL_SEL (1 << 1)

#define LEDS_COUNTER_STATUS_BOOST_OF (1 << 0)
#define LEDS_COUNTER_STATUS_AFR_OF   (1 << 1)

typedef enum LedArray_t
{
	LedArrayAfr   = 0,
	LedArrayBoost = 1
} LedArray;

// Control LED brightness
void leds_set_brightness(LedArray ledArray, byte_t brightness);

// Enable or disable an LED
void leds_enable_led(LedArray ledArray, dword_t addr, bool en);

// Initialize and reset the LED module
void leds_init(void);

// Shutdown the LED module, holding it in reset
void leds_shutdown(void);

/*
 * SSEG array control
 */

#define SSEG_MAX 4

#define SSEG_RESET_CONTROL_TC      (1 << 0)
#define SSEG_RESET_CONTROL_COOLANT (1 << 1)
#define SSEG_RESET_CONTROL_OIL     (1 << 2)
#define SSEG_RESET_CONTROL_AFR     (1 << 3)
#define SSEG_RESET_CONTROL_BOOST   (1 << 4)

#define SSEG_WR_CONTROL_COOLANT (1 << 0)
#define SSEG_WR_CONTROL_OIL     (1 << 1)
#define SSEG_WR_CONTROL_AFR     (1 << 2)
#define SSEG_WR_CONTROL_BOOST   (1 << 3)

#define SSEG_OE_BOOST   (1 << 0)
#define SSEG_OE_AFR     (1 << 1)
#define SSEG_OE_OIL     (1 << 2)
#define SSEG_OE_COOLANT (1 << 3)

typedef enum SsegArray_t
{
	SsegArrayAfr     = 0,
	SsegArrayBoost   = 1,
	SsegArrayOil     = 2,
	SsegArrayCoolant = 3
} SsegArray;

#define SSEG_EN (1 << 7)
#define SSEG_SIGN (1 << 6)
#define SSEG_DP (1 << 5)

// Control SSEG brightness
void sseg_set_brightness(SsegArray ssegArray, byte_t brightness);

// Initialize the SSEG module
void sseg_init(void);

// Shutdown the SSEG module, holding it in reset
void sseg_shutdown(void);

// Set a BCD value using SSEG_WR_VAL to construct val
void sseg_set_bcd(SsegArray ssegArray, dword_t addr, byte_t val);

/*
 * Status LED control
 */

#define STATUS_LED_IDX(X) (1 << X)

// Enable or disable one of the status LED by mask
void status_led_en(dword_t mask);

/*
 * Timer counter control
 */

#define TC_RESET_TC1 (1 << 0)
#define TC_RESET_TC2 (1 << 1)
#define TC_RESET_TC3 (1 << 2)
#define TC_RESET_TC4 (1 << 3)

#define TC_STATUS_COUNTER (1 << 0)
#define TC_STATUS_OF      (1 << 25)

typedef enum TcArray_t
{
	Tc1 = 0,
	Tc2 = 1,
	Tc3 = 2,
	Tc4 = 3
} TcArray;

// Set the clock maximum after which the counter is incremented
void tc_set_max(TcArray tc, dword_t m);

// Get the TC tick count
dword_t tc_get_ticks(TcArray tc);

// Get the TC overflow status
bool tc_get_of(TcArray tc);

// Reset the TC
void tc_reset(TcArray tc);

// Initialize the TC array
void tc_init(void);

// Shutdown the TC array, holding it in reset
void tc_shutdown(void);

/*
 * UART1 control
 */


#define UART1_RESET_TX_TC (1 << 0)
#define UART1_RESET_RX_TC (1 << 1)
#define UART1_RESET       (1 << 2)

#define UART1_WR_CONTROL_WR (1 << 0)
#define UART1_WR_CONTROL_RD (1 << 1)

#define UART1_STATUS_TX_COUNTER_OF (1 << 0)
#define UART1_STATUS_RX_COUNTER_OF (1 << 1)
#define UART1_STATUS_E_TXOF        (1 << 2)
#define UART1_STATUS_E_RXOF        (1 << 3)
#define UART1_STATUS_E_FRAME       (1 << 4)
#define UART1_STATUS_E_PARITY      (1 << 5)
#define UART1_STATUS_RX_EMPTY      (1 << 6)
#define UART1_STATUS_TX_FULL       (1 << 7)

// Sets the baud rate; data bit, parity bit, clock ticks for stop bit, clock ticks for overscan ratio, and baud divisor 50M/(16 * baud rate)
void uart1_init(byte_t dbit, byte_t pbit, byte_t sb_tick, byte_t os_tick, word_t dvsr);

// Shuts down the UART, holding it in reset
void uart1_shutdown(void);

// Reads from the RX FIFO, returning -1 if no value could be read
int uart1_rx(void);

// Adds data to the TX FIFO, waiting for the FIFO to clear if full
void uart1_tx(char data);

// Reads values which can be masked by UART_STATUS
dword_t uart1_read_status(void);

/*
 * Warning LED control
 */

#define WARN_PWM_CONTROL_EN    (1 << 0)
#define WARN_PWM_CONTROL_RESET (1 << 1)

// Control Warning LED brightness
void warn_set_brightness(byte_t brightness);

// Set warning LED enable state
void warn_set_en(bool en);

// Initialize the warning LED PWM controller
void warn_init(void);

// Shutdown the warning LED PWM controller, holding it in reset
void warn_shutdown(void);
