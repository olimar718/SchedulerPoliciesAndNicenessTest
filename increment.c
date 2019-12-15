#include <stdio.h>
#include <stdlib.h>
int main(int argc, char *argv[]){
  if(argc < 2){
    printf("One argument : number to increment\n");
    exit(128);
  }
  long double incrementmax=atoi(argv[1]);
  long double i = 0;
  while (i<incrementmax){
    // printf("%Lf",i);
    i = i+1;
  }
}
