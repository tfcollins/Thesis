from scipy import *
from scipy.linalg import toeplitz
import numpy as np
import scipy as sp
import matplotlib as mpl
import matplotlib.pyplot as plt

received=array([1+1j,2+2j,3+3j,4+4j,5+5j,6+6j,7+7j,8,9,10])
preamble=array([1,2,3,4,5,6,7,0,0,0])

n=3
delta=0		#delay
p = len(received)-delta
print p
r1=received[n:p]
r2=received[n::-1]
R=toeplitz(r1,r2)
S=preamble[n-delta:p-delta]
#S=S.transpose()
print "R: ",R
print "S: ",S

f1=np.linalg.inv(dot(R.conj().transpose(),R))
f2=dot(R.conj().transpose(),S)
f=dot(f1,f2)
print "f1: ",f1
print "f2: ",f2
print "Estimate: ",f 


