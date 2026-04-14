.globl make_node
.globl insert
.globl get
.globl getAtMost

make_node:
    addi sp,sp,-16
    sd ra,8(sp)
    sd s0,0(sp)

    mv s0,a0        # saving the value we got

    li a0,24        # allocating enough space for node (val + 2 pointers)
    call malloc

    sw s0,0(a0)     # putting value into node
    sd x0,8(a0)     # left = NULL
    sd x0,16(a0)    # right = NULL

    ld ra,8(sp)
    ld s0,0(sp)
    addi sp,sp,16
    ret


insert:
    addi sp,sp,-32
    sd ra,24(sp)
    sd s0,16(sp)
    sd s1,8(sp)

    mv s0,a0      # root
    mv s1,a1      # val we want to insert

    bne s0,x0,insert_notnull   # if root is NULL, just make node

    mv a0,s1
    call make_node
    j insert_done

insert_notnull:
    lw t0,0(s0)        # root->val

    beq s1,t0,insert_return_root   # already present, do nothing

    blt s1,t0,insert_left         # smaller -> go left

    # otherwise go right
    ld a0,16(s0)
    mv a1,s1
    call insert
    sd a0,16(s0)      # attach result to right
    j insert_return_root

insert_left:
    ld a0,8(s0)
    mv a1,s1
    call insert
    sd a0,8(s0)       # attach result to left

insert_return_root:
    mv a0,s0          # returning original root

insert_done:
    ld ra,24(sp)
    ld s0,16(sp)
    ld s1,8(sp)
    addi sp,sp,32
    ret


get:
    beq a0,x0,get_done   # tree empty

    lw t0,0(a0)

    beq a1,t0,get_done   # found it

    blt a1,t0,get_go_left   # go left if smaller

    ## else go right
    ld a0,16(a0)
    j get

get_go_left:
    ld a0,8(a0)
    j get

get_done:
    ret

getAtMost:
    addi sp,sp,-32
    sd ra,24(sp)
    sd s0,16(sp)
    sd s1,8(sp)
    sd s2,0(sp)

    mv s0,a0     # target value
    mv s1,a1     # root

    li s2,-1     # best answer till now

getAtMost_loop:
    beq s1,x0,getAtMost_done   # reached end

    lw t0,0(s1)

    blt s0,t0,getAtMost_go_left   # too big, go left

    mv s2,t0        # possible answer

    beq s0,t0,getAtMost_done   # exact match, done

    ld s1,16(s1)    # try to find better on right
    j getAtMost_loop

getAtMost_go_left:
    ld s1,8(s1)
    j getAtMost_loop

getAtMost_done:
    mv a0,s2

    ld ra,24(sp)
    ld s0,16(sp)
    ld s1,8(sp)
    ld s2,0(sp)
    addi sp,sp,32
    ret