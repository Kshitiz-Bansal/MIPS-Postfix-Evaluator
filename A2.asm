# TO DO:
        # div by zero // NO NEED
        # overflow // done
        # invalid input, raise error:
            # plus minus mult only // done
            # if stack contains more than one at end // done

# COL216: Assignment 2
# Code of: Kshitiz Bansal
#           2019CS50438

# Input: Postfix expression with constant integer operands in the range 0-9 and operators +, -, and *.

    .data
msg: .asciiz "Enter the postfix expression: "
prompt_overflow: .asciiz "Values overflowed. Execution terminated. "
prompt_wrong_in1: .asciiz "Wrong input: input contains characters other than 0-9, +, - and *. "
prompt_wrong_in2: .asciiz "Invalid input: Postfix expression is not valid. "
CR: .asciiz "\n"
NT: .asciiz "Normal Termination"
char: .space 2
arr: .space 1000


    .text

main:
    li $v0, 4
    la $a0, msg
    syscall

    j input

# input loop
input:
    la $s1, arr

loop1:
    li $v0, 8
    la $a0, char
    li $a1, 2
    syscall

    lb $t0, char
    sb $t0, 0($s1)
    lb $t2, CR
    beq $t0, $t2, input_done
    addi $s1, $s1, 1
    j loop1

# the main part
input_done:
    la $s0, arr
    li $t0, 0
    li $t8, 0

    loop_over_string:
        add $s1, $s0, $t0
        lb $s2, 0($s1) # string[i]

        lb $t2, CR
        beq $s2, $t2, done

        blt $s2, 48, operator
        bgt $s2, 57, operator
        addi $s2, $s2, -48   #converted to int

        # push              DND $t8
        subu $sp, $sp, 4
        sw $s2, ($sp)
        addi $t8, $t8, 1

        j next

    operator:

        beq $s2, 43, plus
        beq $s2, 45, minus
        beq $s2, 42, multiply

        j error1
        # beq $s2, 37, remainder
        # beq $s2, 47, divide

    plus:
        li $t5, 2
        blt $t8, $t5, error2
        lw $t3, ($sp)
        lw $t4, 4($sp)
        addu $sp, $sp, 8

        add $t4, $t4, $t3
        # bltz $t4, over_flow

        subu $sp, $sp, 4
        sw $t4, ($sp)
        addi $t8, $t8, -1
        j next

    minus:
        li $t5, 2
        blt $t8, $t5, error2
        lw $t3, ($sp)
        lw $t4, 4($sp)
        addu $sp, $sp, 8

        sub $t4, $t4, $t3
        # bltz $t4, over_flow

        subu $sp, $sp, 4
        sw $t4, ($sp)
        addi $t8, $t8, -1
        j next

    multiply:
        li $t5, 2
        blt $t8, $t5, error2
        lw $t3, ($sp)
        lw $t4, 4($sp)
        addu $sp, $sp, 8

        mul $t4, $t4, $t3
        # bltz $t4, over_flow

        subu $sp, $sp, 4
        sw $t4, ($sp)
        addi $t8, $t8, -1
        j next

# not relevant to our requirements //
    remainder:
        li $t5, 2
        blt $t8, $t5, error2
        lw $t3, ($sp)
        lw $t4, 4($sp)
        addu $sp, $sp, 8

        rem $t4, $t4, $t3 #check rem by zero
                          #check rem by negative numbers

        subu $sp, $sp, 4
        sw $t4, ($sp)
        addi $t8, $t8, -1
        j next

    divide:
        li $t5, 2
        blt $t8, $t5, error2
        lw $t3, ($sp)
        lw $t4, 4($sp)
        addu $sp, $sp, 8

        div $t4, $t4, $t3 # check divide by zero
                          # check over flow
        subu $sp, $sp, 4
        sw $t4, ($sp)
        addi $t8, $t8, -1
        j next


    next:
        # lw $t3, ($sp)
        # li $v0, 1
        # la $a0, ($t3)
        # syscall
        #
        # li $v0, 4
        # la $a0, CR
        # syscall

        addi $t0, $t0, 1
        j loop_over_string

    done:
    lw $t3, ($sp)
    li $t5, 1
    bne $t8, $t5, error2

    li $v0, 1
    la $a0, ($t3)
    syscall

    li $v0, 10
    syscall


# if stack is not empty after all operations are done == wrong input
    error2:
    li $v0, 4
    la $a0, prompt_wrong_in2
    syscall
    li $v0, 4
    la $a0, CR
    syscall

    li $v0, 10
    syscall

# if input contains characters which are not allowed
    error1:
    li $v0, 4
    la $a0, prompt_wrong_in1
    syscall
    li $v0, 4
    la $a0, CR
    syscall

    li $v0, 10
    syscall

# jumps here if overflow happens at any stage
    over_flow:
    li $v0, 4
    la $a0, prompt_overflow
    syscall
    li $v0, 4
    la $a0, CR
    syscall

    li $v0, 10
    syscall
