.data 
# parte a
frase_ascii: .ascii "Esto es un problema"
.align 2
# parte b, cada entero corresponde a la representacion de las letras de la frase en ascii
frase_byte: .byte 69, 115, 116, 111, 32, 101, 115, 32, 117, 110, 32, 112, 114, 111, 98, 108, 101, 109, 97 
.align 2
# parte c
frase_word: .word 69, 115, 116, 111, 32, 101, 115, 32, 117, 110, 32, 112, 114, 111, 98, 108, 101, 109, 97
