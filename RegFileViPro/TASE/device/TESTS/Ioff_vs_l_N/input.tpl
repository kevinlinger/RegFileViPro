simulator lang=spectre
global 0


parameters 	ldef=<ldef>	\
		wdef=<wdef>	\
		pvdd=<pvdd>	\
		minl=<minl>


include "<include>"
include "<subN>"
include "<subP>"
include "Ioff_vs_l_N.scs"


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
	sub=N1			\
	param=ldef		\
	start=minl		\
	stop=20*minl


saveOptions options save=allpub currents=all
