simulator lang=spectre
global 0

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

include "<include>"
include "<subN>"
include "<subP>"
include "<subPU>"
include "<subPD>"
include "<subPG>"	
include "SRAM_PUratio.scs"


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

swp1 sweep param=wpu start=70n stop=350n {
tran tran start=0 stop=1n step=0.01n strobeperiod=0.001n
}
save Q
saveOptions options save=selected currents=none
