	.data
v: 	.word 0,-4,-5,-2, 2, 0, 4, 6, 0, 0,11,3,17,18,4
lenv:	.word 14
rango1: .word 3
rango2: .word 17
n: 	.space 4
	.text
main:
	la $t0, v
	lw $t1, lenv # $t1 = 9
	lw $t2, rango1
	lw $t3, rango2
	and $t4, $t4, $0 # $t4 = 0
	and $t6, $t6, $0 # $t6 = 0

for: 	bgt $t4, $t1, endfor # for ($t4=0; $t4<lenv; $t4++)
	lw $t5, 0($t0) # $t5 = v[0]
		
		
	bge $t5, $t2, then # if $t5 >= $t2 goto then
	j endif
then:
	ble $t5, $t3, ininterval # if $t5 <= $t3 goto ininterval
	j endif # else goto endif

ininterval:
	addi $t6, $t6, 1 # $t6++
endif:		
	addi $t4, $t4, 1
	addi $t0, $t0, 4
	j for
		 
endfor:	 
	sw $t6, n($0) # res = $t6