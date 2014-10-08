simulator lang=spectre
global 0

parameters 	mcrunNum=<mcrunNum> 

parameters	wpu=<wpu>       \
		lpu=<lpu>	\
		wpd=<wpd>	\
		lpd=<lpd>	\
		wpg=<wpg>	\
		lpg=<lpg> bitline=<bitline> wlv=<wlv> pvbn=<pvbn> pvbp=<pvbp> pvss=<pvss> pdvtar=<pdvtar> pdvtal=<pdvtal> pgvtar=<pgvtar> pgvtal=<pgvtal> puvtar=<puvtar> puvtal=<puvtal>	

parameters	ldef=<ldef>	\
		wdef=<wdef>	\
		pvdd=<pvdd>	\
		minl=<minl>     \
		minw=<minw>	
		
parameters	pvIn=1.0
		
include "<include>"
include "<subN>"
include "<subP>"
include "SRAM_RSNM.scs"


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
    saveprocessparams=no processparamfile="../monteCarlo/processParam" \
    processscalarfile="../monteCarlo/processData" {
dc dc                           \
	param=pvIn		\
	start=-pvdd		\
	stop=pvdd		\
	step=0.001
modelParameter info what=models where=rawfile
export RSNMh=oceanEval("ymax(clip(v(\"v1mv2\" ?result 'dc) nil 0))/sqrt(2)")
export RSNMl=oceanEval("ymin(clip(v(\"v1mv2\" ?result 'dc) 0 nil))/sqrt(2)*(-1)")
export RSNM=oceanEval("min(ymax(clip(v(\"v1mv2\" ?result 'dc) ymax(v(\"VDD\" \
    ?result 'dc))*(-1) 0))/sqrt(2) ymin(clip(v(\"v1mv2\" ?result 'dc) 0 \
    ymax(v(\"VDD\" ?result 'dc))))/sqrt(2)*(-1))")
export VT_PL=oceanEval("pv(\"ICell.MPl.PX.<pModelName>\" \"vtho\" ?result 'model)")
export VT_PR=oceanEval("pv(\"ICell.MPr.PX.<pModelName>\" \"vtho\" ?result 'model)")
export VT_NL=oceanEval("pv(\"ICell.MNl.NX.<nModelName>\" \"vtho\" ?result 'model)")
export VT_NR=oceanEval("pv(\"ICell.MNr.NX.<nModelName>\" \"vtho\" ?result 'model)")
export VT_TL=oceanEval("pv(\"ICell.MTl.NX.<nModelName>\" \"vtho\" ?result 'model)")
export VT_TR=oceanEval("pv(\"ICell.MTr.NX.<nModelName>\" \"vtho\" ?result 'model)")
}

saveOptions options save=allpub currents=none
