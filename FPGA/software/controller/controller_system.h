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
#define CLOCK_SPEED_HZ           ((dword_t)50000000)                         // ex 50Mhz
#define CLOCK_PERIOD_NS          ((dword_t)20)                               // 20ns per 50mhz clock
#define CLOCK_MILLIS_TO_TICKS(X) (((dword_t)X * 1000000U) / CLOCK_PERIOD_NS)

// Delays for one clock period
static inline void nop(void)
{
	__asm__ ("nop");
}

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

typedef enum LedArray_t
{
	LedArray1 = 0,
	LedArray2 = 1
} LedArray;

#define LEDS_MAX 30 // Maximum LED strip LEDs

#define LEDS_COUNTER_RESET   (1 << 0)
#define LEDS_RESET           (1 << 1)

#define LEDS_N_BITS 4
#define LEDS_M_BITS 4
#define LEDS_ADDR_W (LEDS_N_BITS + LEDS_M_BITS)

#define LEDS_N_MASK ((1 << LEDS_N_BITS) - 1)
#define LEDS_M_MASK ((1 << LEDS_M_BITS) - 1)
#define LEDS_ADDR_MASK ((1 << LEDS_ADDR_W) - 1)

#define LEDS_CONTROL_EN_IDX LEDS_ADDR_W
#define LEDS_CONTROL_SEL_IDX (LEDS_ADDR_W + 1)

#define LEDS_CONTROL_EN  (1 << LEDS_CONTROL_EN_IDX)
#define LEDS_CONTROL_SEL (1 << LEDS_CONTROL_SEL_IDX)

#define LEDS_BRIGHTNESS_MAX 0xFF

// Control LED brightness
void leds_set_brightness(LedArray arr, byte_t brightness);

// Enable or disable an LED
void leds_enable_led(LedArray arr, dword_t addr, bool en);

// Initialize and reset the LED module
void leds_init(LedArray arr);

// Shutdown the LED module, holding it in reset
void leds_shutdown(LedArray arr);

/*
 * SSEG array control
 */

#define SSEG_MAX 20

#define SSEG_COUNTER_RESET  (1 << 0)
#define SSEG_RESET          (1 << 1)

#define SSEG_VAL_BITS 4
#define SSEG_SEL_BITS 5

#define SSEG_SEL_MASK ((1 << SSEG_SEL_BITS) - 1)
#define SSEG_VAL_MASK ((1 << SSEG_VAL_BITS) - 1)

#define SSEG_WR_IDX     (SSEG_SEL_BITS + SSEG_VAL_BITS + 3)
#define SSEG_SEL_IDX    (SSEG_VAL_BITS + 3)
#define SSEG_VAL_EN_IDX (SSEG_VAL_BITS + 2)
#define SSEG_SIGN_IDX   (SSEG_VAL_BITS + 1)
#define SSEG_DP_IDX     (SSEG_VAL_BITS)

#define SSEG_WR     (1 << SSEG_WR_IDX)
#define SSEG_SEL    (1 << SSEG_SEL_IDX)
#define SSEG_VAL_EN (1 << SSEG_VAL_EN_IDX)
#define SSEG_SIGN   (1 << SSEG_SIGN_IDX)
#define SSEG_DP     (1 << SSEG_DP_IDX)


#define SSEG_BRIGHTNESS_MAX 0xFF

// Control SSEG brightness
void sseg_set_brightness(byte_t brightness);

// Initialize the SSEG module
void sseg_init(void);

// Shutdown the SSEG module, holding it in reset
void sseg_shutdown(void);

// Set a BCD value using SsegVal to construct val
void sseg_set_bcd(dword_t addr, dword_t flags, dword_t val);

/*
 * Status LED control
 */

#define STATUS_LED_IDX(X) (1 << X)
#define STATUS_LED_0 STATUS_LED_IDX(0)
#define STATUS_LED_1 STATUS_LED_IDX(1)
#define STATUS_LED_2 STATUS_LED_IDX(2)
#define STATUS_LED_3 STATUS_LED_IDX(3)

// Enable or disable LEDS by max
void status_led_enable(bool en);
void status_led_on(dword_t mask);
void status_led_off(dword_t mask);

/*
 * Timer counter control
 */

#define TC_RESET_TC1 (1 << 0)
#define TC_RESET_TC2 (1 << 1)
#define TC_RESET_TC3 (1 << 2)
#define TC_RESET_TC4 (1 << 3)

#define TC_STATUS_COUNTER (1 << 0)
#define TC_STATUS_OF      (1 << 25)

#define TC_MAX (dword_t)((1 << 24) - 1)

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

#define UART_OS_MAX   ((dword_t)(1 << 8) - 1)
#define UART_DVSR_BIT ((dword_t)UART1_DVSR_DATA_WIDTH)
#define UART_DBIT_BIT ((dword_t)8

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
#define UART1_STATUS_RX_FULL       (1 << 8)
#define UART1_STATUS_TX_EMPTY      (1 << 9)

// Sets the baud rate; data bit, parity bit, clock ticks for stop bit, clock ticks for overscan ratio, and baud divisor int(50M/(os_tick * baud rate))
void uart1_init(byte_t dbit, byte_t pbit, byte_t sb_tick, byte_t os_tick, word_t dvsr);

// Explicitly reset the UART, clearing internal FIFO and state
void uart1_reset(void);

// Shuts down the UART, holding it in reset
void uart1_shutdown(void);

// Reads from the RX FIFO, blocking until the RX buffer is ready
int uart1_rx(void);

// Adds data to the TX FIFO, waiting for the FIFO to clear if full
void uart1_tx(char data);

// Reads values which can be masked by UART_STATUS
dword_t uart1_read_status(void);

// Debug print UART status
void uart1_print_status(dword_t status);

/*
 * Warning LED control
 */

#define WARN_PWM_CONTROL_EN    (1 << 0)
#define WARN_PWM_CONTROL_RESET (1 << 1)

#define WARN_BRIGHTNESS_MAX 0xFF

// Control Warning LED brightness
void warn_set_brightness(byte_t brightness);

// Set warning LED enable state
void warn_set_en(bool en);

// Initialize the warning LED PWM controller
void warn_init(void);

// Shutdown the warning LED PWM controller, holding it in reset
void warn_shutdown(void);

/*
 * Reset control
 */

#define RC_M_BITS 24

#define RC_CONTROL_START (1 << RC_M_BITS)

// Force the controller into reset, bringing it back up after counts
void rc_reset(dword_t counts);

/*
 * Global LED control
 */

#define LEDS_PERIOD_MAX (dword_t)((1 << 24) - 1)

// Set the LED transition period in clocks
void led_set_period(dword_t period);

