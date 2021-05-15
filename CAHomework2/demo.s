.globl __start

.rodata
    msg1: .string "Computer Architecture 2021"
    
.text
__start:
    # Print message
    li a0, 4
    la a1, msg1
    ecall
    # Exit this program
    li a0, 10
    ecall