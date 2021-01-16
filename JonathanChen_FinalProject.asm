.eqv PRINT_INT 1
.eqv PRINT_STRING 4
.eqv PRINT_CHAR 11
.eqv INPUT_INT 5
.eqv SYS_EXIT 10

.data

# the array that would hold stack elements
arr: .word 0:100
	
endl:		.asciiz  "\n" 
space:		.asciiz  " "
label_arr:	.asciiz  "Current elements: "
label_inst:	.asciiz  "Enter 1 to push, 2 to pop, 3 to find max, 0 to exit\n"
label_invalid:	.asciiz  "Invalid option \n"
label_empty:	.asciiz  "Array is empty \n"
label_max:	.asciiz  "Max is: "
pushy:		.asciiz  "Push a number:"
poppy:		.asciiz  "popped"



.text	

	li $t0,0
	
	addi $t2, $zero, 0													
main:		
		
	#introduction prompt
	li $v0, PRINT_STRING
	la $a0, label_inst
	syscall
	
	# endl
	li $v0, 4
	la $a0, endl
	syscall
	
	
	#user input
	li $v0, 5
	syscall
	
	move $a0, $v0 # store inside $t0
	
	#options
	beq $a0, 0, exit
	
	beq $a0, 1, push
	
	beq $a0, 2, pop
	
	beq $a0, 3, max
	
	bgt $a0, 3, error # t > 3
	
	blt $a0, 0, error # t < 0

# safety stop
li $v0, 10
syscall


						
error:

li $v0, 4
la $a0, label_invalid
syscall	

j main					
																		
												
exit:

#stop code
li $v0, 10
syscall




printAR:

li $t0,0

li $t3,100


#current elements
li $v0, 4
la $a0, label_arr
syscall

################################################################################################################
##############################################--print_arr--#####################################################
################################################################################################################
print_arr:
beq $t0, $t2, newLines

lw $t6, arr($t0)

# set t3 into the data of $t6
add $t3,$t6,$zero

# print out t3
li $v0, 1
addi $a0, $t3, 0
syscall

#space
li $v0, 4
la $a0, space
syscall

addi $t0,$t0,4

li $t3,0

j print_arr



newLines:

	
# endl
li $v0, 4
la $a0, endl
syscall
	
# endl
li $v0, 4
la $a0, endl
syscall

j main

################################################################################################################
#################################################--PUSH--#######################################################
################################################################################################################



push:

#push prompt
li $v0, 4
la $a0, pushy
syscall

#user input
li $v0, 5
syscall


addi $t2, $t2, 4


sw $v0, arr($t0)
    addi $t0, $t0, 4

j printAR



################################################################################################################
######################################################--POP--###################################################
################################################################################################################

pop:
blt $t2, 4, emptyArray # if t2 less than 0   ->    emptyArray

beq $t2, 4, turnEmpty

#subtract t2 by 4
subi $t2, $t2, 4


#subtract t0 by 4
subi $t0, $t0, 4

#popped
li $v0, 4
la $a0, poppy
syscall

li $v0, 4
la $a0, endl
syscall

li $v0, 4
la $a0, endl
syscall

j printAR


##########################################################################################################################
###################################################--MAX--################################################################
##########################################################################################################################

max:
blt $t2, 4, emptyArray# if t2 less than 4   ->    emptyArray
#beq $t2, 4, oneMax #only one max in array

	# max is
	li $v0, 4
	la $a0, label_max
	syscall
	
#--------------------------------------------------------------------------------------------------------------------------------

lw $t9, arr($t0) #initialize min = arr(0)
lw $t4, arr($t0) #initialize max = arr(0)
li $t0, 0
li $t7, 0
la $t0, arr

loop:  lw $t8,($t0)            
    bge $t8, $t9, notMin     
    move $t9,$t8           
    j notMax

 notMin: ble $t8,$t4, notMax       
    move $t4,$t8     

 notMax:    
    add $t7,$t7,4          
    add $t0,$t0, 4       
    blt $t7, $t2,loop     

    move $a0, $t4
    li $v0,1
    syscall
    
   li $t0, 0
   add $t0, $t0, $t2
#--------------------------------------------------------------------------------------------------------------------------------
			
	#endl
	li $v0, 4
	la $a0, endl
	syscall
	
	#endl
	li $v0, 4
	la $a0, endl
	syscall
	
	j main
	
	
################################################################################################################
###############################################--emptyArray--###################################################
################################################################################################################


turnEmpty:
#subtract t2 by 4
subi $t2, $t2, 4

#subtract t0 by 4
subi $t0, $t0, 4

#popped
li $v0, 4
la $a0, poppy
syscall

li $v0, 4
la $a0, endl
syscall

li $v0, 4
la $a0, endl
syscall
	
emptyArray:

	# Array Is Empty
	li $v0, 4
	la $a0, label_empty
	syscall

	#endl
	li $v0, 4
	la $a0, endl
	syscall

j main

	
