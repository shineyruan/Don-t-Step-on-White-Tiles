#include <inttypes.h>
#include <stdio.h>
#include "drivers/mss_uart/mss_uart.h"
#include "drivers/mss_gpio/mss_gpio.h"

int main() {
    uint8_t reset[] = {0x12};
    uint8_t clear_display[] = {0xFE, 0x01};
    uint8_t set_cursor_pos[] = {0xFE, 0x80};
    uint8_t backlight_off[] = {0x7C, 0x80};
    uint8_t tx_buff[] = "Hello World!";

    /* Initialize the UART1 */
    MSS_UART_init(&g_mss_uart1, MSS_UART_9600_BAUD,
                  MSS_UART_DATA_8_BITS | MSS_UART_NO_PARITY | MSS_UART_ONE_STOP_BIT);

    while (1) {
        MSS_UART_polled_tx(&g_mss_uart1, reset, sizeof(reset));
        MSS_UART_polled_tx(&g_mss_uart1, clear_display, sizeof(clear_display));
    }

    return 0;
}
