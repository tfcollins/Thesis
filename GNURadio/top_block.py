#!/usr/bin/env python
##################################################
# Gnuradio Python Flow Graph
# Title: Top Block
# Generated: Wed Jan 18 15:50:02 2012
##################################################

from gnuradio import digital
from gnuradio import eng_notation
from gnuradio import gr
from gnuradio.eng_option import eng_option
from gnuradio.gr import firdes
from grc_gnuradio import blks2 as grc_blks2
from grc_gnuradio import wxgui as grc_wxgui
from optparse import OptionParser
import wx

class top_block(grc_wxgui.top_block_gui):

	def __init__(self):
		grc_wxgui.top_block_gui.__init__(self, title="Top Block")
		_icon_path = "/usr/share/icons/hicolor/32x32/apps/gnuradio-grc.png"
		self.SetIcon(wx.Icon(_icon_path, wx.BITMAP_TYPE_ANY))

		##################################################
		# Variables
		##################################################
		self.samp_rate = samp_rate = 32000

		##################################################
		# Blocks
		##################################################
		self.gr_throttle_0 = gr.throttle(gr.sizeof_char*1, samp_rate)
		self.gr_file_source_0 = gr.file_source(gr.sizeof_char*1, "/home/traviscollins/GNURADIO/tfc_models/txt2transmit.txt", True)
		self.gr_file_sink_0_0 = gr.file_sink(gr.sizeof_float*1, "")
		self.gr_file_sink_0_0.set_unbuffered(False)
		self.gr_file_sink_0 = gr.file_sink(gr.sizeof_char*1, "/home/traviscollins/GNURADIO/tfc_models/Output.txt")
		self.gr_file_sink_0.set_unbuffered(False)
		self.gr_channel_model_0 = gr.channel_model(
			noise_voltage=0.0,
			frequency_offset=0.0,
			epsilon=1.0,
			taps=(1.0 + 1.0j, ),
			noise_seed=42,
		)
		self.digital_psk_mod_0 = digital.psk.psk_mod(
		  constellation_points=8,
		  mod_code="gray",
		  differential=True,
		  samples_per_symbol=2,
		  excess_bw=0.35,
		  verbose=False,
		  log=False,
		  )
		self.digital_psk_demod_0 = digital.psk.psk_demod(
		  constellation_points=8,
		  differential=True,
		  samples_per_symbol=2,
		  excess_bw=0.35,
		  phase_bw=6.28/100.0,
		  timing_bw=6.28/100.0,
		  gray_coded="gray",
		  verbose=False,
		  log=False,
		  )
		self.blks2_packet_encoder_0 = grc_blks2.packet_mod_b(grc_blks2.packet_encoder(
				samples_per_symbol=2,
				bits_per_symbol=2,
				access_code="",
				pad_for_usrp=True,
			),
			payload_length=0,
		)
		self.blks2_packet_decoder_0 = grc_blks2.packet_demod_b(grc_blks2.packet_decoder(
				access_code="",
				threshold=-1,
				callback=lambda ok, payload: self.blks2_packet_decoder_0.recv_pkt(ok, payload),
			),
		)
		self.blks2_error_rate_0 = grc_blks2.error_rate(
			type='BER',
			win_size=1000,
			bits_per_symbol=2,
		)

		##################################################
		# Connections
		##################################################
		self.connect((self.blks2_packet_decoder_0, 0), (self.blks2_error_rate_0, 1))
		self.connect((self.gr_channel_model_0, 0), (self.digital_psk_demod_0, 0))
		self.connect((self.blks2_packet_encoder_0, 0), (self.digital_psk_mod_0, 0))
		self.connect((self.digital_psk_demod_0, 0), (self.blks2_packet_decoder_0, 0))
		self.connect((self.blks2_packet_decoder_0, 0), (self.gr_file_sink_0, 0))
		self.connect((self.blks2_error_rate_0, 0), (self.gr_file_sink_0_0, 0))
		self.connect((self.digital_psk_mod_0, 0), (self.gr_channel_model_0, 0))
		self.connect((self.gr_file_source_0, 0), (self.gr_throttle_0, 0))
		self.connect((self.gr_throttle_0, 0), (self.blks2_packet_encoder_0, 0))
		self.connect((self.gr_throttle_0, 0), (self.blks2_error_rate_0, 0))

	def get_samp_rate(self):
		return self.samp_rate

	def set_samp_rate(self, samp_rate):
		self.samp_rate = samp_rate

if __name__ == '__main__':
	parser = OptionParser(option_class=eng_option, usage="%prog: [options]")
	(options, args) = parser.parse_args()
	tb = top_block()
	tb.Run(True)

