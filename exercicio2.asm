MAIN: 	addi $a0, $zero, 1		#  inicialização de l = 1

	jal FUNCT			#  chamada de funct
	
	li $v0, 1 			# $v0 => serviço 1: imprimir um valor  inteiro
	add $a0, $v1, $zero 		# carrega o valor de resultado em $a0
	syscall 			# faz uma chamada de sistema 
	
	li $v0, 10			# finaliza o programa
	syscall 			# faz uma chamada de sistema 

FUNCT: 	
	addi $v1, $a0, 1 		# $v1 = result = f + 1
	
	slti $t1, $a0, 6		# $t1 = 0, se f > 5
	bne  $t1, $zero, CONT		# $t1 =1, se f < 5 continua

	jr $ra

CONT: 	add $a0, $zero, $v1		# $a0 = $v0
	j FUNCT				# chama FUNCT com argumento result
