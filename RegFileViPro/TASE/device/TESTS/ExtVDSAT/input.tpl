simulator lang=spectre
global 0

parameters ldef=<lpg> wdef=<wpg> pvdd=<pvdd>
include "<include>"
include "<subPG>"
include "<subP>"
include "ExtVDSAT.scs"


simulatorOptions options	\
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
	dev=VVDS		\
	param=dc		\
	start=0			\
	stop=pvdd

saveOptions options save=allpub currents=all
