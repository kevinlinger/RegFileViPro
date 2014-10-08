
; ************************** main code ***************************
simulator( 'spectre )
(envSetVal "spectre.opts" "multithread" 'string "on")
(envSetVal "spectre.opts" "nthreads" 'string "3")

design(	 "./netlist")
modelFile( 
    '("<include>")
    '("<subN>")
    '("<subP>")
)

    desVar(       "wp1" <wp1>   )
    desVar(       "lp1" <lp1>   )
    desVar(       "wn1" <wn1>   )
    desVar(       "ln1" <ln1>   )
    desVar(       "wna" <wna>   )
    desVar(       "lna" <lna>   )
    desVar(       "wp2" <wp1>   )
    desVar(       "lp2" <lp1>   )
    desVar(       "wn2" <wn2>   )
    desVar(       "ln2" <ln2>   )
    desVar(       "wrs" <wrs>   )
    desVar(       "lrs" <lrs>   )

    desVar(       "wpu" <wpu>   )
    desVar(       "lpu" <lpu>   )
    desVar(       "wpd" <wpd>   )
    desVar(       "lpd" <lpd>   )
    desVar(       "wpg" <wpg>   )
    desVar(       "lpg" <lpg>   )

desVar(   "numRows" <numRows> )
desVar(   "ldef" <ldef> )
desVar(   "wdef" <wdef> )
desVar(   "pvdd" <pvdd> )
desVar(   "pvddl" <pvddl> )
desVar(   "minl" <minl> )
desVar(   "minw" <minw> )
desVar(   "pvin" <pvdd> )
desVar(   "cap"  <cellCap>*<numRows>)
desVar(   "cap6"  2*<cellCap>*<numRows>)

desVar( "pr" <pr>)
desVar( "pf" <pf>)
desVar( "pw" <pw>)

pr = <pr>
pf = <pf>
pw = <pw>

resultsDir( "./OUT" )
fout=outfile("diff.txt","w")

analysis( 'tran ?start 0 ?stop 1.2*(pw+pr+pf) ?step 1.2*(pw+pr+pf)/100 ?errpreset "conservative")
temp( <temp> ) 
option( 'reltol 1e-6 'gmin <gmin> )
save('all)
run()
selectResult('tran)

bl1 = value(v("BL1") 1.2*(pw+pr+pf))
bl2 = value(v("BL2") 1.2*(pw+pr+pf))

bl = value(v("BL") 1.2*(pw+pr+pf))
blb = value(v("BLB") 1.2*(pw+pr+pf))

diff1=ymax(abs(v("BL1")-v("BL2")))
diff2=ymax(abs(v("BL")-v("BLB")))
fprintf(fout, "%f %f %f %f %f %f\n", 1e3*bl1, 1e3*bl2, 1e3*bl, 1e3*blb, 1e3*diff1, 1e3*diff2)

close(fout)
