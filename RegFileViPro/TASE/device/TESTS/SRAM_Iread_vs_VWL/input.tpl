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
                pvwl=<pvdd>     \
		minl=<minl>     \
		minw=<minw>	
		
include "<include>"
include "<subN>"
include "<subP>"
include "<subPU>"
include "<subPD>"
include "<subPG>"	
include "SRAM_Iread_vs_VWL.scs"


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

dc dc                     \
  param=pvwl              \
  start=0                 \
  stop=<pvdd>*2           \
  step=0.001

saveOptions options save=allpub
