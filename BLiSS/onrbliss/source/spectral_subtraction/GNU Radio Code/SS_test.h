/* Spectral Subtraction C file*/

#include<iostream>
//#include"armadillo"
#include <math.h>
#include"fftw.h"

/*cx_mat recSig;          //The recieved signal
cx_mat interfSig;*/       //The interfering signal
int main()
{

    N = 1000; //size of signals I HAVE NO IDEAE WHAT TO USE AS A SIZE?
    double Alpha=10, Beta=.2;
    
    double recReal[N];
    double interReal[N];
    
    //The recieved and interfering signals are defined with an imaginary component
    fftw_complex recSigIN[N], recSigOUT[N], interSigIN[N], interSigOUT[N];
    fftw_plan FTransPlan_recSig;
    fftw_plan FTransPlan_interSig;     //The FTransPlans are the plans for the fourire 
    //transform of the recieved and interfering signal
    
    //Not sure if this will work//int fftw_fft_unwrap_phase( int N, double *recSigIN[N], int nAngleUnit = ANGLE_RAD)
    
    //Both plans are the same length, are coputed forward rathe than backwards and
    //the fft is computed numerous times to create a more specialized fft for the
    //signal size
    FTransPlan_recSig = fftw_create_plan(N, FFTW_FORWARD, FFTW_MEASURE);
    FTransPlan_interSig = fftw_create_plan(N, FFTW_FORWARD, FFTW_MEASURE);
    
    void fftw_one(fftw_plan FTransPlan_recSig, fftw_complex *recSigIN, fftw_complex *recSigOUT);
    void fftw_one(fftw_plan FTransPlan_interSig, fftw_complex *interSigIN, fftw_complex *interSigOUT);

    recReal = abs(recSigIN);
    interReal = abs(interSigIN);
    
    for (i = 0:lenght(recReal))
    {
        recReal(i) = recReal(i)-inerReal(i);
        if (recReal(i)<0)
           recReal(i)-0;
        if (recReal(i)<Beta*interReal(i))
           recReal(i)=Beta*interReal(i);
    }
    
    
