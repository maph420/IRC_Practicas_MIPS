.data # inicializa en 0x10010000 por defecto
# parte a
fil_1: .word 1,2,3
fil_2: .word 4,5,6
fil_3: .word 7,8,9


A_por_filas: .word fil_1, fil_2, fil_3

# parte b
col_1: .word 1,4,7
col_2: .word 2,5,8
col_3: .word 3,6,9

A_por_columnas: .word col_1, col_2, col_3
