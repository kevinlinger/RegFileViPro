simulator lang=spectre
global 0

parameters      wpu1=<wpu1>     \
                lpu1=<lpu1>       \
                wpu2=<wpu2>     \
                lpu2=<lpu2>       \
                wpd1=<wpd1>     \
                lpd1=<lpd1>       \
                wpd2=<wpd2>     \
                lpd2=<lpd2>       \
                wpg=<wpg>       \
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
include "5TSRAM_Ioff_Ileak_vs_VDD.scs"

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

dc dc				\
	param=pvdd		\
	start=<pvdd>		\
	stop=0

saveOptions options save=allpub
