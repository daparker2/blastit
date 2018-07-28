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

/*
 * Data types
 */

#define PID_T_MAX_N 29

typedef struct Pid_t
{
	word_t Code;           // PID code
	byte_t N[PID_T_MAX_N]; // PID parameters [0-25] -> [A-Z]
}
Pid;

/*
 * Supporting functions
 */

static void obd2_state_entry();
static void obd2_state_exit();
static bool obd2_parse_at_response();
static bool obd2_parse_pid_response();
static void obd2_update_pid_values();
static int obd2_get_pid_result_size(int pid);
static int tohex(char ch);

/*
 * Data storage
 */

#define PID_STORAGE_SIZE 5
#define BA_MODULO_N 10

State obd2_state;                  // State machine state
static Pid pids[PID_STORAGE_SIZE]; // Pid storage, aggregate commands return up to 5 PID codes.
static word_t ba_count;            // Count of successive BA states
static int boost_ref;              // The boost reference in kPA

/*
 * Functions definitions
 */

void obd2_init()
{
	obd2_state = StateReset;
	memset(pids, 0, sizeof(pids));
	ba_count = 0;
	boost_ref = 0;
}

bool obd2_update(void)
{
	if (obd2_state == StateReset)
	{
		// We're in the reset state, so we need to send the first command to the device.
		obd2_state_entry();
		return true;
	}
	else
	{
		if (0 != strstr(uart_rx_buf, ">"))
		{
			// We got a complete response to...something. Depending on the current state
			// parse the result and move to the next state.
			obd2_state_exit();
			obd2_state_entry();
			return true;
		}
	}

	return false;
}

void obd2_state_entry()
{
	if (StateReset == obd2_state)
	{
		strcpy(uart_tx_buf, "atz\r");
	}
	else if (StateAtsp0 == obd2_state)
	{
		strcpy(uart_tx_buf, "atsp0\r");
	}
	else if (StateAtlp == obd2_state)
	{
		strcpy(uart_tx_buf, "atlp\r");
	}
	else if (StateAte0 == obd2_state)
	{
		strcpy(uart_tx_buf, "ate0\r");
	}
	else if (StateAtsh7e0 == obd2_state)
	{
		strcpy(uart_tx_buf, "atsh 7e0\r");
	}
	else if (StateAtat2 == obd2_state)
	{
		strcpy(uart_tx_buf, "atat2\r");
	}
	else if (StateCILBr == obd2_state)
	{
		strcpy(uart_tx_buf, "01 05 0f 04 33\r");
	}
	else if (StateOil == obd2_state)
	{
		strcpy(uart_tx_buf, "21 01\r");
	}
	else if (StateBA == obd2_state)
	{
		strcpy(uart_tx_buf, "01 34 0b\r");
	}
}

void obd2_state_exit()
{
	if (StateReset == obd2_state)
	{
		if (obd2_parse_at_response())
		{
			// If the modem turned on wait for the ECU to be ready
			obd2_state = StateAtsp0;
		}
	}
	else if (StateAtsp0 == obd2_state)
	{
		if (obd2_parse_at_response())
		{
			obd2_state = StateAte0;
		}
		else
		{
			wait_tick(1000);
		}
	}
	else if (StateAtlp == obd2_state)
	{
		// Delay a few thousand MS before powering the controller back on
		wait_tick(5000);
		obd2_state = StateCILBr;
	}
	else if (StateAte0 == obd2_state)
	{
		if (obd2_parse_at_response())
		{
			obd2_state = StateAtsh7e0;
		}
		else
		{
			wait_tick(1000);
			obd2_state = StateReset;
		}
	}
	else if (StateAtsh7e0 == obd2_state)
	{
		if (obd2_parse_at_response())
		{
			obd2_state = StateAtat2;
		}
		else
		{
			wait_tick(1000);
			obd2_state = StateReset;
		}
	}
	else if (StateAtat2 == obd2_state)
	{
		if (obd2_parse_at_response())
		{
			obd2_state = StateCILBr;
		}
		else
		{
			wait_tick(1000);
			obd2_state = StateReset;
		}
	}
	else if (StateCILBr == obd2_state)
	{
		if (obd2_parse_pid_response())
		{
			obd2_state = StateOil;
		}
		else
		{
			obd2_state = StateAtlp;
		}
	}
	else if (StateOil == obd2_state)
	{
		if (obd2_parse_pid_response())
		{
			obd2_state = StateBA;
		}
		else
		{
			obd2_state = StateAtlp;
		}
	}
	else if (StateBA == obd2_state)
	{
		if (obd2_parse_pid_response())
		{
			if (ba_count++ < BA_MODULO_N)
			{
				obd2_state = StateBA;
			}
			else
			{
				ba_count = 0;
				obd2_state = StateCILBr;
			}
		}
		else
		{
			obd2_state = StateAtlp;
		}
	}
	else
	{
		// Completely unknown state
		obd2_state = StateReset;
	}
}

bool obd2_parse_at_response()
{
	// A command is an "AT" directive which is either OK or fails
	return strstr(uart_rx_buf, "OK") != 0;
}

bool obd2_parse_pid_response()
{
	int iPid = -1, iPidEnd = 0;
	int pidSize = 0;
	bool digit_skipped = false;

	//A PID response to a coded request for data
	memset(pids, 0, sizeof(pids));

	if (strstr(uart_rx_buf, "UNABLE TO CONNECT") != 0)
	{
		// The car is off.
		return false;
	}
	else if (strstr(uart_rx_buf, "NO DATA") != 0)
	{
		// The PID is bad, but we'll try the next one without an update.
		return true;
	}
	else
	{
		// We MIGHT have our PID response.
		char *ptr = uart_rx_buf;
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
			display_params.Afr = (pids[i].N[0] * 25600 - pids[i].N[1] * 100) / (327680 * 147);
		}
		else if (pids[i].Code == 0x010b)
		{
			// Intake manifold pressure
			display_params.Boost = (pids[i].N[0] - boost_ref) * 14 / 10;
		}
		else if (pids[i].Code == 0x0104)
		{
			// Calculated engine load
			display_params.Load = pids[i].N[0] * 1000 / 255;
		}
		else if (pids[i].Code == 0x015c)
		{
			// Engine oil temp
			display_params.OilTemp = 10 * pids[i].N[0] - 400;
		}
		else if (pids[i].Code == 0x2101)
		{
			// Subaru specific debug dump
			display_params.OilTemp = 10 * pids[i].N[28] - 400;
		}
		else if (pids[i].Code == 0x0105)
		{
			// Engine coolant temp
			display_params.CoolantTemp = 10 * pids[i].N[0] - 400;
		}
		else if (pids[i].Code == 0x010f)
		{
			// Intake air temp
			display_params.IntakeTemp = 10 * pids[i].N[0] - 400;
		}
		else if (pids[i].Code == 0x0133)
		{
			// Barometric pressure
			boost_ref = 10 * pids[i].N[0];
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
