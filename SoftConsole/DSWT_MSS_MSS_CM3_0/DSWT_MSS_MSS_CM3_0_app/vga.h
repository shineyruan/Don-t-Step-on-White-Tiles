#ifndef __MAIN_H__
#define __MAIN_H__

#define DATA_MEAN 5
#define SAME_LENGTH 50
#include "pixy.h"
#include "CMSIS/a2fxxxm3.h"
#include <time.h>
//width of column
#define width 96
//width of column line
#define col_width 5
#define res_width 640
#define res_length 480
#define longest_delay 500
#define heart_num 5
//0..9: col_width 10..19: col1 20..29: col2
static volatile int *col_addr1 = (int *)0x40050000;
//0..9: col3 10..19: col4 20..29: col5
static volatile int *col_addr2 = (int *)0x40050004;
//0..9: length of column: 480
static volatile int *col_addr3 = (int *)0x40050038;

static volatile int *num_addr0 = (int *)0x4005001c;
static volatile int *num_addr1 = (int *)0x40050020;
static volatile int *num_addr2 = (int *)0x40050028;
static int number[10] = {0x0f99999f, 0x04444444, 0x0f11f88f, 0x0f11f11f, 0x0aaaaf22, 0x0f88f11f, 0x0f88f99f, 0x0f111111, 0x0f99f99f, 0x0f99f11f};
static int speed = -3;
sq_info sq[8];
static bool dead = false;
typedef struct {
    volatile int *addr;
    int alive;
} health_info;

health_info health[5];

int get_col_pos(int i);
void define_column();
void sq_init();
void health_init();
bool overlap(int k);
void random_mode(int k);
void set_score(int x);
void delay(int x);
void set_health();
void vga_init();


#endif
