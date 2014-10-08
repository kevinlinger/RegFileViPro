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
		pvbp=<pvbp>	\
		minl=<minl>     \
		minw=<minw>	
		
include "<include>"
include "<subN>"
include "<subP>"
include "RVP_I_cell.scs"


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

dc dc               \
  param=pvdd        \
  start=<pvdd>      \
  stop=0

saveOptions options save=allpub
