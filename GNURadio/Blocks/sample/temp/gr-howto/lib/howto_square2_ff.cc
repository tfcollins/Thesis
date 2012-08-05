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
#include <howto_square2_ff.h>


howto_square2_ff_sptr
howto_make_square2_ff ()
{
	return howto_square2_ff_sptr (new howto_square2_ff ());
}

static const int MIN_IN = 1;        // mininum number of input streams
static const int MAX_IN = 1;        // maximum number of input streams
static const int MIN_OUT = 1;        // minimum number of output streams
static const int MAX_OUT = 1;        // maximum number of output streams

howto_square2_ff::howto_square2_ff ()
	: gr_sync_block ("square2_ff",
		gr_make_io_signature (MIN_IN, MAX_IN, sizeof (float)),
		gr_make_io_signature (MIN_IN, MAX_IN, sizeof (float)))
{
}


howto_square2_ff::~howto_square2_ff ()
{
}


int
howto_square2_ff::work (int noutput_items,
			gr_vector_const_void_star &input_items,
			gr_vector_void_star &output_items)
{
	const float *in = (const float *) input_items[0];
	float *out = (float *) output_items[0];

	// Do <+signal processing+>

	// Tell runtime system how many output items we produced.
	return noutput_items;
}

