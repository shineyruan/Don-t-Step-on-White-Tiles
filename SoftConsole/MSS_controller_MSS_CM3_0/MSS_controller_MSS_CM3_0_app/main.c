#include <inttypes.h>
#include <stdbool.h>
#include <stdio.h>
#include "drivers/mss_uart/mss_uart.h"

#include "controller.h"
#include "menu.h"
#include "soundboard.h"

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
    printf("Controller init: %x\r\n", *command_addr);
    // (*soundboard_addr) = 0x7F;
    // printf("Sound Initial: %x\r\n", *soundboard_addr);
    printf("Controller init: %x\r\n", *command_addr);


    bool changed = true;

    while (1) {
        if (changed) {
            Display_displayMenu(&g_mss_uart1);
            changed = false;

            if (myMenu.curr_location == PRINT)
                print_state = true;
            else
                print_state = false;
        }

        prev_NES_command_struct = NES_command_struct;

        Controller_getCommand(&NES_command_struct);

        if (NES_command_struct.right) {
            if (!(prev_NES_command_struct.right && NES_command_struct.right)) {
                switch (myMenu.curr_location) {
                    case ROOT:
                        if (myMenu.frame.curr_selection == 0) {
                            Display_enterStart();
                            changed = true;
                        } else if (myMenu.frame.curr_selection == 1) {
                            Display_enterModeSelections();
                            changed = true;
                        } else if (myMenu.frame.curr_selection == 2) {
                            Display_enterSongSelections();
                            changed = true;
                        } else if (myMenu.frame.curr_selection == 3) {
                            Display_enterPrintConfig();
                            changed = true;
                        }
                        break;
                    case MODE:
                        if (myMenu.frame.curr_selection == 0) {
                            Display_printSuccessful();
                            selected_config.selected_mode = SLOW;
                            changed = true;
                        } else if (myMenu.frame.curr_selection == 1) {
                            selected_config.selected_mode = MEDIUM;
                            Display_printSuccessful();
                            changed = true;
                        } else if (myMenu.frame.curr_selection == 2) {
                            selected_config.selected_mode = FAST;
                            Display_printSuccessful();
                            changed = true;
                        }
                        break;
                    case SONG:
                        selected_config.selected_song = myMenu.frame.curr_selection + 1;
                        Display_printSuccessful();
                        changed = true;
                        break;
                    default:
                        break;
                }
                continue;
            }
        }
        if (NES_command_struct.left) {
            if (!(prev_NES_command_struct.left && NES_command_struct.left)) {
                if (!started) {
                    Display_returnLastMenu();
                    changed = true;
                    continue;
                }
            }
        }
        if (NES_command_struct.down) {
            if (!(prev_NES_command_struct.down && NES_command_struct.down)) {
                if (!started && !print_state) {
                    Display_scrollDownMenu();
                    changed = true;
                    continue;
                }
            }
        }
        if (NES_command_struct.up) {
            if (!(prev_NES_command_struct.up && NES_command_struct.up)) {
                if (!started && !print_state) {
                    Display_scrollUpMenu();
                    changed = true;
                    continue;
                }
            }
        }
        if (NES_command_struct.select) {
            if (!(prev_NES_command_struct.select && NES_command_struct.select)) {
                switch (myMenu.curr_location) {
                    case ROOT:
                        if (myMenu.frame.curr_selection == 0) {
                            Display_enterStart();
                            changed = true;
                        } else if (myMenu.frame.curr_selection == 1) {
                            Display_enterModeSelections();
                            changed = true;
                        } else if (myMenu.frame.curr_selection == 2) {
                            Display_enterSongSelections();
                            changed = true;
                        } else if (myMenu.frame.curr_selection == 3) {
                            Display_enterPrintConfig();
                            changed = true;
                        }
                        break;
                    case MODE:
                        if (myMenu.frame.curr_selection == 0) {
                            Display_printSuccessful();
                            selected_config.selected_mode = SLOW;
                            changed = true;
                        } else if (myMenu.frame.curr_selection == 1) {
                            selected_config.selected_mode = MEDIUM;
                            Display_printSuccessful();
                            changed = true;
                        } else if (myMenu.frame.curr_selection == 2) {
                            selected_config.selected_mode = FAST;
                            Display_printSuccessful();
                            changed = true;
                        }
                        break;
                    case SONG:
                        selected_config.selected_song = myMenu.frame.curr_selection + 1;
                        Display_printSuccessful();
                        changed = true;
                        break;
                    default:
                        break;
                }
                continue;
            }
        }
        if (NES_command_struct.button_a) {
            if (!(prev_NES_command_struct.button_a && NES_command_struct.button_a)) {
                MSS_UART_polled_tx(&g_mss_uart1, reset, sizeof(reset));
                Display_clearMenu();
                Display_initializeMenu();
                started = false;
                prev_frame = myMenu.frame;
                changed = true;
            }
        }
        if (NES_command_struct.button_b) {
            if (!(prev_NES_command_struct.button_b && NES_command_struct.button_b)) {
                if (started) {
                    Display_returnLastMenu();
                    changed = true;
                    continue;

                    // (*soundboard_addr) &= ~(1 << 6);
                }
            }
        }
    }

    return 0;
}
