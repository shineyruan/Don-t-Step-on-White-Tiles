# Don't Step on White Tiles (Chinese: 别踩白块)

**For detailed information, please visit the full introduction on [my personal website](https://shineyruan.github.io/2019/05/03/373Proj/).**

This is a very popular music game on smartphones. Simply by tapping on the blacktiles on a piano-like graphical interface, users can generate pieces of piano music (and even more!) and have fun with it. This game has already had many extended versions.

This is a picture showing the basic interface. **Image is obtained through Google Image and will be deleted immediately if it is subject to copyright issues.**

![interface](http://s9.rr.itc.cn/r/wapChange/20145_16_13/a497lx8444512524323.jpg)

## Project Objectives &mdash; Name Changed to *Step on White Tiles*

We aim to extend the game *Don't Step on White Tiles* into real world. We hope to transform tapping on a smartphone into stepping on the ground. Graphical interface are designed to be generated by a projector. 

Due to the limitations of projector brightness in the day, **we changed our project name to *[Do] Step on White Tiles*** and we determine to inverse the tile colors in our user interface.

In order to increase project difficulty, we use Actel SmartFusion FPGA (Verilog) to generate VGA signals to the projector, combined with C to implement other functions.

## Demo 

Here is a demo at the *EECS 373 Project Expo* at the University of Michigan.

[![final](https://www.youtube.com/embed/2wzuU-qfCKQ/0.jpg)](https://www.youtube.com/embed/2wzuU-qfCKQ)

## Work Environment 

* [Actel SmartFusion SoC FPGA](https://www.microsemi.com/product-directory/soc-fpgas/1693-smartfusion)
* [Libero SoC v11.9 SP3](https://www.microsemi.com/product-directory/design-resources/1750-libero-soc)
* Microsemi SoftConsole IDE v3.4
* Visual Studio Code (used for code editing)

## Component Diagram

![diagram](https://github.com/shineyruan/Don-t-Step-on-White-Tiles/blob/master/poster/diagram.png)

## EECS373 Project Expo Poster 

![poster](https://github.com/shineyruan/Don-t-Step-on-White-Tiles/blob/master/poster/poster.PNG)

## Milestone Preview Demo Videos (YouTube)

[![fase](http://img.youtube.com/vi/Fj3yvPvErxQ/0.jpg)](https://youtu.be/Fj3yvPvErxQ)

*VGA demo on a monitor &mdash; fase mode*

[![medium](http://img.youtube.com/vi/1dtxWQbyNNc/0.jpg)](https://youtu.be/1dtxWQbyNNc)

*VGA demo on a monitor &mdash; medium mode*

## Copyright

This project is the joint effort of [Zhihao Ruan](https://github.com/shineyruan), [Kun Huang](https://github.com/voyager1998), [Jingliang Ren](https://github.com/Regina8023), and Shiyu Liu. 
