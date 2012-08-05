#!/bin/sh
export GR_DONT_LOAD_PREFS=1
export srcdir=/home/traviscollins/git/gnuradio/gr-howto-write-a-block/lib
export PATH=/home/traviscollins/git/gnuradio/gr-howto-write-a-block/build/lib:$PATH
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$DYLD_LIBRARY_PATH
export DYLD_LIBRARY_PATH=$LD_LIBRARY_PATH:$DYLD_LIBRARY_PATH
export PYTHONPATH=$PYTHONPATH
qa_howto_square_ff 
