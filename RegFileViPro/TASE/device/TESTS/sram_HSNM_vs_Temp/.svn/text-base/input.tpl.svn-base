simulator lang=spectre
global 0

parameters 	mcrunNum=<mcrunNum> 

parameters	wpu=<wpu>       \
		lpu=<lpu>	\
		wpd=<wpd>	\
		lpd=<lpd>	\
		wpg=<wpg>	\
		lpg=<lpg>	

parameters	ldef=<ldef>	\
		wdef=<wdef>	\
		pvdd=<pvdd>	\
		minl=<minl>     \
		minw=<minw>	
		
parameters	pvIn=1.0
		
include "<include>"
include "<subN>"
include "<subP>"
include "<subPG>"
include "<subPD>"
include "<subPU>"
include "SRAM_HSNM.scs"


simulatorOptions options        \
	reltol=<reltol>		\
	vabstol=<vabstol>	\
	iabstol=<iabstol>	\
	temp=<temp>		\
	tnom=<tnom>		\
	scalem=<scalem>		\
	scale=<scale>		\
	gmin=<gmin>		\
	rforce=<rforce>		\
	pivrel=<pivrel>




subckt sweepTemp()
         parameters ptemp
         setTemp alter param=temp value=ptemp
         dc dc dev=VVDD param=dc start=-pvdd stop=pvdd
ends sweepTemp

Temp1 sweepTemp ptemp=-50
Temp2 sweepTemp ptemp=-25
Temp3 sweepTemp ptemp=25
Temp4 sweepTemp ptemp=75
Temp5 sweepTemp ptemp=125
Temp6 sweepTemp ptemp=175
       



saveOptions options save=allpub currents=none







