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

#ifndef INCLUDED_HOWTO_SQUARE2_FF_H
#define INCLUDED_HOWTO_SQUARE2_FF_H

#include <howto_api.h>
#include <gr_sync_block.h>

class howto_square2_ff;
typedef boost::shared_ptr<howto_square2_ff> howto_square2_ff_sptr;

HOWTO_API howto_square2_ff_sptr howto_make_square2_ff ();

/*!
 * \brief <+description+>
 *
 */
class HOWTO_API howto_square2_ff : public gr_sync_block
{
	friend HOWTO_API howto_square2_ff_sptr howto_make_square2_ff ();

	howto_square2_ff ();

 public:
	~howto_square2_ff ();


	int work (int noutput_items,
		gr_vector_const_void_star &input_items,
		gr_vector_void_star &output_items);
};

#endif /* INCLUDED_HOWTO_SQUARE2_FF_H */

