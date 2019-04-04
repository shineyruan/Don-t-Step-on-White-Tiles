#include "controller.h"

void Controller_getCommand(Command* cmd_struct) {
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