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
# - Unit width in pixels: 8      
# - Unit height in pixels: 8     
# - Display width in pixels: 256   
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
player_pos:
    .word 3
##############################################################################
# Code
#####################################################################00FF#########
	.text
	.globl main

    # Run the game.
main:

    jal init_game
 
  # basically calls to draw the square and the player
  #
  init_game:
      lw $t0, ADDR_DSPL #given address
      li $a0, 0x006B7280 # store grey colour
      addi $a1, $t0 912 # starting position on screen
      li $a2, 9 # 9 squares
      jal draw_horizontal_line
      addi $a1, $t0 2960
      li $a2, 9
      jal draw_horizontal_line
      addi $a1, $t0 1040
      li $a2, 15
      jal draw_vertical_line
      addi $a1, $t0 1072
      li $a2, 15
      jal draw_vertical_line
      jal draw_whole_player
      j game_loop
      

# Inputs: $t1 = colour, $t2 = starting display address, $t4 = number of squares

  draw_horizontal_line:
    
    beq $a2, $zero, line_end # check if it is 0 at the start
    
    sw $a0, 0($a1) # draw first square ( loops for each square needed to draw )
    addi $a2, $a2, -1 
    addi $a1, $a1, 4
    
    j draw_horizontal_line # repeat

#same as horizontal line

  draw_vertical_line:
    beq $a2, $zero, line_end # check if it is 0 at the start
    
    sw $a0, 0($a1) # draw first square ( loops for each square needed to draw )
    addi $a2, $a2, -1 
    addi $a1, $a1, 128
    
    j draw_vertical_line # repeat

  # feel like smt wrong with the address stored when returning to call, check!!
  line_end:
    jr $ra
    
# draw the red line that the player is going to be on
  draw_player_line:

    addi $sp, $sp, -8
    sw $ra, 4($sp) # saves the address before calling another function
  
    lw $t0, ADDR_DSPL
    addi $a1, $t0 2836
    li $a0, 0x003F202C
    li $a2, 7

    jal draw_horizontal_line


    lw $ra, 4($sp)
    addi $sp, $sp, 8

    jr $ra
    
# a white dot that is the player
  draw_player:
    
    lw $t0, ADDR_DSPL
    addi $t2, $t0, 2836
    
    li $t1, 0x00FFFFFF
    lw $t3, player_pos
    sll $t4, $t3, 2
    add $t2, $t2, $t4 

    sw $t1, 0($t2)

    jr $ra

#draws the whole player 
  draw_whole_player:
    
    jal draw_player_line
    jal draw_player
    j loop_sleep # goes to sleep after drawing the player
    
#check ketboard a,d
# t0: key_address, t1: check if key pressed, t2: load the key's AS...code thing, t3: a's code
# ADDR_KRBD, player_pos -> pressed key
game_loop:

    lw $t0, ADDR_KBRD

    lw $t1, 0($t0) #store the first 4 in t1
    andi $t1, $t1, 1 # compare the bitwise of if key pressed so keeps the 1. store in t1
    beq $t1, $zero, loop_sleep

    lw $t2, 4($t0)

    #check if its a:
    li $t3, 97
    beq $t2, $t3, move_left

    #check if its d:
    li $t3, 100
    beq $t2, $t3, move_right

    #quit game for q:
    li $t3, 113
    beq $t2, $t3, exit

    j loop_sleep # for ingnoring other keys.
    
    #player_pos -> change in player_pos and redraw
    #t3: load player_pos
    move_left:
      
      lw $t3, player_pos
      beq, $t3, $zero, loop_sleep

      addi $t3, $t3 -1
      sw $t3, player_pos

      j draw_whole_player

    move_right:
      
      lw $t3, player_pos
      li, $t4, 6
      beq, $t3, $t4, loop_sleep

      addi $t3, $t3,1
      sw $t3, player_pos

      j draw_whole_player
      
    exit:
      li $v0, 10              # terminate the program gracefully
      syscall

       
    # 1a. Check if key has been pressed
    # 1b. Check which key has been pressed
    # 2a. Check for collisions
	# 2b. Update locations (capsules)
	# 3. Draw the screen
	# 4. Sleep
    loop_sleep:
      li $a0, 17
      li $v0, 32
      syscall

      j game_loop

    # 5. Go back to Step 1
    j game_loop
