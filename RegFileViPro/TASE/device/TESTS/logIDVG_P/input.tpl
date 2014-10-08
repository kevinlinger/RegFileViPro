simulator lang=spectre
global 0

parameters ldef=<ldef> wdef=<wdef> pvdd=<pvdd>
include "<include>"
include "<subN>"
include "<subP>"
include "logIDVG_P.scs"

simulatorOptions options        \
	reltol=<reltol>		\
	vabstol=<vabstol>	\
	iabstol=<iabstol>	\
	tnom=<tnom>		\
	scalem=<scalem>		\
	scale=<scale>		\
	gmin=<gmin>		\
	rforce=<rforce>		\
	pivrel=<pivrel>


subckt sweepTemp()
	parameters ptemp
	setTemp alter param=temp value=ptemp
	dc dc dev=VVGS param=dc start=-pvdd stop=pvdd
ends sweepTemp

Temp1 sweepTemp ptemp=-50
Temp2 sweepTemp ptemp=-25
Temp3 sweepTemp ptemp=0
Temp4 sweepTemp ptemp=25
Temp5 sweepTemp ptemp=50
Temp6 sweepTemp ptemp=75
Temp7 sweepTemp ptemp=100
Temp8 sweepTemp ptemp=125

saveOptions options save=allpub currents=all
