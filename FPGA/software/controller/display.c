/*
 * display.c
 *
 * Contains implementation of display update functionality.
 *
 */

#include <string.h>
#include "display.h"
#include "controller_system.h"

DisplayParams display_params;

void display_init(void)
{
	memset(&display_params, 0, sizeof(display_params));
}

void display_update(void)
{

}
