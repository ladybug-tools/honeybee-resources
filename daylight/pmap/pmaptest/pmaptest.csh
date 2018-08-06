#!/bin/tcsh

# Photon map sizes & bandwidths
set numGlobal = 10000
set numCaustic = 100000
set numDirect = 100000
set numBiasComp = 10000
set numVolume = 100000

set bwidth = 50
set biasCompFixedBwidth = 1000
set biasCompBwidth = '20 1000'

# Random seed for mkpmap
set rndSeed = '-apr 0'

# Rendering size
set imgSize = 200

# Exposure for ximage
set exp = '-e -4'

# Num processors for rtrace / mkpmap
set nProc = '-n 4'

# Max allowable % irradiance deviation between Classic/reference & pmap
set maxError = 10

# Number of measurement points in highlight for bias compensation test
# and distance from highlight centre
set biasCompSamples = 100
set biasCompRadius = 0.03

# % relative error averaged over RGB, pos passed through
set RCALC = 'rdiff(x, y) : if(x, (y - x) / x, 0); \
             dr = rdiff($4, $10); dg = rdiff($5, $11); \
             db = rdiff($6, $12); \
             $1 = $1; $2 = $2; $3 = $3; \
             $4 = floor(1000 * (dr + dg + db) / 3) / 10'
             
# Reference values
set causticRef = cornell-caustic.dat
set volumeRef = cornell-volume.dat


cat << _EOF_

This test suite verifies the installation of the RADIANCE photon map
extension through a series of comparisons between RADIANCE Classic and
RADIANCE with photon mapping using a simple Cornell box scene. A
side-by-side visual comparison of renderings using rpict is performed,
followed by a quantitative comparison of radiance/irradiance at discrete
measurement points using rtrace.

Choose test to run:

1) Photon emission (direct pmap) test
2) Global & precomputed pmap test
3) Caustic pmap test
4) Volume pmap test
5) Bias compensation test
6) All tests
7) Quit

_EOF_

chooseTest:
echo -n 'Your choice? '
set testType = $<
if ($testType !~ [1-7]) goto chooseTest
if ($testType == 7) then
   echo Have a nice day!
   exit
endif

# Set up bit mask for tests to perform
@ testMask = (1 << $testType - 1)
if ($testType == 6) @ testMask--

\rm -f *pm *pm.leaf *.amb err*.dat



#
# Test direct photons
#
if ($testMask & 1) then
   clear
   echo Photon Emission \(Direct Pmap\) Test: Visual Comparison\\n
   oconv cornell-emission.rad > cornell.oct
   echo Running mkpmap...
   mkpmap $rndSeed -apd cornell.dpm $numDirect cornell.oct
   echo \\nRunning rpict...
   rpict -x $imgSize -y $imgSize -vf cornell.vf \
      cornell.oct > cornell-rad.pic &
   rpict -x $imgSize -y $imgSize -vf cornell.vf \
      -ap cornell.dpm $bwidth cornell.oct > cornell-pmap.pic &
   wait
   echo cornell-rad: RADIANCE Classic direct illumination \(reference\).
   echo cornell-pmap: Direct photon map, will be noisy.
   echo \\nRenderings should be similar, with discernible emission pattern.
   ximage -e auto cornell-rad.pic cornell-pmap.pic &
   #clear
   echo
   echo Photon Emission \(Direct Pmap\) Test: Irradiance Comparison\\n
   echo Running rtrace...
   cat cornell-{wall,floor}.pos | rtrace $nProc -I -h -oov \
      cornell.oct > cornell-rad.dat
   cat cornell-{wall,floor}.pos | rtrace $nProc -I -h -oov \
      -ap cornell.dpm $bwidth cornell.oct > cornell-pmap.dat
   echo \\nPosX\\tPosY\\tPosZ\\t\%Error
   rlam cornell-rad.dat cornell-pmap.dat | rcalc -e ${RCALC:q} | tee err.dat
   set avgError = `cut -f4 err.dat | total -m`
   echo 'Average deviation (should be < '$maxError'%) = '$avgError'%'
   if (`ev "floor(if($avgError, $avgError, -($avgError)))"` < \
       $maxError) then
      echo Test successful.
   else
      echo 'Test *FAILED*, quitting.'
      exit 1
   endif
   if ($testMask > 1) then
      echo -n \\n'<Enter> for next test '
      echo $<
   endif
endif



#
# Test global photons
#
@ testMask = ($testMask >> 1)
if ($testMask & 1) then
   clear
   echo Global \& Precomputed Pmap Test: Visual Comparison\\n
   oconv cornell.rad > cornell.oct
   echo Running mkpmap...
   mkpmap $rndSeed -apg cornell1.gpm $numGlobal cornell.oct
   mkpmap $rndSeed -app cornell2.gpm $numGlobal $bwidth cornell.oct
   echo \\nRunning rpict...
   rpict -x $imgSize -y $imgSize -vf cornell.vf -af cornell-rad.amb \
      -ab 5 cornell.oct > cornell-rad.pic &
   rpict -x $imgSize -y $imgSize -vf cornell.vf -af cornell-pmap1.amb \
      -ab 1 -ap cornell1.gpm $bwidth cornell.oct > cornell-pmap.pic &
   rpict -x $imgSize -y $imgSize -vf cornell.vf -af cornell-pmap2.amb \
      -ab 1 -ap cornell2.gpm 1 cornell.oct > cornell-precomp-pmap.pic &      
   wait
   echo 
   echo cornell-rad: RADIANCE Classic global illumination \(reference\).
   echo cornell-pmap: Global photon map.
   echo cornell-precomp-pmap: Precomputed global photon map.
   echo \\nRenderings should be identical.
   ximage -e auto cornell-rad.pic cornell-pmap.pic cornell-precomp-pmap.pic &
   #clear
   echo
   echo Global \& Precomputed Pmap Test: Irradiance Comparison\\n
   echo Running rtrace...
   cat cornell-{floor,ceil,wall}.pos | rtrace $nProc -I -h -oov \
      -af cornell-rad.amb -ab 5 cornell.oct > cornell-rad.dat
   cat cornell-{floor,ceil,wall}.pos | rtrace $nProc -I -h -oov \
      -af cornell-pmap1.amb -ab 1 -ap cornell1.gpm $bwidth \
      cornell.oct > cornell-pmap1.dat
   cat cornell-{floor,ceil,wall}.pos | rtrace $nProc -I -h -oov \
      -af cornell-pmap2.amb -ab 1 -ap cornell2.gpm 1 \
      cornell.oct > cornell-pmap2.dat
   echo \\nPosX\\tPosY\\tPosZ\\t\%Error\\t\%Error\(precomp\)
   rlam cornell-rad.dat cornell-pmap1.dat | rcalc -e ${RCALC:q} > err1.dat
   rlam cornell-rad.dat cornell-pmap2.dat | rcalc -e ${RCALC:q} > err2.dat
   rlam err1.dat '\!cut -f4 err2.dat'
   set avgError1 = `cut -f4 err1.dat | total -m`
   set avgError2 = `cut -f4 err2.dat | total -m`
   echo 'Average deviation (should be < '$maxError'%) =' \
        $avgError1'%, '$avgError2'%'
   set avgError1 = `ev "floor(if($avgError1, $avgError1, -($avgError1)))"`
   set avgError2 = `ev "floor(if($avgError2, $avgError2, -($avgError2)))"`
   if ($avgError1 < $maxError && $avgError2 < $maxError) then
      echo Test successful.
   else
      echo 'Test *FAILED*, quitting.'
      exit 1
   endif
   if ($testMask > 1) then
      echo -n \\n'<Enter> for next test '
      echo $<
   endif
endif



#
# Test caustic photons
#
@ testMask = ($testMask >> 1)
if ($testMask & 1) then
   clear
   echo Caustic Pmap Test: Visual Comparison\\n
   oconv cornell-caustic.rad > cornell.oct
   echo Running mkpmap...
   mkpmap $nProc $rndSeed -apc cornell.cpm $numCaustic cornell.oct
   echo \\nRunning rpict...
   rpict -x $imgSize -y $imgSize -vf cornell.vf \
      cornell.oct > cornell-rad.pic &
   rpict -x $imgSize -y $imgSize -vf cornell.vf \
      -ap cornell.cpm $bwidth -ab 0 cornell.oct > cornell-pmap.pic &
   wait
   echo cornell-rad: RADIANCE Classic.
   echo cornell-pmap: Caustic photon map, caustic should appear below sphere.
   ximage -e auto cornell-rad.pic cornell-pmap.pic &
   #clear
   echo
   echo Caustic Pmap Test: Irradiance Comparison\\n
   echo Running rtrace...
   cat cornell-caustic.pos | rtrace $nProc -I -h -oov \
      -ap cornell.cpm $bwidth cornell.oct > cornell-pmap.dat
   # Uncomment to update reference file
   # \cp -f cornell-pmap.dat $causticRef
   echo \\nPosX\\tPosY\\tPosZ\\t\%Error
   rlam $causticRef cornell-pmap.dat | rcalc -e ${RCALC:q} | tee err.dat
   set avgError = `cut -f4 err.dat | total -m`
   echo 'Average deviation within caustic (should be < '$maxError'%)' \
        = $avgError'%'
   if (`ev "floor(if($avgError, $avgError, -($avgError)))"` < \
       $maxError) then
      echo Test successful.
   else
      echo 'Test *FAILED*, quitting.'
      exit 1
   endif
   if ($testMask > 1) then
      echo -n \\n'<Enter> for next test '
      echo $<
   endif
endif



#
# Test volume photons
#
@ testMask = ($testMask >> 1)
if ($testMask & 1) then
   clear
   echo Volume Pmap Test: Visual Comparison\\n
   oconv cornell-mist.rad > cornell.oct
   echo Running mkpmap...
   mkpmap $nProc $rndSeed -apv cornell.vpm $numVolume cornell.oct
   echo \\nRunning rpict...
   rpict -x $imgSize -y $imgSize -vf cornell.vf -ms 0.01 \
      cornell.oct > cornell-rad.pic &
   rpict -x $imgSize -y $imgSize -vf cornell.vf -ms 0.01 \
      -ap cornell.vpm $bwidth -ab 0 cornell.oct > cornell-pmap.pic &
   wait
   echo cornell-rad: RADIANCE Classic.
   echo cornell-pmap: Volume photon map, caustic should appear below sphere.
   ximage -e +0 cornell-rad.pic cornell-pmap.pic &
   #clear
   echo
   echo Volume Pmap Test: Radiance Comparison\\n
   echo Running rtrace...
   # Note we repeat for the same positions, generating a different pmap
   # on every iteration (via random seed) to average out inscattering 
   # sampling noise along the rays.
   cat cornell-volume.pos | rtrace $nProc -h -odv -lr 1 -ms 0.1 \
      -ap cornell.vpm $bwidth -ab 0 cornell.oct > cornell-pmap.dat
   @ i = 0
   while ($i < 10)
      mkpmap $nProc -apr $i -fo -apv cornell.vpm $numVolume cornell.oct
      cat cornell-volume.pos | rtrace $nProc -h -odv -lr 1 -ms 0.1 \
         -ap cornell.vpm $bwidth -ab 0 cornell.oct >> cornell-pmap.dat
      @ i++
   end
   # Uncomment to update reference file
   #\cp -f cornell-pmap.dat $volumeRef
   echo \\nDirX\\t\\tDirY\\t\\tDirZ\\t\\t\%Error
   # Average first, then diff; less sensitive to noise
   rlam "\!total -m $volumeRef" "\!total -m cornell-pmap.dat" | \
      rcalc -e ${RCALC:q} | tee err.dat
   set avgError = `cut -f4 err.dat`
   echo 'Average deviation within volume caustic (should be <' \
        $maxError'%) = '$avgError'%'
   if (`ev "floor(if($avgError, $avgError, -($avgError)))"` < \
       $maxError) then
      echo Test successful.
   else
      echo 'Test *FAILED*, quitting.'
      exit 1
   endif
   if ($testMask > 1) then
      echo -n \\n'<Enter> for next test '
      echo $<
   endif
endif



#
# Test bias compensation
#
@ testMask = ($testMask >> 1)
if ($testMask & 1) then
   clear
   echo Bias Compensation Test: Visual Comparison\\n
   oconv hilite.rad > hilite.oct
   echo Running mkpmap...
   mkpmap $rndSeed -apd hilite.dpm $numBiasComp hilite.oct
   echo \\nRunning rpict...
   rpict -x $imgSize -y $imgSize -vf hilite.vf \
      hilite.oct > hilite-rad.pic &
   rpict -x $imgSize -y $imgSize -vf hilite.vf \
      -ap hilite.dpm $biasCompFixedBwidth hilite.oct > hilite-pmap.pic &
   rpict -x $imgSize -y $imgSize -vf hilite.vf \
      -ap hilite.dpm $biasCompBwidth hilite.oct > hilite-pmap-biascomp.pic &
   wait
   echo hilite-rad: RADIANCE Classic direct illumination \(reference\)
   echo hilite-pmap: Photon map using fixed bandwidth, severely blurred
   echo hilite-pmap-biascomp: Photon map using bias compensation, blurring \
        reduced        
   echo \\nRADIANCE Classic and bias compensated photon map should have \
        similar irradiance. Irradiance from photon map using fixed \
        bandwidth will be substantially lower \(=bias\).
   ximage $exp hilite-rad.pic hilite-pmap.pic hilite-pmap-biascomp.pic &
   #clear
   echo
   echo Bias Compensation Test: Irradiance Comparison\\n
   echo Running rtrace...
   cnt $biasCompSamples | \
      rcalc -e '$1='$biasCompRadius'*cos(2*PI*$1/'$biasCompSamples'); \
                $2='$biasCompRadius'*sin(2*PI*$1/'$biasCompSamples'); \
                $3=0; $4=0; $5=0; $6=1' > hilite.pos                
   cat hilite.pos | rtrace $nProc -I -h -oov \
      hilite.oct > hilite-rad.dat
   cat hilite.pos | rtrace $nProc -I -h -oov \
      -ap hilite.dpm $biasCompFixedBwidth hilite.oct > hilite-pmap1.dat
   cat hilite.pos | rtrace $nProc -I -h -oov \
      -ap hilite.dpm $biasCompBwidth hilite.oct > hilite-pmap2.dat
   rlam hilite-rad.dat hilite-pmap1.dat | rcalc -e ${RCALC:q} > err1.dat
   rlam hilite-rad.dat hilite-pmap2.dat | rcalc -e ${RCALC:q} > err2.dat
   set avgError1 = `cut -f4 err1.dat | total -m`
   set avgError2 = `cut -f4 err2.dat | total -m`
   echo \\n'Average fixed bwidth deviation (should be > '$maxError'%)' \
        = $avgError1'%'
   echo 'Average bias compensation deviation (should be < '$maxError'%)' \
        = $avgError2'%'
   set avgError2 = `ev "floor(if($avgError2, $avgError2, -($avgError2)))"`
   if ($avgError2 < $maxError) then
      echo Test successful.
   else
      echo 'Test *FAILED*, quitting.'
      exit 1
   endif
endif

echo \\nTest suite completed -- have a nice day!

