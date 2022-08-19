.data
palabra:   .word 0x10203040

.text

la $t0, palabra

# primer mediapalabra 
lh $s0, 0($t0)
# segunda mediapalabra
lh $s1, 2($t0)

# invertimos el orden de guardado
sh $s0, 2($t0)
sh $s1, 0($t0)