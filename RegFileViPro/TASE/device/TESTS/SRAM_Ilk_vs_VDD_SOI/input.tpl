// Jiajing Wang, 2009-01-06
// Characterize SRAM 6T bitcell leakge current vs VDD.


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
		minl=<minl>     \
		minw=<minw>	

parameters	pvdd=<pvdd> pvbn=<pvbn> pvbp=<pvbp>	

		
include "<include>"
include "<subN>"
include "<subP>"
include "SRAM_Ilk_vs_VDD_SOI.scs"


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
// DC Simulation
//===========================================
dc dc                           \
	param=pvdd		\
	start=<pvdd>		\
	stop=0.1		\
	step=-0.1

saveOptions options save=allpub currents=all

