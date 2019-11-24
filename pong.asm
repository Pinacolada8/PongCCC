MAIN:

    #WIDTH = 640
    #HEIGHT = 480

    addi $s0 $zero 320 #ballx = WIDTH/2
    addi $s1 $zero 240 #bally = HEIGHT / 2 
    addi $s2 $zero 240 #paddleOney = HEIGHT / 2
    addi $s3 $zero -1  #paddleOneSpeed = -1
    addi $s4 $zero 240 #paddleTwoy = HEIGHT / 2
    addi $s5 $zero 1   #paddleTwoSpeed = 1
    addi $s6 $zero 1   #speedBallx = 1
    addi $s7 $zero 1   #speedBally = 1

    addi $sp $sp -1228800 #Reservando espaco para o array de pixel WIDTHxHEIGHT

    add $t8 $zero $zero #int quit = 0

    LOOP:
    jal MOVEPADDLEONE #movePaddleOne()
    jal MOVEPADDLETWO #movePaddleTwo()
    jal MOVEBALL #moveBall()
    jal DRAW #draw()


    bne $t8 $zero END #if (quit != 1) return
    j LOOP

    END: 
    li $v0, 10			# finaliza o programa
	syscall

DRAWPADDLE:
    add $t0 $zero $zero #int i = 0
    addi $t1 $zero 2 #PADDLE_RADIUS
    addi $t3 $zero 480 #$t3 = HEIGHT

    mult	$a0 $t3	#paddleX * Height, pora compor o endereco em forma de vetor unico
    mflo	$t2	#Endereco
    
    sll $t2 $t2 2 #Endereco * 4, tranformando para endereco de 32bits
    add $t2 $sp $t2 #paddlex = $t2    

    FOR1_DRAWPADDLE:
        addi $t6 $zero 2 #Valor da barra '|' que compoe os paddles

        add $t4 $a1 $t0 #paddley + i
        add $t4 $t2 $t4 #Endereco em vetor unidimensional(paddley+1)
        sw $t6 0($t4) #screen[paddlex][paddley + i] = '|'

        sub $t5 $a1 $t0 #paddley - i
        add $t5 $t2 $t5 #Endereco em vetor unidimensional(paddley-1)
        sw $t6 0($t5) #screen[paddlex][paddley - i] = '|'

        addi $t0 $t0 1 #i++
    ble $t0 $t1 FOR1_DRAWPADDLE
    jr $ra

CLEARMATRIX:
    addi $t0 $zero 0 #variavel de iteração = i
    addi $t1 $zero 1228800 #valor maximo WIDTHxHEIGHT
    FOR1_DRAW:
        add $t2 $sp $t0 #Posicao de memoria a ser atualizada = i + memAdd
        sw $zero 0($t2)
        sll $t0 $t0 2
    blt $t0 $t1 FOR1_DRAW

    jr $ra

DRAW:
    add $t9 $ra $zero #Guarda o endereco de retorno

    addi $t2 $zero 1 #valor que representa a bola 'O'

    addi $t0 $zero 480 #Height
    mult $s0 $t0 #valor ballx em vetor unidimensional
    mflo  $t0
    add $t1 $t0 $s1 #[ballx][bally]
    sll $t1 $t1 2 #[ballx][bally] em palavras de 32bits
    add $t1 $sp $t1 #Endereco de [ballx][bally]
    sw $t2 0($t1) #screen[ballx][bally] = 'O'

    addi $a0 $zero 4 #arg0 = MARGIN_HORIZONTAL
    add $a1 $zero $s2 #arg1 = paddleOneY
    jal DRAWPADDLE #drawPaddle(MARGIN_HORIZONTAL, paddleOney)

    addi $a0 $zero 636 #arg0 = MARGIN_HORIZONTAL
    add $a1 $zero $s4 #arg1 = paddleOneY
    jal DRAWPADDLE #drawPaddle(MARGIN_HORIZONTAL, paddleOney)

    add $ra $t9 $zero #Resgata o endereco de retorno
    jr $ra

MOVEPADDLEONE:
    add $s2 $s2 $s3 #paddleOney += paddleOneSpeed

    addi $t0 $s2 2 #paddleOney + PADDLE_RADIUS
    addi $t1 $zero 480 #t1 = Height, Necessario para usar slt
    slt $t2 $t1 $t0 #(paddleOney + PADDLE_RADIUS) > HEIGHT)
    beq $t2 $zero END_IF1_MOVEPADDLEONE    
        addi $s2 $s2 -1 #paddleOney-- 
        addi $t3 $zero -1 # $t3 = -1
        mult $s3 $t3 # $lo = paddleOneSpeed * -1
        mflo $s3 #paddleOneSpeed *= -1
    END_IF1_MOVEPADDLEONE:  
	
    subi $t0 $s2 2 #paddleOney - PADDLE_RADIUS
    slti $t1 $t0 0 #(paddleOney - PADDLE_RADIUS) < 0)
    bne $t1 $zero END_IF2_MOVEPADDLEONE    
        addi $s2 $s2 1 #paddleOney++ 
        addi $t3 $zero -1 # $t3 = -1
        mult $s3 $t3 # $lo = paddleOneSpeed * -1
        mflo $s3 #paddleOneSpeed *= -1
    END_IF2_MOVEPADDLEONE:

    jr $ra

MOVEPADDLETWO:
    add $s2 $s2 $s3 #paddleOney += paddleOneSpeed

    addi $t0 $s2 2 #paddleOney + PADDLE_RADIUS
    addi $t1 $zero 480 #t1 = Height, Necessario para usar slt
    slt $t2 $t1 $t0 #(paddleOney + PADDLE_RADIUS) > HEIGHT)
    beq $t2 $zero END_IF1_MOVEPADDLETWO    
        addi $s2 $s2 -1 #paddleOney-- 
        addi $t3 $zero -1 # $t3 = -1
        mult $s3 $t3 # $lo = paddleOneSpeed * -1
        mflo $s3 #paddleOneSpeed *= -1
    END_IF1_MOVEPADDLETWO:  
	
    subi $t0 $s2 2 #paddleOney - PADDLE_RADIUS
    slti $t1 $t0 0 #(paddleOney - PADDLE_RADIUS) < 0)
    bne $t1 $zero END_IF2_MOVEPADDLETWO    
        addi $s2 $s2 1 #paddleOney++ 
        addi $t3 $zero -1 # $t3 = -1
        mult $s3 $t3 # $lo = paddleOneSpeed * -1
        mflo $s3 #paddleOneSpeed *= -1
    END_IF2_MOVEPADDLETWO:

    jr $ra

GAMEOVER:
    addi $s0 $zero 320 #ballx = WIDTH/2
    addi $s1 $zero 240 #bally = HEIGHT / 2 
    addi $s2 $zero 240 #paddleOney = HEIGHT / 2
    addi $s3 $zero -1  #paddleOneSpeed = -1
    addi $s4 $zero 240 #paddleTwoy = HEIGHT / 2
    addi $s5 $zero 1   #paddleTwoSpeed = 1
    addi $s6 $zero 1   #speedBallx = 1
    addi $s7 $zero 1   #speedBally = 1
    
    jr $ra

MOVEBALL:
    add $s0 $s0 $s6 #ballx += speedBallx
    
    addi $t0 $zero 636 #WIDTH - MARGIN_HORIZONTAL
    slt $t1 $t0 $s0 #ballx > WIDTH - MARGIN_HORIZONTAL
    beq $t1 $zero END_IF1_MOVEBALL #if (ballx > WIDTH - MARGIN_HORIZONTAL)
        addi $t2 $s4 -4 #paddleTwoy - PADDLE_RADIUS
        addi $t3 $s4 4 #paddleTwoy + PADDLE_RADIUS
        and $t4 $t2 $t3 #(bally >= paddleTwoy - PADDLE_RADIUS) && (bally <= paddleTwoy + PADDLE_RADIUS)
        beq $t4 $zero ELSE_IF2_MOVEBALL #if ((bally >= paddleTwoy - PADDLE_RADIUS) && (bally <= paddleTwoy + PADDLE_RADIUS))
            addi $t5 $zero -1 # $t5 = -1
            mult $s6 $t5 #speedBallx * -1
            mflo $s6 #speedBallx *= -1 
        j END_IF2_MOVEBALL

        ELSE_IF2_MOVEBALL: #else
            add $t9 $ra $zero
            jal GAMEOVER #gameOver()
            add $ra $t9 $zero

        END_IF2_MOVEBALL:

    END_IF1_MOVEBALL:

    slti $t0 $s0 4 #ballx < MARGIN_HORIZONTAL
    beq $t0 $zero END_IF3_MOVEBALL #if (ballx < MARGIN_HORIZONTAL)
        addi $t1 $s2 -4 #paddleOney - PADDLE_RADIUS
        addi $t2 $s4 4 #paddleOney + PADDLE_RADIUS
        and $t3 $t1 $t2 #(bally >= paddleOney - PADDLE_RADIUS) && (bally <= paddleOney + PADDLE_RADIUS)
        beq $t3 $zero ELSE_IF4_MOVEBALL #if ((bally >= paddleOney - PADDLE_RADIUS) && (bally <= paddleOney + PADDLE_RADIUS))
            addi $t4 $zero -1 # $t5 = -1
            mult $s6 $t4 #speedBallx * -1
            mflo $s6 #speedBallx *= -1 
        j END_IF4_MOVEBALL

        ELSE_IF4_MOVEBALL: #else
            add $t9 $ra $zero
            jal GAMEOVER #gameOver()
            add $ra $t9 $zero

        END_IF4_MOVEBALL:

    END_IF3_MOVEBALL:
	
    add $s1 $s1 $s7 #bally += speedBally

	addi $t0 $zero 480 #$t0 = HEIGHT
    slt $t1 $t0 $s1 #bally > HEIGHT 
    beq $t1 $zero END_IF5_MOVEBALL #if (bally > HEIGHT)
        addi $s1 $s1 -1 #bally--
        addi $t2 $zero -1# -1
        mult $s7 $t2 #speedBally * -1
        mflo $s7 #speedBally *= -1
    END_IF5_MOVEBALL:

    slt $t3 $s0 $zero #bally < 0
    beq $t3 $zer0 END_IF6_MOVEBALL #if (bally < 0)
        addi $s1 $s1 1 #bally++
        addi $t4 $zero -1 # -1
        mult $s7 $t4 #speedBally * -1
        mflo $s7 #speedBally *= -1
    END_IF6_MOVEBALL:

    jr $ra

    