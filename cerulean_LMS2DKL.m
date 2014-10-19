function ds = Cerulean_LMS2DKL(ds)


%Converting LMS cone excitations to DKL 


%Check Dimensionality of the input
ds.DKL = [];
nodim = ndims(ds.LMS);
if (nodim > 2)
    [s1,s2,s3] = size(ds.LMS);
    ds.LMS = reshape(ds.LMS,s1*s2,s3);
end


%LMS -> DKL
ds.DKL = (ds.LMS2DKL * ds.LMS')';


%Calculate azimuths and elevations
warning off;
ds.azimuth_rads = atan2(-ds.DKL(:,3),ds.DKL(:,2));
ds.azimuth_rads(ds.azimuth_rads < 0) = 2*pi + ds.azimuth_rads(ds.azimuth_rads < 0);
ds.isolum_len = sqrt(ds.DKL(:,2).^2 + ds.DKL(:,3).^2);
ds.elevation_rads = atan(ds.DKL(:,1) ./ ds.isolum_len);
ds.azimuth = ds.azimuth_rads .* (360/(2*pi));
ds.elevation = ds.elevation_rads .* (360/(2*pi));
warning on;


%Transform back
if (nodim > 2)
    ds.LMS = reshape(ds.LMS,s1,s2,s3);
    ds.DKL = reshape(ds.DKL,s1,s2,s3);
    ds.azimuth = reshape(ds.azimuth,s1,s2);
    ds.isolum_len = reshape(ds.isolum_len,s1,s2);
    ds.elevation = reshape(ds.elevation,s1,s2);
    ds.azimuth_rads = reshape(ds.azimuth_rads,s1,s2);
    ds.elevation_rads = reshape(ds.elevation_rads,s1,s2);
end


