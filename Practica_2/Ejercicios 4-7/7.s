.data
str: 	.asciiz "alimalaya"
char: 	.byte 'a'
	.align 2
res: 	.space 4
	.text
main: 	la $t0, str
	lb $t3, char
 
	andi $t2,$t2, 0 # $t2=0
	andi $t5,$t5, 0 # $t5=0
	

while: 	lb $t1,0($t0) #almacenar byte en $t1
	beq $t1, $0, endwhile # while (($t1=$t0[0]) != '\0')
	
	seq $t4, $t1, $t3
	add $t5, $t5, $t4
	
	addi $t0,$t0, 1 #$t0=$t0+1
	j while #saltar a mientras
	
endwhile: sw $t5,n($0) # res = $t2