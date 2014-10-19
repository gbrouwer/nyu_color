function cerulean_calibrate(whitepoint,monitor,verbosity,stepsize)


%Init;
clc;
ds = [];
ds.monitorid = monitor;
ds.userwhitepoint = whitepoint;
ds.rootdir = cd;




%Load the Calibration data
ds = cerulean_load_calibration(ds);

 


%Determine xdata range
[~,elements] = size(ds.calibration.lum);
ds.calibration.stepsize = stepsize;
ds.calibration.xdata = 0:stepsize:1;
ds.calibration.xdata = ds.calibration.xdata(end-elements+1:end);
ds.red.gamut = squeeze(ds.calibration.xy(1,end,:));
ds.green.gamut = squeeze(ds.calibration.xy(2,end,:));
ds.blue.gamut = squeeze(ds.calibration.xy(3,end,:));




%Fit Gammas
ds = cerulean_fitgammas(ds);




%Setup LUM -> XYZ conversion matrix
xr = ds.red.gamut(1);
yr = ds.red.gamut(2);
zr = 1 - xr - yr;
xg = ds.green.gamut(1);
yg = ds.green.gamut(2);
zg = 1 - xg - yg;
xb = ds.blue.gamut(1);
yb = ds.blue.gamut(2);
zb = 1 - xb - yb;
ds.LUM2XYZ = [xr/yr xg/yg xb/yb; 1 1 1 ; zr/yr zg/yg zb/yb]';
ds.XYZ2LUM = inv(ds.LUM2XYZ);




%Setup XYZ -> LMS conversion matrix
xpc = 0.7465;
xdc = 1.4000;
xtc = 0.1748;
ypc = 0.2535;
ydc = -0.400;
ytc = 0;
zpc = 0;
zdc = 0;
ztc = 0.8252;
kl = 0.2535;
km = -0.400;
ks = 0.01327;
kmatrix = [kl 0 0 ; 0 km 0 ; 0 0 ks];
ds.XYZ2LMS = (kmatrix * inv([xpc xdc xtc ; ypc ydc ytc ; zpc zdc ztc]))';
ds.LMS2XYZ = inv(ds.XYZ2LMS);




%Whitepoints
ds.xyz = [ds.userwhitepoint(1) ds.userwhitepoint(2) 1-ds.userwhitepoint(1)-ds.userwhitepoint(2)];
ds.Y = ds.userwhitepoint(3);
ds = cerulean_xyY2XYZ(ds);
ds = cerulean_XYZ2RGB(ds);
ds.whitepoints.RGB = ds.RGB;
ds.whitepoints.xyz = ds.xyz;
ds.whitepoints.XYZ = ds.XYZ;
ds = cerulean_XYZ2LAB(ds);
ds.whitepoints.LAB = ds.LAB;
ds.whitepoints.LMS = (ds.XYZ2LMS' * ds.XYZ')';




%Setup LMS->DKL conversion matrix
matrix = ([1 1 0 ; 1 -ds.whitepoints.LMS(1)/ds.whitepoints.LMS(2) 0 ; -1 -1 ((ds.whitepoints.LMS(1)+ds.whitepoints.LMS(2)) / ds.whitepoints.LMS(3))]);
invmatrix = inv(matrix);
isochrom_raw = invmatrix(:,1);
rgisolum_raw = invmatrix(:,2);
sisolum_raw = invmatrix(:,3);
isochrom_raw_pooled = norm(isochrom_raw ./ ds.whitepoints.LMS');
rgisolum_raw_pooled = norm(rgisolum_raw ./ ds.whitepoints.LMS');
sisolum_raw_pooled = norm(sisolum_raw ./ ds.whitepoints.LMS');
isochrom_unit = isochrom_raw ./ isochrom_raw_pooled;
rgisolum_unit = rgisolum_raw ./ rgisolum_raw_pooled;
sisolum_unit = sisolum_raw ./ sisolum_raw_pooled;
lum_resp_raw = matrix * isochrom_unit;
l_minus_m_resp_raw = matrix * rgisolum_unit;
s_minus_lum_resp_raw = matrix * sisolum_unit;
D_rescale = [1/lum_resp_raw(1) 0 0 ; 0 1/l_minus_m_resp_raw(2) 0 ; 0 0 1/s_minus_lum_resp_raw(3)];
ds.LMS2DKL = D_rescale * matrix;
ds.DKL2LMS = inv(ds.LMS2DKL);




%Save Calibration
ds = cerulean_output(ds);
cd('save data');
save(['cerulean_' ds.monitorid],'ds');
cd ..





%Plot Calibration
if (verbosity > 0)
  ds = cerulean_plot_calibration(ds);
end



