.globl __start

.rodata
    divide_by_zero: .string "divide by zero"

.text
__start:
    # Read first operand
    li a0, 5
    ecall
    mv s0, a0
    # Read operation
    li a0, 5
    ecall
    mv s1, a0
    # Read second operand
    li a0, 5
    ecall
    mv s2, a0

###################################
#  TODO: Develop your calculator  #
#                                 #
###################################
    #addition, (0)
    bne s1, zero, subtraction # if s1 = 0 -> addition else -> subtraction and so on
    add s3, s0, s2
    j exit
    
    #subtraction, (1)
subtraction:
    addi s4, zero, 1
    bne s1, s4, multiplication
    sub s3, s0, s2
    j exit
    #multiplication, (2)
multiplication:
    addi s4, s4, 1
    bne s1, s4, division
    mul s3, s0, s2
    j exit
    #division, (3)
division:
    addi s4, s4, 1
    bne s1, s4, power
    beq s2, zero, zero_except # if divide by 0
    div s3, s0, s2
    j exit
    #power,(4)
power:
    addi s4, s4, 1
    bne s1, s4, fac_return #to factorial
    beq s2, zero, out_one # if power = 0 return 1
    addi t0, zero, 1  # t0 = 1 (count for mul)
    add t1, zero, s0 # t1 = base number
    Loop:
    bge t0, s2, power_return # if t0 = power,return, s3:=t1
    mul t1, s0, t1 # t1 = base number * t1
    addi t0, t0, 1 # t0 = t0 + 1
    j Loop
power_return:
    add s3, zero, t1 #return t1 after termination of power multiplication
    j exit

out_one:
    addi s3, zero, 1  # return 1 if power = 0
    j exit
    
    #factorial,(5)
    
fac_return:
    add a0, s0, zero # a0 := s0
    jal factorial
    add s3, a0, zero
    j exit
    
factorial:
    addi sp, sp -8 #room for a0, ra
    sw a0, 4(sp)  # a0 should store n!
    sw ra, 0(sp)  # ra store address of n!, use
    li t0, 1     # t0 = 1
    bgt a0, t0, fac_notend  # if a0 = 1-> 1! = 1 else fac_notend
    addi a0, zero, 1
    addi sp, sp, 8
    jr ra #return address
    
        
fac_notend:
    addi a0, a0 ,-1
    jal factorial # n! <-> n-1! * n
    lw ra, 0(sp)
    lw t1, 4(sp)   # t1 = n-1!
    addi sp, sp, 8
    mul a0, t1, a0
    jr ra

exit:
    # Output the result
    li a0, 1
    mv a1, s3
    ecall
    # Exit program(necessary)
    li a0, 10
    ecall

zero_except:
    # Divide by zero exception
    li a0, 4
    la a1, divide_by_zero
    ecall
    # Exit the program(necessary)
    li a0, 10
    ecall
