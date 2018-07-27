/*
 * obd2.h
 *
 * Contains supporting routines for implementing OBD2 state machine functionality
 *
 */


// Initialize the OBD2 state machine with the given RX and TX buffer and sizes
void obd2_init(const char* rxbuf, dword_t rxbufsz, char* txbuf, dword_t txbufsz);

// Update the OBD2 state machine. If TX is necessary, the full buffer is placed in TX and the function returns true and the txbuf must be cleared afterwards.
bool obd2_update(void);
