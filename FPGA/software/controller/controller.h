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
 * Timer counter support
 */

#define TC_TICK_COUNTER Tc1    // The tick counter ticks once per tick (~1ms)
#define TC_FRAME_COUNTER Tc2   // The frame counter ticks once every frame interval (~8ms)

void wait_tick(dword_t ticks); // Wait for ticks
bool is_frame(void);           // Determine if we have entered a frame interval
