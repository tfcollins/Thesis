from scipy import *
from scipy.linalg import toeplitz
import numpy as np
import scipy as sp
import matplotlib as mpl
import matplotlib.pyplot as plt
from scipy.signal import lfilter
from numpy import genfromtxt


#received=array([1+1j,2+2j,3+3j,4+4j,5+5j,6+6j,7+7j,8,9,10])
#preamble=array([1,2,3,4,5,6,7,0,0,0])
preamble = genfromtxt('/home/traviscollins/data/pypreamble.txt', delimiter=',')

#Correlator
xcorr=np.correlate(received,preamble)
max_val=np.max(xcorr)
locations= np.where(xcorr==max_val)
index= locations[0]

received=received[index:index+len(preamble)]

#Equalizer
n=4
delta=0		#delay
p = len(received)-delta
r1=received[n:p]
r2=received[n::-1]
R=toeplitz(r1,r2)
S=preamble[n-delta:p-delta]
#S=S.transpose()

f1=np.linalg.inv(dot(R.conj().transpose(),R))
f2=dot(R.conj().transpose(),S)
f=dot(f1,f2)

output=lfilter(f,1,received)



