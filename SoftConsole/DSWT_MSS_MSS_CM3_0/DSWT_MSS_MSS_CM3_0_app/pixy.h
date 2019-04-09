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
#include <stdbool.h>

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

typedef struct{
	int delay;
	int col;
	//top_y: 0-480 up to down, move from down to up
	int top_x, top_y, length;
	int actual_length;
	//0..9 top_x 10..19 top_y 20..29 length 30 left_foot_on 31 right_foot_on
	volatile int* addr;
    int left_on;
    int right_on;
}sq_info;

Two_Block process(BoundingBox range,uint16_t* receive_data){
	Two_Block oneframe;


	//Object 1
	oneframe.signature1 = receive_data[1];
	oneframe.x1= receive_data[2];
	oneframe.y1= receive_data[3];
	oneframe.width1= receive_data[4];
	oneframe.height1= receive_data[5];



	//determine the column [0:3] of user's position
	uint16_t left = range.lbx+(range.ltx - range.lbx)*(oneframe.y1 - range.lby)/(range.lty-range.lby);
	uint16_t right = range.rbx+(range.rtx - range.rbx)*(oneframe.y1 - range.rby)/(range.rty-range.rby);
	if (oneframe.x1>=left && oneframe.x1<left + (right-left)/4){
		oneframe.col1=0;
	}
	else if (oneframe.x1 >= left + (right-left)/4 && oneframe.x1 < left + (right-left)/2){
		oneframe.col1=1;
	}
	else if (oneframe.x1 >= left + (right-left)/2 && oneframe.x1 < left + (right-left)*3/4){
		oneframe.col1=2;
	}
	else if (oneframe.x1 >= left + (right-left)*3/4 && oneframe.x1 < right){
		oneframe.col1=3;
	}
	else{
		oneframe.col1=4;
	}


	//Object 2
	oneframe.signature2 = receive_data[7+1];
	oneframe.x2= receive_data[7+2];
	oneframe.y2= receive_data[7+3];
	oneframe.width2= receive_data[7+4];
	oneframe.height2= receive_data[7+5];


	//determine the column [0:3] of user's position
	left = range.lbx+(range.ltx - range.lbx)*(oneframe.y2 - range.lby)/(range.lty-range.lby);
	right = range.rbx+(range.rtx - range.rbx)*(oneframe.y2 - range.rby)/(range.rty-range.rby);
	if (oneframe.x2>=left && oneframe.x2<left + (right-left)/4){
		oneframe.col2=0;
	}
	else if (oneframe.x2 >= left + (right-left)/4 && oneframe.x2 < left + (right-left)/2){
		oneframe.col2=1;
	}
	else if (oneframe.x2 >= left + (right-left)/2 && oneframe.x2 < left + (right-left)*3/4){
		oneframe.col2=2;
	}
	else if (oneframe.x2 >= left + (right-left)*3/4 && oneframe.x2 < right){
		oneframe.col2=3;
	}
	else{
		oneframe.col2=4;
	}

	printf(
		"signature: %d\t    x center: %*d\t    y center: %*d\t    width: %*d\t    height: %*d\t 	column: %d\r\n",
		oneframe.signature1, 3, oneframe.x1, 3, oneframe.y1, 3, oneframe.width1, 3, oneframe.height1, oneframe.col1);

	printf(
		"signature: %d\t    x center: %*d\t    y center: %*d\t    width: %*d\t    height: %*d\t 	column: %d\r\n",
		oneframe.signature2, 3, oneframe.x2, 3, oneframe.y2, 3, oneframe.width2, 3, oneframe.height2, oneframe.col2);

	return oneframe;
}

uint16_t tf_floor_2_cam(int y, BoundingBox range){
	uint16_t y_cam;
	uint16_t yb=(range.lby+range.rby)/2;
	uint16_t yt=(range.lty+range.rty)/2;
	y_cam = yt + y * (yb-yt) /480;
	return y_cam;
}

bool is_left_on_tile(sq_info* tiles, Two_Block oneframe, BoundingBox range){
	bool result=false;
	size_t n_tiles = 5;
	if (oneframe.signature1 == 1){
		size_t i = 0;
		for (i = 0; i < n_tiles; i++){
	//		sq_info tile = tiles[i];
			if(oneframe.col1 == tiles[i].col - 1){
				if (oneframe.y1> tf_floor_2_cam(tiles[i].top_y,range)   && oneframe.y1< tf_floor_2_cam( (tiles[i].top_y + tiles[i].length),range)){
					tiles[i].left_on = 1;
					result = true;
					break;
				}
			}
		}
	}
	else if (oneframe.signature2 == 1){
		size_t i = 0;
		for (i = 0; i < n_tiles; i++){
	//		sq_info tile = tiles[i];
			if(oneframe.col2 == tiles[i].col - 1){
				if (oneframe.y2> tf_floor_2_cam(tiles[i].top_y,range)   && oneframe.y2< tf_floor_2_cam( (tiles[i].top_y + tiles[i].length),range)){
					tiles[i].left_on = 1;
					result = true;
					break;
				}
			}
		}
	}
    return result;
}

bool is_right_on_tile(sq_info* tiles, Two_Block oneframe, BoundingBox range){
	bool result=false;
	size_t n_tiles = 5;
	if (oneframe.signature1 == 2){
		size_t i = 0;
		for (i = 0; i < n_tiles; i++){
			if(oneframe.col1 == tiles[i].col - 1){
				if (oneframe.y1> tf_floor_2_cam(tiles[i].top_y,range)   && oneframe.y1< tf_floor_2_cam( (tiles[i].top_y + tiles[i].length),range)){
					tiles[i].right_on = 1;
					result = true;
					break;
				}
			}
		}
	}
	else if (oneframe.signature2 == 2){
		size_t i = 0;
		for (i = 0; i < n_tiles; i++){
			if(oneframe.col2 == tiles[i].col - 1){
				if (oneframe.y2> tf_floor_2_cam(tiles[i].top_y,range)   && oneframe.y2< tf_floor_2_cam( (tiles[i].top_y + tiles[i].length),range)){
					tiles[i].right_on = 1;
					result = true;
					break;
				}
			}
		}
	}
	return result;
}


#endif /* PIXY_H_ */
