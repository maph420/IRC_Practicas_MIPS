		.data
v: 		.word -1,-4,-5,-2
menoracero: 	.word 1
		.text
main:
		la $t0, v
		la $t1, menorquecero
		li $t2, 3

		and $t3, $t3, $0

for: 		bgt $t3, $t2, endfor # for ($t3=0; $t3<$t2; $t3++)
		lw, $t4, 0($t0)	 

		bgt $t4, $0, break # if ($t4 > 0) goto break

		addi $t3, $t3, 1
		addi $t0, $t0, 4
		j for

break: 
		and $t1, $t1, $0 # $t1=0

endfor:
		sne $t1,$t1,$0 # ($t1 != 0) ? 1 : 0
		sb $t1, menorquecero($0)