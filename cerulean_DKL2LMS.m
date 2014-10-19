function ds = cerulean_DKL2LMS(ds)


%Check Dimensionality of the input
ds.conecontrast = [];
ds.LMS = [];
nodim = ndims(ds.DKL);
if (nodim > 2)
    [s1,s2,s3] = size(ds.DKL);
    ds.DKL = reshape(ds.DKL,s1*s2,s3);
end


%DKL -> LMS
ds.LMS = (ds.DKL2LMS * ds.DKL')';


%Transform back
if (nodim > 2)
    ds.LMS = reshape(ds.LMS,s1,s2,s3);
    ds.DKL = reshape(ds.DKL,s1,s2,s3);
end


