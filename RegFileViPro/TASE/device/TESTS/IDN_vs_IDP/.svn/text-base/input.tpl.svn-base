simulator lang=spectre
global 0

parameters ldef=<ldef> wdef=<wdef> pvdd=<pvdd>
include "<include>"
include "<subN>"
include "<subP>"
include "IDN_vs_IDP.scs"


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
	param=pvdd		\
	start=0.1		\
	stop=<pvdd>		\
	step=0.05

saveOptions options save=allpub currents=all
