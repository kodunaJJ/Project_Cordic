#include <stdio.h>
#include <math.h>
#include <stdlib.h>

int main(){

  unsigned char* value = NULL;
  double conv_num = 0;
  char sign = 0;
  unsigned int integer_part_size = 0;
  unsigned int data_size = 0; 
  unsigned int frac_part_size = 0;
  unsigned int point_pos = 0;
  int i=0;
  do{
    puts("Integer part bit size ? (1/2/3):");
    scanf("%d",&integer_part_size);
    
    switch (integer_part_size){

    case 1:
      value = (unsigned char *) malloc((size_t)integer_part_size+16);
      data_size = 16;
      point_pos = 1;
      break;
    case 2:
      value = (unsigned char *) malloc(integer_part_size+15);
      data_size = 16;
      point_pos = 2;
      break;
    case 3:
      value = (unsigned char *) malloc(integer_part_size+14);
      data_size = 19;
      point_pos = 4;
      break;
    default :
      puts("Unsupported data format");
    }
    
    puts("value to convert = ");
    scanf("%s",value);
    //printf("%s\n",value);

    if(value[0] == '1'){
      sign = -1;
    }
    else{
      sign = 1;
    }
    conv_num=sign*(value[0]-'0')*pow(2, point_pos-1);
    
    printf("%lf\n",conv_num);
    frac_part_size=data_size-integer_part_size;

    /*for(i=1; i<point_pos; i++){
      conv_num+=pow(2,(point_pos-i))*(value[i]-'0');
    }*/
    if(point_pos == 1){
      for(i=point_pos; i<(frac_part_size+1); i++){

	conv_num += pow(2,-i)*(value[i]-'0');
      }
    }
    else if(point_pos == 2){
          
      conv_num+=(value[1]-'0');
      for(i=point_pos; i<16; i++){

	conv_num += pow(2,-i+1)*(value[i]-'0');
      }
    }
    else{
          for(i=1; i<point_pos; i++){
      conv_num+=pow(2,(point_pos-i-1))*(value[i]-'0');
    }
      for(i=point_pos; i<19; i++){

	conv_num += pow(2,-i+3)*(value[i]-'0');
      }
    }

    printf("Converted value = %.10lf\n", conv_num);
  }while(1);

}
