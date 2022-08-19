.data 0x10000000
palabra: .word 0xff0f1235
.text
main:
lw $t1, palabra

# 0xDD7FFFFF es un numero binario con todos los bits a 1, menos los bits 3,7,9
andi $t1, $t1, 0xDD7FFFFF
