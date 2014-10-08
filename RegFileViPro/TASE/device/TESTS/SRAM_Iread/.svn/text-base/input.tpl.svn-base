simulator lang=spectre
global 0

parameters      mcrunNum=<mcrunNum>


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

parameters      pvIn=1.0

#number rows minus 1#
parameters	rowsM1=<rowsM1>
		
include "<include>"
include "<subN>"
include "<subP>"
include "<subPU>"
include "<subPD>"
include "<subPG>"	
include "SRAM_Iread.scs"


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

//===========================================
// Monte-Carlo Simulation
//===========================================
mc montecarlo numruns=mcrunNum firstrun=1 seed=1 \
    variations=<mcType> donominal=yes \
    scalarfile="../monteCarlo/mcdata" paramfile="../monteCarlo/mcparam" \
    saveprocessparams=yes processparamfile="../monteCarlo/processParam" \
    processscalarfile="../monteCarlo/processData" {
tran tran			\
	start=0			\
	stop=1.1n               \
	strobeperiod=0.001n	
export Ipeak=oceanEval("ymax(i(\"VBL:p\" ?result 'tran))")
export rd0Delay=oceanEval("cross(abs(v(\"BLB1\" ?result 'tran)-v(\"BL1\" \
    ?result 'tran)) 100m 1 'rising)-0.01n")
export Iavg=oceanEval("average(i(\"VBL:p\" ?result 'tran))")
}
save BLB1 BL1 VBL:p
saveOptions options save=selected currents=selected
