/*
 * obd2.h
 *
 * Contains supporting routines for implementing OBD2 state machine functionality
 *
 */

#pragma once

typedef enum Obd2State_t
{
	Obd2StateReset,   // OOR state.
	Obd2StateCILBr,   // Read Coolant/Intake/Load/Boost reference
	Obd2StateOil,     // Read Oil temp (Subaru)
	Obd2StateBA,      // Read Boost/AFR
}
Obd2State;

extern Obd2State obd2_state;

// Initialize the OBD2 coroutine
void obd2_init(void);

// Shutdown the OBD2 coroutine
void obd2_shutdown(void);

// Update the OBD2 state machine. If TX is necessary, the full buffer is placed in TX and the function returns true and the txbuf must be cleared afterwards.
bool obd2_update(void);
