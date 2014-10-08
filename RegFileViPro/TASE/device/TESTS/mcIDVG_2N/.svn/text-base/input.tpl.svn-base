simulator lang=spectre
global 0

parameters 	mcrunNum=<mcrunNum> 

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
		minw=<minw>	
		
//parameters	pvIn=1.0
		


include "<include>"
include "<subN>"
include "<subP>"
include "mcIDVG2N.scs"


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
	stop=<pvdd>
export Ioff2= oceanEval("value(i(\"N2.NX:d\" ?result 'dc) 0)")
export Ion2= oceanEval("value(i(\"N2.NX:d\" ?result 'dc) <pvdd>)")
export Ioff= oceanEval("value(i(\"N4.NX:d\" ?result 'dc) 0)")
export Ion= oceanEval("value(i(\"N4.NX:d\" ?result 'dc) <pvdd>)")
export Ioff3= oceanEval("value(i(\"N5.NX:d\" ?result 'dc) 0)")
export Ion3= oceanEval("value(i(\"N5.NX:d\" ?result 'dc) <pvdd>)")
}
saveOptions options save=allpub currents=all
