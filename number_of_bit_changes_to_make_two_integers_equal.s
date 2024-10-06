.data
n1:   .word 13
k1:   .word 4
n2:   .word 21
k2:   .word 21
n3:   .word 14
k3:   .word 13
msg1: .string "The number of bit changes to make "
msg2: .string " and "
msg3: .string " equal is: "
endl: .string "\n"

.text
main:
    li s0, 3                        # s0 stores how many test cases
    la s1, n1                       # s1 stores address of n1
loop:
    lw a0, 0(s1)                    # a0 = n
    lw a1, 4(s1)                    # a1 = k
 
    addi sp, sp, -4                 
    sw ra, 0(sp)                    
    jal ra, bitChanges              # goto bitChanges function
    lw ra, 0(sp)
    addi sp, sp, 4
    addi s1, s1, 8                  # move to the next test case
    addi s0, s0, -1                 # test case counter--
    bnez s0, loop                   # still got test case, stay in the loop 
    j end                           # no more test case, end the program

#bitChanges function
bitChanges:
    mv t0, a0                        # t0 = n
    mv t1, a1                        # t1 = k
    xor a0, t0, t1                   # a0 = n xor k
    addi sp, sp, -4
    sw ra, 0(sp)
    jal ra, my_clz                   # goto my_clz function
    lw ra, 0(sp)
    addi sp, sp, 4
    li t2, 0                         # init i = 0
    li t3, 32                        # let t3 = 32
    sub t3, t3, a0                   # let t3 = (32 - num)
    li t4, 0                         # init result = 0
    bne t3, x0, bitChanges_loop      # if (32 - num) != 0 then start looping
    li a0, 0                         # if (32 - num) == 0, the result is 0
    j bitChanges_end
bitChanges_loop:
    andi s2, t0, 1                   # s2 = (n & 1)
    andi s3, t1, 1                   # s3 = (k & 1)
    beq s2, zero, skip_add           # if s2 == 0, goto skip_add
    bne s3, zero, skip_add           # if s3 == 1, goto skip_add
    addi t4, t4, 1                   # if(s2 == 1) && (s3 == 0), then result++
skip_add: 
    bne s2, zero, shift              # if s2 == 1, goto shift
    beq s3, zero, shift              # if s3 == 0, goto shift
    li a0, -1                        # if (s2 == 0) && (s3 == 1), then result = -1
    j bitChanges_end                
shift:
    srli t0, t0, 1                   # n >>= 1
    srli t1, t1, 1                   # k >>= 1
    addi t2, t2, 1                   # i++
    bne t2, t3, bitChanges_loop      # if(i < (32 - num)), stay in the loop
    mv a0, t4                        # else, let a0 = result
bitChanges_end:
    addi sp, sp, -4
    sw ra, 0(sp)
    jal ra, print                    # goto print
    lw ra, 0(sp)
    addi sp, sp, 4
    jr ra                            # return
    
    
#clz function
my_clz:
    li t2, 1                     # init t3 = 1U
    li t3, 0                     # init count = 0
    li t4, 31                    # init i = 31
my_clz_loop:    
    sll t5, t2, t4               # t5 = 1U << i
    and t5, t5, a0               # t5 = (x & (1U << i))
    bne t5, x0, clz_end          # if (t5 != 0), exit the loop
    addi t3, t3, 1               # count++
    addi t4, t4, -1              # --i
    bge t4, zero, my_clz_loop    # if (i >= 0), stay in the loop
clz_end:
    mv a0, t3                    # a0 = count
    jr ra                        # return
    

#print result
print:
    mv s4, a0                # store the result in s4

    la a0, msg1              # print "The number of bit changes to make"
    li a7, 4
    ecall

    lw a0, 0(s1)             # print n
    li a7, 1
    ecall

    la a0, msg2              # print "and"
    li a7, 4
    ecall

    lw a0, 4(s1)             # print k
    li a7, 1
    ecall

    la a0, msg3              # print "equal is:"
    li a7, 4
    ecall

    mv a0, s4                # print the result
    li a7, 1
    ecall

    la a0, endl              # print " \n "
    li a7, 4
    ecall

    jr ra

end:
    li a7, 10                # system call number for exit
    li a0, 0                 # return 0
    ecall
