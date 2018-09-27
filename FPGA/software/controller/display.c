/*
 * display.c
 *
 * Contains implementation of display update functionality.
 *
 */

#include "sys/alt_stdio.h"
#include <string.h>
#include <stdbool.h>
#include <math.h>
#include "controller_system.h"
#include "controller.h"
#include "display.h"
#include <assert.h>

/*
 * Display macros
 */

#define BOOST_ARRAY LedArray1
#define AFR_ARRAY   LedArray2

// Scale down PWM brightness during low light by this amount
#define NIGHTTIME_DVSR (2 / 3)

// Number of available digits per readout row
#define READOUT_DIGITS 5

/*
 * Display macros
 */

#define AFR_WARN_L     11.f
#define AFR_WARN_U     18.f
#define AFR_MIN_LOAD   25.f
#define OIL_WARN_L     160.f
#define OIL_WARN_U     265.f
#define COOLANT_WARN_L 160.f
#define COOLANT_WARN_U 240.f
#define INTAKE_WARN_L  0.f
#define INTAKE_WARN_U  170.f
#define BOOST_MIN     -10.f
#define BOOST_MAX      10.f

#define SLINK_NONCE (dword_t)0xc0c0c0c0

/*
 * Display data definitions
 */

static void* display_tasks_start = 0;
struct display_params_t display_params;
daylight_task_data daylight_task;
blinker_task_data pwm_update_task;
readout_task_data afr_readout_task;
readout_task_data oil_readout_task;
readout_task_data coolant_readout_task;
readout_task_data intake_readout_task;
warning_task_data mil_task;
boost_task_data boost_task;
afr_task_data afr_task;

/*
 * Static function declarations
 */

static const char* etos(display_task_data_enum e);
static const char* ftos(warning_flag f);

/*
 * Display functions
 */

void display_init(void)
{
	void* cur;

	memset(&display_params, 0, sizeof(display_params));

	// Daylight task
	cur = display_slink_add(&display_tasks_start, &daylight_task);

	// PWM task
	cur = display_slink_add(&cur, &pwm_update_task);

	// AFR readout task
	afr_readout_task.code = 0xa;
	afr_readout_task.flag = AFR_WARN;
	afr_readout_task.warn_l = AFR_WARN_L;
	afr_readout_task.warn_u = AFR_WARN_U;
	afr_readout_task.value = &display_params.Afr;
	afr_readout_task.sseg_idx = 0;
	cur = display_slink_add(&cur, &afr_readout_task);

	// oil readout task
	oil_readout_task.code = 0x0;
	oil_readout_task.flag = OIL_WARN;
	oil_readout_task.warn_l = OIL_WARN_L;
	oil_readout_task.warn_u = OIL_WARN_U;
	oil_readout_task.value = &display_params.OilTemp;
	oil_readout_task.sseg_idx = 5;
	cur = display_slink_add(&cur, &oil_readout_task);

	// coolant readout task
	coolant_readout_task.code = 0xc;
	coolant_readout_task.flag = COOLANT_WARN;
	coolant_readout_task.warn_l = COOLANT_WARN_L;
	coolant_readout_task.warn_u = COOLANT_WARN_U;
	coolant_readout_task.value = &display_params.CoolantTemp;
	coolant_readout_task.sseg_idx = 10;
	cur = display_slink_add(&cur, &coolant_readout_task);

	// Intake readout task
	intake_readout_task.code = 0x1;
	intake_readout_task.flag = INTAKE_WARN;
	intake_readout_task.warn_l = INTAKE_WARN_L;
	intake_readout_task.warn_u = INTAKE_WARN_U;
	intake_readout_task.value = &display_params.IntakeTemp;
	intake_readout_task.sseg_idx = 15;
	cur = display_slink_add(&cur, &intake_readout_task);

	// MIL task
	cur = display_slink_add(&cur, &mil_task);

	// Boost task
	boost_task.boost_l = BOOST_MIN;
	boost_task.boost_u = BOOST_MAX;
	cur = display_slink_add(&cur, &boost_task);

	// AFR task
	afr_task.afr_l = AFR_WARN_L;
	afr_task.afr_u = AFR_WARN_U;
	cur = display_slink_add(&cur, &afr_task);

	// Init the display tasks
	cur = display_tasks_start;
	while (0 != cur)
	{
		display_task_data* td = (display_task_data*)cur;
		td->type = UNDEF_TASK;
		td->init(td);
		alt_printf("Started display task %d\n", etos(td->type));
		cur = display_slink_next(cur);
	}
}

void display_update(void)
{
	void* cur = display_tasks_start;
	while (0 != cur)
	{
		display_task_data* td = (display_task_data*)cur;
		td->slink.done = td->update(td);
		cur = display_slink_next(cur);
	}

	display_slink_compact((void**)&display_tasks_start);
}

void* display_slink_add(void** x, void* y)
{
	display_slink* n = (display_slink*)&y;
	if (0 == *x)
	{
		n->done = 0;
		n->next = 0;
		n->nonce = SLINK_NONCE;
		*x = n;
	}
	else
	{
		display_slink* sl;

		do
		{
			sl = (display_slink*)*x;
			if (sl == y)
			{
				// We added it before!
				return y;
			}

			*x = display_slink_next(sl);
		}
		while (!display_slink_last(*x));

		if (SLINK_NONCE == sl->nonce)
		{
			n->done = 0;
			n->next = 0;
			n->nonce = SLINK_NONCE;
			sl->next = n;
			*x = n;
		}
	}

	return *x;
}

void* display_slink_next(void* x)
{
	if (0 != x)
	{
		display_slink* n = (display_slink*)x;
		if (SLINK_NONCE == n->nonce)
		{
			return n->next;
		}
	}

	return 0;
}

bool display_slink_last(void* x)
{
	if (0 != x)
	{
		display_slink* n = (display_slink*)x;
		if (SLINK_NONCE == n->nonce)
		{
			return 0 == n->next;
		}
	}

	return true;
}

void display_slink_compact(void** x)
{
	display_slink* n = (display_slink*)*x;

	// Compact the start of the list
	while (0 != *x)
	{
		n = (display_slink*)*x;
		if (SLINK_NONCE == n->nonce)
		{
			if (n->done)
			{
				*x = n->next;
			}
		}
	}

	// Compact the rest of the list
	n = (display_slink*)*x;
	while (0 != n)
	{
		display_slink* nr;
		do
		{
			nr = display_slink_next(*x);
		}
		while (0 != nr && nr->done);
		n->next = nr;
		n = nr;
	}
}

void daylight_init(display_task_data* task)
{
	daylight_task_data* t = (daylight_task_data*)task;
	t->is_daylight = is_daylight();
}

bool daylight_update(display_task_data* task)
{
	daylight_task_data* t = (daylight_task_data*)task;
	bool d = is_daylight();

	// Also as a side effect update the brightness on the SSEG display
	if (d != t->is_daylight)
	{
		if (d)
		{
			alt_printf("Using daylight PWM duty cycle\n");
			sseg_set_brightness(SSEG_BRIGHTNESS_MAX);
		}
		else
		{
			alt_printf("Using night-time PWM duty cycle\n");
			sseg_set_brightness(SSEG_BRIGHTNESS_MAX * NIGHTTIME_DVSR);
		}

		t->is_daylight = d;
	}

	return false;
}

void blinker_init(display_task_data* task)
{
	blinker_task_data* p = (blinker_task_data*)task;
	p->task_data.type = BLINKER_TASK;
	p->sdata = 0;
}

bool blinker_update(display_task_data* task)
{
	blinker_task_data* p = (blinker_task_data*)task;
	void* cur = p->sdata;
	while (0 != cur)
	{
		blinker_data* d = (blinker_data*)cur;
		if (!d->slink.done)
		{
			// Update the PWM duty cycle. The individual task asking for blinker functionality has to update the associated PWM itself...
			++d->count;
			if (d->count == d->dvsr)
			{
				d->count = 0;
				if (0 == d->sign)
				{
					++d->duty_cycle;
				}
				else
				{
					--d->duty_cycle;
				}
			}

			if (d->duty_cycle == 100)
			{
				d->sign = 1;
			}
			else if (d->duty_cycle == 0)
			{
				d->sign = 0;
			}
		}

		cur = display_slink_next(cur);
	}

	display_slink_compact(&p->sdata);
	return false;
}

void blinker_start(blinker_task_data* task, blinker_data* bdata)
{
	bdata->count = 0;
	bdata->sign = 0;
	display_slink_add(&task->sdata, bdata);
}

void blinker_stop(blinker_data* bdata)
{
	bdata->slink.done = 1;
}

void readout_init(display_task_data* task)
{
	readout_task_data* t = (readout_task_data*)task;
	int i;

	sseg_set_bcd(t->sseg_idx, SSEG_VAL_EN | SSEG_DP, t->code);
	for (i = 1; i < READOUT_DIGITS; ++i)
	{
		sseg_set_bcd(t->sseg_idx + i, 0, 0);
	}
}

bool readout_update(display_task_data* task)
{
	readout_task_data* t = (readout_task_data*)task;
	byte_t bcd[BCD_MAX];
	dword_t dec;
	int i, j;
	bool sign;
	int sign_idx;

	if (*t->value < 0)
	{
		dec = (dword_t)-(*t->value * 10.f);
		sign = true;
	}
	else
	{
		dec = (dword_t)(*t->value * 10.f);
		sign = false;
	}

	// We assume 3 decimals digits and 1 fractional digit which is visible only if the sign is positive
	bcd_convert(dec, bcd);
	if (sign)
	{
		sseg_set_bcd(t->sseg_idx + 1, SSEG_VAL_EN | SSEG_SIGN, 0);
		i = 2;
		sign_idx = READOUT_DIGITS - 1;
	}
	else
	{
		i = 1;
		sign_idx = READOUT_DIGITS - 2;
	}

	// Chop off leading 0's
	for (j = 0; bcd[j] == 0 && j < BCD_MAX - 2; ++i, ++j)
	{
		sseg_set_bcd(t->sseg_idx + i, 0, 0);
	}

	// Print out the rest of the number
	for (; j < BCD_MAX && i < READOUT_DIGITS; ++i, ++j)
	{
		dword_t flags = SSEG_VAL_EN;
		if (i == sign_idx)
		{
			flags |= SSEG_DP;
		}

		sseg_set_bcd(t->sseg_idx + i, flags, bcd[j]);
	}

	// Check if warning condition is set
	if (!(*t->value >= t->warn_l && *t->value <= t->warn_u))
	{
		warning_set(&mil_task, t->flag);
	}
	else
	{
		warning_clear(&mil_task, t->flag);
	}

	return false;
}

void warning_init(display_task_data* task)
{
	warning_task_data* t = (warning_task_data*)task;
	t->bdata.dvsr = 2;
	t->flags = 0x0;
}

bool warning_update(display_task_data* task)
{
	warning_task_data* t = (warning_task_data*)task;
	if (0 < t->flags && 1 == t->bdata.slink.done)
	{
		blinker_start(&pwm_update_task, &t->bdata);
		warn_set_en(true);
	}
	else if (0 == t->bdata.slink.done)
	{
		blinker_stop(&t->bdata);
		warn_set_en(false);
	}

	if (0 == t->bdata.slink.done)
	{
		dword_t u = WARN_BRIGHTNESS_MAX * t->bdata.duty_cycle / 100;
		if (!daylight_task.is_daylight)
		{
			u *= NIGHTTIME_DVSR;
		}

		warn_set_brightness(u);
	}

	return false;
}

bool warning_set(warning_task_data* task, warning_flag flag)
{
	if (!(task->flags & flag))
	{
		alt_printf("Setting warning condition for '%s'\n", ftos(flag));
		task->flags |= flag;
		return true;
	}

	return false;
}

bool warning_clear(warning_task_data* task, warning_flag flag)
{
	if (!(task->flags & flag))
	{
		alt_printf("Clearing warning condition for '%s'\n", ftos(flag));
		task->flags &= ~flag;
		return true;
	}

	return false;
}

void boost_init(display_task_data* task)
{
	boost_task_data* t = (boost_task_data*)task;
	t->bdata.dvsr = 1;
}

bool boost_update(display_task_data* task)
{
	boost_task_data* t = (boost_task_data*)task;
	float boost = display_params.Boost;
	int boost_idx;
	int i;
	bool modulate;

	// Check if warning condition is set
	if (!(boost >= t->boost_l && boost <= t->boost_u) && !(mil_task.flags & BOOST_WARN))
	{
		warning_set(&mil_task, BOOST_WARN);
	}
	else if (mil_task.flags & BOOST_WARN)
	{
		warning_clear(&mil_task, BOOST_WARN);
	}

	modulate = 0 != (mil_task.flags & BOOST_WARN);

	if (boost < t->boost_l)
	{
		boost = t->boost_l;
	}

	if (boost > t->boost_u)
	{
		boost = t->boost_u;
	}

	boost_idx = (int)(boost - t->boost_l) * (float)LEDS_MAX / (t->boost_u - t->boost_l);
	if (boost_idx < LEDS_MAX)
	{
		boost_idx = LEDS_MAX;
	}

	for (i = 0; i < boost_idx; ++i)
	{
		leds_enable_led(BOOST_ARRAY, i, true);
	}

	for (i = boost_idx; i < LEDS_MAX; ++i)
	{
		leds_enable_led(BOOST_ARRAY, i, false);
	}

	if (modulate)
	{
		dword_t u = WARN_BRIGHTNESS_MAX * t->bdata.duty_cycle / 100;
		if (!daylight_task.is_daylight)
		{
			u *= NIGHTTIME_DVSR;
		}

		leds_set_brightness(BOOST_ARRAY, u);
	}
	else
	{
		if (daylight_task.is_daylight)
		{
			leds_set_brightness(BOOST_ARRAY, LEDS_BRIGHTNESS_MAX);
		}
		else
		{
			leds_set_brightness(BOOST_ARRAY, LEDS_BRIGHTNESS_MAX * NIGHTTIME_DVSR);
		}
	}

	return false;
}

void afr_init(display_task_data* task)
{
	afr_task_data* t = (afr_task_data*)task;
	t->bdata.dvsr = 1;
}

bool afr_update(display_task_data* task)
{
	afr_task_data* t = (afr_task_data*)task;
	float afr = display_params.Afr;
	float load = display_params.Load;
	int start;
	int end;
	int i;
	bool modulate;

	if (afr < t->afr_l)
	{
		afr = t->afr_l;
	}

	if (afr > t->afr_u)
	{
		afr = t->afr_u;
	}

	modulate = (0 != (mil_task.flags & AFR_WARN)) && load >= AFR_MIN_LOAD;

	if (load >= AFR_MIN_LOAD)
	{
        float offsetLambda = (afr - 11.2f) / 7.f;
		start = LEDS_MAX / 2;
        end = (int)ceilf((float)LEDS_MAX * offsetLambda);
        if (end < 0)
        {
        	end = 0;
        }

        if (end > LEDS_MAX)
        {
        	end = LEDS_MAX;
        }
	}
	else
	{
		// Just light everything up to indicate that the reading is inaccurate
		start = 0;
		end = LEDS_MAX;
	}

	if (end < start)
	{
		int t = start;
		start = end;
		end = t;
	}

	for (i = 0; i < LEDS_MAX; ++i)
	{
		if (i >= start && i <= end)
		{
			leds_enable_led(AFR_ARRAY, i, true);
		}
		else
		{
			leds_enable_led(AFR_ARRAY, i, false);
		}
	}

	if (modulate)
	{
		dword_t u = WARN_BRIGHTNESS_MAX * t->bdata.duty_cycle / 100;
		if (!daylight_task.is_daylight)
		{
			u *= NIGHTTIME_DVSR;
		}

		leds_set_brightness(AFR_ARRAY, u);
	}
	else
	{
		if (daylight_task.is_daylight)
		{
			leds_set_brightness(AFR_ARRAY, LEDS_BRIGHTNESS_MAX);
		}
		else
		{
			leds_set_brightness(AFR_ARRAY, LEDS_BRIGHTNESS_MAX * NIGHTTIME_DVSR);
		}
	}

	return false;
}

const char* etos(display_task_data_enum e)
{
	switch (e)
	{
	case UNDEF_TASK:
		return "UNDEF_TASK";
	case DAYLIGHT_TASK:
		return "DAYLIGHT_TASK";
	case BLINKER_TASK:
		return "BLINKER_TASK";
	case READOUT_TASK:
		return "READOUT_TASK";
	case WARNING_TASK:
		return "WARNING_TASK";
	case BOOST_TASK:
		return "BOOST_TASK";
	case AFR_TASK:
		return "AFR_TASK";
	}

	return "<unknown>";
}

const char* ftos(warning_flag f)
{
	switch (f)
	{
	case AFR_WARN:
		return "AFR_WARN";
	case BOOST_WARN:
		return "BOOST_WARN";
	case OIL_WARN:
		return "OIL_WARN";
	case COOLANT_WARN:
		return "COOLANT_WARN";
	case INTAKE_WARN:
		return "INTAKE_WARN";
	}

	return "<unknown>";
}
