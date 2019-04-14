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
    started = false;
    strcpy(myMenu.layer[0], "Start");
    strcpy(myMenu.layer[1], "Mode");
    strcpy(myMenu.layer[2], "Song");
    strcpy(myMenu.layer[3], "Print config");
    strcpy(myMenu.layer[4], "Calibrate PIXY");
    strcpy(myMenu.layer[5], "Option 3");
    myMenu.frame.length = 6;
    myMenu.frame.curr_selection = 0;
    myMenu.frame.start_line = 0;
    myMenu.frame.end_line = 4;
    myMenu.curr_location = ROOT;
}

void Display_displayMenu(mss_uart_instance_t *this_uart) {
    int i;
    if (myMenu.frame.curr_selection >= 0)
        for (i = myMenu.frame.start_line; i < myMenu.frame.end_line; i++)
            if (myMenu.frame.curr_selection == i)
                strcpy(Display.lines[i - myMenu.frame.start_line], "> ");
            else
                strcpy(Display.lines[i - myMenu.frame.start_line], "  ");

    for (i = myMenu.frame.start_line; i < myMenu.frame.end_line; i++)
        strcat(Display.lines[i - myMenu.frame.start_line], myMenu.layer[i]);

    Display_frame(this_uart);
}

void Display_scrollDownMenu() {
    if (myMenu.frame.curr_selection == myMenu.frame.end_line - 1) {
        if (myMenu.frame.end_line != myMenu.frame.length) {
            myMenu.frame.start_line++;
            myMenu.frame.end_line++;
        }
    }
    if (myMenu.frame.curr_selection < myMenu.frame.length - 1)
        myMenu.frame.curr_selection++;
}

void Display_scrollUpMenu() {
    if (myMenu.frame.curr_selection == myMenu.frame.start_line) {
        if (myMenu.frame.start_line != 0) {
            myMenu.frame.start_line--;
            myMenu.frame.end_line--;
        }
    }
    if (myMenu.frame.curr_selection > 0)
        myMenu.frame.curr_selection--;
}

void Display_enterStart() {
    started = true;

    prev_frame = myMenu.frame;
    Display_clearMenu();
    strcpy(myMenu.layer[1], "    Game Start     ");
    strcpy(myMenu.layer[2], " Press B to return ");
    myMenu.frame.length = 3;
    myMenu.frame.curr_selection = -100;
    myMenu.frame.end_line = 3;
    myMenu.curr_location = PRINT;

#ifdef DEBUG
    printf("Before: %x\r\n", *soundboard_addr);
#endif

    (*soundboard_addr) = ~(1 << (selected_config.selected_song - 1)) & (0xFF);

#ifdef DEBUG
    printf("After: %x\r\n", *soundboard_addr);
#endif
}

void Display_enterModeSelections() {
    prev_frame = myMenu.frame;
    Display_clearMenu();
    strcpy(myMenu.layer[0], "Slow");
    strcpy(myMenu.layer[1], "Medium");
    strcpy(myMenu.layer[2], "Fast");
    myMenu.frame.length = 3;
    myMenu.frame.curr_selection = 0;
    myMenu.frame.start_line = 0;
    myMenu.frame.end_line = 3;
    myMenu.curr_location = MODE;
}

void Display_enterSongSelections() {
    prev_frame = myMenu.frame;
    Display_clearMenu();
    strcpy(myMenu.layer[0], "Song 1");
    strcpy(myMenu.layer[1], "Song 2");
    strcpy(myMenu.layer[2], "Song 3");
    strcpy(myMenu.layer[3], "Song 4");
    strcpy(myMenu.layer[4], "Song 5");
    strcpy(myMenu.layer[5], "Song 6");
    myMenu.frame.length = 6;
    myMenu.frame.curr_selection = 0;
    myMenu.frame.start_line = 0;
    myMenu.frame.end_line = 4;
    myMenu.curr_location = SONG;
}

void Display_enterPrintConfig() {
    prev_frame = myMenu.frame;
    Display_clearMenu();
    strcpy(myMenu.layer[0], "  Mode: ");
    strcpy(myMenu.layer[1], "  Song: ");

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

    strcpy(myMenu.layer[3], "  LEFT for return  ");

    myMenu.frame.length = 4;
    myMenu.frame.curr_selection = -100;
    myMenu.frame.start_line = 0;
    myMenu.frame.end_line = 4;
    myMenu.curr_location = PRINT;
}

void Display_enterCalibrationMode() {
    prev_frame = myMenu.frame;
    Display_clearMenu();
    strcpy(myMenu.layer[0], "Top-left");
    strcpy(myMenu.layer[1], "Top-right");
    strcpy(myMenu.layer[2], "Bottom-right");
    strcpy(myMenu.layer[3], "Bottom-left");

    myMenu.frame.length = 4;
    myMenu.frame.curr_selection = 0;
    myMenu.frame.start_line = 0;
    myMenu.frame.end_line = 4;
    myMenu.curr_location = CALIBRATION;
}

void Display_enterCalibration() {
    Display_clearMenu();
    strcpy(myMenu.layer[1], "   Calibrating...  ");
    myMenu.frame.length = 2;
    myMenu.frame.curr_selection = -100;
    myMenu.frame.start_line = 0;
    myMenu.frame.end_line = 2;
    myMenu.curr_location = PRINT;

    // Display_displayMenu(&g_mss_uart1);

    int i;
    int x_mean = 0;
    int y_mean = 0;
    int count = 50;
    for (i = 0; i < count; i++) {
        Two_Block data = Pixy_getData(&g_mss_spi1);
        x_mean += data.x1;
        y_mean += data.y1;
    }

    x_mean /= count;
    y_mean /= count;

    switch (pos) {
        case TOP_LEFT:
            range.ltx = x_mean;
            range.lty = y_mean;
            printf("Top-left: %d, %d\r\n", range.ltx, range.lty);
            break;
        case TOP_RIGHT:
            range.rtx = x_mean;
            range.rty = y_mean;
            printf("Top-right: %d, %d\r\n", range.rtx, range.rty);
            break;
        case BOTTOM_LEFT:
            range.lbx = x_mean;
            range.lby = y_mean;
            printf("Bottom-left: %d, %d\r\n", range.lbx, range.lby);
            break;
        case BOTTOM_RIGHT:
            range.rbx = x_mean;
            range.rby = y_mean;
            printf("Bottom-right: %d, %d\r\n", range.rbx, range.rby);
            break;
        default:
            break;
    }

    Display_returnLastMenu();
}

void Display_enterCalibrationSuccessful() {
    Display_clearMenu();
    strcpy(myMenu.layer[1], " Calibration Done! ");
    strcpy(myMenu.layer[3], "  LEFT for return  ");
    myMenu.frame.length = 4;
    myMenu.frame.curr_selection = -100;
    myMenu.frame.start_line = 0;
    myMenu.frame.end_line = 4;
    myMenu.curr_location = PRINT;
}

void Display_printSuccessful() {
    Display_clearMenu();
    strcpy(myMenu.layer[1], "   Config Saved    ");
    strcpy(myMenu.layer[3], "  LEFT for return  ");
    myMenu.frame.length = 4;
    myMenu.frame.curr_selection = -100;
    myMenu.frame.start_line = 0;
    myMenu.frame.end_line = 4;
    myMenu.curr_location = PRINT;
}

void Display_returnLastMenu() {
    if (myMenu.curr_location == SONG || myMenu.curr_location == MODE || 
        myMenu.curr_location == PRINT || myMenu.curr_location == CALIBRATION) {
        Display_clearMenu();
        Display_initializeMenu();
        myMenu.frame = prev_frame;
    }
    started = false;
}
