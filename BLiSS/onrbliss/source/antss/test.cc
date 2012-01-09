#include "gr_antss.h"
#include "math.h"
#include <cstdlib>
#include <ctime>
#include <iostream>
#include <sstream>
using namespace std;
	
const int num_r=2;
charac chan_char[num_r];
charac * char_ptr = chan_char;

void rand_char()
{
	for(int n=0; n<num_r; n++)
	{
		chan_char[n].snr = float(rand()%10000)/10000;
		chan_char[n].ber = float(rand()%10000)/10000;
		chan_char[n].est = float(rand()%10000)/10000;
	}
}

int main()
{
	float w_snr=15;
	float w_ber=20;
	float w_est =3;
	srand (time(NULL)); //initialize random

	gr_antss new_antss(4, num_r, w_snr, w_ber, w_est, char_ptr);
	
	cout<<"Welcome to the AntSS module demonstration!\n";
	cout<<"This section demonstrates the passing of random values from"
		<<" the \"BLISS\" block to the AntSS block\n";
	cout<<"Press enter to continue...";
	cin.get();

	rand_char();
	new_antss.work();
	
	cout<<"Press enter to continue to weigh/selection demo";
	cin.get();
	system("clear"); //This is bad, but its a demo and not important
	
	new_antss.demo();

}
