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
	cx_vec r1(N);
	cx_vec r2(N);

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



	int n=3;
	int delta=0;//delay
	int p=N-delta;

	int index=0;
	int i;
	for (i=n+1;i<p;i++){
		r1(index)=data(i);	
		index++;
	}
	cout<<"Reached"<<endl;
	index=0;
	int j;
	for (j=n+1;j>-1;j--){
		r2(index)=data(j);	
		index++;
	}
	cout<<"Reached"<<endl;
	cout<<r1<<endl;
	cout<<r2<<endl;

	mat X = toeplitz(real(r1),real(r2));
	mat Y = toeplitz(imag(r1),imag(r2));
//	mat Y = toeplitz(dataReal,dataImag);
	cx_mat Z(N,N);
	Z=cx_mat(X,Y);
	
	//TRAINING VECTOR
        fstream sig("training.txt");
        vec dataReal_t(N);
        vec dataImag_t(N);
        cx_vec data_t(N);
        cx_vec S(N);

        // import real part of data
        int h;
        for(h=0;h<N;h++){
                sig >> dataReal_t(h);
        }
        // import imaginary part of data
        for(h=0;h<N;h++){
                sig >> dataImag_t(h);
        }
        data_t=cx_vec(dataReal_t,dataImag_t);
        // construct training vector
	int u=0;
	for (u=n+1;u<p-n+1;u++){
		S(index)=data_t(u);
		index++;
	}
	S=S.t;

	//Channel Estimate
	cx_vec F=inv(Z.t*Z)*Z.t*S;
	cout<<F<<endl;

	//mat Y = circ_toeplitz(A);
//	cout<<X<<endl;
	cout<<X<<endl;
	cout<<Y<<endl;
	cout<<Z<<endl;

	return 0;
}
