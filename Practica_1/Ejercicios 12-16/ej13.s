.data 0x1000000
num1: .word 18
num2: .word -1215
divisor: .word 5

divDeDivs: .word 0x10010000

.text
main:

lw $t0, num1
lw $t1, num2
lw $t2, divisor

div $t4, $t0, $t2
div $t5, $t1, $t2

div $t6, $t5, $t4

sw $t6, divDeDivs

