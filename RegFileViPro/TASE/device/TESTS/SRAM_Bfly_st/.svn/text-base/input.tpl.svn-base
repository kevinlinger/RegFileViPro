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
		minw=<minw> bitline=<bitline> 	wlv=<wlv> pvbn=<pvbn> pvbp=<pvbp> pvss=<pvss>  lbl=<lbl>
		
parameters	pvIn=1.0
		
include "<include>"
include "<subN>"
include "<subP>"
include "<subPG>"
include "<subPD>"
include "<subPU>"
include "SRAM_Bfly.scs"


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

dc dc                           \
	param=pvIn		\
	start=pvss		\
	stop=pvdd-pvss		\
	step=0.001 



saveOptions options save=allpub currents=none
