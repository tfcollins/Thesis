Robet Over
7/20/11
Professor Wyglinski
Professor Anderson
USNA BliSS

Spectral Subtraction READ ME

This document provides information for the spectral subtraction programs designed for the BliSS project. It specifies the inputs outputs and workings of the C++ file Spectral_Subtraction. This file is designed to be a model of spectral subtraction methods providing an idea of how spectral subtraction should be implemented when it is performed in real time using GNU Radio. 

The Spectral Subtraction code takes in three files each one containing data for the signals used in the subtraction. These files contain data made using the MATLAB file DataGen2 and transferred into text files in order to be used in C++. The file SigData.txt contains the time domain information for the simulated received data signal, the time domain data for the interfering signal and the Phase information for the desired signal. Each of these pieces of information is stored as floating point number. This means that a certain amount of precision is allowed for each variable. 

The file FFT_file.txt contains the data for the two matrices that are used as the conversion into and out of frequency domain. As it is not easy to transfer unreal data from MATLAB into C++ the signals are split up into their real and imaginary parts. This means that the signal contains first the real parts of the n by n fft matrix and then the unreal parts of the matrix followed by the real and then unreal components of the ifft matrix. To facilitate the use of unreal numbers the C++ library complex.h was used to turn the two components of the FFT matrices back into complex numbers. 
	 
Rather than adding a library to perform matrix functions the information is placed into vectors and matrices piece by piece. The multiplication and other functions are then also performed piece by piece. The Spectral Subtraction is described through the comments in the code and further information is provided in the file Spectral_Subtraction_Description.  
	
Finally when the subtraction has taken place the signal is then output into the command prompt. An estimation of the Bit Error Rate is also printed out in order to give an idea of the accuracy of the spectral subtraction. This information can easily be read into an M file and then sent back to MATLAB for graphical evaluation. 
	
Though the Spectral Subtraction algorithm is simple it should be able to perform the necessary removal of a known interfering signal. When this code is ported into GNU Radio I would suggest the use of one of the built in FFTs. These functions will be faster and in some cases more accurate than the FFT matrix made in MATLAB.
