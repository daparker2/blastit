/*
 * obd2.h
 *
 * Contains supporting routines for implementing OBD2 state machine functionality
 *
 */

#pragma once

typedef enum State_t
{
	StateReset,   // Initial state/Reset controller state
	StateAtsp0,   // Wait for controller ready state
	StateAtlp,    // Low power state
	StateAte0,    // Disable echo
	StateAtsh7e0, // Only talk to ECU #1, the engine ECU
	StateAtat2,   // Use most agressive timing
	StateCILBr,   // Read Coolant/Intake/Load
	StateOil,     // Read Oil temp (Subaru)
	StateBA,      // Read Boost/AFR
}
State;

extern State obd2_state;

// Initialize the OBD2 state machine with the given RX and TX buffer and sizes
void obd2_init(void);

// Update the OBD2 state machine. If TX is necessary, the full buffer is placed in TX and the function returns true and the txbuf must be cleared afterwards.
bool obd2_update(void);
