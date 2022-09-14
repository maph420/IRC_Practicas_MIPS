	.data
dato1: 	.word 2
dato2: 	.word 10
dato3: 	.word 50
dato4: 	.word 70
dato5: 	.word 4
res: 	.space 4
	.text
main:
	li $t0, 0
	lw $t1, dato1
	lw $t2, dato2
	lw $t3, dato3
	lw $t4, dato4
	lw $t5, dato5

	bge $t5, $t1, then # if $t5 >= $t1 goto then
	bge $t5, $t3, else #else if $t5 >= $t3 goto else
then:
	ble $t5, $t2, ininterval # if $t5 <= $t2 goto ininterval
	j endif # else goto endif
else:
	ble $t5, $t4, ininterval # if $t5 <= $t4 goto ininterval
	j endif # else goto endif
ininterval:
	ori $t0, $t0, 1
endif:
	sw $t0, res($0)
