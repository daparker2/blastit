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
#define UART_DEBUG

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
	UartErrorBufferOverflow = -5
} UartError;

// This stores the last UART error, or OK
extern UartError uart_error;
extern dword_t uart_status;

/*
 * UART buffers
 */

#define UART_TX_BUFSZ (1 << 10)
#define UART_RX_BUFSZ (1 << 10)

// These buffers are supplied for convenience so the user can read or write to them.
// The below functions all update them.
extern char uart_tx_buf[UART_TX_BUFSZ], uart_rx_buf[UART_RX_BUFSZ];
extern dword_t uart_tx_bufsz, uart_rx_bufsz;

/*
 * UART behavior modifiers
 */

#define DEFAULT_UART_TIMEOUT_CLOCKS CLOCK_MILLIS_TO_TICKS(10000)
#define DEFAULT_UART_EOL '\n'

// Define the EOL character for uart_readline
extern char uart_eol;

// Define the UART timeout in clocks
extern dword_t uart_timeout_clocks; // Default to a 10ish second timeout

// Convert a UART error type to a string
const char* uart_etos(UartError error);

// Reset the UART buffers
void uart_bufclr(void);

// Transmit string data over the UART, updating uart_tx_buf and returning the size of data written or a UART error
int uart_putstr(const char* str);

// Reads a line of data off the UART using uart_eol as the delimiter in nonblocking mode.
// - If the read failed or the terminator was not read than a corresponding error is returned.
// - If the read succeeded, the corresponding string is pointed to by str.
int uart_start_getline();
int uart_end_getline(char** str);

// This just wraps start/get endline
int uart_getline(char** str);

// Updates the UART state machine once per frame allowing for coroutine behavior of UART functions.
int uart_update();

// Blocks until the UART TX and RX buffers are empty. Returns an error indicating the status of the operation.
int uart_flush();
