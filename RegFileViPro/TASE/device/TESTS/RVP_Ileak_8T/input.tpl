simulator lang=spectre
global 0

parameters 	wrd1=<wrd1>	\
		lrd1=<lrd1>	\
		wrdpg=<wrdpg>	\
		lrdpg=<lrdpg>	\
		pvdd=<pvdd>	


include "<include>"
include "<subPG>"
include "RVP_Ileak_PG.scs"


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
