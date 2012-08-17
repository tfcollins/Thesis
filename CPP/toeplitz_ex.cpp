#include <armadillo>
#include <iostream>

using namespace std;
using namespace arma;

int main(){


mat C = randu<mat>(4,5);
mat D = randu<mat>(4,5);
  
cout << C*D.t() << endl;


cout<<"Testing"<<endl;

vec A = randu<vec>(5);
vec B = randu<vec>(5);
vec E = cor(A,B);

cout<<"COR: "<<cor(A,trans(B))<<endl;
cout<<"COR: "<<E.t()<<endl;
cout<<"Corr Size: "<<E.n_rows<<" "<<E.n_cols<<endl;

cout<<"A "<<A<<endl;

mat X = toeplitz(A);
mat Y = circ_toeplitz(A);



mat F = randu<mat>(4,5);
mat G = randu<mat>(4,5);

mat H = cor(F,G);

cout<<H<<endl;

	return 0;
}
