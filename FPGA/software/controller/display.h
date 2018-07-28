/*
 * display.c
 *
 * Contains headers and definitions of display update functionality.
 *
 */

typedef struct DisplayParams_t
{
	int Boost;       // The boost amount in deci-psi
	int Afr;         // The AFR in deci-% where 147 is stochiometric
	int OilTemp;     // The oil temperature in deci-degrees C
	int CoolantTemp; // The coolant temperature in deci-degrees C
	int IntakeTemp;  // The intake temperature in deci-degrees C
	int Load;        // The calculated engine load in deci-%
}
DisplayParams;

// Display parameters being updated
extern DisplayParams display_params;

// Initializes the display
void display_init(void);

// Completely updates the display.
void display_update(void);
