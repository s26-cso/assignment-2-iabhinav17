.section .rodata
int_fmt: .string "%d"
space_str: .string " "
newline_str: .string "\n"

.text
.globl main

main:
    addi sp,sp,-80
    sd ra,72(sp)
    sd s0,64(sp) # n = argc-1
    sd s1,56(sp) # arr
    sd s2,48(sp) # result
    sd s3,40(sp) # stack
    sd s4,32(sp) # stack size
    sd s5,24(sp) # loop var
    sd s6,16(sp) # argv

    addi s0,a0,-1
    mv s6,a1

    beq s0,x0,empty_exit # nothing passed

    # allocate arrays
    slli a0,s0,2
    call malloc
    mv s1,a0

    slli a0,s0,2
    call malloc
    mv s2,a0

    slli a0,s0,2
    call malloc
    mv s3,a0

    li s4,0   # stack empty

    # parse input 
    li s5,0

parse_loop:
    bge s5,s0,parse_done

    addi t0,s5,1
    slli t1,t0,3
    add  t1,s6,t1
    ld  a0,0(t1)
    call atoi

    slli t1,s5,2
    add t1,s1,t1
    sw a0,0(t1)

    addi s5,s5,1
    j parse_loop

parse_done:

    # fill result with -1
    li s5,0
init_loop:
    bge s5,s0,init_done
    slli t0,s5,2
    add  t0,s2,t0
    li   t1,-1
    sw   t1,0(t0)
    addi s5,s5,1
    j init_loop

init_done:
    # start from right
    addi s5,s0,-1

algo_loop:
    blt s5,x0,algo_done

while_loop:
    beq s4,x0,while_done

    # top index
    addi t1,s4,-1
    slli t1,t1,2
    add t1,s3,t1
    lw  t2,0(t1)

    # value at stack top
    slli t3,t2,2
    add t3,s1,t3
    lw t0,0(t3)

    # current value
    slli t4,s5,2
    add t4,s1,t4
    lw t4,0(t4)

    bgt t0,t4,while_done   # stop if greater
    addi s4,s4,-1
    j while_loop

while_done:

    beq s4,x0,skip_result

    addi t1,s4,-1
    slli t1,t1,2
    add  t1,s3,t1
    lw   t2,0(t1)

    slli t3,s5,2
    add  t3,s2,t3
    sw   t2,0(t3)

skip_result:

    # push index
    slli t1,s4,2
    add  t1,s3,t1
    sw   s5,0(t1)
    addi s4,s4,1

    addi s5,s5,-1
    j algo_loop

algo_done:

    # print output
    li s5,0
print_loop:
    bge s5,s0,print_done

    beq s5,x0,no_space
    la  a0,space_str
    call printf

no_space:
    slli t0,s5,2
    add  t0,s2,t0
    lw   a1,0(t0)

    la  a0,int_fmt
    call printf

    addi s5,s5,1
    j print_loop

print_done:
    la a0,newline_str
    call printf

    li a0,0
    ld ra,72(sp)
    ld s0,64(sp)
    ld s1,56(sp)
    ld s2,48(sp)
    ld s3,40(sp)
    ld s4,32(sp)
    ld s5,24(sp)
    ld s6,16(sp)
    addi sp,sp,80
    ret

empty_exit:
    li a0,0
    ld ra,72(sp)
    ld s0,64(sp)
    ld s1,56(sp)
    ld s2,48(sp)
    ld s3,40(sp)
    ld s4,32(sp)
    ld s5,24(sp)
    ld s6,16(sp)
    addi sp,sp,80
    ret