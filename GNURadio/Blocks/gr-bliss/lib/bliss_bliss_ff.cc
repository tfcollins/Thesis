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
#include <bliss_bliss_ff.h>
#include <gr_fft_vcc.h>
#include <iostream>

using namespace std;

bliss_bliss_ff_sptr
bliss_make_bliss_ff ()
{
	return bliss_bliss_ff_sptr (new bliss_bliss_ff ());
}

static const int MIN_IN = 1;
static const int MAX_IN = 1;
static const int MIN_OUT = 1;
static const int MAX_OUT = 1;
static const gr_complex training_vector(2,3);


bliss_bliss_ff::bliss_bliss_ff ()
	: gr_block ("bliss_ff",
		gr_make_io_signature (MIN_IN, MAX_IN, sizeof (gr_complex)),
		gr_make_io_signature (MIN_OUT, MAX_OUT, sizeof (gr_complex)))
{
}


bliss_bliss_ff::~bliss_bliss_ff ()
{
}


int
bliss_bliss_ff::general_work (int noutput_items,
			       gr_vector_int &ninput_items,
			       gr_vector_const_void_star &input_items,
			       gr_vector_void_star &output_items)
{

  gr_complex *in = (gr_complex *) input_items[0];
  gr_complex *out = (gr_complex *) output_items[0];

//  const float *in = (const float *) input_items[0];
//  float *out = (float *) output_items[0];

  int channel_size=8;
  set_history(channel_size);  

  //DO SOMETHING

  //Take FFT of input signal
  int fft_size=512;
  bool forward=1;
  bool shift=0;
  
  //gr_fft_vcc sig_fft;
  //gr_fft_vcc tr_fft;
  gr_fft_vcc(fft_size,forward,in,shift);

  gr_complex *sig_fft = gr_fft_vcc(fft_size,forward,in,shift);
  gr_complex *tr_fft = gr_fft_vcc(fft_size,forward,training_vector,shift);

  //Create Frequency Domain Estimate
  gr_complex d[8]={0, 0, 0, 0, 0, 0, 0, 0};
  for(int i=0;i<channel_size;i++){

	d[i]=sig_fft[i]/tr_fft[i];

  }
  
  //Channel Estimate
  gr_complex channel_estimate = gr_fft_vcc(fft_size, 0, d, shift);

  cout<<"Channel Estimate: ";
  cout<<channel_estimate<<endl;

  out=in;

  // Tell runtime system how many input items we consumed on
  // each input stream.
  consume_each (noutput_items);

  // Tell runtime system how many output items we produced.
  return noutput_items;
}

