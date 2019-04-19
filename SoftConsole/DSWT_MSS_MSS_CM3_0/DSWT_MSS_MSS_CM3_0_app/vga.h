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

/******************* EXTERNAL VARIABLES *******************/
// pixy.h
extern BoundingBox range;
extern Position pos;
extern int score;
extern uint16_t receive_data[14];
/**********************************************************/

typedef struct {
    volatile int *addr;
    int alive;
} health_info;


//0..9: col_width 10..19: col1 20..29: col2
volatile int *col_addr1;
//0..9: col3 10..19: col4 20..29: col5
volatile int *col_addr2;
//0..9: length of column: 480
volatile int *col_addr3;

volatile int *num_addr0;
volatile int *num_addr1;
volatile int *num_addr2;
int number[10];
sq_info sq[8];
health_info health[5];

int speed;
bool dead;


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
