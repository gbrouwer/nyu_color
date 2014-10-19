function ds = cerulean_XYZ2RGB(ds)


%Reshape if more than 2 dimensions
ds.RGB = [];
ds.LUM = [];
ndimensions = ndims(ds.XYZ);
if (ndimensions > 2)
  [s1,s2,s3] = size(ds.XYZ);
  ds.XYZ = reshape(ds.XYZ,s1*s2,s3);
end



%Convert to LUM
ds.LUM = (ds.XYZ2LUM' * ds.XYZ')';
minval = min(ds.LUM');
ds.invalid = (minval < 0);
ds.LUM(ds.LUM < 0) = 0;



%Convert LUM to RGB
ds.RGB(:,1) = ds.LUM(:,1)./ds.red.Lmax;
ds.RGB(:,2) = ds.LUM(:,2)./ds.green.Lmax;
ds.RGB(:,3) = ds.LUM(:,3)./ds.blue.Lmax;
ds.RGB(:,1) = ds.RGB(:,1).^(1./ds.red.gamma);
ds.RGB(:,2) = ds.RGB(:,2).^(1./ds.green.gamma);
ds.RGB(:,3) = ds.RGB(:,3).^(1./ds.blue.gamma);



%Reshape back
if (ndimensions > 2)
  ds.LUM = reshape(ds.LUM,s1,s2,s3);
  ds.RGB = reshape(ds.RGB,s1,s2,s3);
  ds.XYZ = reshape(ds.XYZ,s1,s2,s3);
  ds.invalid = reshape(ds.invalid,s1,s2);
end



%Correct
ds.RGB(ds.RGB < 0) = 0;
ds.RGB(ds.RGB > 1) = 1;
