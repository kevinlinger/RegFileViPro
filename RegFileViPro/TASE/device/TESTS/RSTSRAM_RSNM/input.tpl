simulator lang=spectre
global 0

parameters 	mcrunNum=<mcrunNum> 

parameters	wp1=<wp1>     \
		wp2=<wp2>	\
		lp1=<lp1>	\
		lp2=<lp2>	\
		wn1=<wn1>	\
		ln1=<ln1>	\
		wn2=<wn2>	\
		ln2=<ln2>	\
		wna=<wna>	\
		lna=<lna>	\
		wrs=<wrs>	\
		lrs=<lrs>

parameters	ldef=<ldef>	\
		wdef=<wdef>	\
		pvdd=<pvdd>	\
		minl=<minl>     \
		minw=<minw>	
		
parameters	pvIn=1.0
		
include "<include>"
include "<subN>"
include "<subP>"
include "RSTSRAM_RSNM.scs"


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
dc dc                           \
	param=pvIn		\
	start=-pvdd		\
	stop=pvdd		\
	step=0.001
export RSNMh=oceanEval("ymax(clip(v(\"v1mv2h\" ?result 'dc) nil 0))/sqrt(2)*1e3")
export RSNMl=oceanEval("ymin(clip(v(\"v1mv2h\" ?result 'dc) 0 nil))/sqrt(2)*(-1)*1e3")
export RSNM=oceanEval("min(ymax(clip(v(\"v1mv2h\" ?result 'dc) ymax(v(\"VDD\" \
    ?result 'dc))*(-1) 0))/sqrt(2) ymin(clip(v(\"v1mv2h\" ?result 'dc) 0 \
    ymax(v(\"VDD\" ?result 'dc))))/sqrt(2)*(-1))*1e3")
export VM1=oceanEval("value(v(\"Isnmh.v1\" ?result 'dc) cross(v(\"v1mv2h\" \
    ?result 'dc) 0.0001 1 'either))/sqrt(2)+cross(v(\"v1mv2h\" ?result \
    'dc) 0.0001 1 'either)/sqrt(2)*1e3")
export VM2=oceanEval("value(v(\"Isnmh.v1\" ?result 'dc) cross(v(\"v1mv2h\" \
    ?result 'dc) 0.0001 2 'either))/sqrt(2)+cross(v(\"v1mv2h\" ?result \
    'dc) 0.0001 2 'either)/sqrt(2)*1e3")
export VM3=oceanEval("value(v(\"Isnmh.v1\" ?result 'dc) cross(v(\"v1mv2h\" \
    ?result 'dc) 0.0001 3 'either))/sqrt(2)+cross(v(\"v1mv2h\" ?result \
    'dc) 0.0001 3 'either)/sqrt(2)*1e3")
}

saveOptions options save=allpub currents=none
