.data 0x10000000
V: .word 10,20,25,500,3

.text
main:
# cargamos el vector en la direccion temporal $2
la $t1, V

# asignamos los respectivos valores del vector a cada regristro
lw $s0, 0($t1)
lw $s1, 4($t1)
lw $s2, 8($t1)
lw $s3, 12($t1)
lw $s4, 16($t1)
