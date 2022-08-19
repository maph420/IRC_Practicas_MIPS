.data 0x10010002
bytes: .byte 0x10, 0x20, 0x30, 0x40

reservado: .space 4

.text
main:

la $t0, bytes
la $t1, reservado
        
# direccion en la cual termina el loop
addi $t2, $zero, 0
addi $t2, $t1, 4

loop:
# cargar el primer byte   
lb $t3, 0($t0)
# guardarlo en la direccion pedida
sb $t3, 0($t1)
 
# ir al siguiente byte
addi $t0, $t0, 1

# ir al siguiente byte
addi $t1, $t1, 1

blt $t1, $t2, loop
