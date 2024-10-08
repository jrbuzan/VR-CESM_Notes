{\rtf1\ansi\ansicpg1252\cocoartf2639
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fswiss\fcharset0 Helvetica;}
{\colortbl;\red255\green255\blue255;\red53\green134\blue255;\red16\green60\blue192;}
{\*\expandedcolortbl;;\cssrgb\c25490\c61176\c100000;\cssrgb\c6667\c33333\c80000;}
\paperw11900\paperh16840\margl1440\margr1440\vieww16520\viewh16380\viewkind0
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0

\f0\fs24 \cf0 ############################\
#************************************#\
#                VR-CESM                  #\
#************************************#\
# User guide                                #\
# Written by:                                #\
# Jonathan R. Buzan                   #\
# 18.09.2024                               #\
#************************************#\
############################\
\
################################################\
This is a multistep guide to generate a new grid using CESM3 with variable resolution. Furthermore, there are multiple documents with details on execution of each step. They are not collated into one place. But, I refer to them because they have more details than I write below.\
\
Outline of steps:\
1) generating a rotated Cubic-Sphere grid\
2) preliminary nested grid.\
3) cleaning the grid.\
4) generating the Exodus\
5) Plotting the Exodus for clear results\
6) generating the control volumes to make LATLON and SCRIP files.\
7) Generating the input files: ESMF Mesh, gen_CLMsrfdata, gen_CAMncdata, gen_atmsrf, and gen_topo.\
8) creating a case, and changing the xml files. \
9) execute 5 day run to check stability. \
10) this expands to 7 day check. Followed by another 7 day check. If this is succeeding, repeat a few more times to generate a CAM initialization file.\
11) Then the land surface needs to be spun up.\
12) Simulation is ready to go.\
################################################\
\
################################################\
################################################\
# **************************************************************** #\
All of the tools below require GCC (aka GNU), ESMF, netcdf, gmake, and cmake. ESMF requires PIO. Recommended is pnetcdf. Also required are NCL, NCO/CDO. \
# **************************************************************** #\
\
# **************************************************************** #\
Follow the instructions for installing ESMF and PIO with gcc compiler: \
https://github.com/wyssacademy-unibe-ch/climate_wiki/tree/main/installation_notes_cesm\
# **************************************************************** #\
\
# **************************************************************** #\
Follow the instructions for installing NCL/NCO/CDO:\
https://github.com/wyssacademy-unibe-ch/climate_wiki/commit/40a473cac156daac4f096c84c79145e480e0201c\
# **************************************************************** #\
\
# **************************************************************** #\
################################################\
# **************************************************************** #\
Remember to load the same compilers, modules, and paths that were used to make the ESMF gnu version before beginning or continuing any session with generating a grid.\
# **************************************************************** #\
################################################\
\
\
################################################\
Detailed steps:\
################################################\
1) Generate the Cubic-Sphere Grid\
################################################\
\
The first stem is downloading the community mesh making kit. \
\pard\pardeftab720\partightenfactor0
\cf0 \expnd0\expndtw0\kerning0
 {\field{\*\fldinst{HYPERLINK "https://eur03.safelinks.protection.outlook.com/?url=https%3A%2F%2Fgithub.com%2FESMCI%2FCommunity_Mesh_Generation_Toolkit%2F&data=05%7C02%7Cjonathan.buzan%40unibe.ch%7C5d64323535994b80576508dc3a441ba6%7Cd400387a212f43eaac7f77aa12d7977e%7C1%7C0%7C638449311567542620%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C0%7C%7C%7C&sdata=Ph6JA9KFOQcIJ442iHDQvHdPm%2FqSA4%2Fqfd9QdAri3gQ%3D&reserved=0"}}{\fldrslt \cf2 \ul \ulc2 https://github.com/ESMCI/Community_Mesh_Generation_Toolkit/}}\kerning1\expnd0\expndtw0 \
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0
\cf0 \
This toolkit has a majority of the tools required to build new grids for CESM3. \
After downloading the kit, the next useful tool is TigerVNC.  Part of the tools can use a visual GUI interface, and since the tools should be executed on a cluster system, this is the most efficient way to set up a GUI with the VRM_Editor.\
\
\pard\pardeftab720\partightenfactor0
\cf0 \expnd0\expndtw0\kerning0
\'a0{\field{\*\fldinst{HYPERLINK "https://eur03.safelinks.protection.outlook.com/?url=https%3A%2F%2Ftigervnc.org%2F&data=05%7C02%7Cjonathan.buzan%40unibe.ch%7C5d64323535994b80576508dc3a441ba6%7Cd400387a212f43eaac7f77aa12d7977e%7C1%7C0%7C638449311567551966%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C0%7C%7C%7C&sdata=ZuwN4S9PlICUg2szpc33vGVlyNxVkfg%2FvzRvh7Mqx0c%3D&reserved=0"}}{\fldrslt \cf2 \ul \ulc2 https://tigervnc.org/}}\cf2 \ul \ulc2 \
\
\pard\pardeftab720\partightenfactor0
\cf0 \kerning1\expnd0\expndtw0 \ulnone \
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0
\cf0 > cd  $COMMUNITYTOOLS/\expnd0\expndtw0\kerning0
VRM_Editor/src/ \
> qmake VRM_Editor.pro\
> make\
\
These tools are untested on Eiger. This will require some steps to generate an interactive session in the queue that can be tunneled to with the TigerVNC. \
If the user decides to use VRM_Editor:\
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0
\cf0 \kerning1\expnd0\expndtw0 ################################################\
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0
\cf0 \expnd0\expndtw0\kerning0
File: \
VRM_Editor_VRCESM.pdf\
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0
\cf0 \kerning1\expnd0\expndtw0 ################################################\
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0
\cf0 \expnd0\expndtw0\kerning0
\
I created this file as a visual guide to the VRM_Editor. \
Additionally, there is a guide from Adam Herrington at NCAR:\
\
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0
\cf0 \kerning1\expnd0\expndtw0 ################################################\
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0
\cf0 \expnd0\expndtw0\kerning0
File:\
MUSICA_Tutorial_2022-01-14_CreatingGrids.pdf\
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0
\cf0 \kerning1\expnd0\expndtw0 ################################################\
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0
\cf0 \expnd0\expndtw0\kerning0
\
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0
\cf0 \kerning1\expnd0\expndtw0 ################################################\
################################################\expnd0\expndtw0\kerning0
\
Ultimately, I do not recommend using the TigerVNC this step unless absolutely necessary (aka a brand new grid). It is buggy, and crashes. However, it is great for initially setting the grid and outputting: \
\
FILENAME:  ne0np4.THETITLE.neYYx??\
?? = to the level of refinement.\
YY = 30 for the ~1x1 grid.  YY can also be set to 60 for the ~0.5x0.5 grid.\
Note this should be the number of multiplication of x-y grid cells. For example, a ne30 grid (~1x1) that goes to a 0.125x0.125 grid would be 8, aka 3 levels of refinement, or 1/2 * 1/2 * 1/2 = 1/8  \'97>  ne0np4.THETITLE.ne30x8\
\
Exodus File:\
FILENAME_exodus.nc\
\
Refinement Grid File:\
FILENAME_refinemap_file.dat\
\
Refinement Map File:\
FILENAME_refinemap.nc\
\
These files are iterated on to make a clean grid. \
\
\
I have provided rotated coordinates and grid for the ne30 grid (~1x1) that can be used with SQuadGen using the command line. Granted, I never used SQuadGen. This would require building the software (with a make file) and following the readme for SQuadGen.\
\
Additionally, Prof. Jan Driasma (Mathematisches Institut, UniBe), has provided a wolfram notebook which produces a rotated orientation for a grid. This would need to be rewritten in python and tested (Wolfram is amazing software, but is financially expensive). The notebook can be opened in wolfram notebook reader, but cannot be executed without a license.  \
\
What we got out of the notebook was a rotation that provided grid orients such that Switzerland, Kenya, Peru, and Laos are all \'93orthogonal\'94 to each other.\
\
\kerning1\expnd0\expndtw0 ################################################\
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0
\cf0 \expnd0\expndtw0\kerning0
File: \
wolfram_cube_rotation.nb\
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0
\cf0 \kerning1\expnd0\expndtw0 ################################################\
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0
\cf0 \expnd0\expndtw0\kerning0
\
Orientation:\
x:-58, y:-22, and lon: 32\
\
\kerning1\expnd0\expndtw0 The YouTube video at the time step 1897 shows editing a grid dat file.\
\
 https://www.youtube.com/live/tCbZA9JsD9I?si=AMJ-0eyL2gAijKla&t=1897\
\
The grid tools must be created. \
\
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0
\cf0 ################################################\
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0
\cf0 File:\
Makefile-Create_VRMgrid\
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0
\cf0 ################################################\
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0
\cf0 \
This file needs to be modified to work on your machine (e.g. Eiger). CC must be changed to the correct flag (see the ESMF installation information). Paths must be corrected, etc.  \
\
However, before executing the make command below, there is an error in the .cpp file. The executable will not accept the y-direction rotation. \
\
Error:\
       CommandLineDouble (MyGridYRotate       ,"x_rotate"      ,0.0);\
\
Replacement:\
       CommandLineDouble (MyGridYRotate       ,\'94y_rotate"      ,0.0);\
\
\
> make -f Makefile-Create_VRMgrid\
################################################\
\
################################################\
2) through 5) Refinement of the grid, cleaning the grid, generating the Exodus, and plotting the results.\
################################################\
\
The .dat file is an ASCII file. The dat file contains the information of where the nested regions are and what level of refinement. Combined with the other two files, the results will become the full grid. \
\
This step is a series of iterations where the dat file is edited, then recombined with the Exodus and Refinement Map files. The goal is to have smooth transitions between each nested region, with the requirement that the innermost regions have large enough extent to properly resolve synoptic scale activity. I generated a script that takes the user\'92s new dat file and combines them with the Exodus/Refinement map file. Upon completion, the new result is plotted so the user can see the results. \
\
Remember to load NCL.\
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0
\cf0 ################################################\
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0
\cf0 File:\
run_Create_VRMgrid.csh\
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0
\cf0 ################################################\
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0
\cf0 \
The most computationally efficient grid has no refinement that cross the cube-face edges/corners, with at least 4 grid points at the lowest resolution to the nearest transition zone, and continuing with at least 4 grid points between transition zones. The transition zones should be \'91clean\'92 with symmetric edges. If this is accomplished, the future file construction steps will be easier to complete, and the computational grid will be the most efficient. This is not to say that grids cannot cross edges or be irregularly shaped (e.g. Wills et al., 2024), but they are more difficult to implement and can be computationally inefficient.\
\
Below is an example of the iterative process. \
\
a) example modification of a .dat file. Zeros are the ne30 grid. 1 is the first level of refinement, 2 is the second, and 3 is the third.  \
\
b) an example of grid refinement with edges that are not symmetric. \
\
c) an example of grid refinement with adequate spacing between refinement areas, refinement not crossing edges/corners, large enough space between each refinement area, and finally, has a large enough innermost domain to resolve synoptic scale events.\
################################################\
\
################################################\
6) Create the Control Volumes: LATLON file and SCRIP Files. \
################################################\
\
The following follow steps from the Community mesh documentation.  Starting on page 20. This documentation goes into more detail about what these next grids are, and what they do.\
\
A repository directory needs to be created based upon the name of your Exodus filename and grid refinement.\
\
Example:\
ne0np4.GRIDNAME.neZZxRR\
\
Where GRIDNAME is the name of your grid.\
ZZ is the baseline resolution (for example 30 for ne30, aka ~1x1 grid). \
RR is the level of refinement. A refinement of 3 zones from ne30 is 8 (aka 2^3). \
\
> mkdir $(REPO)/ne0np4.GRIDNAME.neZZxRR/grids\
> mv GRIDNAME.neZZxRR_EXODUS.nc $(REPO)/ne0np4.GRIDNAME.neZZxRR/grids/\
\
Many of the routines are designed around a \'93standardized repository\'94.\
\
In the VRM_ControlVolumes:\
Edit the input.nl file.\
\
  GridPath = \'91$(REPO)/ne0np4.GRIDNAME.neZZxRR/grids/\'92\
          GridName = \'91GRIDNAME_neZZxRR\'92\
\
\
Execute: \
> ./Gen_ControlVolumes.exe input_nl\
\
If ./Gen_ControlVolumes.exe does not exist, then execute the makefile.  However, like, with everything before, the correct flags must be listed in the Makefile (CC, ESMF, etc.) Modify the Makefile then:\
> make\
\
Then:\
> ./Gen_ControlVolumes.exe input_nl\
\
This will generate the LATLON and SCRIP files. \
################################################\
\
################################################\
7) Generating the input files: ESMF Mesh, gen_CLMsrfdata, gen_CAMncdata, gen_atmsrf, and gen_topo.\
################################################\
\
Start with the ESMF Mesh Files.\
################################################\
The approach taken here is to create an ESMF mesh file from an existing SCRIP file of your grid. On casper, load ESMF serial libraries and locate the path to ESMF executables:\
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0
\cf0 \
################################################\
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0
\cf0 ::If you are on Derecho::\
module load mpi-serial/2.3.0\'a0\
module load esmf/8.5.0\
module show esmf/8.5.0\
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0
\cf0 ################################################\
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0
\cf0 \
Otherwise, the user should find the path within their ESMF_gnu path to the directory where the executable commands are.\
\
Module show will provide a bunch of directories; copy the \'93PATH\'94 directory, and look at it\'92s contents:\
ESMF_PrintInfo\'a0 ESMF_PrintInfoC\'a0 ESMF_Regrid\'a0 ESMF_RegridWeightGen\'a0 ESMF_Scrip2Unstruct\'a0 ESMF_WebServController\'a0 ESMX_Builder\
\
The executable ESMF_Scrip2Unstruct generates an ESMF mesh file from a SCRIP file.\
\
At the command line, execute the following:\
<PATH>/ESMF_Scrip2Unstruct <SCRIP_in.nc> <ESMF_out.nc> 0\
\
Note the \'930\'94 fulfills a required argument (run the executable with --help for description of what it sets).\
################################################\
\
################################################\
Now the generation of the CLM Surface Data\
################################################\
gen_CLMsrfdata \'97> don\'92t use this. Instead, download and install CTSM5.2 following the guidelines in: \
https://github.com/wyssacademy-unibe-ch/climate_wiki/tree/main/installation_notes_cesm\
\
NOTE: Currently, there is an issue with the ORGANICS in CTSM5.2.  A fix is underway.\
Then execute the following steps: \
\
On Derecho, checkout a CTSM5.2 tag:\
##These commands should work for Eiger##\
\
git clone https://github.com/ESCOMP/CTSM ctsm5.2.007\
cd ctsm5.2.007\
git checkout ctsm5.2.007\
bin/git-fleximod update\
\
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0
\cf0 ################################################\
##Fix was applied but hasn\'92t been released yet##\
################################################\
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0
\cf0 File:\
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural\partightenfactor0
\cf0 mksoiltexMod.F90\
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0
\cf0 ################################################\
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural\partightenfactor0
\cf0 \
> cp mksoiltexMod.F90 $\{YOURCTSMPATH\}/tools/mksurfdata_esmf/src/\
\
## Fix is now in directory after the git checkout. ##\
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0
\cf0 \
\
Note that the surface datasets will be generated in this directory tree, and therefore this should be cloned into your work or scratch directory where sufficient storage is available.\
OUTPUT FILES TAKE UP 50GB.\
Copy the directory to $SCRATCH before execution. \
\
Navigate into the tools/mksurfdata_esmf/ directory and build the executable:\
>  ./gen_mksurfdata_build\
\
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0
\cf0 ################################################\
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0
\cf0 ::If you are on Derecho::\
Generate a namelist file containing specifications for creating the surface datasets. First load the conda environment:\
module load conda/latest\
conda activate npl\
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0
\cf0 ################################################\
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0
\cf0 \
\
Generate a namelist file containing specifications for creating the surface datasets. Below is an example command. This generates the surface and land use datasets from 1979\'972026 using the SSP3-7.0 scenario, where the user enters their own ESMF mesh (created in the previous section). (Don\'92t forget to change the nx variable to match your ESMF Mesh). This would ideally be done for each climate scenario. But best to start with just getting one set of surface and land use files completed, and coming back to this step once there is a working CESM3 model setup.\
\
\
Run gen_mksurfdata_namelist:\
> ./gen_mksurfdata_namelist --res NATL_ne30x4 --start-year 1979 --end-year 2026 --ssp-rcp SSP3-7.0 --model-mesh NATL_ne30x4_np4_esmf.nc --model-mesh-nx 142346 --model-mesh-ny 1\
\
Run with --help for all available arguments. The ssp-rcp argument is to specify a future scenario for the transient landuse_timeseries file.\
\
Example of the command I executed:\
> ./gen_mksurfdata_namelist --res WYSS_LARGE.ne30x3_np4  --start-year 1979 --end-year 2026 --ssp-rcp SSP3-7.0 --model-mesh /glade/u/home/jbuzan/VRM_files/ne0np4.WYSS_LARGE.ne30x3/grids/ESMF_out/ne0np4.WYSS_LARGE.ne30x3_np4_ESMFmesh_c20240905.nc --model-mesh-nx 346718  --model-mesh-ny 1\
\
\
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0
\cf0 ################################################\
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0
\cf0 ::If you are on Derecho::\
Generate a batch submit script:\
> ./gen_mksurfdata_jobscript_single --number-of-nodes 4 --tasks-per-node 128 --namelist-file <namelist_file>\
\
In the resulting batch script, manually add in a working project code and submit it to derecho:\
> qsub <single_batch_job>\
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0
\cf0 ################################################\
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0
\cf0 \
\
In theory, this could be executed on Eiger with generating a batch script. Executing on front end node will not work. Large files + >12 hours of computational time. \
\
Monitor the log file for errors. A successful completion message will appear in the log once the job is complete, and should have produced two netcdf files \'96 the surface dataset file and transient landuse_timeseries file.\
\
Because I gave great care with the construction of my grid, I had no issues with executing this command script on Derecho. There were no errors. \
################################################\
\
################################################\
Now build the gen_atmsurf \
################################################\
Modify the MAKE_genAtmsrf_script.csh script following the instructions in the script.  \
This script also uses NCL.\
\
Execute:\
> ./MAKE_genAtmsrf_script.csh\
\
The user will likely have to modify the outcome a tiny bit because the script assumes that the paths are to a standardized repository.\
\
I had no issues, otherwise, and it executed fine.\
################################################\
\
################################################\
Now build the gen_topo\
################################################\
\
\pard\pardeftab720\partightenfactor0
\cf0 \expnd0\expndtw0\kerning0
Download: {\field{\*\fldinst{HYPERLINK "https://github.com/NCAR/Topo/wiki/User's-Guide"}}{\fldrslt \cf3 \ul \ulc3 https://github.com/NCAR/Topo/wiki/User's-Guide}}. \
Run the cube_to_target executable at the command line.\kerning1\expnd0\expndtw0 \
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0
\cf0 \
> cd $\{PATHTOTOPO\}/topo/cube_to_target\
\
Execute the make file.  As before, remember to check the flags in the Makefile to match the system the user is executing on.\
\
I was having trouble executing this on Derecho. Adam Herrington recommended just running it on the command line. \
However, I did get it to execute on Eiger.\
\
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0
\cf0 ################################################\
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0
\cf0 File:\
submit_to_queue.csh\
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0
\cf0 ################################################\
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0
\cf0 \
> ./submit_to_queue.csh\
\
There is a very useful ncl script in this directory. This script takes your topo file and your SCRIP file and reads in the topo information and plots it according to your SCRIP grid. This can be easily modified to operate on any of the files that are generated. For example, was able to plot vegetation, topography, and add country borders. \
################################################\
\
################################################\
Finally build the gen_CAMncdata\
################################################\
\
Adam Herrington suggest just using the ESMF commands to regrid the ncdata files. I could not get gen_CAMncdata to work on Derecho. Something related to compilers (these were designed for Cheyenne, the previous cluster system). I did get this to work on Eiger, but it is true that the real computer support is with ESMF not with gen_CAMncdata. \
\
If you use gen_CAMncdata:\
Modify the MAKE_interpic_script.csh script.\
\
Switch to NCO environment. \
The user may need to modify the script that is generated. Then execute the script. \
################################################\
\
\
################################################\
8) \'9712)  Setting up a case, implementing the files, and modifying the cfl criteria and other model tuning effects.\
################################################\
Now all, input boundary condition files should be complete.\
The next step is to follow the \
\
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0
\cf0 ################################################\
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0
\cf0 File:\
Simple_Users_guide_VRCESM_changes_to_xml\
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0
\cf0 ################################################\
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0
\cf0 \
Instructions for modifications to a new case.\
\
Then follow the instructions for:\
\
File (in the VRM toolkit docs)\
CAM-tsteps-inic-for-newgrids_v0.pdf\
\
This is likely the most difficult part of the process for new users. The problem is that the errors are not entirely clear, and it is more like diagnosing what is going on. The big thing to be aware of, stability criteria for CAM must be maintained, or the model will behave poorly both in scientific results and utilizing computational resources. 7 day runs are continuously updated as the user slowly relaxes parameters down to a scaling factor 1. Anything going too fast will cause the instabilities to grow rather than collapse. \
\
I\'92ll quote the end of the pdf above:\
\'93The final product is then the last *cam.i.* file from a stable N = 1 run. This file contains initial conditions that are in balance with the new grid, and should be cherished.\'94\
\
Finally, after this step, a run would need to be executed to develop a ~5-10 year atmospheric time series.  Then this time is fed to CLM/CTSM in an \'91accelerated\'92 spinup case, to get the initial conditions file for the land model. \
\
When this is complete, all of the boundary conditions are done. Your configuration is ready to execute for production runs.\
\
 YMMV and Good Luck!\
################################################\
\
\
\
\
}