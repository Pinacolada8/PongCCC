#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#define WINDOWS _WIN32 || _WIN64
#ifdef WINDOWS
#include <Windows.h>
#else
#include <unistd.h>
#endif

#define HEIGHT 28
#define WIDTH (1.333333*HEIGHT) // 16/9 resolution
#define MARGIN_HORIZONTAL 4
#define PADDLE_RADIUS 2 //Total paddle size of 5
#define DELAY_TIME 200

char **screen;
int ballx = WIDTH / 2, bally = HEIGHT / 2;
int paddleOnex = MARGIN_HORIZONTAL,
	paddleOney = HEIGHT / 2,
	paddleOneSpeed = -1,
	paddleTwox = WIDTH - MARGIN_HORIZONTAL,
	paddleTwoy = HEIGHT / 2,
	paddleTwoSpeed = 1;
int speedBallx = 1, speedBally = 1;

void printMatrix(char **matrix)
{
	int i = 0, j = 0;
	for (i = 0; i < HEIGHT + 1; i++)
	{
		for (j = 0; j < WIDTH; j++)
		{
			printf("%c", matrix[j][i]);
		}
		printf("\n");
	}
}

void drawMargin(){
	int i;
	for(i=0;i<HEIGHT;i++){
		screen[0][i] = '*';
		screen[(int)WIDTH][i] = '*';
	}

	for(i=0;i<WIDTH;i++){
		screen[i][0] = '*';
		screen[i][HEIGHT] = '*';
	}
}

void delay(int delayTime)
{
#ifdef WINDOWS
	Sleep(delayTime);
#else
	usleep(delayTime * 1000); /* sleep for 100 milliSeconds */
#endif
}

void drawPaddle(char **matrix, int paddlex, int paddley)
{
	int i = 0;
	for (i = 0; i <= PADDLE_RADIUS; i++)
	{
		matrix[paddlex][paddley + i] = '|';
		matrix[paddlex][paddley - i] = '|';
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

void clear()
{
	clearMatrix();
#ifdef _WIN32
	system("cls");
#else
	system("clear");
#endif
}

void draw()
{
	clear();	
	screen[ballx][bally] = 'O';
	drawPaddle(screen, paddleOnex, paddleOney);
	drawPaddle(screen, paddleTwox, paddleTwoy);
	drawMargin();
	printMatrix(screen);
}

void movePaddles(int *paddley, int *paddleSpeed)
{
	*paddley += *paddleSpeed;
	if ((*paddley + PADDLE_RADIUS) > HEIGHT)
	{
		*paddley--;
		*paddleSpeed *= -1;
	}
	if ((*paddley - PADDLE_RADIUS) < 0)
	{
		*paddley++;
		*paddleSpeed *= -1;
	}
}

void gameOver()
{
	ballx = WIDTH / 2;
	bally = HEIGHT / 2;
	paddleOnex = MARGIN_HORIZONTAL;
	paddleOney = HEIGHT / 2;
	paddleOneSpeed = -1;
	paddleTwox = WIDTH - MARGIN_HORIZONTAL,
	paddleTwoy = HEIGHT / 2;
	paddleTwoSpeed = 1;
	speedBallx = 1;
	speedBally = 1;
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
	if (bally > HEIGHT)
	{
		bally--;
		speedBally *= -1;
	}
	if (bally < 0)
	{
		bally++;
		speedBally *= -1;
	}
}

void loop()
{
	delay(DELAY_TIME);
	movePaddles(&paddleOney, &paddleOneSpeed);
	movePaddles(&paddleTwoy, &paddleTwoSpeed);
	moveBall();
	draw();
	loop(screen);
}

int main()
{
	int i, j;

	screen = malloc(sizeof(char *) * WIDTH);

	loop();

	return 0;
}
