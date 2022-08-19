.data
palabra: .word 0x10203040
palabra_invertida: .space 4

.text
main: 
# cargar espacio de memoria asignado en registro
la $t0, palabra_invertida

# cargar palabra en registro
lw $t1, palabra

# hacemos un left-shifting de 8 bits = 1 byte, sacando asi el byte de mas atrás
sb $t1, 3($t0)
srl $t1, $t1, 8
            
sb $t1, 2($t0)
srl $t1, $t1, 8

sb $t1, 1($t0)
srl $t1, $t1, 8
sb $t1, 0($t0)