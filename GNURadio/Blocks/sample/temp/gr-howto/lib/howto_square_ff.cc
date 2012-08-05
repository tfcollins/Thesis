/* -*- c++ -*- */
/* 
 * Copyright 2012 <+YOU OR YOUR COMPANY+>.
 * 
 * This is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3, or (at your option)
 * any later version.
 * 
 * This software is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this software; see the file COPYING.  If not, write to
 * the Free Software Foundation, Inc., 51 Franklin Street,
 * Boston, MA 02110-1301, USA.
 */

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include <gr_io_signature.h>
#include <howto_square_ff.h>


howto_square_ff_sptr
howto_make_square_ff ()
{
	return howto_square_ff_sptr (new howto_square_ff ());
}

static const int MIN_IN = 1;        // mininum number of input streams
static const int MAX_IN = 1;        // maximum number of input streams
static const int MIN_OUT = 1;        // minimum number of output streams
static const int MAX_OUT = 1;        // maximum number of output streams

//Private Constructor, basically determines what inputs and outputs we have and how many
howto_square_ff::howto_square_ff ()
	: gr_block ("square_ff",
		gr_make_io_signature (MIN_IN, MAX_IN, sizeof (float)),
		gr_make_io_signature (MIN_IN, MAX_IN, sizeof (float)))
{
	//Nothing else needed
}


//Virutal Destructor
howto_square_ff::~howto_square_ff ()
{
	//Nothing Else needed
}


int
howto_square_ff::general_work (int noutput_items,
			       gr_vector_int &ninput_items,
			       gr_vector_const_void_star &input_items,
			       gr_vector_void_star &output_items)
{
  const float *in = (const float *) input_items[0];
  float *out = (float *) output_items[0];

  //Actually do something
  for(int i=0;i<noutput_items;i++){
		out[i]=in[i]*in[i];

 	}


  // Tell runtime system how many input items we consumed on
  // each input stream.
  consume_each (noutput_items);

  // Tell runtime system how many output items we produced.
  return noutput_items;
}

