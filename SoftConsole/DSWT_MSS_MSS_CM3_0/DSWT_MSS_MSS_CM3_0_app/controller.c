#include "controller.h"

inline void Controller_getCommand(Command* cmd_struct) {
    uint8_t command = (*command_addr);

    cmd_struct->right = command & 0x1;
    cmd_struct->left = (command >> 1) & 0x1;
    cmd_struct->down = (command >> 2) & 0x1;
    cmd_struct->up = (command >> 3) & 0x1;
    cmd_struct->start = (command >> 4) & 0x1;
    cmd_struct->select = (command >> 5) & 0x1;
    cmd_struct->button_b = (command >> 6) & 0x1;
    cmd_struct->button_a = (command >> 7) & 0x1;
}

void Controller_getAction(Command* cmd_struct, Command* prev_cmd_struct) {
    Command NES_command_struct = *cmd_struct;
    Command prev_NES_command_struct = *prev_cmd_struct;

    if (NES_command_struct.right && !(prev_NES_command_struct.right && NES_command_struct.right)) {
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
        return;
    }
    if (NES_command_struct.left) {
        if (!(prev_NES_command_struct.left && NES_command_struct.left)) {
            if (!started) {
                Display_returnLastMenu();
                changed = true;
                return;
            }
        }
    }
    if (NES_command_struct.down) {
        if (!(prev_NES_command_struct.down && NES_command_struct.down)) {
            if (!started && !print_state) {
                Display_scrollDownMenu();
                changed = true;
                return;
            }
        }
    }
    if (NES_command_struct.up) {
        if (!(prev_NES_command_struct.up && NES_command_struct.up)) {
            if (!started && !print_state) {
                Display_scrollUpMenu();
                changed = true;
                return;
            }
        }
    }
    if (NES_command_struct.button_b) {
        if (!(prev_NES_command_struct.button_b && NES_command_struct.button_b)) {
            if (started) {
                Display_returnLastMenu();
                changed = true;
                vga_init();
                (*soundboard_addr) &= (~(1 << 6)) & (0xFF);
                return;
            }
        }
    }
}
