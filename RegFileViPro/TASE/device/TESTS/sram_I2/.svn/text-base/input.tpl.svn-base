simulator lang=spectre
global 0

parameters 	mcrunNum=<mcrunNum> 

parameters	wpu=<wpu>       \
		lpu=<lpu>	\
		wpd=<wpd>	\
		lpd=<lpd>	\
		wpg=<wpg>	\
		lpg=<lpg> bitline=<bitline> wlv=<wlv> pvbn=<pvbn> pvbp=<pvbp> pvss=<pvss> 		

parameters	ldef=<ldef>	\
		wdef=<wdef>	\
		pvdd=<pvdd>	\
		minl=<minl>     \
		minw=<minw>	
		
//parameters	pvIn=1.0
		


include "<include>"
include "<subN>"
include "<subP>"
include "Iread2.scs"


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

//===========================================
// Monte-Carlo Simulation
//===========================================
mc montecarlo numruns=mcrunNum firstrun=1 seed=1 \
    variations=<mcType> donominal=yes  \
    scalarfile="../monteCarlo/mcdata" paramfile="../monteCarlo/mcparam" \
    saveprocessparams=yes processparamfile="../monteCarlo/processParam"  \
    processscalarfile="../monteCarlo/processData" {

dc dc				\
	dev=VVGS		\
	param=dc		\
	start=0			\
	stop=<wlv>
export Ioff= oceanEval("value(i(\"N2.NX:d\" ?result 'dc) 0)")
export Ion= oceanEval("value(i(\"N2.NX:d\" ?result 'dc) <wlv>)")
}
saveOptions options save=allpub currents=all
