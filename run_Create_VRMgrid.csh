#!/bin/tcsh -fv
################


setenv MASTERDIR /glade/u/home/jbuzan/Community_Mesh_Generation_Toolkit-master/VRM_tools/VRM_Editor/src/
setenv DATDIR ${MASTERDIR}Grids_JBUZAN/Grids_MODS/
setenv REFDIR ${MASTERDIR}Grids_JBUZAN/Grids_ORIG/
setenv OUTDIR ${MASTERDIR}Grids_JBUZAN/Grids_NEW/

#setenv reftype LOWCONN
setenv reftype CUBIT
setenv grtype CubeSquared
#setenv smthtype SPRING
setenv smthtype NONE
setenv resolu 30
setenv reflvl 3
setenv teslate 0
setenv subcel 0
setenv smdist 0
setenv smiter 0
setenv revorie 
setenv xaxis -58
setenv yaxis -22
setenv laxis 32

setenv MAPFILE ne0np4.x-58.y-22.l32_rc3_none0_ne30x_newmesh_v03_04
setenv ofile ${OUTDIR}ne0np4.x-58.y-22.l32_rc3_none0_ne30x_newmesh_v03_04.nc
setenv refcube ${DATDIR}ne0np4.x-58.y-22.l32_rc3_none0_ne30x_refinemap_file.dat

#setenv MAPFILE ne0np4.x-58.y-22.l32_rc3_none0_ne30x_newmesh_v01_small_04
#setenv ofile ${OUTDIR}ne0np4.x-58.y-22.l32_rc3_none0_ne30x_newmesh_v01_small_04.nc
#setenv refcube ${DATDIR}ne0np4.x-58.y-22.l32_rc3_none0_ne30x_refinemap_file_small.dat


#setenv ifile ${REFDIR}ne0np4.x-58.y-22.l32_Z3_rc3_sprn0_ne30x_refinemap.nc
setenv ifile ${REFDIR}ne0np4.x-58.y-22.l32_rc3_none0_ne30x_refinemap.nc
echo ${ifile}
ls ${ifile}
#setenv ifile ${REFDIR}ne0np4.x-58.y-22.l32_Z3_rl3_sprn0_ne30x_refinemap.nc
#setenv ofile ${OUTDIR}ne0np4.x-58.y-22.l32_Z3_rl3_sprn0_ne30x_newmesh_v08.nc
#setenv ofile ${OUTDIR}ne0np4.x-58.y-22.l32_Z3_rc3_sprn0_ne30x_newmesh_v01.nc
#setenv ofile ${OUTDIR}ne0np4.x-58.y-22.l32_rc3_none0_ne30x_newmesh_v01.nc
#setenv refcube ${DATDIR}ne0np4.x-58.y-22.l32_Z3_rl3_sprn0_ne30x_refinemap_file.dat
#setenv refcube ${DATDIR}ne0np4.x-58.y-22.l32_rc3_none0_ne30x_refinemap_file.dat

${MASTERDIR}Create_VRMgrid --refine_type ${reftype} --grid_type ${grtype} --smooth_type ${smthtype} --resolution ${resolu} --refine_level ${reflvl} --tessellate ${teslate} --subcells ${subcel} --smooth_dist ${smdist} --smooth_iter ${smiter} --x_rotate ${xaxis} --y_rotate ${yaxis} --lon_shift ${laxis} --refine_file ${ifile} --output ${ofile} --refine_cube ${refcube}

ncl /glade/u/home/jbuzan/Community_Mesh_Generation_Toolkit-master/VRM_tools/VRM_Diagnostics/plotting/gridplot.jrb.Z3.ncl


exit
################
