#!/bin/sh
export GR_DONT_LOAD_PREFS=1
export srcdir=/home/traviscollins/git/Thesis/GNURadio/Blocks/gr-bliss/python
export PATH=/home/traviscollins/git/Thesis/GNURadio/Blocks/gr-bliss/build/python:$PATH
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$DYLD_LIBRARY_PATH
export DYLD_LIBRARY_PATH=$LD_LIBRARY_PATH:$DYLD_LIBRARY_PATH
export PYTHONPATH=/home/traviscollins/git/Thesis/GNURadio/Blocks/gr-bliss/build/swig:$PYTHONPATH
/usr/bin/python /home/traviscollins/git/Thesis/GNURadio/Blocks/gr-bliss/python/qa_bliss.py 
