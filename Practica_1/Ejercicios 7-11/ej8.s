.data 0x10000000
V: .word 10,20,25,500,3

.text
main:
# cargamos el vector en el registro temporal $2
la $t0, V

# asignamos los respectivos valores del vector a cada regristro
lw $s0, 0($t0)
lw $s1, 4($t0)
lw $s2, 8($t0)
lw $s3, 12($t0)
lw $s4, 16($t0)

# cargamos en un registro temporal $3 el hexadecimal inmediato (que es la direccion desde donde queremos empezar a copiar)
li $t1, 0x10010000

sw $s0, 0($t1)
sw $s1, 4($t1)
sw $s2, 8($t1)
sw $s3, 12($t1)
sw $s4, 16($t1)
