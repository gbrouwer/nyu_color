function ds = cerulean_load_calibration(ds)


%Load Calibration data
cd('calibration data');
cd(ds.monitorid);
fdir = dir;
[s1,s2] = size(fdir);
for m=3:s1
  fname = fdir(m).name;
  if ~isempty(strfind(fname,'calib'))
    load(fname)
    ds.calibration = calibration;
  end
end
cd(ds.rootdir);



%Load CIE tongue
cd('Colorimetric data');
load('cerulean_CIETongue.mat');
ds.colormetric.ciexi = ciexi;
ds.colormetric.cieyi = cieyi;
cd ..
