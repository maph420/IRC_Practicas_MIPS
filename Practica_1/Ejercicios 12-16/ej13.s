.data 
num1: .byte 18
num2: .byte -1215
divisor: .byte 5
divnums: .space 2

divDeDivs: .byte 0x10010000
.text
main:

la $t4, divnums

lb $t0, num1
lb $t1, num2
lb $t2, divisor

la $t3, divnums

div $t3, $t0, $t2
sb $t3, 0($t4)

addi $t3, $t3, 1

div $t3, $t1, $t2

