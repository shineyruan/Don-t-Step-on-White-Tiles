#include <inttypes.h>
#include <stdbool.h>
#include <stdio.h>
#include <string.h>
#include "drivers/mss_uart/mss_uart.h"
#include "drivers/mss_gpio/mss_gpio.h"

#include "controller.h"
#include "vga.h"
#include "menu.h"
#include "pixy.h"
#include "soundboard.h"

Command NES_command_struct;
Command prev_NES_command_struct;

/******************* EXTERNAL VARIABLES *******************/
// controller.h
extern volatile uint8_t* command_addr;
extern bool changed;
// vga.h
extern volatile int* col_addr1;
extern volatile int* col_addr2;
extern volatile int* col_addr3;
extern volatile int* num_addr0;
extern volatile int* num_addr1;
extern volatile int* num_addr2;
extern int number[10];
extern sq_info sq[8];
extern health_info health[5];
extern int speed;
extern bool dead;
// menu.h
extern bool started;
extern bool print_state;
extern LCD_Display Display;
extern Menu myMenu;
extern Menu_Essential prev_frame;
extern Selected selected_config;
extern uint8_t line_start[4];
extern uint8_t set_cursor_pos[2];
extern uint8_t reset[1];
extern uint8_t clear_display[2];
// pixy.h
extern BoundingBox range;
extern Position pos;
extern int score;
extern uint16_t receive_data[14];
// soundboard.h
extern volatile uint8_t* soundboard_addr;
/**********************************************************/

__attribute__((interrupt)) void Fabric_IRQHandler(void) {
    NVIC_ClearPendingIRQ(Fabric_IRQn);

    int i;
    if (started && !dead) {
        for (i = 0; i < sq_num; i++) {
            random_mode(i);
        }
        set_score(score);
        set_health();
        bool found = false;
        for (i = 0; i < heart_num; i++)
            if (health[i].alive)
                found = true;
        if (!found)
            dead = true;
    }
}

void init_everything() {
    // controller.h
    command_addr = (uint8_t*)(CONTROLLER_ADDR);
    // menu.h
    static const uint8_t line_start_temp[] = {0, 64, 20, 84};
    memcpy(line_start, line_start_temp, sizeof(line_start_temp));
    static const uint8_t set_cursor_pos_temp[] = {0xFE, CURSOR_POS_BASE};
    memcpy(set_cursor_pos, set_cursor_pos_temp, sizeof(set_cursor_pos_temp));
    reset[0] = 0x12;
    static const uint8_t clear_display_temp[] = {0xFE, 0x01};
    memcpy(clear_display, clear_display_temp, sizeof(clear_display_temp));
    // soundboard.h
    soundboard_addr = (uint8_t*)(SOUNDBOARD_ADDR);
    // vga.h
    col_addr1 = (int*)0x40050000;
    col_addr2 = (int*)0x40050004;
    col_addr3 = (int*)0x40050038;
    num_addr0 = (int*)0x4005001c;
    num_addr1 = (int*)0x40050020;
    num_addr2 = (int*)0x40050028;
    static const int number_temp[10] = {0x0f99999f, 0x04444444, 0x0f11f88f, 0x0f11f11f,
                                        0x0aaaaf22, 0x0f88f11f, 0x0f88f99f, 0x0f111111,
                                        0x0f99f99f, 0x0f99f11f};
    memcpy(number, number_temp, sizeof(number_temp));
}

void SoundEffect() {
    MSS_GPIO_set_output(MSS_GPIO_2, 0);
    int i = 0;
    for (i = 0; i < 10000; ++i) {
    }
    MSS_GPIO_set_output(MSS_GPIO_2, 1);
}

int main() {
    // common
    init_everything();

    /* initiate Sound Board */
    MSS_GPIO_init();
    MSS_GPIO_config(MSS_GPIO_0, MSS_GPIO_OUTPUT_MODE);
    MSS_GPIO_config(MSS_GPIO_1, MSS_GPIO_OUTPUT_MODE);
    MSS_GPIO_config(MSS_GPIO_2, MSS_GPIO_OUTPUT_MODE);
    MSS_GPIO_set_output(MSS_GPIO_0, 1);
    MSS_GPIO_set_output(MSS_GPIO_1, 1);
    MSS_GPIO_set_output(MSS_GPIO_2, 1);

    /* Enable FABINT Interrupt for generating tiles */
    NVIC_EnableIRQ(Fabric_IRQn);

    // vga
    vga_init();

    // pixy
    const frame_size = 16;
    MSS_SPI_init(&g_mss_spi1);
    MSS_SPI_configure_master_mode(&g_mss_spi1, MSS_SPI_SLAVE_0, MSS_SPI_MODE0,
                                  MSS_SPI_PCLK_DIV_256, frame_size);

    MSS_SPI_set_slave_select(&g_mss_spi1, MSS_SPI_SLAVE_0);

    /* LCD init */
    MSS_UART_init(&g_mss_uart1, MSS_UART_9600_BAUD,
                  MSS_UART_DATA_8_BITS | MSS_UART_NO_PARITY | MSS_UART_ONE_STOP_BIT);

    Display_initializeMenu();
    started = false;
    (*soundboard_addr) = 0x7F;

    changed = true;
    while (1) {
        // pixy
        // memset(receive_data, 0, sizeof(receive_data));
        Two_Block data = Pixy_getData(&g_mss_spi1);
        // printf(
        // "signature: %d\t    x center: %*d\t    y center: %*d\t    width: %*d\t    height: %*d\t 	column: %d\r\n",
        // data.signature1, 3, data.x1, 3, data.y1, 3, data.width1, 3, data.height1, data.col1);
        // printf(
        // "signature: %d\t    x center: %*d\t    y center: %*d\t    width: %*d\t    height: %*d\t 	column: %d\r\n",
        // data.signature2, 3, data.x2, 3, data.y2, 3, data.width2, 3, data.height2, data.col2);

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

        if (!is_left_on_tile(sq, data) || !(is_right_on_tile(sq, data))) {
            SoundEffect();
        }

        // controller
        prev_NES_command_struct = NES_command_struct;
        Controller_getCommand(&NES_command_struct);
        Controller_getAction(&NES_command_struct, &prev_NES_command_struct);
    }

    return 0;
}
