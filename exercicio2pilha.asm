MAIN: 	addi $a0, $zero, 1		#  inicialização de L = 1
	jal FUNCT			#  chamada a função funct
	
	li $v0, 1 			# $v0 => serviço 1: imprimir um valor  inteiro
	add $a0, $v1, $zero 		# carrega o valor de resultado em $a0
	syscall 			# faz uma chamada de sistema 
	
	li $v0, 10			# finaliza o programa
	syscall 			# faz uma chamada de sistema 

FUNCT: 	subi $sp, $sp, 4		# reserva espaço para um elemento na pilha 
	sw $ra, 0($sp)			# armazena endereço de retorno na pilha
	
	addi $v1, $a0, 1 		# $v1 = result = f + 1
	slti $t1, $a0, 6		# $t1 = 0, se f > 5
	bne  $t1, $zero, CONT		# $t1 =1, se f < 5 continua
	
	subi $t2, $a0, 1		# calcula número de chamadas jal funct em CONT
	add $t2, $t2, $t2		# número de chamadas em CONT * 2
	add $t3, $t2, $t2		# número de chamadas em CONT * 4
	
	add $sp, $sp, $t3		# ajusta piha para ignorar $ra armazenados pelas chamadas recursivas
	lw $ra, 0($sp)			# restaura o primeiro valor de $ra armazenado na pilha 
	jr $ra				# retorna ao main

CONT: 	add $a0, $zero, $v1		# $a0 = $v0
	jal FUNCT			# chama FUNCT com argumento result