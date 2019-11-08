#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>


#define HEIGHT 48
#define WIDTH 1.333333*HEIGHT // 16/9 resolution
#define MARGIN_HORIZONTAL 4
#define PADDLE_RADIUS 2 //Total paddle size of 5
#define DELAY_TIME 500

void printMatrix(char** matrix){
	int i = 0,j=0;
	for(i=0;i<HEIGHT;i++){
		for(j=0;j<WIDTH;j++){			
			printf("%c",matrix[j][i]);
		}
	printf("\n");
	}
}

void drawPaddle(char** matrix, int paddlex, int paddley){
	int i = 0;
	for(i = 0; i <= PADDLE_RADIUS; i++){
		matrix[paddlex][paddley + i] = '|';
		matrix[paddlex][paddley - i] = '|';	
	}
}

void delay(int milli_seconds) 
{  
    // Stroing start time 
    clock_t start_time = clock(); 
  
    // looping till required time is not acheived 
    while (clock() < start_time + milli_seconds) 
        ; 
}

void clear(){
	#ifdef _WIN32
		system("cls");
	#else
		system("clear");
	#endif
}

void loop(char** screen){
	delay(DELAY_TIME);
	clear();
	printMatrix(screen);
	loop(screen);
}


int main() {
	int i,j;
	int ballx = WIDTH/2 , bally = HEIGHT/2;
	int paddleOnex = MARGIN_HORIZONTAL, paddleOney = HEIGHT/2, paddleTwox = WIDTH - MARGIN_HORIZONTAL, paddleTwoy = HEIGHT/2;
	int speedBallx = 1, speedBally = 1;
	
	char** screen = malloc(sizeof(char*)*WIDTH);
	for(i=0;i<WIDTH;i++){
		screen[i] = malloc(sizeof(char)*HEIGHT);
		for(j=0;j<HEIGHT;j++){
			screen[i][j] = '*';
		}
	}

	screen[ballx][bally] = 'o';
	drawPaddle(screen, paddleOnex, paddleOney);
	drawPaddle(screen, paddleTwox, paddleTwoy);

	loop(screen);
		
	return 0;
}

