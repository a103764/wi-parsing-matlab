% filename_power = '/home/lasse/Documentos/5GMDATA/Rosslyn/myarea1/Rosslyn.power.t001_02.r016.p2m';
% filename_pl = '/home/lasse/Documentos/5GMDATA/Rosslyn/myarea1/Rosslyn.pl.t001_02.r016.p2m';
% filenamme_spread = '/home/lasse/Documentos/5GMDATA/Rosslyn/myarea1/Rosslyn.spread.t001_02.r016.p2m';
% filename_cir = '/home/lasse/Documentos/5GMDATA/Rosslyn/myarea1/Rosslyn.cir.t001_02.r016.p2m';
% filename_paths = '/home/lasse/Documentos/5GMDATA/Rosslyn/myarea1/Rosslyn.paths.t001_02.r016.p2m';



%% Script to read files p2m
%% Results per receiver
% Read the total received power (dBm) %% 
[power_phase,rx,rx_position] = power_insite(filename_power);

% Read Path Loss (dB) % 
[pl_db] = pldb_insite(filename_pl);

% Delay Spread (sec) % 
[delayspread] = ds_insite(filename_spread);

% -250 is the power threshold to eliminate the receiver 
for i = 1:rx
    if power_phase(i,1) == -250 || length(power_phase)< rx 
        power_phase(i,:)= NaN;
    end
    if pl_db(i) == 250 || length(pl_db)< rx 
        pl_db(i)= NaN;
    end
end

%% Results per path
% Read the Complex Impulse Response
if rx ~=0
[time_arrival,powerpaths_dbm,powerphase_deg,rx_paths,path_max_rx] =cir_insite(rx,paths_max,filename_cir);
else
    powerpaths_dbm=-Inf;
    powerphase_deg=0;
    rx_paths=0;
    total_paths=0;
    paths_summary=0;
end

if powerpaths_dbm==-Inf
    powerpaths_W=0;
else
   powerpaths_W = dbm2W(powerpaths_dbm,ls_db); 
end

% Read the Propagation Paths
[rx_matrix,path_int,path_info,path_des,path_int_position] = paths_insite(rx,filename_paths,rx_paths,path_max_rx);