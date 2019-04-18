#include <inttypes.h>
#include <stdbool.h>
#include <stdio.h>
#include "drivers/mss_uart/mss_uart.h"

#include "controller.h"
#include "vga.h"
#include "menu.h"
#include "pixy.h"
#include "soundboard.h"

extern volatile uint8_t* soundboard_addr;
extern uint16_t receive_data[14];
//0..9: col_width 10..19: col1 20..29: col2
extern volatile int *col_addr1;
//0..9: col3 10..19: col4 20..29: col5
extern volatile int *col_addr2;
//0..9: length of column: 480
extern volatile int *col_addr3;

extern volatile int *num_addr0;
extern volatile int *num_addr1;
extern volatile int *num_addr2;
extern int speed;

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

int main() {
	Command NES_command_struct;
	Command prev_NES_command_struct;

    /* Enable FABINT Interrupt for generating tiles */
    NVIC_EnableIRQ(Fabric_IRQn);

    // vga
    vga_init();

    // pixy
    const uint8_t frame_size = 16;
    MSS_SPI_init(&g_mss_spi1);
    MSS_SPI_configure_master_mode(&g_mss_spi1, MSS_SPI_SLAVE_0, MSS_SPI_MODE0,
                                  MSS_SPI_PCLK_DIV_256, frame_size);

    MSS_SPI_set_slave_select(&g_mss_spi1, MSS_SPI_SLAVE_0);

    /* LCD init */
    MSS_UART_init(&g_mss_uart1, MSS_UART_9600_BAUD,
                  MSS_UART_DATA_8_BITS | MSS_UART_NO_PARITY | MSS_UART_ONE_STOP_BIT);

#ifdef INIT_DEBUG
    printf("Controller init: %x\r\n", *command_addr);
#endif
    (*soundboard_addr) = 0x7F;
#ifdef INIT_DEBUG
    printf("Sound Initial: %x\r\n", *soundboard_addr);
    printf("Controller init: %x\r\n", *command_addr);
#endif

    Display_initializeMenu();
    started = false;
    changed = true;

    while (1) {
        // pixy
        int i;
        for (i = 0; i < 14; i++) {
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
        Controller_getAction(&NES_command_struct, &prev_NES_command_struct);
    }

    return 0;
}
