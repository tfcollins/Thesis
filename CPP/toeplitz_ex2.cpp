#include <armadillo>
#include <iostream>

using namespace std;
using namespace arma;

int main(){

	int N=5;
	fstream sig("data.txt");
	vec dataReal(N);
	vec dataImag(N);
	cx_vec data(N);
	//cx_vec r1(N);
	//cx_vec r2(N);


	// import real part of data
	int h;
	for(h=0;h<N;h++){
		sig >> dataReal(h);
	}
	// import imaginary part of data
	for(h=0;h<N;h++){
		sig >> dataImag(h);
	}
	// construct data vector
	data=cx_vec(dataReal,dataImag);


	int n=2; //Number of equalizer taps
	int delta=0;//delay
	int p=N-delta;
	int index=0;
	int i;

	cx_vec r1(p-n);
	for (i=n;i<p;i++){
		r1(index)=data(i);	
		index++;
	}

	index=0;//reset
	int j;
	cx_vec r2(n+1);
	for (j=n;j>-1;j--){
		r2(index)=data(j);	
		index++;
	}

	mat X = toeplitz(real(r1),real(r2));
	mat Y = toeplitz(imag(r1),imag(r2));
	cx_mat R(N,N);
	R=cx_mat(X,Y); //Received vector 
	
	/////////////TRAINING VECTOR/////////////
        fstream sig2("training.txt");
        vec dataReal_t(N);
        vec dataImag_t(N);
        cx_vec data_t(N);

        // import real part of data
        //int h;
        for(h=0;h<N;h++){
                sig2 >> dataReal_t(h);
        }
        // import imaginary part of data
        for(h=0;h<N;h++){
                sig2 >> dataImag_t(h);
        }
        data_t=cx_vec(dataReal_t,dataImag_t);
	cout<<"Data_t: "<<data_t<<endl;
        // construct training vector
	int u=0;
	index=0;
        cx_vec S(p-n);//p=N
	for (u=n;u<p-n+1;u++){
		S(index)=data_t(u);
		index++;
	}
	//S=S.t();//transpose
	//Channel Estimate
	cout<<"R: "<<R<<endl;
	cout<<"S: "<<S<<endl;
	cx_vec F=inv(R.t()*R)*R.t()*S;
	cout<<"Channel Estimate: "<<F<<endl;

	//mat Y = circ_toeplitz(A);

	return 0;
}
