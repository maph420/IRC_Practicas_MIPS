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


slist:          .word 0 #lista simplemente enlazada para la memoria
cclist:         .word 0 # category list
wclist:         .word 0 # working category list
 
                .text
main:

### MAIN MENU ###

# Menu principal
mainMenu:
                # Imprime menu

                la $a0, menu1 # carga el valor a mostrar (menu1)
                addi $v0, $0, 4 # instruccion print string
                syscall
                
                # Lee un entero
                li $v0, 5 # carga instruccion de leer un numero
                syscall
                move $t0, $v0 # carga el input en t0
                
                # Imprime la opcion elegida
                la $a0, eleccion # carga el valor a mostrar (eleccion)
                addi $v0, $0, 4 # instruccion print string
                syscall
                move $a0, $t0 # carga el input en a0
                addi $v0, $0, 1 # carga la instruccion print integer
                syscall
                la $a0, salto # \n
                addi $v0, $0, 4 # instruccion print string
                syscall
 
                # jal chequeareleccion
 
                j derivar_a_funcion
 
                j fin
                
                
# Ejecuta la funcion indicada por el usuario
derivar_a_funcion:
                la $a0, buenaeleccion # carga buena eleccion
                addi $v0, $0, 4 # instruccion print string
                syscall
 
                # ATENCION: por convencion toda funcion termina en j menu
                # switch para llamar funcion correspondiente con el input (t0)
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
		# imprime mensaje
                la $a0, continueText            
                li $v0, 4
                syscall
 
 		# espera entrada para continuar
                li $v0, 12
                syscall
 
                j mainMenu
                

### MAIN FUNCTIONS ###

# Given a string name, create a new category.
crearcategoria1:
                # mostrar mensaje de seleccionar categoria
                la $a0, selecCat 
                jal print

                # guardar espacio en v0
                jal smalloc # pide memoria
                move $a0, $v0 # direccion de memoria alocada para guardar el sting ingresado (a0)
                li $a1, 16 # cantidad maxima de caracteres a leer

                # leer nombre de categoria (se guarda en a0)
                li $v0, 8 # instruccion read string
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
                
                # muevo el stack pointer en una palabra (4)
                addiu $sp, $sp, -4 # el stack pointer se mueve 4 bytes hacia atras
                sw $ra, 4($sp) # se guarda la dir de la instruccion posterior al ult jal, en el stack pointer

                jal newnode

                lw $a0, cclist # almacena en $a0 cclist (inicializado en 0)
                move $a1, $v0 # almacena en $a1 el nodo con la memoria ya reservada con newnode
                
                jal addnode
 
                lw $t0, cclist # almacena cclist en $t0 (hace que cclist apunte al nodo anterior al agregado)
                bnez $t0, nonEmpty # si $t0 no es 0 salta a nonEmpty
                sw $v0, wclist # si es vacio guarda wclist en $v0

nonEmpty:       sw $v0, cclist # si no es vacio guarda cclist en $v0
                lw $ra, 4($sp) # vuelve
                addiu $sp, $sp, 4
                jr $ra

 
 
# $a0: string name
# $v0: returns node address
# Create a new node with string name
newnode:
                addiu $sp, $sp, -4 # se hace espacio en el stack pointer
                sw $ra, 4($sp) # se guarda la direccion a la que volver en el stack pointer
                move $s1, $a0 # se guarda el valor de $a0 (el nombre) a $s1 asi no se pierde en la sig llamada
                 
                jal smalloc # se pide memoria, la cual se guarda en $v0
                sw $zero, 4($v0) # se "limpia" la word del nodo en la segunda word | |x| | |
                sw $s1, 8($v0) # se guarda el nombre del nodo en la tercer word    | | |x| |
                 
                lw $ra, 4($sp) # carga la dir de retorno del stack pointer en $ra (y sale del $sp)
                addiu $sp, $sp, 4 # decrementar espacio del stack pointer en 1 word
                jr $ra # vuelve a newCategory, despues del ultimo jal llamado
                 
# $a0 list address
# $a1 node memory address
# $v0: new list address
# Add specified node to given list by argument. Return the new updated list memory address.
addnode:
                beqz $a0, empty # chequea si la lista esta vacia (es el primer elemento)
                # si la lista no es vacia:
                lw $t0, 0($a0)  # se guarda en un temporal la dir del nodo anterior al nodo al que apunta cclist |x| | | |
                sw $t0, 0($a1)	# se asigna $t0 como nodo anterior para el nodo que agrego |x| | | |

                sw $a0, 12($a1)	# se asigna la dir del nodo actual almacenado en cclist como el siguiente al que agrego | | | |x|
                sw $a1, 0($a0)	# se asigna la dir del nodo actual como el anterior al almacenado en cclist |x| | | |

                sw $a1, 12($t0) # se asigna el nodo agregado como el siguiente al anterior a cclist | | | |x|
                 
                move $v0, $a0	# mueve los valores del nodo antiguo actual a $v0
                jr $ra
 
empty:          # si la lista es vacia, la dir del nodo ant y del post es la misma, si misma
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
		la $a0, deleteCatMessage
		jal print
		
		# guardar dir de categoria actual en $t0
		lw $t0, wclist
		# guardar dir de su lista de objetos en $t1
		lw $t1, 4($t0)
			
		j delLoop
delLoop:
		# eliminar nodo actual
		move $a0, $t1
		jal delnode
		lw $t2, 0($t2)
		
		beq $t2, $t1, breakDelLoop
		
		lw $t1, 12($t1) # ahora $t1 apunta al siguiente nodo
		j delLoop
		
breakDelLoop:
		move $a0, $t1
		jal delnode
		
		move $a0, $t0
		jal delnode
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
		
		lw $s0, 8($s2)
		move $a0, $s0
		jal print
		
		lw $s0, 8($t2)
		move $a0, $s0
		jal print
		
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


# imprime, tomando como argumento $a0
print:
	li	$v0, 4
	syscall
	jr	$ra

# imprime, tomando como argumento $a0
printint:
	li	$v0, 1
	syscall
	jr	$ra


# $a0 is the pointer to the first field of the node
# Frees memory for node given its pointer
delnode:
                addiu $sp, $sp, -4         # guarda en el stack la direccion para volver
                sw $ra, 4($sp)

                lw $t0, ($a0)                   # (t0 )previous node (| | | | |) <- |x| | | |
                lw $t1, 12($a0)                 # (t1) next node | | | | | . | | | |x| -> (| | | | |)
                sw $t0, ($t1)                   # store prv node into prv of nxt | | | | | . |x| | | | . |x| | | |
                addiu $t0, $t0, 12
                sw $t1, ($t0)                   # store nxt node into nxt of prv | | | |x| . | | | |x| . | | | | |

                jal sfree            # libera la memoria del nodo en $a0

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
