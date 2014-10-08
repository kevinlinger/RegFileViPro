simulator lang=spectre
global 0

parameters 	lpd=<lpd>	\
		wpd=<wpd>	\
		pvdd=<pvdd>	


include "<include>"
include "<subPD>"
include "RVP_Ileak_PD.scs"


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
