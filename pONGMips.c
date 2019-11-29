#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#define HEIGHT 28
#define WIDTH 32 // 16/9 resolution
#define MARGIN_HORIZONTAL 4
#define PADDLE_RADIUS 3 //Total paddle size of 5
#define DELAY_TIME 200

char **screen;
int ballx = WIDTH / 2, bally = HEIGHT / 2;
int paddleOney = HEIGHT / 2,
	paddleOneSpeed = -1,
	paddleTwoy = HEIGHT / 2,
	paddleTwoSpeed = 1;
int speedBallx = 1, speedBally = 1;

void drawPaddle(int paddlex, int paddley)
{
	int i = 0;
	for (i = 0; i < PADDLE_RADIUS; i++)
	{
		screen[paddlex][paddley + i] = '|';
		screen[paddlex][paddley - i] = '|';
	}
}

void clearMatrix()
{
	int i, j;
	for (i = 0; i < WIDTH; i++)
	{
		screen[i] = malloc(sizeof(char) * HEIGHT);
		for (j = 0; j < HEIGHT; j++)
		{
			screen[i][j] = ' ';
		}
	}
}

void draw()
{
	clearMatrix();
	screen[ballx][bally] = 'O';
	drawPaddle(MARGIN_HORIZONTAL, paddleOney);
	drawPaddle(WIDTH - MARGIN_HORIZONTAL, paddleTwoy);
}

void movePaddleTwo()
{
	paddleTwoy += paddleTwoSpeed;
	if ((paddleTwoy + PADDLE_RADIUS) >= HEIGHT)
	{
		paddleTwoy--;
		paddleTwoSpeed *= -1;
	}
	if ((paddleTwoy - PADDLE_RADIUS) <= 0)
	{
		paddleTwoy++;
		paddleTwoSpeed *= -1;
	}
}

void movePaddleOne()
{
	paddleOney += paddleOneSpeed;
	if ((paddleOney + PADDLE_RADIUS) >= HEIGHT)
	{
		paddleOney--;
		paddleOneSpeed *= -1;
	}
	if ((paddleOney - PADDLE_RADIUS) <= 0)
	{
		paddleOney++;
		paddleOneSpeed *= -1;
	}
}

void gameOver()
{
	ballx = WIDTH / 2;
	bally = HEIGHT / 2;
	//paddleOney = HEIGHT / 2;
	//paddleOneSpeed = -1;
	//paddleTwoy = HEIGHT / 2;
	//paddleTwoSpeed = 1;
	//speedBallx = 1;
	//speedBally = 1;
}

void moveBall()
{
	ballx += speedBallx;
	if (ballx > WIDTH - MARGIN_HORIZONTAL)
	{
		if ((bally >= paddleTwoy - PADDLE_RADIUS) &&
			(bally <= paddleTwoy + PADDLE_RADIUS))
			speedBallx *= -1;
		else
			gameOver();
	}
	if (ballx < MARGIN_HORIZONTAL)
	{
		if ((bally >= paddleOney - PADDLE_RADIUS) &&
			(bally <= paddleOney + PADDLE_RADIUS))
			speedBallx *= -1;
		else
			gameOver();
	}

	bally += speedBally;
	if (bally >= HEIGHT)
	{
		bally--;
		speedBally *= -1;
	}
	if (bally <= 0)
	{
		bally++;
		speedBally *= -1;
	}
}

int main()
{
	int quit = 0,i,j;
	screen = malloc(sizeof(char *) * WIDTH);
	for (i = 0; i < WIDTH; i++)
	{
		screen[i] = malloc(sizeof(char) * (HEIGHT + 1));
		for (j = 0; j < HEIGHT; j++)
		{
			screen[i][j] = ' ';
		}
	}

	LOOP:
	movePaddleOne();
	movePaddleTwo();
	moveBall();
	draw();

	if (quit == 1) return 0; 

	goto LOOP;
	return 0;
}
