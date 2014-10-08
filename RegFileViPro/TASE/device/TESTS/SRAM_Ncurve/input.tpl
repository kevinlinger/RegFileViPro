; Mark McCartney, 2008-01-14
; Characterize 6T cell using N-curve.

; ************************** procedures ***************************

; ************************** main code ***************************
;ocnWaveformTool( 'wavescan )

simulator( 'spectre )
design(	 "./netlist")
resultsDir( "./OUT" )
;path( "/afs/ece.cmu.edu/usr/mbhargav/fslbulk045/Stimuli" )
modelFile( 
    ;'("/afs/ece.cmu.edu/usr/mmccartn/cds/FSL_45/spectre/rev0c/cmos11lp.scs" "NN")
    '("<include>")
    '("<subN>")
    '("<subP>")
    	'("<subPU>")
	'("<subPD>")
	'("<subPG>")
)

;stimulusFile( ?xlate nil
;    "/afs/ece.cmu.edu/usr/mmccartn/simulation/6T/spectre/schematic/netlist/stimuli/6T_Noise_Margin.sim"
;)

of = outfile( "./OUT/ncurve.out" )
; MATLAB can't read text, so don't put this in as a header.
;fprintf(of "VDD\tVINA\tVINB\tVINC\tSVNM\tSINM\tWTV\tWTI\n")

num_points = 40

for(i 1 num_points
    VDD_sweep = i * <pvdd> / num_points
    analysis('dc ?param "pvin" ?start "0" ?stop VDD_sweep )

    desVar(	  "wpu" <wpu>	)
    desVar(	  "lpu" <lpu>	)
    desVar(	  "wpd" <wpd>	)
    desVar(	  "lpd" <lpd>	)
    desVar(	  "wpg" <wpg>	)
    desVar(	  "lpg" <lpg>	)

    desVar(   "ldef" <ldef> )
    desVar(   "wdef" <wdef> )
    desVar(   "pvdd" VDD_sweep)
    desVar(   "pvbp" <pvbp> )
    desVar(   "pvin" 0      )
    desVar(   "minl" <minl> )
    desVar(   "minw" <minw> )

    save( 'i "/IIN/in" )
    temp( 27 ) 
    run()

  selectResults('dc)

  ;outputs()
  ;ocnPrint( i("IIN:in") ?output "./OUT/IIN" ?numberNotation 'engineering )

  ;plot(VIN, IIN:in)

  ; Find points A, B, C

  VINA = cross(i("IIN:in") 0 1 "either")
  VINB = cross(i("IIN:in") 0 2 "either")
  VINC = cross(i("IIN:in") 0 3 "either")

if(!(VINA && VINB)
    then
    SVNM = 0.0
    SINM = 0.0
    else
    SVNM = (VINB - VINA)
    SINM = ymax(clip(i("IIN:in") VINA VINB))
  )

if(!(VINC && VINB)
    then
    WTV = 0.0
    WTI = 0.0
    else
    WTV = (VINC - VINB)
    WTI = abs(ymin(clip(i("IIN:in") VINB VINC)))
  )

if((!VINA || !VINB || !VINC)
    then 
    VINA=0.0
    VINB=0.0
    VINC=0.0
  )

  fprintf(of "%8.3g\t%8.3g\t%8.3g\t%8.3g\t%8.3g\t%8.3g\t%8.3g\t%8.3g\n" VDD_sweep VINA VINB VINC SVNM SINM WTV WTI)
  drain(of)

  ) ; for(i 1 num_points)

close(of)

; Sample equations.
;WriteMargin_WL = (1 - value(VT("/WL") cross(VT("/BLTI") 0.5 1 "falling")))
;plot( WriteMargin_WL ?expr '( "WriteMargin_WL" ) )
;WriteMargin_BL = value(VT("/BLB") cross(VT("/BLTI") 0.5 1 "rising"))
;plot( WriteMargin_BL ?expr '( "WriteMargin_BL" ) )
;RNM_WL0 = ((((cross(clip((VT("/BLTI_g") - VT("/BLFI_g")) 4e-06 5e-06) 0 1 "either") * 1000000.0) - 4) * 2.8) - 0.2)
;plot( RNM_WL0 ?expr '( "RNM_WL0" ) )
;RSNM_WL1 = ((((cross(clip((VT("/BLTI_g") - VT("/BLFI_g")) 4e-06 5e-06) 0 2 "either") * 1000000.0) - 4.5) * 4.8) - 1.2)
;plot( RSNM_WL1 ?expr '( "RSNM_WL1" ) )
;I_ON = value(IT("/I1/BITLINE") 1.55e-06)
;plot( I_ON ?expr '( "I_ON" ) )
;I_OFF = value(IT("/I1/BITLINE") 1.05e-06)
;plot( I_OFF ?expr '( "I_OFF" ) )

; vim: sts=2 sw=2 fdm=indent tw=90 et
