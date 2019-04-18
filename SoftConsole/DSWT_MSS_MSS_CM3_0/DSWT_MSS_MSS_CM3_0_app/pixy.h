/*
 * pixy.h
 *
 *  Created on: Apr 6, 2019
 *      Author: huangkun
 */

#ifndef PIXY_H_
#define PIXY_H_

#include <inttypes.h>
#include <stdbool.h>
#include <stdio.h>
#include "drivers/mss_spi/drivers/mss_spi/mss_spi.h"
#include "drivers/mss_uart/mss_uart.h"

#define PIXY_START_WORD 0xaa55
#define PIXY_START_WORD_CC 0xaa56
#define sq_num 8

typedef enum Box_Position {
    TOP_LEFT,
    TOP_RIGHT,
    BOTTOM_RIGHT,
    BOTTOM_LEFT
} Position;

typedef struct
{
    uint16_t signature1;
    uint16_t x1;
    uint16_t y1;
    uint16_t width1;
    uint16_t height1;
    uint16_t col1;
    uint16_t signature2;
    uint16_t x2;
    uint16_t y2;
    uint16_t width2;
    uint16_t height2;
    uint16_t col2;
} Two_Block;

typedef struct
{
    uint16_t lbx;
    uint16_t lby;
    uint16_t rbx;
    uint16_t rby;
    uint16_t ltx;
    uint16_t lty;
    uint16_t rtx;
    uint16_t rty;
} BoundingBox;

typedef struct {
    int delay;
    int col;
    //top_y: 0-480 up to down, move from down to up
    int top_x, top_y, length;
    int actual_length;
    //0..9 top_x 10..19 top_y 20..29 length 30 left_foot_on 31 right_foot_on
    int left_on;
    int right_on;
    volatile int* addr;
} sq_info;


BoundingBox range;
Position pos;
int score;
static uint16_t receive_data[14];

Two_Block process();
uint16_t tf_floor_2_cam(int y);
bool is_left_on_tile(sq_info* tiles, Two_Block oneframe);
bool is_right_on_tile(sq_info* tiles, Two_Block oneframe);
/**
 * Modifies: global array `receive_data`
 */
inline Two_Block Pixy_getData(mss_spi_instance_t* this_spi);

#endif /* PIXY_H_ */
