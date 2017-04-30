# Project_Cordic
# Microelectronic Digital Signal project in Phelma
# This is the co-processor that can calculate sin and cos functions based on CORDIC double rotation algorithm.
We are working with 19 bits data lenght for the input angle with 1 sign bit + 3 bits for the integer part and 15 bits for the decimal one (fix point standard).
The output value have a 16 bits lenght with 1 sign bit + 1 bit for the integer part and 14 bits for the decimal one.
The ROM value have a 1 sign bit + 15 bits for the decimal part representation.
The given angle must be in radian unit and between -2pi;2pi.
See block_schematic folder for detailled view of the architecture.
The test_opti branch gives an max frequency speed increase of around 10%.

For the test on the FPGA board, with the actual Fsm_UI entering the input angle is in three steps.
1) You start with the 8 LSBs of the angle and press the load_button
2) You repeat this two more times

Then you can press the start_button and observe the results displayed in binary on the LED of the board.
The Toggle_button allows to change the displayed value.
The New_calc_button allows to start a new angle entry process.

The state of the Fsm_UI is shown on the 7-segment display.
