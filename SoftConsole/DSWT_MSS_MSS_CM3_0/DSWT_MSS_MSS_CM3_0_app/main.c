#include <inttypes.h>
#include <stdbool.h>
#include <stdio.h>
#include "drivers/mss_uart/mss_uart.h"

#include "controller.h"
#include "main.h"
#include "menu.h"
#include "pixy.h"
#include "soundboard.h"

Command NES_command_struct;
Command prev_NES_command_struct;

__attribute__((interrupt)) void Fabric_IRQHandler(void) {
    NVIC_ClearPendingIRQ(Fabric_IRQn);

    int i;

    if (started) {
        for (i = 0; i < 4; i++) {
            random_mode(i);
        }
        set_score(score);
    }
}
int main() {
    /* Enable FABINT Interrupt for generating tiles */
    NVIC_EnableIRQ(Fabric_IRQn);

    // pixy
    // x: 0~320, left to right
    // y: 0~200, up to down

    // range.lbx = 63;
    // range.lby = 164;
    // range.rbx = 285;
    // range.rby = 165;
    // range.ltx = 54;
    // range.lty = 20;
    // range.rtx = 311;
    // range.rty = 25;

    // vga
    vga_init();

    const uint8_t frame_size = 16;
    MSS_SPI_init(&g_mss_spi1);
    MSS_SPI_configure_master_mode(&g_mss_spi1, MSS_SPI_SLAVE_0, MSS_SPI_MODE0,
                                  MSS_SPI_PCLK_DIV_256, frame_size);

    MSS_SPI_set_slave_select(&g_mss_spi1, MSS_SPI_SLAVE_0);

    // controller
    Display.curr_line_num = 0;

    /* LCD init */
    MSS_UART_init(&g_mss_uart1, MSS_UART_9600_BAUD,
                  MSS_UART_DATA_8_BITS | MSS_UART_NO_PARITY | MSS_UART_ONE_STOP_BIT);

    /************* Welcome Message *************/

    uint8_t tx_buff[] = "Welcome to Nintendo!";

    MSS_UART_polled_tx(&g_mss_uart1, clear_display, sizeof(clear_display));
    MSS_UART_polled_tx(&g_mss_uart1, set_cursor_pos, sizeof(set_cursor_pos));
    MSS_UART_polled_tx_string(&g_mss_uart1, tx_buff);

    /*******************************************/

    Display_initializeMenu();
    started = false;

#ifdef INIT_DEBUG
    printf("Controller init: %x\r\n", *command_addr);
#endif
    (*soundboard_addr) = 0x7F;
#ifdef INIT_DEBUG
    printf("Sound Initial: %x\r\n", *soundboard_addr);
    printf("Controller init: %x\r\n", *command_addr);
#endif

    bool changed = true;
    while (1) {
        // pixy
        int i;
        for (i = 0; i < 14;i++){
            receive_data[i] = 0;
        }
        Two_Block data = Pixy_getData(&g_mss_spi1);

        // LCD display
        if (changed) {
            Display_displayMenu(&g_mss_uart1);
            changed = false;

            if (myMenu.curr_location == PRINT)
                print_state = true;
            else
                print_state = false;
        }

        // pixy judge
        if (is_left_on_tile(sq, data)) {
            printf("left foot is on tile!\r\n");
        }
        if (is_right_on_tile(sq, data)) {
            printf("right foot is on tile!\r\n");
        }

        // controller
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
                        } else if (myMenu.frame.curr_selection == 4) {
                            Display_enterCalibrationMode();
                            changed = true;
                        }
                        break;
                    case MODE:
                        if (myMenu.frame.curr_selection == 0) {
                            Display_printSuccessful();
                            selected_config.selected_mode = SLOW;
                            speed = -5;
                            changed = true;
                        } else if (myMenu.frame.curr_selection == 1) {
                            selected_config.selected_mode = MEDIUM;
                            speed = -10;
                            Display_printSuccessful();
                            changed = true;
                        } else if (myMenu.frame.curr_selection == 2) {
                            selected_config.selected_mode = FAST;
                            speed = -15;
                            Display_printSuccessful();
                            changed = true;
                        }
                        break;
                    case SONG:
                        selected_config.selected_song = myMenu.frame.curr_selection + 1;
                        Display_printSuccessful();
                        changed = true;
                        break;
                    case CALIBRATION:
                        if (myMenu.frame.curr_selection == 0) {
                            pos = TOP_LEFT;
                            Display_enterCalibration();
                            changed = true;
                        } else if (myMenu.frame.curr_selection == 1) {
                            pos = TOP_RIGHT;
                            Display_enterCalibration();
                            changed = true;
                        } else if (myMenu.frame.curr_selection == 2) {
                            pos = BOTTOM_RIGHT;
                            Display_enterCalibration();
                            changed = true;
                        } else if (myMenu.frame.curr_selection == 3) {
                            pos = BOTTOM_LEFT;
                            Display_enterCalibration();
                            changed = true;
                        }
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
                        } else if (myMenu.frame.curr_selection == 4) {
                            Display_enterCalibrationMode();
                            changed = true;
                        }
                        break;
                    case MODE:
                        if (myMenu.frame.curr_selection == 0) {
                            Display_printSuccessful();
                            selected_config.selected_mode = SLOW;
                            speed = -5;
                            changed = true;
                        } else if (myMenu.frame.curr_selection == 1) {
                            selected_config.selected_mode = MEDIUM;
                            speed = -10;
                            Display_printSuccessful();
                            changed = true;
                        } else if (myMenu.frame.curr_selection == 2) {
                            selected_config.selected_mode = FAST;
                            speed = -15;
                            Display_printSuccessful();
                            changed = true;
                        }
                        break;
                    case SONG:
                        selected_config.selected_song = myMenu.frame.curr_selection + 1;
                        Display_printSuccessful();
                        changed = true;
                        break;
                    case CALIBRATION:
                        if (myMenu.frame.curr_selection == 0) {
                            pos = TOP_LEFT;
                            Display_enterCalibration();
                            changed = true;
                        } else if (myMenu.frame.curr_selection == 1) {
                            pos = TOP_RIGHT;
                            Display_enterCalibration();
                            changed = true;
                        } else if (myMenu.frame.curr_selection == 2) {
                            pos = BOTTOM_RIGHT;
                            Display_enterCalibration();
                            changed = true;
                        } else if (myMenu.frame.curr_selection == 3) {
                            pos = BOTTOM_LEFT;
                            Display_enterCalibration();
                            changed = true;
                        }
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
                    vga_init();
                    (*soundboard_addr) &= (~(1 << 6)) & (0xFF);
                    continue;
                }
            }
        }
    }

    return 0;
}
