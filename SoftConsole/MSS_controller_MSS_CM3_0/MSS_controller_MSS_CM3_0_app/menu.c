#include "menu.h"

void Display_newline(mss_uart_instance_t *this_uart, const uint8_t *content) {
    if (Display.curr_line_num + 1 < 4)
        Display.curr_line_num++;
    else
        Display.curr_line_num = 0;

    strcpy(Display.lines[Display.curr_line_num], content);

    Display_frame(this_uart);
}

void Display_newline_scroll(mss_uart_instance_t *this_uart, const uint8_t *content) {
    bool all_filled = true;

    int i = 0;
    for (i = 0; i < 4; i++)
        if (!Display_lineEmpty(Display.lines[i])) {
            strcpy(Display.lines[i], content);
            all_filled = false;
            break;
        }

    if (all_filled) {
        for (i = 0; i < 3; i++)
            strcpy(Display.lines[i], Display.lines[i + 1]);

        strcpy(Display.lines[3], content);
    }

    Display_frame(this_uart);
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
    strcpy(myMenu.layer_1[0], "Player 1");
    strcpy(myMenu.layer_1[1], "Player 2");
    strcpy(myMenu.layer_1[2], "Player 3");
    strcpy(myMenu.layer_1[3], "Player 4");
    strcpy(myMenu.layer_1[4], "Player 5");
    strcpy(myMenu.layer_1[5], "Player 6");
    myMenu.curr_selection = 0;
    myMenu.start_line = 0;
    myMenu.end_line = 4;
}

void Display_displayMenu() {
    if (myMenu.curr_selection >= 0 && myMenu.curr_selection <= 1) {
        uint8_t combined;
        strcpy(combined, "> ");
        strcat(combined, myMenu.layer_1[myMenu.curr_selection]);
    }
}
