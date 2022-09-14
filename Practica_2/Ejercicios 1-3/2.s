	.data
v:	.word 2,-4,-6
res: 	.space 12
	.text
	main:
	la $t2,v
	la $t3,res

	li $t0,0 # recorredor del bucle
	li $t1,2 # longitud del vector-1
for:	bgt $t0,$t1,endfor # for ($t0=0; $t0<$t1; $t0++)
	
	lw $t4,0($t2)

	sge $t4, $t4, $0 # ($t4 >= 0) : 1 ? 0
	sw $t4, 0($t3) # res[0] = $t4

	addi $t0, $t0, 1
	addi $t2, $t2, 4
	addi $t3, $t3, 4

	j for
endfor: