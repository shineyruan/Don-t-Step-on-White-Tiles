#include <inttypes.h>
#include <stdbool.h>
#include <stdio.h>
#include "drivers/mss_gpio/mss_gpio.h"
#include "drivers/mss_uart/mss_uart.h"

#define CURSOR_POS_BASE 0x80
#define FIRST_LINE_START 0
#define SECOND_LINE_START 64
#define THIRD_LINE_START 20
#define FOURTH_LINE_START 84

typedef struct Controller {
    /* data */
    bool right;
    bool left;
    bool down;
    bool up;
    bool start;
    bool select;
    bool button_b;
    bool button_a;
} Command;

typedef struct LCD {
    /* data */
    uint8_t line_num;
} LCD_Display;

Command NES_command_struct;
Command prev_NES_command_struct;
LCD_Display Display;

static uint8_t line_start[] = {0, 64, 20, 84};

void newline();

int main() {
    Display.line_num = 0;

    uint8_t reset[] = {0x12};
    uint8_t clear_display[] = {0xFE, 0x01};
    uint8_t set_cursor_pos[] = {0xFE, CURSOR_POS_BASE + 20 * Display.line_num};
    uint8_t backlight_off[] = {0x7C, 0x80};
    uint8_t tx_buff[] = "Hello! Welcome to Nintendo!";

    /* Initialize the UART1 */
    MSS_UART_init(&g_mss_uart1, MSS_UART_9600_BAUD,
                  MSS_UART_DATA_8_BITS | MSS_UART_NO_PARITY | MSS_UART_ONE_STOP_BIT);

    MSS_UART_polled_tx(&g_mss_uart1, reset, sizeof(reset));
    MSS_UART_polled_tx(&g_mss_uart1, clear_display, sizeof(clear_display));
    MSS_UART_polled_tx(&g_mss_uart1, set_cursor_pos, sizeof(set_cursor_pos));
    MSS_UART_polled_tx_string(&g_mss_uart1, tx_buff);

    volatile uint8_t* command_addr = (uint8_t*)(0x40050000);

    while (1) {
        prev_NES_command_struct = NES_command_struct;

        uint8_t command = (*command_addr);

        NES_command_struct.right = command & 0x1;
        NES_command_struct.left = (command >> 1) & 0x1;
        NES_command_struct.down = (command >> 2) & 0x1;
        NES_command_struct.up = (command >> 3) & 0x1;
        NES_command_struct.start = (command >> 4) & 0x1;
        NES_command_struct.select = (command >> 5) & 0x1;
        NES_command_struct.button_b = (command >> 6) & 0x1;
        NES_command_struct.button_a = (command >> 7) & 0x1;

        if (NES_command_struct.right) {
            if (!(prev_NES_command_struct.right && NES_command_struct.right)) {
                uint8_t tx_str[] = "Right";
                newline();
                MSS_UART_polled_tx_string(&g_mss_uart1, tx_str);
            }
        }
        if (NES_command_struct.left) {
            if (!(prev_NES_command_struct.left && NES_command_struct.left)) {
                uint8_t tx_str[] = "Left";
                newline();
                MSS_UART_polled_tx_string(&g_mss_uart1, tx_str);
            }
        }
        if (NES_command_struct.down) {
            if (!(prev_NES_command_struct.down && NES_command_struct.down)) {
                uint8_t tx_str[] = "Down";
                newline();
                MSS_UART_polled_tx_string(&g_mss_uart1, tx_str);
            }
        }
        if (NES_command_struct.up) {
            if (!(prev_NES_command_struct.up && NES_command_struct.up)) {
                uint8_t tx_str[] = "Up";
                newline();
                MSS_UART_polled_tx_string(&g_mss_uart1, tx_str);
            }
        }
        if (NES_command_struct.start) {
            if (!(prev_NES_command_struct.start && NES_command_struct.start)) {
                uint8_t tx_str[] = "Start";
                newline();
                MSS_UART_polled_tx_string(&g_mss_uart1, tx_str);
            }
        }
        if (NES_command_struct.select) {
            if (!(prev_NES_command_struct.select && NES_command_struct.select)) {
                uint8_t tx_str[] = "Select";
                newline();
                MSS_UART_polled_tx_string(&g_mss_uart1, tx_str);
            }
        }
        if (NES_command_struct.button_a) {
            if (!(prev_NES_command_struct.button_a && NES_command_struct.button_a)) {
                uint8_t tx_str[] = "A";
                newline();
                MSS_UART_polled_tx_string(&g_mss_uart1, tx_str);
            }
        }
        if (NES_command_struct.button_b) {
            if (!(prev_NES_command_struct.button_b && NES_command_struct.button_b)) {
                uint8_t tx_str[] = "B";
                newline();
                MSS_UART_polled_tx_string(&g_mss_uart1, tx_str);
            }
        }
    }

    return 0;
}

void newline() {
    if (Display.line_num + 1 < 4)
        Display.line_num++;
    else
        Display.line_num = 0;

    uint8_t set_cursor_pos[] = {0xFE, CURSOR_POS_BASE + line_start[Display.line_num]};
    MSS_UART_polled_tx(&g_mss_uart1, set_cursor_pos, sizeof(set_cursor_pos));

    uint8_t clear_line[] = "                    ";
    MSS_UART_polled_tx_string(&g_mss_uart1, clear_line);

    MSS_UART_polled_tx(&g_mss_uart1, set_cursor_pos, sizeof(set_cursor_pos));
}
