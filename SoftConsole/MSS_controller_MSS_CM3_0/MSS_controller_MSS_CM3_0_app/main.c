#include <inttypes.h>
#include <stdio.h>
#include "drivers/mss_gpio/mss_gpio.h"
#include "drivers/mss_uart/mss_uart.h"

int main() {
    // uint8_t reset[] = {0x12};
    // uint8_t clear_display[] = {0xFE, 0x01};
    // uint8_t set_cursor_pos[] = {0xFE, 0x80};
    // uint8_t backlight_off[] = {0x7C, 0x80};
    // uint8_t tx_buff[] = "Hello World!";

    // /* Initialize the UART1 */
    // MSS_UART_init(&g_mss_uart1, MSS_UART_9600_BAUD,
    //               MSS_UART_DATA_8_BITS | MSS_UART_NO_PARITY | MSS_UART_ONE_STOP_BIT);

    // while (1) {
    //     MSS_UART_polled_tx(&g_mss_uart1, reset, sizeof(reset));
    //     MSS_UART_polled_tx(&g_mss_uart1, clear_display, sizeof(clear_display));
    // }

    volatile uint8_t* command_addr = (uint8_t*)(0x40050000);

    while (1) {
        uint8_t command = (*command_addr);
        printf("Right: %d  Left: %d  Down: %d  Up: %d  Start: %d  Select: %d  B: %d  A: %d\r\n",
               command & (0x1), (command >> 1) & 0x1, (command >> 2) & 0x1, (command >> 3) & 0x1,
               (command >> 4) & 0x1, (command >> 5) & 0x1, (command >> 6) & 0x1, (command >> 7) & 0x1);
    }

    return 0;
}
