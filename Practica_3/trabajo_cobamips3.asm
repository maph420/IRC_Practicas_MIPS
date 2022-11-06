.data
                
menu1:          		.ascii "1: Crear categoria\n"
menu2:          		.ascii "2: Siguiente categoria\n"
menu3:          		.ascii "3: Categoria anterior\n"
menu4:          		.ascii "4: Listar categorias\n"
menu5:          		.ascii "5: Borrar categoria actual\n"
menu6:          		.ascii "6: Anexar objeto a la categoria actual\n"
menu7:          		.ascii "7: Borrar objeto de la categoria\n" 
menu8:          		.ascii "8: Listar objetos de la categoria\n"
menu9:          		.ascii "9: Salir\n"
finmenu:        		.asciiz "Ingrese la opcion deseada: "
eleccion:       		.asciiz "Usted eligio la opcion: "
salto:          		.asciiz "\n"
erroreleccion:  		.asciiz "La opcion elegida es invalida. Por favor ingrese un numero del 1 al 9.\n\n\n"
buenaeleccion:  		.asciiz "Buena eleccion!\n"
selecCat:       		.asciiz "Elija el nombre de la categoria a crear: "
continueText:   		.asciiz "Presione una tecla para continuar\n"
noCatsMessage: 			.asciiz "No hay categorias creadas actualmente\n"
showNextCatMessage: 		.asciiz "La siguiente categoria es: \n"
showCatsMessage: 		.asciiz "Las categorias son:\n"
endLoopMessage:  		.asciiz "Loop is no more"
asterisk:			.asciiz "(*)"	
changeCatMessage:		.asciiz "Te moviste hacia la categoria: "
deleteCatMessage:		.asciiz "Se ha eliminado la categoria "
newObjMessage:			.asciiz "Ingresar nombre del objeto a crear: \n"
showObjsMessage:		.asciiz "Los objetos relacionados a la categoria son:\n"
noObjectsMessage:		.asciiz "No hay objetos en la lista \n"
inputIDMessage:			.asciiz "Ingresar ID del objeto a borrar \n"
space:				.asciiz " "
rmObjMessage:			.asciiz "Se elimino el objeto "


slist:          		.word 0 # lista enlazada simple
cclist:         		.word 0 # category list
wclist:         		.word 0 # working category list
 
.text
main:

### MAIN MENU ###

# Menu principal
mainMenu:
		# Imprime menu
                la $a0, menu1
                addi $v0, $0, 4
                syscall
          	
          	# Lee un entero
                li $v0, 5
                syscall
                move $t0, $v0
                
                # Imrpime la opcion elegida
                la $a0, eleccion
                addi $v0, $0, 4 
                syscall
                move $a0, $t0 
                addi $v0, $0, 1 
                syscall
                la $a0, salto
                addi $v0, $0, 4
                syscall
 
                # jal chequeareleccion
 
                j derivar_a_funcion
 
                j fin
                
                
# Ejecuta la funcion indicada por el usuario
derivar_a_funcion:
                la $a0, buenaeleccion # Hasta ahora imprime esto porque quiero ver si llega bien a esta parte
                addi $v0, $0, 4
                syscall
 
                # ATENCION: por convencion toda funcion termina en j menu
                beq $t0, 1, crearcategoria1
                beq $t0, 2, siguientecategoria2
                beq $t0, 3, categoriaanterior3
                beq $t0, 4, traverseList4
                beq $t0, 5, deleteCategory5
                beq $t0, 6, appendObject6
                beq $t0, 7, deleteObject7
                beq $t0, 8, showObject8
                beq $t0, 9, fin
 
                j mainMenu
               
# Run after function. Press key to continue
menu:
                la $a0, continueText            #We print the string for the current element.
                li $v0, 4
                syscall				#Wait for keypress to continue
 
 		# espera entrada para continuar
                li $v0, 12
                syscall
 
                j mainMenu
                

### MAIN FUNCTIONS ###

# Given a string name, create a new category.
crearcategoria1:
                la $a0, selecCat 		#print message
                jal print

                jal smalloc # pide memoria para el string
                move $a0, $v0 
                li $a1, 16 
                li $v0, 8 			#enter name
                syscall
    
                jal newCategory
                j menu
        
fin:
                li $v0, 10
                syscall                         # :))))
                

### WORKING FUNCTIONS ###

#$a0: string name
# Add new category with string name
newCategory:
                
                # se hace espacio en el stack para almacenar bytes
                # (en este caso lo usamos para guardar la dir de retorno $ra al momento de saltar)
                addiu $sp, $sp, -4
                sw $ra, 4($sp)

                jal newnode

                lw $a0, cclist
                move $a1, $v0
                jal addnode
 
                lw $t0, cclist
                bnez $t0, nonEmpty 
                sw $v0, wclist

nonEmpty:       sw $v0, cclist 
                lw $ra, 4($sp) 
                addiu $sp, $sp, 4
                jr $ra
                
# $a0: string name
# $v0: returns node address
# Create a new node with string name
newnode:
                addiu $sp, $sp, -4
                sw $ra, 4($sp)
                move $s1, $a0
                 
                jal smalloc
                sw $zero, 4($v0) 	# hopefully a good idea
                sw $s1, 8($v0
                 
                lw $ra, 4($sp)
                addiu $sp, $sp, 4
                jr $ra
                 
# $a0 list address
# $a1 node memory address
# $v0: new list address
# Add specified node to given list by argument. Return the new updated list memory address.
addnode:
                beqz $a0, empty # caso de lista vacia
                lw $t0, 0($a0)  #t0 is the previous memory address
                sw $t0, 0($a1)
                sw $a0, 12($a1)	
                sw $a1, 0($a0)	
                sw $a1, 12($t0)
                 
                move $v0, $a0
                jr $ra
 
empty:          
                sw $a1, 0($a1)   # carga su propia direccion de memoria en la primera word |x| | | |
                sw $a1, 12($a1) # carga su propia direccion de memoria en la cuartaa word | | | |x|
                move $v0, $a1	# carga el nodo en $v0
                jr $ra


siguientecategoria2:
		# cargar lista de la categoria actual en $t2
		lw $t2, wclist
		
		beqz $t0 noCats
		
		# desplazar el valor de $t0 a la dir del siguiente
		lw $t2, 12($t2)
		sw $t2, wclist
		sw $t2, cclist
		
		la $a0, changeCatMessage
		jal print
		
		# cargar en $t1 la direccion de la tercer pos del nodo (el nombre de la categoria)
		lw $t1, 8($t2)
		move $a0, $t1
		jal print
		j menu

categoriaanterior3:

		# cargar lista de la categoria actual en $t2
		lw $t2, cclist
		
		beqz $t0 noCats
		
		# desplazar el valor de $t0 a la dir del anterior
		lw $t2, 0($t2)
		sw $t2, wclist
		sw $t2, cclist
		
		
		la $a0, changeCatMessage
		jal print
		
		# cargar en $t1 la direccion de la tercer pos del nodo (el nombre de la categoria)
		lw $t1, 8($t2)
		move $a0, $t1
		jal print
		j menu

traverseList4:
		# cargar lista de la categoria actual en $t0
		lw $t0, cclist
		# cargo dir del nodo previo en $t3
		la $t3, 0($t0)
		
		beqz $t0 noCats
		
		la $a0, showCatsMessage
		jal print
		
		# hace lo mismo del loop solo que agregandole el *
		lw $t1, 8($t0)
		la $a0, asterisk
		jal print
		move $a0, $t1
		jal print
		lw $t0, 12($t0)
		beq $t0, $t3, endLoop
		j loop
loop:
		# cargar nombre asignado al nodo actual en $t1
		lw $t1, 8($t0)
		
		# mostrar $t1
		move $a0, $t1
		jal print
		
		lw $t0, 12($t0) # ahora $t0 apunta al siguiente nodo
		
		beq $t0, $t3, endLoop
		j loop
		
noCats:		
		la $a0, noCatsMessage 
		jal print
		j menu
                
endLoop:
		# la $a0, endLoopMessage
		# jal print
		j menu


deleteCategory5:
		# guardar dir de categoria actual en $t0
		lw $t0, wclist
		# guardar dir de lista de categorias en $s0
		lw $s0, cclist
		
		beqz $t0, menu
		
		la $a0, deleteCatMessage
		jal print
		
		lw $t3, 8($t0)
		move $a0, $t3
		jal print
		
		# guardar dir de su lista de objetos en $t1
		lw $t1, 4($t0)
		beqz $t1, delCat		
			
		# guardar dir del anterior
		lw $t2, 0($t1)
		j delObj
delObj:
		lw $t3, 12($t1)
		# terminar bucle cuando solo quede 1 elem
		beq $t3, $t2, delLastNode
		
		# eliminar nodo actual
		move $a0, $t1
		jal delnode
		
		lw $t1, 12($t1) # ahora $t1 apunta al siguiente nodo
		j delObj
	
delLastNode:	
		addi $t6, $zero, 0
		lw $t0, wclist
		sw $t6, 4($t0)
		move $a0, $t2
		jal delnode
		j delCat
	
delCat:		
		lw $s0, cclist
		lw $t0, wclist
		# dir de la categoria anterior
		lw $t1, 0($t0)
		
		# quiero borrar la unica categoria
		beq $t0, $t1, delLastCat
		
		# mover wclist hacia la sig categoria
		lw $a0, 12($t0)
		sw $a0, wclist
		
		# saltar si la cat a eliminar no es la primera de la lista
		bne $t0, $s0, notFirst
		# si no, tambien hace flata actualizar la cclist
		sw $a0, cclist

notFirst:
		move $a0, $t0
		jal delnode
		j menu

delLastCat:	
		lw $t0, wclist
		move $a0, $t0
		jal sfree
		
		lw $s0, cclist
		lw $t1, 8($s0)
		move $a0, $t1
		jal sfree
		move $a0, $s0
		jal sfree
		
		addi $t5, $zero, 0
		move $t0, $t5
		
		addi $t5, $zero, 0
		sw $t5, cclist
		j menu

appendObject6:
		# cargar lista de cat actual en $t5
		lw $t5, wclist
		# cargar direccion a lista de objetos de la cat actual en $t1
		lw $t1, 4($t5)
		
		
		# mostrar mensaje ingresar nombre
		la $a0, newObjMessage
		jal print
		
		# ingresar nombre objeto
		jal smalloc
                move $a0, $v0
                li $a1, 16
                
                # guardar en $a0 el nombre
                li $v0, 8
                syscall
		
		# si aun no hay una lista de objetos creada para esa categoria, crearla
		beqz $t1, emptyObjList
		
		# guardar id del anterior al objeto actual en la lista
		lw $t7, 0($t1)
		lw $t6, 4($t7)
		
		# toma el string $a0 para crear el nuevo nodo y retorna su direccion en $v0
		jal newnode
		
		# cargar wclist en $a0
		move $a0, $t1
		# cargar memoria reservada en $a1
		move $a1, $v0
		
		# toma la lista $a0 y su memoria reservada $a1 para agregar el nodo
		jal addnode
		
		addi $t6, $t6, 1
		lw $t7, 0($v0)
		sw $t6, 4($t7)
		
		lw $t7, wclist
		sw $v0, 4($t7)
		j menu

emptyObjList:
		# toma el string $a0 para crear el nuevo nodo y retorna su direccion en $v0
		jal newnode
		
		# mueve valor de la lista de objetos al argumento $a0
		move $a0, $t1
		# cargar memoria reservada por newnode en $a1
		move $a1, $v0
		
		# toma la lista $a0 y su memoria reservada $a1 para agregar el nodo
		jal addnode
		
		# cargar la nueva lista en t2
		move $t2, $v0
		# $t3=1
		addi $t3, $zero, 1
		# la id del unico objeto de la lista es 1 (default)
		sw $t3, 4($t2)
		
		lw $t7, wclist
		sw $v0, 4($t7)
		j menu

deleteObject7:
		# mensaje de ingresar ID
		la $a0, inputIDMessage
		jal print
		
		# Lee un entero
                li $v0, 5
                syscall
                move $t0, $v0 # carga el input en t0
		
		lw $t1, wclist
		
		# cargar en $t2 lista de objetos
		
		lw $t2, 4($t1)
		lw $s2, 4($t1)
		lw $t6, 0($t2)
		lw $t7, 12($t2)
		lw $s4, 4($t2)
		
		
		# si el anterior es igual al mismo, significa que hay un unico nodo en la lista
		beq $t6, $t2, singleElemCase1
		
		# se quiere borrar el primero
		beq $t0, $s4, singleElemCase2
		
		
		# cargar en $t6 la dir del nodo anterior al primer nodo
		lw $t6, 0($t2)
		lw $t8, wclist
			
		j lookForID
lookForID:
		# cargar id asignada al nodo actual en $t3
		lw $t3, 4($t2)
		
		beq $t3, $t0, deleteNodeWithID
		
		lw $t2, 12($t2) # ahora $t2 apunta al siguiente nodo
		j lookForID
		
		j menu
		
deleteNodeWithID:
		la $a0, rmObjMessage
		jal print
		
		lw $t6, 8($t2)
		move $a0, $t6
		jal print
		
		move $a0, $t2
		jal delnode
		
		j menu

# estoy eliminando el primer elemento, y este es el unico
singleElemCase1:
		addi $t6, $zero, 0
		sw $t6, 4($t1)
		move $a0, $t2
		jal delnode
		j menu

# estoy eliminando el primer elemento, sin ser este el unico		
singleElemCase2:		
		lw $t6, 0($t2)
		j loop3
# recorro hasta el ultimo nodo de la lista
loop3:		
		beq $t2, $t6, break
		lw $t2, 12($t2)
		j loop3

break:
		# $t2 apunta al ult nodo de la lista
		# $s2 apunta al primer nodo de la lista (actual)
		# $t7 apunta al siguiente al primer nodo
		
		lw $s3, 12($s2)
		
		# el siguiente del ult nodo = siguiente del primer nodo
		sw $s3, 12($t2)
		
		# previo del (siguiente del primer elemento) = ult nodo
		sw $t2, 0($t7)
		
		lw $t6, wclist
		# nuevo primer nodo = siguiente del antiguo primer ndodo
		sw $s3, 4($t6)
		
		# liberamos su memoria
		move $a0, $t2
		jal sfree
		j menu

showObject8:
		# cargar lista de categorias en $t0
		lw $t0, wclist
		
		beqz $t0 noCats
		
		la $a0, showObjsMessage
		jal print
		
		# cargar en $t2 lista de objetos
		lw $t2, 4($t0)
		
		beqz $t2, emptyobj
		
		# cargar en $t6 la dir del nodo anterior al primer nodo
		lw $t6, 0($t2)
			
		j loop2
loop2:
		# cargar nombre asignado al nodo actual en $t1
		lw $t1, 8($t2)
		
		# mostrar id del nodo actual
		lw $t7, 4($t2)
		move $a0, $t7
		jal printint
		
		# espacio entre ID y nombre
		la $a0, space
		jal print
		
		
		# mostrar objeto del nodo actual
		move $a0, $t1
		jal print
		
		beq $t6, $t2, endLoop2
		#beq $t2, $t3, endLoop2
		lw $t2, 12($t2) # ahora $t2 apunta al siguiente nodo
		j loop2

endLoop2:
		j menu

emptyobj:
		la $a0, noObjectsMessage
		jal print
		j menu


# imprime un string, tomando como argumento $a0
print:
	li	$v0, 4
	syscall
	jr	$ra

# imprime un entero, tomando como argumento $a0
printint:
	li	$v0, 1
	syscall
	jr	$ra


# $a0 is the pointer to the first field of the node
# Frees memory for node given its pointer
delnode:
                addiu $sp, $sp, -4
                sw $ra, 4($sp)

                lw $t0, ($a0)
                lw $t1, 12($a0)           
                sw $t0, ($t1)   
                addiu $t0, $t0, 12
                sw $t1, ($t0)                  

                jal sfree   

                lw $ra, 4($sp)
                addiu $sp, $sp, 4
                jr $ra

### LOW LEVEL FUNCTIONS ###
 
smalloc:
                #return allocated memory address in $v0
                lw $t0, slist
                beqz $t0, sbrk
                move $v0, $t0
                lw $t0, 12($t0)
                sw $t0, slist
                jr $ra
sbrk:
                li $a0, 16 # node size fixed 4 words
                li $v0, 9
                syscall # return node address in v0
                jr $ra
 
#$a0: memory address to free
sfree:
                lw $t0, slist
                sw $t0, 12($a0)
                sw $a0, slist # $a0 node address in unused list
                jr $ra