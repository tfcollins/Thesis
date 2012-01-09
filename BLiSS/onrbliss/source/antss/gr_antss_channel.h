#ifndef INCLUDE_GR_ANTSS_CHANNEL_H
#define INCLUDE_GR_ANTSS_CHANNEL_H
#include <iostream>
	

class gr_antss_channel;

class gr_antss;

	struct charac{
		float snr;
		float ber;
		float est;
	};

class gr_antss_channel
{
	private : 
		float snr, ber, est, weight; //est set invalid, all others to 0
		float w_snr, w_ber, w_est;//seperate weights for snr, ber, est
		char antenna; //path number set at init
		int rx_path, num_rx, num_ant;
		void set_weight(void);
	public :
		void set_path_num (int, int, int, int, float, float, float);
		gr_antss_channel (int);
		gr_antss_channel ();
		~gr_antss_channel ();
		void set_charac (float, float, float);
		float get_weight (void);
		int get_rx (void);
		void set(charac *chan_charac);
		char get_ant(void);
		void void_chan(void);
};


//gr_antss_channel constructor takes input of channel path number
gr_antss_channel::gr_antss_channel(int p_num) 
{
	set_path_num(p_num, 0,0 ,0,0,0,0); //set path_num at declaration
	//set characteristics to inital values, est invalid to force cycle
	set_charac(0,0,-1);
	
	//Set all characteristic weights equal, updated when path set
	w_snr=1;
	w_ber=1;
	w_est=1;
	
	
}

//gr_antss_channel constructor no input
gr_antss_channel::gr_antss_channel() 
{
	set_path_num(-1, 1,0 ,0,0,0,0); //set path_num at declaration
	//set characteristics to inital values, est invalid to force cycle
	set_charac(0,0,-1);
	weight=0;
	
	//Set all characteristic weights equal, future versions take as input
	w_snr=1;
	w_ber=1;
	w_est=1;
	
}



//gr_antss_channel destructor
gr_antss_channel::~gr_antss_channel ()
{
}


//define all channel characteristics
void gr_antss_channel::set_charac (float s, float b, float e)
{
	snr = s;
	ber = b;
	est = e;
}

//set path number. Used in constructor only
void gr_antss_channel::set_path_num (int ant, int rx, int rx_num, int ant_num, float snr, float ber, float est)
{
	w_snr=snr;
	w_ber=ber;
	w_est=est;
	num_rx = rx_num;
	num_ant= ant_num;
	antenna = ant+65;
	rx_path=rx;
}


//function get_weight calculates and returns the weighted average of
//channel characteristics. Future versions will allow for more complex
//methods of calculating this value.

void gr_antss_channel::set_weight ()
{
	//Check to see if characteristics have been defined
	if (est < 0)
	{
		return; //force cycle if characteristics undefined
	}
	else
	{
		/* Old code for actual values of charactersitics
		 * 
		 * 
		float inv_ber = 1-ber; //need larger ber = better
		//convert all inputs to percentage, take an even average
		//and output as a value from 0-100
		weight = (w_ber*inv_ber + w_snr*snr/50 + w_est*est/100)/.03;
		* 
		* 
		* */
		//weighted average of all characteristics, range between 0 and 1
		weight=100*(w_ber*ber+w_snr*snr+w_est*est)/(w_ber+w_snr+w_est);
	}				  
}

//get_path_num() returns the path number for a channel object. This may 
//be unnecessary, depending on the usage of the channel object
int gr_antss_channel::get_rx ()
{
	return rx_path;
}


char gr_antss_channel::get_ant ()
{
	return antenna;
}
//Call function to cycle to a given path number
void gr_antss_channel::set(charac *chan_charac)
{
	charac values[num_rx];

	values[rx_path] = *(chan_charac+rx_path);
	snr=values[rx_path].snr;
	ber=values[rx_path].ber;
	est=values[rx_path].est;

	set_weight();
}

float gr_antss_channel::get_weight()
{
	return weight;
}

void gr_antss_channel::void_chan()
{
	set_charac(0,0,-1);
	weight = 0;
}
#endif
