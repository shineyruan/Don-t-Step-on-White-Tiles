#ifndef __MENU_H__
#define __MENU_H__

#include <inttypes.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include "drivers/mss_uart/mss_uart.h"
#include "drivers/mss_spi/drivers/mss_spi/mss_spi.h"

#include "soundboard.h"
#include "pixy.h"

#define CURSOR_POS_BASE 0x80

extern volatile uint8_t *soundboard_addr;
extern uint16_t receive_data[14];

typedef enum ModeSelect {
    SLOW,
    MEDIUM,
    FAST
} Mode;

typedef enum SelectionLocation {
    ROOT,
    MODE,
    SONG,
    PRINT,
    CALIBRATION,
    MESSAGE
} Menu_Location;

typedef struct LCD {
    /* data */
    uint8_t lines[4][20];
} LCD_Display;

typedef struct menuEssential
{
    int start_line;
    int end_line;
    int curr_selection;
    int length;
} Menu_Essential;


typedef struct menu
{
    uint8_t layer[6][20];
    Menu_Location curr_location;
    Menu_Essential frame;
} Menu;

typedef struct Selections
{
    Mode selected_mode;
    int selected_song;
} Selected;

bool started;
bool print_state;
LCD_Display Display;
Menu myMenu;
Menu_Essential prev_frame;
Selected selected_config;

static uint8_t line_start[] = {0, 64, 20, 84};
static uint8_t set_cursor_pos[] = {0xFE, CURSOR_POS_BASE};
static uint8_t reset[] = {0x12};
static uint8_t clear_display[] = {0xFE, 0x01};

void Display_clearMenu();
void Display_frame(mss_uart_instance_t *this_uart);
void Display_initializeMenu();
void Display_displayMenu(mss_uart_instance_t *this_uart);
void Display_scrollDownMenu();
void Display_scrollUpMenu();
void Display_enterStart();
void Display_enterModeSelections();
void Display_enterSongSelections();
void Display_enterPrintConfig();
void Display_enterCalibrationMode();
void Display_enterCalibration();
void Display_enterCalibrationSuccessful();
void Display_printSuccessful();
void Display_returnLastMenu();

#endif
