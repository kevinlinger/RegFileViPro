simulator lang=spectre
global 0

parameters	wpu=<wpu>       \
		lpu=<lpu>	\
		wpd=<wpd>	\
		lpd=<lpd>	\
		wpg=<wpg>	\
		lpg=<lpg>	

parameters	ldef=<ldef>	\
		wdef=<wdef>	\
		pvdd=<pvdd>	\
		minl=<minl>     \
		minw=<minw>	\
                vdd=<pvdd>
		
include "<include>"
include "<subN>"
include "<subP>"
include "dc_nodeset.scs"


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

dc dc				\
	param=vdd		\
        force=node              \
        readns="%C:r.dc0"       \
        write="%C:r.dc0"        \
	start=0			\
	stop=pvdd*2

saveOptions options save=allpub
