#include <stdio.h>
#include <math.h>
#include <stdlib.h>

int main(){

  char value[17];
  do{
    double conv_num = 0;
    puts("value to convert = ");
    scanf("%s",value);
    printf("%s\n",value);

    conv_num = (-1)*(value[0]-'0');
    printf("%lf",conv_num);
    for(int i= 2; i<17; i++){

      conv_num += pow(2,-i+1)*(value[i]-'0');
    }

    printf("Converted value = %.10lf\n", conv_num);
  }while(1);

}
