function ds = fandango_xyY2XYZ(ds)

%Reshape if more than 2 dimensions
ds.XYZ = [];
ndimensions = ndims(ds.xyz);
if (ndimensions > 2)
  [s1,s2,s3] = size(ds.xyz);
  ds.xyz = reshape(ds.xyz,s1*s2,s3);
  ds.Y = reshape(ds.Y,s1*s2,1);
end


%Convert
ds.XYZ(:,1) = (ds.Y ./ ds.xyz(:,2)) .* ds.xyz(:,1);
ds.XYZ(:,2) = ds.Y;
ds.XYZ(:,3) = (ds.Y ./ ds.xyz(:,2)) .* (1 - ds.xyz(:,1) - ds.xyz(:,2));


%Reshape back
if (ndimensions > 2)
  ds.xyz = reshape(ds.xyz,s1,s2,s3);
  ds.XYZ = reshape(ds.XYZ,s1,s2,s3);
  ds.Y = reshape(ds.Y,s1,s2);
end