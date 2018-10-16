/*
 * controller.h
 *
 * Contains declarations of controller functionality
 */

#pragma once

/*
 * Test panel support
 */

#define TEST

#ifdef TEST
void test(void);
#endif // TEST

/*
 * Debug LED support
 */

#define POWER_STATUS_LED STATUS_LED_0
#define OBD2_STATUS_LED  STATUS_LED_1
#define URX_STATUS_LED   STATUS_LED_2
#define UTX_STATUS_LED   STATUS_LED_3

/*
 * Timer counter support
 */

#define TC_TICK_COUNTER  Tc1   // The tick counter ticks once per tick (~1ms)
#define TC_FRAME_COUNTER Tc2   // The frame counter ticks once every frame interval (~8ms)
#define TC_URX_COUNTER   Tc3   // Ticks over according to the UARTRX timeout interval (~30s)

void wait_tick(dword_t ticks); // Wait for ticks
bool is_frame(void);           // Determine if we have entered a frame interval
