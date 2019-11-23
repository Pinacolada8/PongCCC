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

    subi $sp $sp 1228800 #Reservando espaco para o array de pixel WIDTHxHEIGHT

    #jal CALC   
    li $v0, 10			# finaliza o programa
	syscall

DRAWPADDLE:

    jr $ra

CLEARMATRIX:

    jr $ra

DRAW:

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
            jal GAMEOVER #gameOver()

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
            jal GAMEOVER #gameOver()

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

    