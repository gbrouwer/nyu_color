function ds = cerulean_RGB2ALL(ds)


%Reshape if more than 2 dimensions
ds.LMS = [];
ds.LAB = [];
ds.XYZ = [];
ds.xyz = [];
ds.LAB = [];
ds.DKL = [];
ds.Y = [];
ndimensions = ndims(ds.RGB);
if (ndimensions > 2)
  [s1,s2,s3] = size(ds.RGB);
  ds.RGB = reshape(ds.RGB,s1*s2,s3);
end


%Convert RGB to XYZ/LAB/xyY
ds = cerulean_RGB2XYZ(ds);
ds = cerulean_XYZ2LAB(ds);
ds = cerulean_XYZ2xyY(ds);



%Convert to LMS
ds = cerulean_XYZ2LMS(ds);


  
%%Remove whitepoint
ds.LMS(:,1) = ds.LMS(:,1) - ds.whitepoints.LMS(1);
ds.LMS(:,2) = ds.LMS(:,2) - ds.whitepoints.LMS(2);
ds.LMS(:,3) = ds.LMS(:,3) - ds.whitepoints.LMS(3);



%Convert to DKL
ds = cerulean_LMS2DKL(ds);

 
 
%Reshape back
if (ndimensions > 2)
  ds.DKL = reshape(ds.DKL,s1,s2,s3);
  ds.LAB = reshape(ds.LAB,s1,s2,s3);
  ds.LMS = reshape(ds.LMS,s1,s2,s3);
  ds.RGB = reshape(ds.RGB,s1,s2,s3);
  ds.XYZ = reshape(ds.XYZ,s1,s2,s3);
  ds.xyz = reshape(ds.xyz,s1,s2,s3);
  ds.Y = reshape(ds.Y,s1,s2);
end