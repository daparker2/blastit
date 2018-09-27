/*
 * display.c
 *
 * Contains headers and definitions of display update functionality.
 *
 */

#include <stdbool.h>

/*
 * Serves as an input to the display task engine.
 */

struct display_params_t
{
	float Boost;       // The boost amount in deci-psi
	float Afr;         // The AFR in deci-% where 147 is stochiometric
	float OilTemp;     // The oil temperature in deci-degrees C
	float CoolantTemp; // The coolant temperature in deci-degrees C
	float IntakeTemp;  // The intake temperature in deci-degrees C
	float Load;        // The calculated engine load in deci-%
};

// Display parameters being updated
extern struct display_params_t display_params;

// Initializes the display
void display_init(void);

// Completely updates the display.
void display_update(void);

/*
 * The following structures are not really meant to be used externally.
 */

/*
 * Display task engine SLL stuff
 */

typedef struct display_slink_t
{
	dword_t nonce;
	struct display_slink_t* next;
	byte_t done;
} display_slink;

#define DISPLAY_SLINK display_slink slink;

// Add SLL node y to x, returning Y
void* display_slink_add(void** x, void* y);

// Move to next node in SLL
void* display_slink_next(void* x);

// Check if the rest of the SLL is empty
bool display_slink_last(void* x);

// Compact SLL pointed to by x by removing freed tasks
void display_slink_compact(void** x);

/*
 * Display task engine task base
 */

typedef enum display_task_data_enum_t
{
	UNDEF_TASK,
	DAYLIGHT_TASK,
	BLINKER_TASK,
	READOUT_TASK,
	WARNING_TASK,
	BOOST_TASK,
	AFR_TASK
}
display_task_data_enum;

typedef struct display_task_data_t
{
	DISPLAY_SLINK;
	display_task_data_enum type;
	void (*init)  (struct display_task_data_t*);
	bool (*update)(struct display_task_data_t*);
} display_task_data;

/*
 * Daylight sensor section
 */

typedef struct daylight_task_data_t
{
	display_task_data task_data;
	bool is_daylight;
} daylight_task_data;

void daylight_init(display_task_data* task);
bool daylight_update(display_task_data* task);

/*
 * Blinker control section
 */

typedef struct blinker_data_t
{
	DISPLAY_SLINK;
	byte_t dvsr;       // duty cycle divisor >1
	byte_t duty_cycle; // duty cycle % (0-100)
	word_t count;      // Count until next duty cycle change
	byte_t sign;       // Duty cycle sign 1 for negative
} blinker_data;

typedef struct blinker_task_data_t
{
	display_task_data task_data;
	void* sdata;
} blinker_task_data;

// Init/update code for blinker
void blinker_init(display_task_data* task);
bool blinker_update(display_task_data* task);
void blinker_start(blinker_task_data* task, blinker_data* bdata);
void blinker_stop(blinker_data* bdata);

/*
 * Digital readout section
 */

typedef struct readout_task_data_t
{
	display_task_data task_data;
	byte_t code;      // Hex code for readout
	float warn_l;     // Lower/upper values for warning
	float warn_u;
	float* value;
	dword_t flag;
	dword_t sseg_idx; // address offset from start of sseg matrix
} readout_task_data;

// Init/update code for readout
void readout_init(display_task_data* task);
bool readout_update(display_task_data* task);

/*
 * Warning indicator section
 */

typedef enum warning_flag_t
{
	AFR_WARN     = 0x01,
	BOOST_WARN   = 0x02,
	OIL_WARN     = 0x04,
	COOLANT_WARN = 0x08,
	INTAKE_WARN  = 0x10
} warning_flag;

typedef struct warning_task_data_t
{
	display_task_data task_data;
	warning_flag flags; // Warning flagged state (0 == no warning)
	blinker_data bdata;
} warning_task_data;

void warning_init(display_task_data* task);
bool warning_update(display_task_data* task);
bool warning_set(warning_task_data* task, warning_flag flag);
bool warning_clear(warning_task_data* task, warning_flag flag);

/*
 * Boost bar section
 */

typedef struct boost_task_data_t
{
	display_task_data task_data;
	float boost_l;
	float boost_u;
	blinker_data bdata;
} boost_task_data;

void boost_init(display_task_data* task);
bool boost_update(display_task_data* task);

/*
 * AFR bar section
 */

typedef struct afr_task_data_t
{
	display_task_data task_data;
	float afr_l;
	float afr_u;
	blinker_data bdata;
} afr_task_data;

void afr_init(display_task_data* task);
bool afr_update(display_task_data* task);

/*
 * Display system tasks
 */

extern daylight_task_data daylight_task;
extern blinker_task_data pwm_update_task;
extern readout_task_data afr_readout_task;
extern readout_task_data oil_readout_task;
extern readout_task_data coolant_readout_task;
extern readout_task_data intake_readout_task;
extern warning_task_data mil_task;
extern boost_task_data boost_task;
extern afr_task_data afr_task;
