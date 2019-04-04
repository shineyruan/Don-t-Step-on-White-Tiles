#include "menu.h"

void Display_newline(mss_uart_instance_t *this_uart, const uint8_t *content) {
    if (Display.curr_line_num + 1 < 4)
        Display.curr_line_num++;
    else
        Display.curr_line_num = 0;

    switch (Display.curr_line_num) {
        case 0:
            strcpy(Display.line_1, content);
            break;
        case 1:
            strcpy(Display.line_2, content);
            break;
        case 2:
            strcpy(Display.line_3, content);
            break;
        case 3:
            strcpy(Display.line_4, content);
            break;

        default:
            break;
    }

    Display_frame(this_uart);
}

void Display_newline_scroll(mss_uart_instance_t *this_uart, const uint8_t *content) {
    if (Display_lineEmpty(1))
        strcpy(Display.line_1, content);
    else if (Display_lineEmpty(2))
        strcpy(Display.line_2, content);
    else if (Display_lineEmpty(3))
        strcpy(Display.line_3, content);
    else if (Display_lineEmpty(4))
        strcpy(Display.line_4, content);
    else {
        strcpy(Display.line_1, Display.line_2);
        strcpy(Display.line_2, Display.line_3);
        strcpy(Display.line_3, Display.line_4);
        strcpy(Display.line_4, content);
    }

    Display_frame(this_uart);
}

void Display_frame(mss_uart_instance_t *this_uart) {
    MSS_UART_polled_tx(this_uart, clear_display, sizeof(clear_display));
    // display line 1
    set_cursor_pos[1] = CURSOR_POS_BASE + line_start[0];
    MSS_UART_polled_tx(this_uart, set_cursor_pos, sizeof(set_cursor_pos));
    MSS_UART_polled_tx_string(this_uart, Display.line_1);
    // display line 2
    set_cursor_pos[1] = CURSOR_POS_BASE + line_start[1];
    MSS_UART_polled_tx(this_uart, set_cursor_pos, sizeof(set_cursor_pos));
    MSS_UART_polled_tx_string(this_uart, Display.line_2);
    // display line 3
    set_cursor_pos[1] = CURSOR_POS_BASE + line_start[2];
    MSS_UART_polled_tx(this_uart, set_cursor_pos, sizeof(set_cursor_pos));
    MSS_UART_polled_tx_string(this_uart, Display.line_3);
    // display line 4
    set_cursor_pos[1] = CURSOR_POS_BASE + line_start[3];
    MSS_UART_polled_tx(this_uart, set_cursor_pos, sizeof(set_cursor_pos));
    MSS_UART_polled_tx_string(this_uart, Display.line_4);
}

bool Display_lineEmpty(int line) {
    bool flag = true;
    int i = 0;

    switch (line) {
        case 1:
            for (i = 0; i < 20; i++)
                if (Display.line_1[i] != 0 && Display.line_1[i] != ' ') {
                    flag = false;
                    break;
                }
            break;
        case 2:
            for (i = 0; i < 20; i++)
                if (Display.line_2[i] != 0 && Display.line_2[i] != ' ') {
                    flag = false;
                    break;
                }
            break;
        case 3:
            for (i = 0; i < 20; i++)
                if (Display.line_3[i] != 0 && Display.line_3[i] != ' ') {
                    flag = false;
                    break;
                }
            break;
        case 4:
            for (i = 0; i < 20; i++)
                if (Display.line_4[i] != 0 && Display.line_4[i] != ' ') {
                    flag = false;
                    break;
                }
            break;

        default:
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
    myMenu.scroll_history = -1;
}

void Display_displayMenu() {
    if (myMenu.curr_selection >= 0 && myMenu.curr_selection <= 1) {
        uint8_t combined;
        strcpy(combined, "> ");
        strcat(combined, myMenu.layer_1[myMenu.curr_selection]);
    }
}
