/*
 * obd2.h
 *
 * Contains definitions for implementing OBD2 state machine functionality
 *
 */

#include <stdio.h>
#include <string.h>
#include <stdbool.h>
#include <ctype.h>
#include "sys/alt_stdio.h"
#include "controller_system.h"
#include "controller.h"
#include "obd2.h"
#include "display.h"
#include "uart.h"

/*
 * Debug
 */

#define OBD2_DEBUG

#ifdef OBD2_DEBUG
#define OBD2_TOKEN "obd2: "
#define OBD2_PRINTF(X, ...) alt_printf(OBD2_TOKEN X, __VA_ARGS__);
#define OBD2_PUTSTR(X) { \
	alt_putstr(OBD2_TOKEN); \
	alt_putstr(X); \
}
#define OBD2_NOTE_STATE(X) {                                                 \
	OBD2_PRINTF("OBD2 noted state: %s\n", X);                                \
	OBD2_PRINTF("OBD2 state: %s (%x)\n", obd2_etos(obd2_state), obd2_state); \
	OBD2_PRINTF("UART state: %s (%x)\n", uart_etos(uart_error), uart_error); \
}
#else
#define OBD2_TOKEN
#define OBD2_PRINTF(X, ...)
#define OBD2_PUTSTR(X)
#define OBD2_NOTE_STATE(X)
#endif // OBD2_DEBUG


/*
 * Data types
 */

#define PID_T_MAX_N 29
#define OBD2_AT_MAX_N (1 << 6)
#define OBD2_PID_MAX_N (1 << 8)

typedef struct Pid_t
{
	word_t Code;           // PID code
	byte_t N[PID_T_MAX_N]; // PID parameters [0-25] -> [A-Z]
}
Pid;

/*
 * Supporting functions
 */

static const char* obd2_etos(Obd2State state);
static void obd2_state_entry();
static void obd2_state_exit(const char* response);
static bool obd2_at_command(const char* command); // Mainly used for OOR setup stuff.
static bool obd2_parse_at_response(const char* str);
static bool obd2_parse_pid_response(const char* str);
static void obd2_update_pid_values();
static int obd2_get_pid_result_size(int pid);
static int tohex(char ch);
static float ctof(float c);

/*
 * Data storage
 */

#define PID_STORAGE_SIZE 5
#define BA_MODULO_N 10

Obd2State obd2_state;              // State machine state
static Pid pids[PID_STORAGE_SIZE]; // Pid storage, aggregate commands return up to 5 PID codes.
static word_t ba_count;            // Count of successive BA states
static float boost_ref;            // The boost reference in kPA

/*
 * Functions definitions
 */

void obd2_init()
{
	const char* AtCommands[] =
	{
		"\ratz\r",
		"atsp0\r",
		"ate0\r",
		"atsh 7e0\r"
	};

	int i;

	OBD2_NOTE_STATE("Out of reset");
	obd2_state = Obd2StateReset;
	memset(pids, 0, sizeof(pids));
	ba_count = 0;
	boost_ref = 0;
	uart_eol = '>';

	for (i = 0; i < sizeof(AtCommands)/sizeof(AtCommands[0]); ++i)
	{
		if (!obd2_at_command(AtCommands[i]))
		{
			OBD2_PUTSTR("Failed init command\n");
			OBD2_NOTE_STATE(AtCommands[i]);
		}
	}

	// Ready the coroutine.
	obd2_state = Obd2StateCILBr;
}

void obd2_shutdown()
{
	int error;

	// Perform OBD2 AT low power sequence.
	error = uart_sendline("atlp\r",  UART_FLAG_SYNC);
	if (error < 0)
	{
		OBD2_NOTE_STATE("uart_putstr failed");
	}
}

bool obd2_update(void)
{
	if (obd2_state == Obd2StateReset)
	{
		OBD2_NOTE_STATE("Coroutine update without successful init.");
		return false;
	}
	else
	{
		char response[OBD2_PID_MAX_N];
		int error = uart_readline(response, OBD2_PID_MAX_N, UART_FLAG_NONE);
		if (UartReady == error)
		{
			// We got a complete response to...something. Depending on the current state
			// parse the result and move to the next state.
			obd2_state_exit(response);
			obd2_state_entry();
			return true;
		}
		else if (UartErrorRxBusy != error)
		{
			OBD2_NOTE_STATE("uart_end_getline failed");
		}
	}

	return false;
}

const char* obd2_etos(Obd2State state)
{
	switch (state)
	{
	case Obd2StateReset:
		return "Obd2StateReset";
	case Obd2StateCILBr:
		return "Obd2StateCILBr";
	case Obd2StateOil:
		return "Obd2StateOil";
	case Obd2StateBA:
		return "Obd2StateBA";
	default:
		return "Obd2StateUnknown";
	}
}

void obd2_state_entry()
{
	int error = UartReady;

	if (Obd2StateCILBr == obd2_state)
	{
		error = uart_sendline("01 05 0f 04 33\r", UART_FLAG_NONE);
	}
	else if (Obd2StateOil == obd2_state)
	{
		error = uart_sendline("21 01\r", UART_FLAG_NONE);
	}
	else if (Obd2StateBA == obd2_state)
	{
		error = uart_sendline("01 34 0b\r", UART_FLAG_NONE);
	}
	else
	{
		obd2_state = Obd2StateReset;
		OBD2_NOTE_STATE("Unknown OBD2 state");
	}

	if (error < 0)
	{
		obd2_state = Obd2StateReset;
		OBD2_NOTE_STATE("uart_putstr failed");
	}
}

void obd2_state_exit(const char* response)
{
	if (Obd2StateCILBr == obd2_state)
	{
		if (obd2_parse_pid_response(response))
		{
			// Check if we are in ignition off state. If yes, move to reset.
			if (0 == display_params.Load)
			{
				obd2_state = Obd2StateReset;
			}
			else
			{
				obd2_state = Obd2StateOil;
			}
		}
		else
		{
			OBD2_NOTE_STATE("Invalid PID response");
			obd2_state = Obd2StateReset;
		}
	}
	else if (Obd2StateOil == obd2_state)
	{
		if (obd2_parse_pid_response(response))
		{
			obd2_state = Obd2StateBA;
		}
		else
		{
			OBD2_NOTE_STATE("Invalid PID response");
			obd2_state = Obd2StateReset;
		}
	}
	else if (Obd2StateBA == obd2_state)
	{
		if (obd2_parse_pid_response(response))
		{
			if (ba_count++ < BA_MODULO_N)
			{
				obd2_state = Obd2StateBA;
			}
			else
			{
				ba_count = 0;
				obd2_state = Obd2StateCILBr;
			}
		}
		else
		{
			OBD2_NOTE_STATE("Invalid PID response");
			obd2_state = Obd2StateReset;
		}
	}
	else
	{
		// Completely unknown state
		OBD2_NOTE_STATE("Unknown OBD2 state at exit");
		obd2_state = Obd2StateReset;
	}
}

bool obd2_at_command(const char* command)
{
	char str[OBD2_AT_MAX_N] = {};
	int error;

	OBD2_NOTE_STATE(command);

	error = uart_sendline(command, UART_FLAG_SYNC);
	if (error < 0)
	{
		OBD2_PUTSTR("uart_putstr failed\n");
		return false;
	}

	if (UartReady == uart_readline(str, OBD2_AT_MAX_N, UART_FLAG_SYNC))
	{
		OBD2_PUTSTR(str);
		OBD2_PUTSTR("\n");

		if (obd2_parse_at_response(str))
		{
			return true;
		}
		else
		{
			return false;
		}
	}
	else
	{
		OBD2_PUTSTR("Command failed\n");
	}

	return false;
}

bool obd2_parse_at_response(const char* str)
{
	// A command is an "AT" directive which is either OK or fails
	return strstr(str, "OK") != 0;
}

bool obd2_parse_pid_response(const char* str)
{
	int iPid = -1, iPidEnd = 0;
	int pidSize = 0;
	bool digit_skipped = false;

	//A PID response to a coded request for data
	memset(pids, 0, sizeof(pids));

	if (strstr(str, "UNABLE TO CONNECT") != 0)
	{
		// The car is off.
		return false;
	}
	else if (strstr(str, "NO DATA") != 0)
	{
		// The PID is bad, but we'll try the next one without an update.
		return true;
	}
	else
	{
		// We MIGHT have our PID response.
		char *ptr = (char*)str;
		bool start_line = true;
		bool skip_digit = false;

		while (*ptr)
		{
			if (start_line)
			{
				start_line = false;
				char* next;
				if ((next = strstr(ptr, ":")) < strstr(ptr, "\r"))
				{
					if (!digit_skipped)
					{
						skip_digit = true;
					}

					// Skip multi line header
					ptr = next + 1;
				}
			}
			else if (*ptr == '\r')
			{
				// EOL
				start_line = true;
				++ptr;
			}
			else if (*ptr != ' ' && *ptr != '\t')
			{
				// We might have X data? try to parse it
				if (*ptr != 0 && *(ptr + 1) != 0)
				{
					if (skip_digit)
					{
						// In a multi-line response, the first digit is the number of bytes in the response.
						skip_digit = false;
						digit_skipped = true;
					}
					else
					{
						int x = (tohex(*ptr) << 8) | tohex(*(ptr + 1));
						if (0 == pidSize)
						{
							++iPid;
							iPidEnd = 0;
							x -= 0x40;
							pidSize = 1;

							// Get the PID mode.
							pids[iPid].Code = x << 8;
						}
						else if (0 == (pids[iPid].Code & 0xFF))
						{
							// Get the PID code.
							pids[iPid].Code |= x;
							pidSize = obd2_get_pid_result_size(pids[iPid].Code);
						}
						else if (iPid >= 0)
						{
							// Get the data.
							pids[iPid].N[iPidEnd++] = x;
							--pidSize;
						}
					}

					ptr += 3;
				}
				else
				{
					++ptr;
				}
			}
			else
			{
				++ptr;
			}
		}

		obd2_update_pid_values();
		return true;
	}
}

int obd2_get_pid_result_size(int pid)
{
	if (pid == 0x0134)
	{
		// AFR
		return 4;
	}
	else if (pid == 0x010b)
	{
		// Intake manifold pressure
		return 1;
	}
	else if (pid == 0x0104)
	{
		// Calculated engine load
		return 1;
	}
	else if (pid == 0x015c)
	{
		// Engine oil temp
		return 1;
	}
	else if (pid == 0x2101)
	{
		// Subaru specific debug dump
		return 29;
	}
	else if (pid == 0x0105)
	{
		// Engine coolant temp
		return 1;
	}
	else if (pid == 0x010f)
	{
		// Intake air temp
		return 1;
	}
	else if (pid == 0x0133)
	{
		// Barometric pressure
		return 1;
	}
	else
	{
		// Garbage data?
		return 0;
	}
}

void obd2_update_pid_values(void)
{
	int i;
	for (i = 0; i < sizeof(pids)/sizeof(Pid); ++i)
	{
		if (pids[i].Code == 0x0134)
		{
			// AFR
			display_params.Afr = (pids[i].N[0] * 2560.f - pids[i].N[1] * 10.f) / (32768.f * 147.f);
		}
		else if (pids[i].Code == 0x010b)
		{
			// Intake manifold pressure
			display_params.Boost = (pids[i].N[0] - boost_ref) * 14.5f / 100.f;
		}
		else if (pids[i].Code == 0x0104)
		{
			// Calculated engine load
			display_params.Load = pids[i].N[0] * 100.f / 255.f;
		}
		else if (pids[i].Code == 0x015c)
		{
			// Engine oil temp
			display_params.OilTemp = pids[i].N[0] * 1.8f / 32.f;
		}
		else if (pids[i].Code == 0x2101)
		{
			// Subaru specific debug dump
			display_params.OilTemp = ctof(pids[i].N[28] - 40.f);
		}
		else if (pids[i].Code == 0x0105)
		{
			// Engine coolant temp
			display_params.CoolantTemp = ctof(pids[i].N[0] - 40.f);
		}
		else if (pids[i].Code == 0x010f)
		{
			// Intake air temp
			display_params.IntakeTemp = ctof(pids[i].N[0] - 40.f);
		}
		else if (pids[i].Code == 0x0133)
		{
			// Barometric pressure
			boost_ref = pids[i].N[0];
		}
	}
}

int tohex(char ch)
{
	if (isdigit(ch))
	{
		return ch - '0';
	}
	else if (isalpha(ch))
	{
		return toupper(ch) - 'A';
	}
	else
	{
		return 0;
	}
}

float ctof(float c)
{
	return c * 1.8f + 32.f;
}
