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
include "<subPU>"
include "<subPD>"
include "<subPG>"	
include "SRAM_Ioff_Ileak_vs_lpu.scs"


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

dc dc	          		\
	param=lpu		\
	start=minl		\
	stop=20*minl

saveOptions options save=allpub
