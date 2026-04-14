.section .rodata
filename: .string "input.txt"
mode: .string "r"
yes_str: .string "Yes\n"
no_str: .string "No\n"

.text
.globl main

main:
    addi sp,sp,-48
    sd ra,40(sp)
    sd s0,32(sp) # FILE*
    sd s1,24(sp) # left
    sd s2,16(sp) # right

    # fopen
    la a0,filename
    la a1,mode
    call fopen
    mv s0,a0

    ## if file not opened
    beq s0,x0,no_case

    # go to end
    mv a0,s0
    li a1,0
    li a2,2
    call fseek

    # get size
    mv a0,s0
    call ftell
    addi s2,a0,-1  # last index

    li s1,0  # start index

    blt s2,x0,yes_case  # empty file

loop:
    bge s1,s2,yes_case

    # read left side
    mv a0,s0
    mv a1,s1
    li a2,0
    call fseek

    addi sp,sp,-8
    mv a0,sp
    li a1,1
    li a2,1
    mv a3,s0
    call fread
    lbu t0,0(sp)
    addi sp,sp,8

    # read right side
    mv a0,s0
    mv a1,s2
    li a2,0
    call fseek

    addi sp,sp,-8
    mv a0,sp
    li a1,1
    li a2,1
    mv a3,s0
    call fread
    lbu t1,0(sp)
    addi sp,sp,8

    # compare
    bne t0,t1,no_case

    addi s1,s1,1
    addi s2,s2,-1
    j loop

yes_case:
    la a0,yes_str
    call printf
    j done

no_case:
    la a0,no_str
    call printf

done:
    li a0,0
    ld ra,40(sp)
    ld s0,32(sp)
    ld s1,24(sp)
    ld s2,16(sp)
    addi sp,sp,48
    ret