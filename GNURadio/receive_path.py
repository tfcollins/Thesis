#!/usr/bin/env python
<<<<<<< HEAD
=======
#
>>>>>>> 8d49faa84f59bbacfa1e96f9d30a844fba01f641

from gnuradio import gr, gru
from gnuradio import eng_notation
from gnuradio import digital

import copy
import sys

# /////////////////////////////////////////////////////////////////////////////
#                              receive path
# /////////////////////////////////////////////////////////////////////////////

class receive_path(gr.hier_block2):
    def __init__(self, demod_class, rx_callback, options):
	gr.hier_block2.__init__(self, "receive_path",
				gr.io_signature(1, 1, gr.sizeof_gr_complex),
				gr.io_signature(0, 0, 0))
        
	#########################################
	#   Variables
	#########################################
        options = copy.copy(options)    # make a copy so we can destructively modify

        self._verbose     = options.verbose
        self._bitrate     = options.bitrate  # desired bit rate

        self._rx_callback = rx_callback  # this callback is fired when a packet arrives
        self._demod_class = demod_class  # the demodulator_class we're using

        # Get demod_kwargs
        demod_kwargs = self._demod_class.extract_kwargs_from_options(options)


<<<<<<< HEAD
	################################
	#  Build Blocks
	###############################
=======
	#########################################
	#   Blocks
	#########################################
>>>>>>> 8d49faa84f59bbacfa1e96f9d30a844fba01f641
        # Build the demodulator
        self.demodulator = self._demod_class(**demod_kwargs)
        
        # Design filter to get actual channel we want
        sw_decim = 1
        chan_coeffs = gr.firdes.low_pass (1.0,                  # gain
                                          sw_decim * self.samples_per_symbol(), # sampling rate
                                          1.0,                  # midpoint of trans. band
                                          0.5,                  # width of trans. band
                                          gr.firdes.WIN_HANN)   # filter type
        self.channel_filter = gr.fft_filter_ccc(sw_decim, chan_coeffs)
        
        # receiver
        self.packet_receiver = \
            digital.demod_pkts(self.demodulator,
                               access_code=None,
                               callback=self._rx_callback,
                               threshold=-1)

        # Carrier Sensing Blocks
        alpha = 0.001
        thresh = 30   # in dB, will have to adjust
        self.probe = gr.probe_avg_mag_sqrd_c(thresh,alpha)

        # Display some information about the setup
        if self._verbose:
            self._print_verbage()

	#########################################
	#    CONNECTIONS
	#########################################

	# connect block input to channel filter
	self.connect(self, self.channel_filter)

        # connect the channel input filter to the carrier power detector
        self.connect(self.channel_filter, self.probe)

        # connect channel filter to the packet receiver
        self.connect(self.channel_filter, self.packet_receiver)

    def bitrate(self):
        return self._bitrate

    def samples_per_symbol(self):
        return self.demodulator._samples_per_symbol

    def differential(self):
        return self.demodulator._differential

    def carrier_sensed(self):
        """
        Return True if we think carrier is present.
        """
        #return self.probe.level() > X
	print "From carrier sensed: "+ self.probe.level()
        return self.probe.unmuted()

    def carrier_threshold(self):
        """
        Return current setting in dB.
        """
        return self.probe.threshold()

    def set_carrier_threshold(self, threshold_in_db):
        """
        Set carrier threshold.

        @param threshold_in_db: set detection threshold
        @type threshold_in_db:  float (dB)
        """
        self.probe.set_threshold(threshold_in_db)
    
        
    def add_options(normal, expert):
        """
        Adds receiver-specific options to the Options Parser
        """
        if not normal.has_option("--bitrate"):
            normal.add_option("-r", "--bitrate", type="eng_float", default=100e3,
                              help="specify bitrate [default=%default].")
        normal.add_option("-v", "--verbose", action="store_true", default=False)
        expert.add_option("-S", "--samples-per-symbol", type="float", default=2,
                          help="set samples/symbol [default=%default]")
        expert.add_option("", "--log", action="store_true", default=False,
                          help="Log all parts of flow graph to files (CAUTION: lots of data)")

    # Make a static method to call before instantiation
    add_options = staticmethod(add_options)


    def _print_verbage(self):
        """
        Prints information about the receive path
        """
        print "\nReceive Path:"
        print "modulation:      %s"    % (self._demod_class.__name__)
        print "bitrate:         %sb/s" % (eng_notation.num_to_str(self._bitrate))
        print "samples/symbol:  %.4f"    % (self.samples_per_symbol())
        print "Differential:    %s"    % (self.differential())
