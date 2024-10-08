#!/bin/tcsh -fv
################




printenv

srun ./cube_to_target --grid_descriptor_file='/users/jbuzan/VRCESM_data/ne0np4.WYSS_LARGE.ne30x3/grids/ne0np4.WYSS_LARGE.ne30x3_np4_classic_SCRIP.nc'  --intermediate_cs_name='/users/jbuzan/VRCESM_data/ne0np4.WYSS_LARGE.ne30x3/grids/gmted2010_modis_bedmachine-ncube3000-220518.nc'  --rrfac_max=8 --smoothing_scale=100.0 --output_grid='ne30pg3_8_WYSSLarge_Eiger' --name_email_of_creator='Jonathan R Buzan, jonathan.buzan@unibe.ch' >& LOG_WYSS_LARGE_eiger
