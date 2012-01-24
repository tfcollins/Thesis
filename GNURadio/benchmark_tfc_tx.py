#!/usr/bin/env python
#
# Copyright 2010,2011 Free Software Foundation, Inc.
# 
# This file is part of GNU Radio
# 
# GNU Radio is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3, or (at your option)
# any later version.
# 
# GNU Radio is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with GNU Radio; see the file COPYING.  If not, write to
# the Free Software Foundation, Inc., 51 Franklin Street,
# Boston, MA 02110-1301, USA.
# 

from gnuradio import gr
from gnuradio import eng_notation
from gnuradio.eng_option import eng_option
from optparse import OptionParser

# From gr-digital
from gnuradio import digital

# from current dir
from transmit_path import transmit_path
from uhd_interface import uhd_transmitter

import time, struct, sys

#import os 
#print os.getpid()
#raw_input('Attach and press enter')


class my_top_block(gr.top_block):
    def __init__(self, modulator, options):# Get options from call, modulator and options
        gr.top_block.__init__(self)

        if(options.tx_freq is not None):
            # Work-around to get the modulation's bits_per_symbol
            args = modulator.extract_kwargs_from_options(options)
            symbol_rate = options.bitrate / modulator(**args).bits_per_symbol()

            self.sink = uhd_transmitter(options.args, symbol_rate,
                                        options.samples_per_symbol,
                                        options.tx_freq, options.tx_gain,
                                        options.spec, options.antenna,
                                        options.verbose)
            options.samples_per_symbol = self.sink._sps
            
        elif(options.to_file is not None):
            sys.stderr.write(("Saving samples to '%s'.\n\n" % (options.to_file)))
            self.sink = gr.file_sink(gr.sizeof_gr_complex, options.to_file)
        else:
            sys.stderr.write("No sink defined, dumping samples to null sink.\n\n")
            self.sink = gr.null_sink(gr.sizeof_gr_complex)

        # do this after for any adjustments to the options that may
        # occur in the sinks (specifically the UHD sink)
	# Pass options to transmitter, setup transmitter, pass to pointer self.txpath
        self.txpath = transmit_path(modulator, options)

	# Connect and construct flowgraph
        self.connect(self.txpath, self.sink)#--> back to main, to enable realtime scheduling

# /////////////////////////////////////////////////////////////////////////////
#                                   main
# /////////////////////////////////////////////////////////////////////////////

def main():
    # Send packet function
    def send_pkt(payload='', eof=False):
        return tb.txpath.send_pkt(payload, eof)

    # Modulation initialization
    mods = digital.modulation_utils.type_1_mods()

    # Get user inputs
    parser = OptionParser(option_class=eng_option, conflict_handler="resolve")
    expert_grp = parser.add_option_group("Expert")

    parser.add_option("-m", "--modulation", type="choice", choices=mods.keys(),
                      default='psk',
                      help="Select modulation from: %s [default=%%default]"
                            % (', '.join(mods.keys()),))

    parser.add_option("-s", "--size", type="eng_float", default=1500,
                      help="set packet size [default=%default]")
    parser.add_option("-M", "--megabytes", type="eng_float", default=1.0,
                      help="set megabytes to transmit [default=%default]")
    parser.add_option("","--discontinuous", action="store_true", default=False,
                      help="enable discontinous transmission (bursts of 5 packets)")
    parser.add_option("","--from-file", default=None,
                      help="use intput file for packet contents")
    parser.add_option("","--to-file", default=None,
                      help="Output file for modulated samples")

    # Send options selected by user to transmit_path file
    transmit_path.add_options(parser, expert_grp)
    uhd_transmitter.add_options(parser)

    # Pass options selected to all modulator file (dbpsk, d8psk, dqpsk, gmsk...)
    for mod in mods.values():
        mod.add_options(expert_grp)

    # Parse command-line for errors
    (options, args) = parser.parse_args ()

    # Print errors and exit
    if len(args) != 0:
        parser.print_help()
        sys.exit(1)

    # Open the file which user wants to transmit       
    if options.from_file is not None:
        source_file = open(options.from_file, 'r')

    # build the graph
    # Constructing transmission flowgraph and pass pointer to variable called "tb"
    tb = my_top_block(mods[options.modulation], options)#--> got to def my_top_block

    # Enable realtime scheduling
    r = gr.enable_realtime_scheduling()
    if r != gr.RT_OK:
        print "Warning: failed to enable realtime scheduling"

    # Start construction of flowgraph
    tb.start()                       # start flow graph
        
    # generate and send packets
    nbytes = int(1e6 * options.megabytes) # Total byte to send, From command-line
    n = 0        # 
    pktno = 0    # First packet number
    pkt_size = int(options.size) #Size of packet

    # send packets/file
    while n < nbytes:
	print "Sending: "+str(n)+"| bytes: "+str(nbytes)+ " | Packet Size: "+str(pkt_size)
        if options.from_file is None:# Generate packet (if raw data transmission chosen)
            data = (pkt_size - 2) * chr(pktno & 0xff) 
        else:  # Generate packet (if data from file is chosen)
            data = source_file.read(pkt_size - 2)
            if data == '':
                break;

        payload = struct.pack('!H', pktno & 0xffff) + data # Construct packet, the easy way
        send_pkt(payload)  # Send packet through send_pkt function --> see def send_pkt()
        n += len(payload) 
        sys.stderr.write('.')
	# If discontinues is selected then after a 4 byte send pause 1 second (Conjestion problem hack)
        if options.discontinuous and pktno % 5 == 4:
            time.sleep(1)
        pktno += 1

    # Tell send function that we are done sending        
    send_pkt(eof=True)

    # Keep running flowgraph until user kills it
    tb.wait()                       # wait for it to finish

#START HERE!!!!!!!!!!!!!!
if __name__ == '__main__':
    try:
        main()
    except KeyboardInterrupt:#STOP Program
        pass
