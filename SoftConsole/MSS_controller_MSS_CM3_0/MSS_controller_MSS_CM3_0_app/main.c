#include <inttypes.h>
#include <stdbool.h>
#include <stdio.h>
#include "drivers/mss_uart/mss_uart.h"

#include "controller.h"
#include "menu.h"

Command NES_command_struct;
Command prev_NES_command_struct;

int main() {
    Display.curr_line_num = 0;

    /* Initialize the UART1 */
    MSS_UART_init(&g_mss_uart1, MSS_UART_9600_BAUD,
                  MSS_UART_DATA_8_BITS | MSS_UART_NO_PARITY | MSS_UART_ONE_STOP_BIT);

    /************* Welcome Message *************/

    uint8_t tx_buff[] = "Welcome to Nintendo!";

    MSS_UART_polled_tx(&g_mss_uart1, clear_display, sizeof(clear_display));
    MSS_UART_polled_tx(&g_mss_uart1, set_cursor_pos, sizeof(set_cursor_pos));
    MSS_UART_polled_tx_string(&g_mss_uart1, tx_buff);

    /*******************************************/

    Display_initializeMenu();

    bool changed = true;

    while (1) {
        if (changed) {
            Display_displayMenu(&g_mss_uart1);
            changed = false;
        }

        prev_NES_command_struct = NES_command_struct;

        Controller_getCommand(&NES_command_struct);

        if (NES_command_struct.right) {
            if (!(prev_NES_command_struct.right && NES_command_struct.right)) {
                if (myMenu.curr_location == ROOT) {
                    if (myMenu.curr_selection == 1) {
                        Display_enterModeSelections();
                        changed = true;
                    } else if (myMenu.curr_selection == 2) {
                        Display_enterSongSelections();
                        changed = true;
                    } else if (myMenu.curr_selection == 3) {
                        Display_enterPrintConfig();
                        changed = true;
                    }
                }
                continue;
            }
        }
        if (NES_command_struct.left) {
            if (!(prev_NES_command_struct.left && NES_command_struct.left)) {
                Display_returnLastMenu();
                changed = true;
                continue;
            }
        }
        if (NES_command_struct.down) {
            if (!(prev_NES_command_struct.down && NES_command_struct.down)) {
                Display_scrollDownMenu();
                changed = true;
                continue;
            }
        }
        if (NES_command_struct.up) {
            if (!(prev_NES_command_struct.up && NES_command_struct.up)) {
                Display_scrollUpMenu();
                changed = true;
                continue;
            }
        }
        // if (NES_command_struct.start) {
        //     if (!(prev_NES_command_struct.start && NES_command_struct.start)) {
        //         Display_newline_scroll(&g_mss_uart1, "Start");
        //     }
        // }
        if (NES_command_struct.select) {
            if (!(prev_NES_command_struct.select && NES_command_struct.select)) {
                if (myMenu.curr_location == ROOT) {
                    if (myMenu.curr_selection == 1) {
                        Display_enterModeSelections();
                        changed = true;
                    } else if (myMenu.curr_selection == 2) {
                        Display_enterSongSelections();
                        changed = true;
                    } else if (myMenu.curr_selection == 3) {
                        Display_enterPrintConfig();
                        changed = true;
                    }
                }
            }
        }
        // if (NES_command_struct.button_a) {
        //     if (!(prev_NES_command_struct.button_a && NES_command_struct.button_a)) {
        //         Display_newline_scroll(&g_mss_uart1, "A");
        //     }
        // }
        // if (NES_command_struct.button_b) {
        //     if (!(prev_NES_command_struct.button_b && NES_command_struct.button_b)) {
        //         Display_newline_scroll(&g_mss_uart1, "B");
        //     }
        // }
    }

    return 0;
}
