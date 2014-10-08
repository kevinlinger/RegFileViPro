/******************************************************************* 
*                                                                  * 
*                    (abChangeXAxis yVar xVar)                     * 
*                                                                  * 
* Return a new waveform object with the x axis set to the y values * 
*                     of the second argument.                      * 
*                                                                  * 
*******************************************************************/ 


(procedure (abChangeXAxis yVar xVar) 
  (let (newWave) 
       (setq newWave (drCreateEmptyWaveform)) 
       (drPutWaveformXVec newWave (drGetWaveformYVec xVar)) 
       (if (eq (drGetWaveformXVec yVar) (drGetWaveformXVec xVar)) 
           /* if the x axes are the same for both, it's simple */ 
           (drPutWaveformYVec newWave (drGetWaveformYVec yVar)) 
           /* otherwise need to use value() to interpolate */ 
           (let (xVec yVec len) 
                (setq xVec (drGetWaveformXVec xVar)) 
                (setq len (drVectorLength xVec)) 
                (setq yVec (drCreateVec (drGetWaveformYType yVar) len)) 
                (for ind 0 (sub1 len) 
                     (drAddElem yVec (value yVar (drGetElem xVec ind))) 
                     ) 
                (drPutWaveformYVec newWave yVec) 
                ) 
           ) 
       newWave 
       ) 
  ) 


