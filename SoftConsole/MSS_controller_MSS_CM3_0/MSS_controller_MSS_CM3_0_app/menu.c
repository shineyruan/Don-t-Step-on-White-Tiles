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

void Display_newline_scroll(mss_uart_instance_t *this_uart, const uint8_t *content){
    if (Display.line_1[0] == 0)
        strcpy(Display.line_1, content);
    else if (Display.line_2[0] == 0)
        strcpy(Display.line_2, content);
    else if (Display.line_3[0] == 0)
        strcpy(Display.line_3, content);
    else if (Display.line_4[0] == 0)
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
