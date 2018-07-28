/*
 * controller.h
 *
 * Contains declarations of controller functionality
 */

#pragma once

#define UART_TX_BUFSZ (1 << 8)
#define UART_RX_BUFSZ (1 << 8)

extern char uart_tx_buf[UART_TX_BUFSZ], uart_rx_buf[UART_RX_BUFSZ];
extern dword_t uart_rx_bufsz;

void wait_tick(dword_t ticks); // Wait for ticks
bool is_frame();               // Determine if we have entered a frame interval
