#ifndef INCLUDE_SPECTRAL_SUB_H
#define INCLUDE_SPECTRAL_SUB_H
#include<iostream>

//#include ADD AN FFT FUNCTION FROM gnu RADIO OR SOME PLACE

class spectral_sub
{
    private :
        double Alpha, Beta, RecSig[2], InterSig[2];
        COMPLEX_DATA Phase[2];
        int size;
    public :
        *double signal_removal(*double, *double, *COMPLEX_DATA, int)
        //*double find_abs(*double)
        (COMPLEX? RETURN THE PHASE) find_phase(COMPLEX? RETURN THE PHASE, *double, int)
};

*double spectral_sub::signal_removal(*double RecSig, *double InterSig, *COMPLEX_DATA int size)
{
    double RecSig_abs[size], InterSig_abs[size];
    COMPLEX_DATA RecSig_freq[2], InterSig_freq[2] //??? This will depend on what fft is used???
    
    //perform fft on each signal
    
    for (i=0;i<size;i++)
    {
        RecSig_abs(i) = abs(RecSig_freq[i][0]+RecSig_freq[i][1]);
        InterSig_abs(i) = abs(InterSig_freq[i][0]+InterSig_freq[i][1]);
        
        RecSig_abs(i) = RecSig_abs(i)-Alpha*InterSig_abs(i);
        if RecSig_abs(i) < 0
            RecSig_abs(i) = 0;
        if RecSig_abs(i) < Beta*InterSig_abs(i)
            RecSig_abs(i) = Beta*InterSig_abs(i);
    }
    
    COMPLEX_DATA *RecSig_freq = find_phase(RecSig_freq, RecSig_abs, size)
                 
    // perform ifft on RecSig_freq
    
    return RecSig;
}

COMPLEX_DATA spectral_sub::find_phase(*COMPLEX_DATA freq_response, *double abs_fftMag, int size)
{
    COMPLEX_DATA phase[size];
    
    for (i-1:size)
    {
        phase(i) = atan2(freq_response[i][0], freq_response[i][1])
        freq_response(i) = abs_fftMag(i)*exp(j*phase(i)) 
    }
    //Shit this won't work I need to find something that will combine unreal info using materecies
    //because this will only make them and not sepperate them back into real and unreal
}


        
