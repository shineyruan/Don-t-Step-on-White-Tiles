#include <inttypes.h>
#include <stdbool.h>
#include <stdio.h>
#include "drivers/mss_uart/mss_uart.h"

#include "controller.h"
#include "menu.h"
#include "soundboard.h"
#include "pixy.h"
#include "main.h"

Command NES_command_struct;
Command prev_NES_command_struct;

int main() {
    //vga
	vga_init();

	//pixy
	const uint8_t frame_size = 16;

	/* inconsequential transfer value (for full duplex) */
	const uint16_t master_tx_frame = 0;

	//x: 0~320, left to right
	//y: 0~200, up to down
	BoundingBox range;
	range.lbx=74;
	range.lby=190;
	range.rbx=248;
	range.rby=190;
	range.ltx=83;
	range.lty=5;
	range.rtx=250;
	range.rty=7;

	MSS_SPI_init(&g_mss_spi1);
	MSS_SPI_configure_master_mode(&g_mss_spi1, MSS_SPI_SLAVE_0, MSS_SPI_MODE0,
								  MSS_SPI_PCLK_DIV_256, frame_size);

	MSS_SPI_set_slave_select(&g_mss_spi1, MSS_SPI_SLAVE_0);

    // controller
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

#ifdef DEBUG
    printf("Controller init: %x\r\n", *command_addr);
#endif
    (*soundboard_addr) = 0x7F;
#ifdef DEBUG
    printf("Sound Initial: %x\r\n", *soundboard_addr);
    printf("Controller init: %x\r\n", *command_addr);
#endif


    bool changed = true;

    while (1) {
        delay(400000);
    	//display
    	if (started) {
    		int i;
    		for (i = 0; i < 4; i++) {
    			random_mode(i);
    		}
    	}
        if (changed) {
            Display_displayMenu(&g_mss_uart1);
            changed = false;

            if (myMenu.curr_location == PRINT)
                print_state = true;
            else
                print_state = false;
        }

        //pixy
        uint16_t receive_data[14] = {0};
        int i = 0;
		int j;
    	for (j = 0; j < 10; j++) {

			uint16_t receiver =
							MSS_SPI_transfer_frame(&g_mss_spi1, master_tx_frame);
			uint16_t frame_starter =
				MSS_SPI_transfer_frame(&g_mss_spi1, master_tx_frame);

			/* Two consecutive 0xaa55 means a start of a new frame. */
			if (receiver == PIXY_START_WORD &&
				frame_starter == PIXY_START_WORD) {
				while (i < 12)
					receive_data[i++] =
						MSS_SPI_transfer_frame(&g_mss_spi1, master_tx_frame);
				i = 0;
			}
    	}
        
		Two_Block data;
		data = process(range,receive_data);

		if (is_left_on_tile(sq, data, range)){
			printf("left foot is on tile!\r\n");
		}
		if (is_right_on_tile(sq, data, range)){
			printf("right foot is on tile!\r\n");
		}

        // controller 
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

                    (*soundboard_addr) &= (~(1 << 6)) & (0xFF);
                    continue;
                }
            }
        }
    }

    return 0;
}
