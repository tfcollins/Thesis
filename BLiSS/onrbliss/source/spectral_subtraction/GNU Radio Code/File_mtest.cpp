/* Spectral Subtraction C file*/

#include<iostream>
#include<fstream>
//#include <math.h>
#include <complex.h>

using namespace std;

int main()
{   
//    FILE *RecSig = fopen("RecSig_data.txt", "r");
//    FILE *IntSig = fopen("IntSig_data.txt", "r");
//    FILE *Phase = fopen("Phase_data.txt", "r");
	long size=1e5;
    int i;
    complex<float> num_i;
    
//	fseek (RecSig, 0, SEEK_END);
//	size = ftell (RecSig);
//	rewind (RecSig);
	
	float RecSig_t[size], IntSig_t[size], PhaseInf[size];
	complex<float> ReturnSig[size];
	
	fstream RecSig("RecSig_data.txt");
	fstream IntSig("IntSig_data.txt");
	fstream Phase("Phase_data.txt");
	
	
	num_i = sqrt( complex<float>(-1) );
	
	for(i=0;i<size;i++)
	{
//		RecSig_t[i]=float(RecSig[i]);
//		IntSig_t[i]=IntSig[i];
//		PhaseInf[i]=Phase[i];
		RecSig >> RecSig_t[i];
		IntSig >> IntSig_t[i];
		Phase >> PhaseInf[i];
		RecSig_t[i]=abs(RecSig_t[i]-IntSig_t[i]);
		
		//perform complex opperations
		ReturnSig[i] = complex<float>(RecSig_t[i]*exp(num_i*PhaseInf[i]));
		RecSig_t[i] = real(ReturnSig[i]);
		cout << RecSig_t[i] << endl;
//		cout << i << endl;
//		if (RecSig_t[i] !> 1e5)
//		   RecSig_t[i]=0;
	}
//	fclose(RecSig);
//	fclose(IntSig);
//	fclose(Phase);
while(1);
//return 1;
}
