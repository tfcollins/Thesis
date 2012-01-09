/*Spectral Subtraction in C++*/
/*Robert Over*/
/*USNA BliSS internship*/
/*Professor Wyglinski*/
/*Professor Anderson*/

#include <iostream>
#include <fstream>
#include <complex.h>

using namespace std;

int main()
{   
	int size=80;	//size of the recieved signal
    int i1,i2,i;	//itterators
    //Here space is allocated for all the singals and the preperation for the FFT matrix
	float RecSig_t[size], IntSig_t[size], PhaseInf[size], X[size];
	float FFT_real[size][size], FFT_imag[size][size], IFFT_real[size][size], IFFT_imag[size][size];
	//Alpha and Beta are the musical noise variables
	float Alpha = 1, Beta = .2, ErrorRate;
	//The complex.h library is useful in creating matrecies with unreal information
	complex<float> FFTmtx[size][size], IFFTmtx[size][size], RecSig_f[size], IntSig_f[size] ,freq_num;
	//The value i is defined here for use in redefining the phase
	complex<float> imag_i = sqrt( complex<float>(-1) ), ;
	size_t result;
	//These streams load data from the text files in question
	fstream Sig_data("Sig_data.txt");
	fstream FFT_data("FFT_file.txt");
	fstream Desired_sig("DesSig.txt");
	
	//Define data
	//Each singal is read in using the stream that holds its data. If more than one interfering singal was
	//subtracted then this assignment would have to be carried out in a for loop that included the spectral
	//subtraction and assignment of the data
	for(i1=0;i1<size;i1++)
		Sig_data >> RecSig_t[i1];
	for(i1=0;i1<size;i1++)
		Sig_data >> IntSig_t[i1];
	for(i1=0;i1<size;i1++)
		Sig_data >> PhaseInf[i1];
	for(i1=0;i1<size;i1++)
        Desired_sig >> X[i1];

	//In order to create an fft matrix in C++ the real and imaginary information must be defined seperately
	//and then recombined. This is also tru for the ifft.
	for (i1=0;i1<size;i1++)
	{
	 	for (i2=0;i2<size;i2++)
	 		FFT_data >> FFT_real[i1][i2];
	 		
	}
	for (i1=0;i1<size;i1++)
	{
	 	for (i2=0;i2<size;i2++)
	 	{
	 		FFT_data >> FFT_imag[i1][i2];
	 		FFTmtx[i1][i2] = complex<float>(FFT_real[i1][i2], FFT_imag[i1][i2]);
		}
	}
	for (i1=0;i1<size;i1++)
	{
	 	for (i2=0;i2<size;i2++)
	 		FFT_data >> IFFT_real[i1][i2];
	}
	for (i1=0;i1<size;i1++)
	{
	 	for (i2=0;i2<size;i2++)
	 	{
	 		FFT_data >> IFFT_imag[i1][i2];
	 		IFFTmtx[i1][i2] = complex<float>(IFFT_real[i1][i2], IFFT_imag[i1][i2]);
		}
		
	}
	//Convert into frequency domain
	for(i1=0;i1<size;i1++)
	{
		//Here the frequency domain version of the signal is specified for the desierd and interfering signals
		freq_num =0;
		for(i2=0;i2<size;i2++)
			freq_num = (FFTmtx[i1][i2]*RecSig_t[i2]) + freq_num;		
		RecSig_f[i1] = freq_num;
		freq_num =0;
		for(i2=0;i2<size;i2++)
			freq_num = FFTmtx[i1][i2]*IntSig_t[i2]+freq_num;
		IntSig_f[i1] = freq_num;
		
		//Perform Spectral Subtraction & conversion into PSD
		RecSig_f[i1] = (abs(RecSig_f[i1])*abs(RecSig_f[i1]))-(Alpha*abs(IntSig_f[i1])*abs(IntSig_f[i1]));
		//Musical Noise Reduction
		if (real(RecSig_f[i1]) < 0)
		   RecSig_f[i1] = 0;
  		if (real(RecSig_f[i1]) < Beta*real(IntSig_f[i1]))
    	   RecSig_f[i1] = Beta*IntSig_f[i1];
		//Add phase back into signal
		RecSig_f[i1] = complex<float>(sqrt(RecSig_f[i1])*exp(imag_i*PhaseInf[i1]));
	}
	for(i1=0;i1<size;i1++)
	{
		//Convert signal bach into time domain with ifft matrix
		freq_num =0;
		for(i2=0;i2<size;i2++)
			freq_num += IFFTmtx[i1][i2]*RecSig_f[i2];
		IntSig_f[i1] = freq_num; //reusing IntSig[] to store info about the signal
		RecSig_t[i1] = real(IntSig_f[i1]);
		
		//Here the information about the subtraceted and actual singal can be compared
		cout << "Original: " << X[i1] << " Subtracted: " << RecSig_t[i1] << endl;
		ErrorRate += abs(RecSig_t[i1]-X[i1]);
	}
	cout << "Bit Error Rate: " << ErrorRate/size;
	cout << " per " << size << " bits" << endl;
	return 1;
}
