#!/usr/bin/env python
##################################################
# Gnuradio Python Flow Graph
# Title: Top Block
# Generated: Tue Jul 10 19:05:18 2012
##################################################

from gnuradio import digital
from gnuradio import eng_notation
from gnuradio import gr
from gnuradio import uhd
from gnuradio import window
from gnuradio.eng_option import eng_option
from gnuradio.gr import firdes
from gnuradio.wxgui import fftsink2
from grc_gnuradio import blks2 as grc_blks2
from grc_gnuradio import wxgui as grc_wxgui
from optparse import OptionParser
import wx
import struct
import threading
import math
import time

class top_block(grc_wxgui.top_block_gui):

	def __init__(self):
		grc_wxgui.top_block_gui.__init__(self, title="Top Block")
		_icon_path = "/usr/share/icons/hicolor/32x32/apps/gnuradio-grc.png"
		self.SetIcon(wx.Icon(_icon_path, wx.BITMAP_TYPE_ANY))

		##################################################
		# Variables
		##################################################
		self.samp_rate = samp_rate = 100000

		##################################################
		# Blocks
		##################################################
		self.wxgui_fftsink2_0_0 = fftsink2.fft_sink_c(
			self.GetWin(),
			baseband_freq=0,
			y_per_div=10,
			y_divs=10,
			ref_level=0,
			ref_scale=2.0,
			sample_rate=samp_rate,
			fft_size=2048,
			fft_rate=15,
			average=False,
			avg_alpha=None,
			title="FFT Plot",
			peak_hold=False,
		)
		self.Add(self.wxgui_fftsink2_0_0.win)
		self.uhd_usrp_source_0 = uhd.usrp_source(
			device_addr="",
			stream_args=uhd.stream_args(
				cpu_format="fc32",
				channels=range(1),
			),
		)
		self.uhd_usrp_source_0.set_samp_rate(samp_rate)
		self.uhd_usrp_source_0.set_center_freq(2.4e9, 0)
		self.uhd_usrp_source_0.set_gain(10, 0)
		self.gr_pll_carriertracking_cc_0 = gr.pll_carriertracking_cc(3.1459/2000, 2, 0)
		self.gr_file_sink_0_0 = gr.file_sink(gr.sizeof_char*1, "/home/sdruser/Desktop/raw2.txt")
		self.gr_file_sink_0_0.set_unbuffered(False)
		self.digital_gmsk_demod_0 = digital.gmsk_demod(
			samples_per_symbol=2,
			gain_mu=0.175,
			mu=0.5,
			omega_relative_limit=0.005,
			freq_error=0.0,
			verbose=True,
			log=False,
		)

		#Callback
		global rc_num, c_num
		rc_num=0
		c_num=0

		def rx_callback(ok,payload):
			global rc_num,c_num
			print "Called"
			print c_num
			try:
				(pktno,) = struct.unpack('!H', payload[0:2])
			except:
				print "Oops"	

			rc_num+=1

			if ok:
				c_num+=1
				print payload

		self.rx_callback=rx_callback #instaniate

		self.blks2_packet_decoder_0 = grc_blks2.packet_demod_b(grc_blks2.packet_decoder(
				access_code="",
				threshold=-1,
				callback=lambda ok, payload: self.rx_callback(ok, payload),
			),
		)


		##################################################
                # Working Threads
                ##################################################
                def _probe_probe():
			offset=0
			offset_max=50000
			old_c_num=0
                        while True:
                                time.sleep(4.0/(1))
                                #print "Power: "+str(self.pll.get_phase())
                                #print "Power: "+str(self.avg_mag.level())
                                #print "CC1: "+str(self.gr_pll_carriertracking_cc_0.get_frequency()/(2*math.pi))
                                #print "CC2: "+str(self.cartrack_2.get_frequency()/(2*math.pi))
                                #print "Lock: "+str(self.cartrack.lock_detector())
                                #try: self.set_probe(val)
                                #except AttributeError, e: pass
				#print c_num
				if old_c_num==c_num:
					#Changing offset
					print "Adjusting Offset"
					offset=offset+400
					self.uhd_usrp_source_0.set_center_freq(2.4e9-offset, 0)
					if  offset>=offset_max:
						print "Reset Offset"
						offset=-1*offset_max

				old_c_num=c_num
				
                _probe_thread = threading.Thread(target=_probe_probe)
                _probe_thread.daemon = True
                _probe_thread.start()


		##################################################
		# Connections
		##################################################
		#self.connect((self.gr_pll_carriertracking_cc_0, 0), (self.wxgui_fftsink2_0_0, 0))
		self.connect((self.uhd_usrp_source_0, 0), (self.gr_pll_carriertracking_cc_0, 0))
		self.connect((self.gr_pll_carriertracking_cc_0, 0), (self.digital_gmsk_demod_0, 0))
		self.connect((self.digital_gmsk_demod_0, 0), (self.blks2_packet_decoder_0, 0))
		self.connect((self.blks2_packet_decoder_0, 0), (self.gr_file_sink_0_0, 0))

	def get_samp_rate(self):
		return self.samp_rate

	def set_samp_rate(self, samp_rate):
		self.samp_rate = samp_rate
		self.uhd_usrp_source_0.set_samp_rate(self.samp_rate)
		self.wxgui_fftsink2_0_0.set_sample_rate(self.samp_rate)

if __name__ == '__main__':
	parser = OptionParser(option_class=eng_option, usage="%prog: [options]")
	(options, args) = parser.parse_args()
	tb = top_block()
	tb.Run(True)

