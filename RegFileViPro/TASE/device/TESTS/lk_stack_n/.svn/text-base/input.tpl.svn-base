simulator lang=spectre
global 0


parameters	ldef=<ldef>	\
		wdef=<wdef>	\
                pvbn=<pvbn>     \
		pvdd=<pvdd>


include "<include>"
include "<subN>"
include "<subP>"
include "lk_stack_n.scs"


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
	dev=VVGS		\
	param=dc		\
	start=-pvdd		\
	stop=pvdd


saveOptions options save=allpub currents=all
