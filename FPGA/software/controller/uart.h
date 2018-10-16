/*
 * uart.h
 *
 * Defines enhanced functionality for the UART on the system
 */

#pragma once

/*
 * UART debug
 */

// Turn on extra UART debugging
//#define UART_DEBUG

/*
 * UART status
 */

typedef enum UartError_t
{
	UartReady = 0,
	UartErrorTxBusy = -1,
	UartErrorRxBusy = -2,
	UartErrorTimeout = -3,
	UartErrorRemaining = -4,
	UartErrorBufferOverflow = -5,
	UartErrorInvalidArg = -6
} UartError;

extern UartError uart_error;     // This stores the last UART error, or OK
extern dword_t uart_status;      // This stores the last UART status
extern dword_t uart_rx_timeout;  // This stores the UART RX timeout

/*
 * UART config
 */

typedef enum uart_dbit_t
{
	UART_DBIT_7 = 7,
	UART_DBIT_8 = 8
} uart_dbit;

typedef enum uart_sbit_t
{
	UART_SBIT_HALF,
	UART_SBIT_ONE,
	UART_SBIT_TWO
} uart_sbit;

typedef enum uart_parity_t
{
	UART_PARITY_NONE = 0,
	UART_PARITY_EVEN = 1,
	UART_PARITY_ODD = 2
} uart_parity;

/*
 * UART RX/TX flags
 */

typedef enum uart_flags_t
{
	UART_FLAG_NONE = 0x0,
	UART_FLAG_SYNC = 0x1
} uart_flags;

/*
 * UART buffers
 */

#define UART_RX_BUFSZ (1 << 10)

// These buffers are supplied for convenience so the user can read or write to them.
// The below functions all update them.
extern char uart_rx_buf[UART_RX_BUFSZ];
extern dword_t uart_rx_bufsz;

/*
 * UART behavior modifiers
 */

#define DEFAULT_UART_EOL '\n'
#define URX_TIMEOUT_DEFAULT 30000

// Define the EOL character for uart_readline
extern char uart_eol;

/*
 * UART functions
 */

// Convert a UART error type to a string
const char* uart_etos(UartError error);

// Open the UART
int uart_open(uart_dbit dbit, uart_sbit sbit, uart_parity parity, dword_t baud);

// Close the UART
void uart_close(uart_flags flags);

// Flush the UART
void uart_flush(uart_flags flags);

// Transmit string data over the UART, updating uart_tx_buf and returning the size of data written or a UART error
int uart_sendline(const char* str, uart_flags flags);

// This just wraps start/get endline
int uart_readline(char* str, dword_t bufsz, uart_flags flags);

