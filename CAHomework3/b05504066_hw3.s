.globl __start

# s0 -> input
# s1 -> output
.text
__start:
  # Read input
  addi a0 ,zero, 5
  ecall
  addi s0,a0,0
  add a0, s0,zero
  jal ra,function
  add s1, a0 ,zero
  jal ra, exit


function:
  addi sp, sp -12 #room for a0, ra
  sw a0, 4(sp)  # a0 input
  sw ra, 0(sp)  # ra store address of total, use
  addi s4, zero, 1 # s4 = 1
  blt s4, a0, formula # if bigger than 1 fo to formula
  addi a0,zero,1   # a0 = 1
  addi sp, sp, 12
  jalr zero,ra,0
  


#t1 = single element
#t2 = total
#t3 = 2
formula:
    #T(n-100)
    addi a0, a0, -100
    jal ra, function
    add t1, a0, zero
    lw a0, 4(sp)    #restore the orginal n
    sw t1, 8(sp)    # store single in stack
    addi t3, zero, 2
    div a0, a0, t3     # a0 = n/2
    # T(n/2)
    jal ra, function
    add t1, a0, zero    
    lw ra, 0(sp)
    lw a0, 4(sp)
    lw t2, 8(sp)
    addi t3, zero, 2
    mul t1, t1, t3   # 2 * T(n/2)
    add t2, t2,t1    # add 2*T(n/2) to total
    addi t2, t2, 5   # add 5
    add a0, t2, zero  # return 
    addi sp, sp, 12
    jalr zero,ra,0
exit:
    # Output the result
    addi a0 ,zero, 1
    addi a1,s1,0
    ecall
    # Exit program(necessary)
    addi a0 ,zero, 10
    ecall