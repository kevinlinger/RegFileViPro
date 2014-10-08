simulator lang=spectre
global 0

parameters 	minw=<minw>	\
		minl=<minl>	\
		pw = <inv_pw>	\
		pl = <inv_pl>	\
		nw = <inv_nw>	\
		nl = <inv_nl>	\
		pvdd=<pvdd>	\

include "<include>"
include "<subN>"
include "<subP>"
include "gate_INV_VTC.scs"


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
	dev=VIN			\
	param=dc		\
	start=0			\
	stop=pvdd

saveOptions options save=allpub currents=all
