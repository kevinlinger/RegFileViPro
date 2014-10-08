simulator lang=spectre
global 0

parameters 	ldef=<ldef>	\
		wdef=<wdef>	\
		pvdd=<pvdd>	\
		minw=<minw>


include "<include>"
include "<subN>"
include "<subP>"
include "Ioff_vs_w_P.scs"


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
	sub=P1			\
	param=wdef		\
	start=minw		\
	stop=20*minw

saveOptions options save=allpub currents=all
