simulator lang=spectre
global 0

parameters 	ldef=<ldef>	\
		wdef=<wdef>	\
		pvdd=<pvdd>	


include "<include>"
include "<subN>"
include "<subP>"
include "RVP_I_offn.scs"


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
	dev=VVDS		\
	param=dc		\
	start=pvdd		\
	stop=0

saveOptions options save=allpub currents=all



