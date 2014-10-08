simulator lang=spectre
global 0


parameters 	ldef=<ldef>	\
		wdef=<wdef>	\
		pvdd=<pvdd>	\
		minl=<minl>


include "<include>"
include "<subN>"
include "<subP>"
include "Ioff_vs_VBS_P.scs"


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
	dev=VVBS		\
	param=dc		\
	start=-pvdd		\
	stop=pvdd


saveOptions options save=allpub currents=all
