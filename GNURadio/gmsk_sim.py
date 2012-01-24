#!/usr/bin/env python
##################################################
# Gnuradio Python Flow Graph
# Title: DVB Simulator (GMSK)
# Author: Alexandru Csete OZ9AEC
# Generated: Wed Jan 18 17:26:49 2012
##################################################

from gnuradio import audio
from gnuradio import digital
from gnuradio import eng_notation
from gnuradio import gr
from gnuradio.eng_option import eng_option
from gnuradio.gr import firdes
from gnuradio.wxgui import forms
from grc_gnuradio import blks2 as grc_blks2
from grc_gnuradio import wxgui as grc_wxgui
from optparse import OptionParser
import wx

class gmsk_sim(grc_wxgui.top_block_gui):

	def __init__(self):
		grc_wxgui.top_block_gui.__init__(self, title="DVB Simulator (GMSK)")
		_icon_path = "/usr/share/icons/hicolor/32x32/apps/gnuradio-grc.png"
		self.SetIcon(wx.Icon(_icon_path, wx.BITMAP_TYPE_ANY))

		##################################################
		# Variables
		##################################################
		self.signal = signal = 1
		self.samp_rate = samp_rate = 32000
		self.noise = noise = 10

		##################################################
		# Blocks
		##################################################
		_signal_sizer = wx.BoxSizer(wx.VERTICAL)
		self._signal_text_box = forms.text_box(
			parent=self.GetWin(),
			sizer=_signal_sizer,
			value=self.signal,
			callback=self.set_signal,
			label="Signal",
			converter=forms.float_converter(),
			proportion=0,
		)
		self._signal_slider = forms.slider(
			parent=self.GetWin(),
			sizer=_signal_sizer,
			value=self.signal,
			callback=self.set_signal,
			minimum=0,
			maximum=1000,
			num_steps=1000,
			style=wx.SL_HORIZONTAL,
			cast=float,
			proportion=1,
		)
		self.Add(_signal_sizer)
		_noise_sizer = wx.BoxSizer(wx.VERTICAL)
		self._noise_text_box = forms.text_box(
			parent=self.GetWin(),
			sizer=_noise_sizer,
			value=self.noise,
			callback=self.set_noise,
			label="Noise",
			converter=forms.float_converter(),
			proportion=0,
		)
		self._noise_slider = forms.slider(
			parent=self.GetWin(),
			sizer=_noise_sizer,
			value=self.noise,
			callback=self.set_noise,
			minimum=0,
			maximum=1000,
			num_steps=1000,
			style=wx.SL_HORIZONTAL,
			cast=float,
			proportion=1,
		)
		self.Add(_noise_sizer)
		self.gr_wavfile_source_0 = gr.wavfile_source("/home/traviscollins/GNURADIO/tfc_models/test.wav", False)
		self.gr_throttle_0 = gr.throttle(gr.sizeof_float*1, samp_rate)
		self.gr_noise_source_x_0 = gr.noise_source_c(gr.GR_GAUSSIAN, noise, 42)
		self.gr_multiply_const_vxx_0 = gr.multiply_const_vcc((signal, ))
		self.gr_file_sink_1_0 = gr.file_sink(gr.sizeof_float*1, "/home/traviscollins/GNURADIO/tfc_models/output_txt.wav")
		self.gr_file_sink_1_0.set_unbuffered(False)
		self.gr_channel_model_0 = gr.channel_model(
			noise_voltage=20,
			frequency_offset=0.0,
			epsilon=1.0,
			taps=(1.0 + 1.0j, ),
			noise_seed=42,
		)
		self.gr_add_xx_0 = gr.add_vcc(1)
		self.digital_gmsk_mod_0 = digital.gmsk_mod(
			samples_per_symbol=2,
			bt=0.35,
			verbose=False,
			log=False,
		)
		self.digital_gmsk_demod_0 = digital.gmsk_demod(
			samples_per_symbol=2,
			gain_mu=0.175,
			mu=0.5,
			omega_relative_limit=0.005,
			freq_error=0.0,
			verbose=False,
			log=False,
		)
		self.blks2_packet_encoder_0 = grc_blks2.packet_mod_f(grc_blks2.packet_encoder(
				samples_per_symbol=2,
				bits_per_symbol=1,
				access_code="",
				pad_for_usrp=True,
			),
			payload_length=0,
		)
		self.blks2_packet_decoder_0 = grc_blks2.packet_demod_f(grc_blks2.packet_decoder(
				access_code="",
				threshold=-1,
				callback=lambda ok, payload: self.blks2_packet_decoder_0.recv_pkt(ok, payload),
			),
		)
		self.audio_sink_0 = audio.sink(samp_rate, "", True)

		##################################################
		# Connections
		##################################################
		self.connect((self.gr_noise_source_x_0, 0), (self.gr_add_xx_0, 1))
		self.connect((self.gr_add_xx_0, 0), (self.digital_gmsk_demod_0, 0))
		self.connect((self.blks2_packet_encoder_0, 0), (self.digital_gmsk_mod_0, 0))
		self.connect((self.digital_gmsk_mod_0, 0), (self.gr_multiply_const_vxx_0, 0))
		self.connect((self.gr_throttle_0, 0), (self.blks2_packet_encoder_0, 0))
		self.connect((self.gr_throttle_0, 0), (self.gr_file_sink_1_0, 0))
		self.connect((self.digital_gmsk_demod_0, 0), (self.blks2_packet_decoder_0, 0))
		self.connect((self.gr_multiply_const_vxx_0, 0), (self.gr_channel_model_0, 0))
		self.connect((self.gr_channel_model_0, 0), (self.gr_add_xx_0, 0))
		self.connect((self.gr_wavfile_source_0, 0), (self.gr_throttle_0, 0))
		self.connect((self.blks2_packet_decoder_0, 0), (self.audio_sink_0, 0))

	def get_signal(self):
		return self.signal

	def set_signal(self, signal):
		self.signal = signal
		self.gr_multiply_const_vxx_0.set_k((self.signal, ))
		self._signal_slider.set_value(self.signal)
		self._signal_text_box.set_value(self.signal)

	def get_samp_rate(self):
		return self.samp_rate

	def set_samp_rate(self, samp_rate):
		self.samp_rate = samp_rate

	def get_noise(self):
		return self.noise

	def set_noise(self, noise):
		self.noise = noise
		self.gr_noise_source_x_0.set_amplitude(self.noise)
		self._noise_slider.set_value(self.noise)
		self._noise_text_box.set_value(self.noise)

if __name__ == '__main__':
	parser = OptionParser(option_class=eng_option, usage="%prog: [options]")
	(options, args) = parser.parse_args()
	tb = gmsk_sim()
	tb.Run(True)

