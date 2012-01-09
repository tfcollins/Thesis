#ifndef INCLUDE_GR_ANTSS_H
#define INCLUDE_GR_ANTSS_H


#include "gr_antss_channel.h"
#include "math.h" //only needed for demo();
#include <cstdlib>//only needed for demo();

	
class gr_antss
{
	private:
		int num_ant, num_rx, num_chan, path_index;
		charac *characteristics; //pointer to array of characteristics. An array of structs
		float w_est, w_ber, w_snr;//characteristic weights

		void find_max(gr_antss_channel *, int, int, int);
		void set_antss(gr_antss_channel*, int);
		void set_chan(char ant, int num_rx);
		
		gr_antss_channel *order_ptr;
		gr_antss_channel *list_ptr;
	
	public:
		gr_antss(int, int, float, float, float, charac *);//take inputs of # of antennas, rx, and pointer to characteristics
		void work(void);
		void demo(void);
		~gr_antss();
		
						
};
//Constructor for gr_antss
gr_antss::gr_antss(int ant, int rx,float snr, float ber, float est, charac *chan_charac)
{
	w_snr=snr;
	w_ber=ber;
	w_est=est;//Fading channel estimate
	num_ant = ant;
	num_rx = rx;
	num_chan = num_ant*num_rx;
	path_index=0;
	characteristics = chan_charac;
}

gr_antss::~gr_antss()
{

}


/*********************************************************************
 * function find_max sets order_ptr to an ordered array of the top 
 * performing viable channels. This array can be used to set the antss
 * board, and contains no conflicting antenna/rx pairs
 * ******************************************************************/
void gr_antss::find_max(gr_antss_channel list[], int num_chan, int num_ant, int num_rx)
{
	gr_antss_channel working[num_chan];//use to store sorted conflicting list
	gr_antss_channel ordered[num_rx];//use to store top list without conflicts

	/*******************************************************************
	 * Develop the array "working" as a list of channels sorted by weight
	 *This list will then have channels pulled in order to send to antss
	 * with invalid channels removed after each selection 
	 * ************************************************************** */
	for(int n = 0; n <num_chan; n++)
	{
		int max_value =0;
		int max_index =0;
		for(int i=0; i <num_chan; i++) //step through entire array list
		{							
			if(list[i].get_weight() > max_value)
			{
				max_value=list[i].get_weight();
				max_index = i;
			}
		}
		working[n]=list[max_index]; //next chan in working = max from list
		list[max_index].void_chan(); //remove highest weighted chan from
	}								 // list
	
	ordered[0]=working[0]; //First value has no conflicts, set to ordered
		
	for(int iter=1;iter<num_rx;iter++){  
		for(int n=0; n<num_chan; n++){//go through all the channels
			for(int i=0; i<iter;i++){//go through all previous channels
				if(ordered[i].get_ant() == working[n].get_ant() || ordered[i].get_rx() == working[n].get_rx())
					working[n].void_chan();
			}
			for(int x =0; x<num_chan; x++){//after voiding channels
				if(working[x].get_weight() !=0)//find next maximum chan
				{
					ordered[iter]=working[x];
					x=num_chan;
				}
			}
		}
	}

	order_ptr = ordered;
}

/*********************************************************************
 * set_antss should be modified as appropriate to pass values to the 
 * AntSS board. Current version prints the string sent to the board
 * as the code to control the board was not available.
 * *******************************************************************/
void gr_antss::set_antss(gr_antss_channel best[], int num_rx)
{
	//Dummy code, real will send the string to python instead of printing it
	std::cout<<"Sending to AntSS Board\n SSM ";
	for(int i=0;i<num_rx;i++)
	{
		std::cout<<best[i].get_ant()<<best[i].get_rx();
	}
	std::cout<<"\n";
}

/*********************************************************************
 * set_chan should set a single rx channel on the antss board. This will
 * allow for a single channels characteristics to be determined. This
 * will likely need to be modified in order to work with the AntSS 
 * control code
 * ******************************************************************/
void gr_antss::set_chan(char ant, int num_rx)
{
	//Dummy code, real will send the string to python instead of printing it
	std::cout<<"Sending to AntSS Board for channel: "<<ant<<num_rx;
	std::cout<<"\n SSM "<<ant<<num_rx<<"\n";
	
}

/**********************************************************************
 * work() sets all the path numbers, gets all values, calls functions
 * to order the antenna/rx options, and sets the AntSS board as
 * appropriate.
 * ********************************************************************/
void gr_antss::work()
{
	gr_antss_channel list[num_chan]; //create array of channels
	gr_antss_channel ordered[num_rx];//[num_outputs]; //ordered output channels


	int n =0;
	for(int rx =0; rx<num_rx; rx++)
	{
		for(int ant=0; ant<num_ant;ant++) //set all path numbers
		{
			list[n].set_path_num(ant, rx, num_rx, num_ant, w_snr, w_ber, w_est);
			list[n].set(characteristics);
			set_chan(list[n].get_ant(),list[n].get_rx());
			n++;
		}
	}
	
	//For Demo and debugging, prints all of the channel paths
	for(int i=0; i<num_chan;i++)
	{
		std::cout<<"\n"<<list[i].get_ant()<<" "<<list[i].get_rx()<<" "<< list[i].get_weight();
	}
	std::cout<<"\n";
	find_max(list, num_chan, num_ant, num_rx);
	
	for(int i=0; i<num_rx;i++)
		ordered[i]= *(order_ptr+i);
		
	
	set_antss(ordered,num_rx);

}

/***********************************************************************
 * demo() is the same as work() except that it assigns random channel
 * characteristics within the class gr_antss to simulate the values
 * changing during runtime as would happen from the bliss block
 * ********************************************************************/

void gr_antss::demo()
{
	
	charac c_char[num_rx];
	charac *cptr = c_char;
	
	gr_antss_channel list[num_chan]; //create array of channels
	gr_antss_channel ordered[num_rx];//[num_outputs]; //ordered output channels


	int n =0;
	for(int rx =0; rx<num_rx; rx++)
	{
		for(int ant=0; ant<num_ant;ant++) //set all path numbers
		{
			list[n].set_path_num(ant, rx, num_rx, num_ant,w_snr,w_ber,w_est);
			for(int nt=0; nt<num_rx; nt++)
			{
				c_char[nt].snr = float(rand()%10000)/10000;
				c_char[nt].ber = float(rand()%10000)/10000;			
				c_char[nt].est = float(rand()%10000)/10000;
			}
			list[n].set(cptr);
			set_chan(list[n].get_ant(),list[n].get_rx());
			n++;
		}
	}

	for(int i=0; i<num_chan;i++)
	{
		std::cout<<"\n"<<list[i].get_ant()<<" "<<list[i].get_rx()<<" "<< list[i].get_weight();
	}
	
	std::cout<<"\n";
	find_max(list, num_chan, num_ant, num_rx);
	
	for(int i=0; i<num_rx;i++)
		ordered[i]= *(order_ptr+i);
		
	
	set_antss(ordered,num_rx);
}
#endif
					
						
