.data 0x10000000
V: .byte 10,20
sum: .space 1

.text
main:
# vector de valores
la $t0, V
# resultado
la $t4, sum

lb $t1, 0($t0)
lb $t2, 1($t0)

add $t3, $t2, $t1

# guardamos suma en memoria
sb $t3, 0($t4)

