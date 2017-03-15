#include <stdio.h>
#include <math.h>

double double_to_binary(double f);
int main() {
	double angle[16];
	for(int j = 0; j < 16; j++ ){
		angle[j] = atan(pow(2, -j));
	}
	double x[16], y[16];
	double angle_input[20];
	double k =  0.9219;
	x[0]= k;
	y[0]= 0;
	int sign = 1, i= 0;
	int temp;
	printf("\n Input angle [0;pi/4] : ");
	
	
	
	scanf("%lf", &angle_input[0]);
		printf("\n Angle: %f \n",fabs(angle_input[0]) );
		printf("\n Input angle [0;pi/4] in binary: ");
		double binary = double_to_binary(angle_input[0]);
		printf("\n");
	printf("Loop |   X[i] binary      |     Y[i]  binary   | Erreur angle binary|   X[i]   |   Y[i]    |Erreur angle|\n");
	printf("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n");		
	while ( i < 16){
		if(angle_input[i] < 0) sign = -1; else sign = 1;
		angle_input[i+1] = angle_input[i] - 2*sign*angle[i+2];
		x[i+1] = x[i] -  sign*pow(2.0, -i-1)*y[i] - pow(2.0, -2*i-2-2)*x[i];
		y[i+1] = y[i] + sign*pow(2.0, -i-1)*x[i] - pow(2.0, -2*i-2-2)*y[i] ;
		i++;
		
		printf("%3d  |" , i);
		double_to_binary(x[i]);
		double_to_binary(y[i]);
		double_to_binary(angle_input[i]);
		if(angle_input[i] > 0){
			printf(" %5.6f |  %5.6f | +%5.6f  |", x[i],  y[i], angle_input[i] );
		}else{
			printf(" %5.6f |  %5.6f | %5.6f  |", x[i],  y[i], angle_input[i] );
		}
		
		printf("\n");
	}
	printf("\n valeur cos:  %.7f \n", x[i]);
	printf("\n valeur sin:  %.7f \n", y[i]);
	
	return 0;
}

double double_to_binary(double f){
	int  integral, binaryInt = 0, i = 1;
    double binaryFract = 0, k =0.1, fractional, temp1, binaryTotal;
	int sign = 0;
	if (f < 0){
	f = f*(-1);
	sign = 1;
	}
	
	integral = floor(f); 
    fractional = f - floor(f);

    while(integral>0)
    {
        binaryInt = binaryInt + integral % 2 * i;
        i = i * 10;
        integral = integral / 2;
    }

    while(k> pow(10, -15))
    {
        temp1 = fractional *2;
        binaryFract = binaryFract+((int)temp1)*k;
        fractional = temp1 - (int)temp1;
        k = k / 10;
    }

    binaryTotal = binaryInt +binaryFract;
    if (sign == 0){
    	printf("0%5.15f   |", binaryTotal);
	}else {
		printf("1%5.15f   |", binaryTotal);
	}
}
