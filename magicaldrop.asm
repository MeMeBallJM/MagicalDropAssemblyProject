################# CSC258 Assembly Final Project ###################
# This file contains our implementation of Magical Drop.
#
# Student 1: Name, Student Number
# Student 2: Cindy Liu, 1009853400 (if applicable)
#
# We assert that the code submitted here is entirely our own 
# creation, and will indicate otherwise when it is not.
#
######################## Bitmap Display Configuration ########################
# - Unit width in pixels: 8      TODO
# - Unit height in pixels: 8     TODO
# - Display width in pixels: 256   TODO
# - Display height in pixels: 256  TODO
# - Base Address for Display:   0x10008000 ($gp)
##############################################################################

    .data
##############################################################################
# Immutable Data
##############################################################################
# The address of the bitmap display. Don't forget to connect it!
ADDR_DSPL:
    .word 0x10008000
# The address of the keyboard. Don't forget to connect it!
ADDR_KBRD:
    .word 0xffff0000

##############################################################################
# Mutable Data
##############################################################################

##############################################################################
# Code
#####################################################################00FF#########
	.text
	.globl main

    # Run the game.
main:
  #initialize the box for milestone 1?
    lw $t0, ADDR_DSPL #given address
    addi $t2, $t0 1040 # starting position on screen
    li $t1, 0x808080 # grey
    li $t4, 9 # 9 squares
    jal draw_horizontal_line

    addi $t2, $t0 3088
    li $t4, 9
    jal draw_horizontal_line
    

  draw_horizontal_line:
    beq $t4, $zero, line_end
    sw $t1, 0($t2) # draw first square
    addi $t4, $t4, -1
    addi $t2, $t2, 4
    j draw_horizontal_line
    
    

  line_end:
    jr $ra

game_loop:
    # 1a. Check if key has been pressed
    # 1b. Check which key has been pressed
    # 2a. Check for collisions
	# 2b. Update locations (capsules)
	# 3. Draw the screen
	# 4. Sleep

    # 5. Go back to Step 1
    j game_loop
