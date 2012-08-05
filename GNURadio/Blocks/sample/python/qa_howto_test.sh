#!/bin/sh
export GR_DONT_LOAD_PREFS=1
export srcdir=/home/traviscollins/git/gnuradio/gr-howto-write-a-block/python
export PATH=/home/traviscollins/git/gnuradio/gr-howto-write-a-block/python:$PATH
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$DYLD_LIBRARY_PATH
export DYLD_LIBRARY_PATH=$LD_LIBRARY_PATH:$DYLD_LIBRARY_PATH
export PYTHONPATH=/home/traviscollins/git/gnuradio/gr-howto-write-a-block/swig:$PYTHONPATH
/usr/bin/python /home/traviscollins/git/gnuradio/gr-howto-write-a-block/python/qa_howto.py 
