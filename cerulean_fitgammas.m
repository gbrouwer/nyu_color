function ds = cerulean_fitgammas(ds)


%Init
maxIter= inf;                                                                                                                                                     
optimParams = optimset('MaxIter',maxIter,'Display', 'off');      


%Fit
ds.red.luminances = ds.calibration.lum(1,:);
ds.green.luminances = ds.calibration.lum(2,:);
ds.blue.luminances = ds.calibration.lum(3,:);
ds.red.Lmax = ds.red.luminances(1,end);
ds.green.Lmax = ds.green.luminances(1,end);
ds.blue.Lmax = ds.blue.luminances(1,end);
ds.red.gamma = lsqnonlin(@cerulean_gamma_fit,0.5,0,10,optimParams,ds.calibration.xdata,ds.red.luminances);
ds.green.gamma = lsqnonlin(@cerulean_gamma_fit,0.5,0,10,optimParams,ds.calibration.xdata,ds.green.luminances);
ds.blue.gamma = lsqnonlin(@cerulean_gamma_fit,0.5,0,10,optimParams,ds.calibration.xdata,ds.blue.luminances);