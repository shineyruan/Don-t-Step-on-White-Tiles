#include "menu.h"

void Display_clearMenu() {
    int i;
    for (i = 0; i < 4; i++)
        memset(Display.lines[i], 0, sizeof(Display.lines[i]));

    for (i = 0; i < 6; i++)
        memset(myMenu.layer[i], 0, sizeof(myMenu.layer[i]));
}

void Display_frame(mss_uart_instance_t *this_uart) {
    MSS_UART_polled_tx(this_uart, clear_display, sizeof(clear_display));

    int i = 0;
    for (i = 0; i < 4; i++) {
        // display line i
        set_cursor_pos[1] = CURSOR_POS_BASE + line_start[i];
        MSS_UART_polled_tx(this_uart, set_cursor_pos, sizeof(set_cursor_pos));
        MSS_UART_polled_tx_string(this_uart, Display.lines[i]);
    }
}

bool Display_lineEmpty(int line) {
    bool flag = true;
    int i = 0;

    for (i = 0; i < 20; i++)
        if (Display.lines[line][i] != 0 && Display.lines[line][i] != ' ') {
            flag = false;
            break;
        }

    return flag;
}

void Display_initializeMenu() {
    strcpy(myMenu.layer[0], "Start");
    strcpy(myMenu.layer[1], "Mode");
    strcpy(myMenu.layer[2], "Song");
    strcpy(myMenu.layer[3], "Print config");
    strcpy(myMenu.layer[4], "Option 2");
    strcpy(myMenu.layer[5], "Option 3");
    myMenu.length = 6;
    myMenu.curr_selection = 0;
    myMenu.start_line = 0;
    myMenu.end_line = 4;
    myMenu.curr_location = ROOT;
}

void Display_displayMenu(mss_uart_instance_t *this_uart) {
    int i;
    for (i = myMenu.start_line; i < myMenu.end_line; i++)
        if (myMenu.curr_selection == i)
            strcpy(Display.lines[i - myMenu.start_line], "> ");
        else
            strcpy(Display.lines[i - myMenu.start_line], "  ");

    for (i = myMenu.start_line; i < myMenu.end_line; i++)
        strcat(Display.lines[i - myMenu.start_line], myMenu.layer[i]);

    Display_frame(this_uart);
}

void Display_scrollDownMenu() {
    if (myMenu.curr_selection == myMenu.end_line - 1) {
        if (myMenu.end_line != myMenu.length) {
            myMenu.start_line++;
            myMenu.end_line++;
        }
    }
    if (myMenu.curr_selection < myMenu.length - 1)
        myMenu.curr_selection++;
}

void Display_scrollUpMenu() {
    if (myMenu.curr_selection == myMenu.start_line) {
        if (myMenu.start_line != 0) {
            myMenu.start_line--;
            myMenu.end_line--;
        }
    }
    if (myMenu.curr_selection > 0)
        myMenu.curr_selection--;
}

void Display_enterModeSelections() {
    Display_clearMenu();
    strcpy(myMenu.layer[0], "Slow");
    strcpy(myMenu.layer[1], "Medium");
    strcpy(myMenu.layer[2], "Fast");
    myMenu.length = 3;
    myMenu.curr_selection = 0;
    myMenu.start_line = 0;
    myMenu.end_line = 3;
    myMenu.curr_location = MODE;
}

void Display_enterSongSelections() {
    Display_clearMenu();
    strcpy(myMenu.layer[0], "Song 1");
    strcpy(myMenu.layer[1], "Song 2");
    strcpy(myMenu.layer[2], "Song 3");
    strcpy(myMenu.layer[3], "Song 4");
    strcpy(myMenu.layer[4], "Song 5");
    strcpy(myMenu.layer[5], "Song 6");
    myMenu.length = 6;
    myMenu.curr_selection = 0;
    myMenu.start_line = 0;
    myMenu.end_line = 4;
    myMenu.curr_location = SONG;
}

void Display_enterPrintConfig() {
    Display_clearMenu();
    strcpy(myMenu.layer[0], "Mode: ");
    strcpy(myMenu.layer[1], "Song: ");

    switch (selected_config.selected_mode) {
        case SLOW:
            strcat(myMenu.layer[0], "slow");
            break;
        case MEDIUM:
            strcat(myMenu.layer[0], "medium");
            break;
        case FAST:
            strcat(myMenu.layer[0], "fast");
            break;
        default:
            break;
    }

    char num_str[3];
    sprintf(num_str, "%d", selected_config.selected_song);
    strcat(myMenu.layer[1], num_str);

    myMenu.length = 2;
    myMenu.curr_selection = -1;
    myMenu.start_line = 0;
    myMenu.end_line = 2;
    myMenu.curr_location = PRINT;
}

void Display_returnLastMenu() {
    if (myMenu.curr_location == SONG || myMenu.curr_location == MODE || myMenu.curr_location == PRINT) {
        Display_clearMenu();
        Display_initializeMenu();
    }
}
