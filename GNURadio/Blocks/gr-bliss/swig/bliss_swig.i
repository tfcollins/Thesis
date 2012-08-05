/* -*- c++ -*- */

#define BLISS_API

%include "gnuradio.i"			// the common stuff

//load generated python docstrings
%include "bliss_swig_doc.i"


%{
#include "bliss_bliss_ff.h"
%}


GR_SWIG_BLOCK_MAGIC(bliss,bliss_ff);
%include "bliss_bliss_ff.h"
