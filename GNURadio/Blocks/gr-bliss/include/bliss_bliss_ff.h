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

#ifndef INCLUDED_BLISS_BLISS_FF_H
#define INCLUDED_BLISS_BLISS_FF_H

#include <bliss_api.h>
#include <gr_block.h>

class bliss_bliss_ff;
typedef boost::shared_ptr<bliss_bliss_ff> bliss_bliss_ff_sptr;

BLISS_API bliss_bliss_ff_sptr bliss_make_bliss_ff ();

/*!
 * \brief <+description+>
 *
 */
class BLISS_API bliss_bliss_ff : public gr_block
{
	friend BLISS_API bliss_bliss_ff_sptr bliss_make_bliss_ff ();

	bliss_bliss_ff ();

 public:
	~bliss_bliss_ff ();


  int general_work (int noutput_items,
		    gr_vector_int &ninput_items,
		    gr_vector_const_void_star &input_items,
		    gr_vector_void_star &output_items);
};

#endif /* INCLUDED_BLISS_BLISS_FF_H */

