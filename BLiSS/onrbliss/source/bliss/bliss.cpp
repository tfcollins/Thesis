/* BLISS channel estimation code
   USNA/WPI BLISS project
   July 2011
   Ryan Dobbins
*/

#include<iostream>
#include<fstream>
#include<complex>
#include"armadillo"

using namespace std;
using namespace arma;

int L,N,S,M,P,Q,i,j;
float SNR,pow_c;

int main(){

	// load data text file, import variables
	fstream sig("data.txt");
	sig >> L;
	sig >> N;
	sig >> pow_c;
	sig >> SNR;

	// set other parameters
	M=L+N;
	P=L;
	Q=N/P;

	vec dataReal(N);
	vec dataImag(N);
	cx_vec data(N);
	mat dftNReal(N,N);
	mat dftNImag(N,N);
	cx_mat dftN(N,N);
	mat dftPReal(P,P);
	mat dftPImag(P,P);
	cx_mat dftP(P,P);
	rowvec hReal(L);
	rowvec hImag(L);
	cx_rowvec h;

	// import real part of data
	for(i=0;i<N;i++){
		sig >> dataReal(i);
	}
	// import imaginary part of data
	for(i=0;i<N;i++){
		sig >> dataImag(i);
	}
	// construct data vector
	data=cx_vec(dataReal,dataImag);

	// load dft matrix text file
	fstream dftmtx("dftmtx.txt");
	// import real part of NxN dft matrix
	for(i=0;i<N;i++){
		for(j=0;j<N;j++){
			dftmtx >> dftNReal(i,j);
		}
	}
	// import imaginary part of NxN dft matrix
	for(i=0;i<N;i++){
		for(j=0;j<N;j++){
			dftmtx >> dftNImag(i,j);
		}
	}
	// construct NxN dft matrix
	dftN=cx_mat(dftNReal,dftNImag);
	// import real part of PxP dft matrix
	for(i=0;i<P;i++){
		for(j=0;j<P;j++){
			dftmtx >> dftPReal(i,j);
		}
	}
	// import imaginary part of PxP dft matrix
	for(i=0;i<P;i++){
		for(j=0;j<P;j++){
			dftmtx >> dftPImag(i,j);
		}
	}
	// construct PxP dft matrix
	dftP=cx_mat(dftPReal,dftPImag);

	// load channel text file
	fstream chan("channel.txt");
	// import real part of channel
	for(i=0;i<L;i++){
		chan >> hReal(i);
	}
	// import imaginary part of channel
	for(i=0;i<L;i++){
		chan >> hImag(i);
	}
	// construct channel
	h=cx_rowvec(hReal,hImag);

/////////////////////////////////////////
// data is now loaded
// implement channel estimation algorithm

	cx_vec c_P(L);
	cx_vec c;
	cx_mat F(N,N);
	cx_vec x_hat;
	cx_vec c_hat;
	cx_mat F_P(P,P);
	cx_vec d(L);
	cx_vec h_hat;
	cx_rowvec err_h;
	vec err_h_sq;

	// construct training vector
	int k=P;
	for(i=0;i<P;i++){
		c_P(i)=complex<float>(((i+1)/(float)P),-(k/(float)P));
		k--;
	}
	c=kron(ones<vec>(Q),c_P);
	c=c/(ones<vec>(N)*(sqrt(trans(c)*c)));

	// NxN DFT matrix
	F=(1/sqrt(N))*dftN;

	// frequency signal and training vectors
	x_hat=F*data;
	c_hat=F*sqrt(pow_c*SNR)*c;

	// PxP DFT matrix
	F_P=dftP/P;

	// dividing out training from signal to get data
	int x=0;
	for(i=0;i<L;i++){
		d(i)=x_hat(x)/c_hat(x);
		x+=Q;
	}

	// channel estimate
	h_hat=trans(F_P)*d;

	// calculate sqaured error
	err_h=h-strans(h_hat);
	err_h_sq=real(err_h*trans(err_h));

	// write estimate and squared error to text file
	ofstream file("chanest.txt");
	file << real(h_hat) << imag(h_hat) << err_h_sq;

}

