.data 0x10000000	
palabra: .word 0x1237

.text
main:
lw $t1, palabra
sll $t1, $t1, 5
