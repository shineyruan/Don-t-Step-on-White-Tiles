#include "pixy.h"

// #define PIXY_DEBUG
int decide_col(int offset){
    uint16_t left = range.lbx + (range.ltx - range.lbx) * (receive_data[3+offset] - range.lby) / (range.lty - range.lby);
    uint16_t right = range.rbx + (range.rtx - range.rbx) * (receive_data[3+offset] - range.rby) / (range.rty - range.rby);
    if (receive_data[2+offset] >= left && receive_data[2+offset] < left + (right - left) / 4) {
        return 0;
    } else if (receive_data[2+offset] >= left + (right - left) / 4 && receive_data[2+offset] < left + (right - left) / 2) {
        return 1;
    } else if (receive_data[2+offset] >= left + (right - left) / 2 && receive_data[2+offset] < left + (right - left) * 3 / 4) {
        return 2;
    } else if (receive_data[2+offset] >= left + (right - left) * 3 / 4 && receive_data[2+offset] < right) {
        return 3;
    } else {
        return 4;
    }

}

Two_Block process() {
    Two_Block oneframe;

    //Object 1
    oneframe.signature1 = receive_data[1];
    oneframe.x1 = receive_data[2];
    oneframe.y1 = receive_data[3];
    oneframe.width1 = receive_data[4];
    oneframe.height1 = receive_data[5];

    //determine the column [0:3] of user's position
    oneframe.col1 = decide_col(0);
    

    //Object 2
    oneframe.signature2 = receive_data[7 + 1];
    oneframe.x2 = receive_data[7 + 2];
    oneframe.y2 = receive_data[7 + 3];
    oneframe.width2 = receive_data[7 + 4];
    oneframe.height2 = receive_data[7 + 5];

    //determine the column [0:3] of user's position
    oneframe.col2 = decide_col(7);
    

#ifdef PIXY_DEBUG
    printf(
        "signature: %d\t    x center: %*d\t    y center: %*d\t    width: %*d\t    height: %*d\t 	column: %d\r\n",
        oneframe.signature1, 3, oneframe.x1, 3, oneframe.y1, 3, oneframe.width1, 3, oneframe.height1, oneframe.col1);

    printf(
        "signature: %d\t    x center: %*d\t    y center: %*d\t    width: %*d\t    height: %*d\t 	column: %d\r\n",
        oneframe.signature2, 3, oneframe.x2, 3, oneframe.y2, 3, oneframe.width2, 3, oneframe.height2, oneframe.col2);
#endif

    return oneframe;
}

uint16_t tf_floor_2_cam(int y) {
    uint16_t y_cam;
    uint16_t yb = (range.lby + range.rby) / 2;
    uint16_t yt = (range.lty + range.rty) / 2;
    y_cam = yt + y * (yb - yt) / 480;
    return y_cam;
}

bool is_left_on_tile(sq_info* tiles, Two_Block oneframe) {
    bool result = false;
    size_t n_tiles = sq_num;
    if (oneframe.signature1 == 1) {
        uint8_t i = 0;
        for (i = 0; i < n_tiles; i++) {
            //		sq_info tile = tiles[i];
            if (oneframe.col1 == tiles[i].col - 1) {
                if (oneframe.y1 + oneframe.height1 / 2 > tf_floor_2_cam(tiles[i].top_y) &&
                    oneframe.y1 - oneframe.height1 / 2 < tf_floor_2_cam((tiles[i].top_y + tiles[i].length))) {
                    if (tiles[i].right_on == 0 && tiles[i].left_on == 0) {
                        score++;
                    }
                    tiles[i].left_on = 1;
                    result = true;
                    break;
                }
            }
        }
    } else if (oneframe.signature2 == 1) {
        uint8_t i = 0;
        for (i = 0; i < n_tiles; i++) {
            //		sq_info tile = tiles[i];
            if (oneframe.col2 == tiles[i].col - 1) {
                if (oneframe.y2 + oneframe.height2 / 2 > tf_floor_2_cam(tiles[i].top_y) &&
                    oneframe.y2 - oneframe.height2 / 2 < tf_floor_2_cam((tiles[i].top_y + tiles[i].length))) {
                    if (tiles[i].right_on == 0 && tiles[i].left_on == 0) {
                        score++;
                    }
                    tiles[i].left_on = 1;
                    result = true;
                    break;
                }
            }
        }
    }

    return result;
}

bool is_right_on_tile(sq_info* tiles, Two_Block oneframe) {
    bool result = false;
    size_t n_tiles = sq_num;
    if (oneframe.signature1 == 2) {
        size_t i = 0;
        for (i = 0; i < n_tiles; i++) {
            if (oneframe.col1 == tiles[i].col - 1) {
                if (oneframe.y1 + oneframe.height1 / 2 > tf_floor_2_cam(tiles[i].top_y) &&
                    oneframe.y1 - oneframe.height1 / 2 < tf_floor_2_cam((tiles[i].top_y + tiles[i].length))) {
                    if (tiles[i].left_on == 0 && tiles[i].right_on == 0) {
                        score++;
                    }
                    tiles[i].right_on = 1;
                    result = true;
                    break;
                }
            }
        }
    }
    else if (oneframe.signature2 == 2) {
        size_t i = 0;
        for (i = 0; i < n_tiles; i++) {
            if (oneframe.col2 == tiles[i].col - 1) {
                if (oneframe.y2 + oneframe.height2 / 2 > tf_floor_2_cam(tiles[i].top_y) &&
                    oneframe.y2 - oneframe.height2 / 2 < tf_floor_2_cam((tiles[i].top_y + tiles[i].length))) {
                    if (tiles[i].left_on == 0 && tiles[i].right_on == 0) {
                        score++;
                    }
                    tiles[i].right_on = 1;
                    result = true;
                    break;
                }
            }
        }
    }
    return result;
}

inline Two_Block Pixy_getData(mss_spi_instance_t* this_spi) {
    /* inconsequential transfer value (for full duplex) */
    const uint16_t master_tx_frame = 0;

    int i = 0;
    int flag = 0;
    while (flag == 0) {
        receiver[1] = receiver[0];
        receiver[0] = MSS_SPI_transfer_frame(this_spi, master_tx_frame);

        /* Two consecutive 0xaa55 means a start of a new frame. */
        if (receiver[0] == PIXY_START_WORD &&
            receiver[1] == PIXY_START_WORD) {
            while (i < 12)
                receive_data[i++] =
                    MSS_SPI_transfer_frame(this_spi, master_tx_frame);
            i = 0;
            memset(receiver, 0, sizeof(receiver));
            flag = 1;
        }
        else if (receiver[0] == 0 &&
            receiver[1] == 0){
            Two_Block result; // to be assigned
            result.signature1 = 0;
            result.signature2 = 0;
            return result;
        }
    }
    return process();
}
