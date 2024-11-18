.data
n1:      .word 13
k1:      .word 4
output1: .word 2
n2:      .word 21
k2:      .word 21
output2: .word 0
n3:      .word 14
k3:      .word 13
output3: .word -1
str1:    .string "pass "
str2:    .string "fail "

.text
main:
    li s0, 3                        # s0 stores how many test cases
    la s1, n1                       # s1 stores address of n1
loop:
    lw a0, 0(s1)                    # a0 = n
    lw a1, 4(s1)                    # a1 = k
    lw a2, 8(s1)                    # a2 = correct output
 
    addi sp, sp, -4                 
    sw ra, 0(sp)                    
    jal ra, bitChanges              # goto bitChanges function
    lw ra, 0(sp)
    addi sp, sp, 4
    jal ra, print_result            # goto print result
    addi s1, s1, 12                 # move to the next test case
    addi s0, s0, -1                 # case counter -1
    bnez s0, loop                   
    
    #exit
    li a7, 10               
    ecall                     

#bitChanges function
bitChanges:
    mv t0, a0                        # t0 = n
    mv t1, a1                        # t1 = k
    xor a0, t0, t1                   # a0 = n xor k
    addi sp, sp, -4
    sw ra, 0(sp)
    jal ra, blclz                   # goto my_clz function
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
    jr ra                            # return
        
#clz function
blclz:
    srli t2, a0, 1        # x >> 1
    or a0, a0, t2         # x |= (x >> 1)
    srli t2, a0, 2        # x >> 2 
    or a0, a0, t2         # x |= (x >> 2)
    srli t2, a0, 4        # x >> 4
    or a0, a0, t2         # x |= (x >> 4)
    srli t2, a0, 8        # x >> 8
    or a0, a0, t2         # x |= (x >> 8)
    srli t2, a0, 16       # x >> 16
    or a0, a0, t2         # x |= (x >> 16)
    
    srli t2, a0, 1        # x >> 1
    li t4, 0x55555555
    and t2, t2, t4        # t2 = ((x >> 1) & 0x55555555)
    sub a0, a0, t2        # x = x - t2
    srli t2, a0, 2        # x >> 2
    li t4, 0x33333333
    and t2, t2, t4        # t2 = ((x >> 2) & 0x33333333)
    and t4, a0, t4        # t4 = x & 0x33333333
    add a0, t2, t4        # x = t2 & t4
    srli t2, a0, 4        # x >> 4
    add t2, t2, a0        # t2 = (x >> 4) + x
    li t4, 0x0f0f0f0f     
    and a0, t2, t4        # x = t2 & 0x0f0f0f0f
    srli t2, a0, 8        # x >> 8
    add a0, a0, t2        # x += (x >> 8)
    srli t2, a0, 16       # x >> 16
    add a0, a0, t2        # x += (x >> 16)
    andi a0, a0, 0x7F     # x & 0x7f
    li t2, 32
    sub a0, t2, a0        # a0 = 32 - (x & 0x7f)
clz_end:
    jr ra                 # return

# print result (pass or fail)
print_result:
    bne a0, a2, fail
    la a0, str1                # print "pass"
    li a7, 4
    ecall
    j print_end
fail:
    la a0, str2                # print "fail"
    li a7, 4
    ecall
print_end:
    jr ra                      # return
