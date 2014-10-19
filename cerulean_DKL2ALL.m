function ds = cerulean_DKL2ALL(ds)

%Convert DKL -> ALL other color spaces
nodim = ndims(ds.DKL);
if (nodim > 2)
    [s1,s2,s3] = size(ds.DKL);
    ds.DKL = reshape(ds.DKL,s1*s2,s3);
end


%Azimuth and Elevation
ds.azimuth_rads = atan2(-ds.DKL(:,3),ds.DKL(:,2));
ds.azimuth_rads(ds.azimuth_rads < 0) = 2*pi + ds.azimuth_rads(ds.azimuth_rads < 0);
ds.isolum_len = sqrt(ds.DKL(:,2).^2 + ds.DKL(:,3).^2);
ds.elevation_rads = atan(ds.DKL(:,1) ./ ds.isolum_len);
ds.azimuth = ds.azimuth_rads .* (360/(2*pi));
ds.elevation = ds.elevation_rads .* (360/(2*pi));


ds = cerulean_RGB2XYZ(ds);
ds = cerulean_XYZ2xyY(ds);
ds = cerulean_xyz2uv(ds);

%To LMS and XYZ
ds = cerulean_DKL2LMS(ds);
ds = cerulean_LMS2XYZ(ds);
ds.XYZ(:,1) = ds.whitepoints.XYZ(:,1) + ds.XYZ(:,1);
ds.XYZ(:,2) = ds.whitepoints.XYZ(:,2) + ds.XYZ(:,2);
ds.XYZ(:,3) = ds.whitepoints.XYZ(:,3) + ds.XYZ(:,3);



%Reshape
if (nodim == 3)
    ds.DKL = reshape(ds.DKL,s1,s2,s3);
    ds.XYZ = reshape(ds.XYZ,s1,s2,s3);
    ds.LMS = reshape(ds.LMS,s1,s2,s3);
    ds.azimuth = reshape(ds.azimuth,s1,s2);
    ds.isolum_len = reshape(ds.isolum_len,s1,s2);
    ds.elevation = reshape(ds.elevation,s1,s2);
    ds.azimuth_rads = reshape(ds.azimuth_rads,s1,s2);
    ds.elevation_rads = reshape(ds.elevation_rads,s1,s2);
end
ds = cerulean_XYZ2RGB(ds);
ds = cerulean_XYZ2LAB(ds);
ds = cerulean_XYZ2xyY(ds);
