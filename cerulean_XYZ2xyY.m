function ds = cerulean_XYZ2xyY(ds)


%Reshape if more than 2 dimensions
ndimensions = ndims(ds.XYZ);
ds.xyz = [];
ds.Y = [];
if (ndimensions > 2)
  [s1,s2,s3] = size(ds.XYZ);
  ds.XYZ = reshape(ds.XYZ,s1*s2,s3);
end


%Convert
ds.xyz(:,1) = ds.XYZ(:,1) ./ sum(ds.XYZ')';
ds.xyz(:,2) = ds.XYZ(:,2) ./ sum(ds.XYZ')';
ds.xyz(:,3) = 1 - ds.xyz(:,1) - ds.xyz(:,2);
ds.Y = ds.XYZ(:,2);


%reshape back
if (ndimensions > 2)
  ds.XYZ = reshape(ds.XYZ,s1,s2,s3);
  ds.xyz = reshape(ds.xyz,s1,s2,s3);
  ds.Y = reshape(ds.Y,s1,s2);
end
