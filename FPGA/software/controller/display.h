/*
 * display.c
 *
 * Contains headers and definitions of display update functionality.
 *
 */

typedef struct DisplayParams_t
{
	int Boost;       // The boost amount in deci-psi
	int BoostRef;    // The boost reference in deci-psi
	int Afr;         // The AFR in deci-% where 147 is stochiometric
	int OilTemp;     // The oil temperature in deci-degrees
	int CoolantTemp; // The coolant temperature in deci-degrees
}
DisplayParams;

// Display parameters being updated
extern DisplayParams display_params;

// Completely updates the display.
void display_update(void);
