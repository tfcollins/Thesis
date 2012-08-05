#!/bin/sh
export GR_DONT_LOAD_PREFS=1
export srcdir=/home/traviscollins/git/gnuradio/gr-howto-write-a-block/temp/gr-howto/python
export PATH=/home/traviscollins/git/gnuradio/gr-howto-write-a-block/temp/gr-howto/build/python:$PATH
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$DYLD_LIBRARY_PATH
export DYLD_LIBRARY_PATH=$LD_LIBRARY_PATH:$DYLD_LIBRARY_PATH
export PYTHONPATH=/home/traviscollins/git/gnuradio/gr-howto-write-a-block/temp/gr-howto/build/swig:$PYTHONPATH
/usr/bin/python /home/traviscollins/git/gnuradio/gr-howto-write-a-block/temp/gr-howto/python/qa_howto.py 
