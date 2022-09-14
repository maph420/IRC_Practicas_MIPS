	.data
v: 	.word 0,-4,-5,-2, 2, 0, 4, 6, 0, 0
n: 	.word 1
	.text
main:
	la $t0, v
	li $t2, 9 # longitud del array-1

	and $t3, $t3, $0

for: 	bgt $t3, $t2, endfor # for ($t3=0; $t3<$t2; $t3++)
	lw $t4, 0($t0)	 
	
	and $t5, $t5, $0
	seq $t5, $t4, $0 # if ($t4==0) $t5=1 else $t5=0
	add $t1, $t1, $t5 # $t1 += $t5

	addi $t3, $t3, 1
	addi $t0, $t0, 4
	j for

endfor:
	sw $t1, n($0)
