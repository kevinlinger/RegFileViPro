simulator lang=spectre
global 0

parameters      wp1=<wp1>     \
                wp2=<wp2>       \
                lp1=<lp1>       \
                lp2=<lp2>       \
                wn1=<wn1>       \
                ln1=<ln1>       \
                wn2=<wn2>       \
                ln2=<ln2>       \
                wna=<wna>       \
                lna=<lna>       \
                wrs=<wrs>       \
                lrs=<lrs>

parameters	ldef=<ldef>	\
		wdef=<wdef>	\
		pvdd=<pvdd>	\
		pvbp=<pvbp>	\
		minl=<minl>     \
		minw=<minw>	
		
include "<include>"
include "<subN>"
include "<subP>"
include "RSTSRAM_Ioff_Ileak_vs_VDD.scs"


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
