MAIN:   addi $a0, $zero, 256		# inicializa N = 256
	addi $a1, $zero, 268500992	# inicializa B[]
	jal CALC			# chamada da função
	li $v0, 10			# finaliza o programa
	syscall 			# faz uma chamada de sistema 

CALC: 	subi $sp, $sp, 8		# ajusta a pilha para 2 regs
	sw  $s1, 4($sp)			# empilha $s1 
	sw  $s2, 0($sp)			# empilha $s2 

	addi $s1, $zero, 1		#  i = $s1 = 1
	addi $s2, $zero, 0		#  x = $s2 = 0

WHILE:	slt $t0, $s1, $a0		#  $t0 = 1, se i < N
	beq $t0, $zero, EXIT		#  se i>N, então sai do while

	add $t1, $s1, $s1		#  $t1 = i + i
	add $t1, $t1, $t1		#  $t1 = 2i + 2i = 4i
	add $t1, $t1, $a1		#  $t1 = 4i + deslocamento da base de B
	
	lw  $t2, 8($t1)			#  $t2 = B[i+2]
	
	add $s2, $s2, $t2		#  x = x + B[i+2]
	
	addi $s2, $s2, 5		#  x = (x + B[i+2]) + 5
	
	sw $s2, 0($t1)			# B[i] = x
	
	add $s1, $s1, $s1		#  i = i + i
	addi $s1, $s1, 8		#  i = i + 8 

	j WHILE				# retorna para teste de while

EXIT:	add $v0, $zero, $s2		# move x para retorno
	lw $s2, 0($sp)			# desempilha $s2
	lw $s1, 4($sp)			# desempilha $s1
	addi $sp, $sp, 8		# ajusta pilha 
	jr $ra				# retorna para main
