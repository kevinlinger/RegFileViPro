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
		pvbn=<pvbn>	\
                pvwl=<pvdd>     \
		minl=<minl>     \
		minw=<minw>	
		
include "<include>"
include "<subN>"
include "<subP>"
include "RSTSRAM_Iread_vs_VWL.scs"


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
