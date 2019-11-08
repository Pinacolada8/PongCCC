#include <stdio.h>
#include <stdlib.h>
#include <string.h>


#define HEIGHT = 480;
#define WIDTH = (4/3)*HEIGHT;

void printMatrix(char** matrix){
	int i = 0,j=0;
	for(i=0;i<HEIGHT;i++){
		for(j=0;j<WIDTH;j++){			
			printf("%c",matriz[i][j]);
		}
	}
}

int main() {
	int i,j;
	
	char** screen = malloc(sizeof(char*)*HEIGHT);
	for(i=0;i<HEIGHT;i++){
		screen[i] = malloc(sizeof(char)*WIDTH);
		for(j=0;j<WIDTH;j++){
			screen[i][j] = ' ';
		}
	}
	
	printMatrix(screen);
	
	return 0;
}