simulator lang=spectre
global 0

parameters 	mcrunNum=<mcrunNum> 

parameters	wpu=<wpu>       \
		lpu=<lpu>	\
		wpd=<wpd>	\
		lpd=<lpd>	\
		wpg=<wpg>	\
		lpg=<lpg> bitline=<bitline> wlv=<wlv> pvbn=<pvbn> pvbp=<pvbp> pvss=<pvss>	


parameters ldef=<ldef> wdef=<wdef> pvdd=<pvdd>
include "<include>"
include "<subN>"
include "<subP>"
include "<subPG>"
include "<subPD>"
include "<subPU>"
include "logIDVG_N.scs"

simulatorOptions options        \
	reltol=<reltol>		\
	vabstol=<vabstol>	\
	iabstol=<iabstol>	\
	tnom=<tnom>		\
	scalem=<scalem>		\
	scale=<scale>		\
	gmin=<gmin>		\
	rforce=<rforce>		\
	pivrel=<pivrel>


subckt sweepTemp()
	parameters ptemp
	setTemp alter param=temp value=ptemp
	dc dc dev=VVGS param=dc start=-pvdd stop=pvdd
ends sweepTemp

Temp1 sweepTemp ptemp=-35
Temp2 sweepTemp ptemp=-35
Temp3 sweepTemp ptemp=0
Temp4 sweepTemp ptemp=35
Temp5 sweepTemp ptemp=70
Temp6 sweepTemp ptemp=105
Temp7 sweepTemp ptemp=140
Temp8 sweepTemp ptemp=175

saveOptions options save=allpub currents=all
