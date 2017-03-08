#include <stdio.h>
#include <math.h>
int main() {
	double angle[16] = { 45, 26.5650, 14.0362, 7.1250, 3.5763, 1.7899, 0.8952, 0.4476, 0.2238, 0.1119, 0.05595, 0.02797, 0.01399, 0.0069941, 0.003497, 0.0017485  };
	double x[20], y[20];
	double angle_input[20];
	angle_input[0] = 25;  /*random angle example*/
	double k = 0.9219;
	x[0]= k;
	y[0]= 0;
	int sign , i= 0;
	int temp;
		printf("\n test 1 %f",fabs(angle_input[i-1]) );
	
	while ((fabs(angle_input[i]) > 0.00002) && (i < 16)){
		if(angle_input[i] < 0) sign = -1; else sign = 1;
		angle_input[i+1] = angle_input[i] - 2*sign*angle[i+2];
        printf("\n angle_input mot %f",angle[i+2] );
		
		x[i+1] = x[i] -  sign*pow(2.0, -i-1)*y[i] - pow(2.0, -2*i-2-2)*x[i];
		y[i+1] = y[i] + sign*pow(2.0, -i-1)*x[i] - pow(2.0, -2*i-2-2)*y[i] ;
		
		i++;
		printf("\n angle_input %f",angle_input[i] );
		printf("\n x[%d] %f", i, x[i] );
		printf("\n y[%d] %f", i, y[i] );
	}
	printf("\n %5.d , %10.7f , %10.7f ",i, x[i], y[i]);
	
	return 0;
}
