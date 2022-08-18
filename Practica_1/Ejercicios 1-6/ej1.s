.data
dato: .byte 3 #inicializo una posición de memoria a 3
.text
.globl main # debe ser global
main: lw $t0,dato($0)

## COMENTARIOS ##
# "inicializo una posicion de memoria a 3" es un comentario
# "debe ser global" es un comentario

## DIRECTIVAS ##
# .data es una directiva que indica el inicio de la zona de declaracion de datos
# .byte es una directiva con la cual se declara un byte en memoria
# .text es una directiva que indica el inicio de la zona de declaracion de instrucciones

## ETIQUETAS ##
# dato es una etiqueta la cual referencia a la dirección de memoria en la que se guarda un byte, cuyo valor decimal es 3
# main es una etiqueta especial, la cual indica al ensamblador a partir de donde y en qué secuencia empezar a ejecutar instrucciones
