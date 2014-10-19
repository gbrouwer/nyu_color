function ds = cerulean_RGB2XYZ(ds)


%Reshape if more than 2 dimensions
ds.LUM = [];
ds.XYZ = [];
ndimensions = ndims(ds.RGB);
if (ndimensions > 2)
  [s1,s2,s3] = size(ds.RGB);
  ds.RGB = reshape(ds.RGB,s1*s2,s3);
end



%Convert to Luminance
ds.LUM(:,1) = (ds.RGB(:,1).^ds.red.gamma).*ds.red.Lmax;
ds.LUM(:,2) = (ds.RGB(:,2).^ds.green.gamma).*ds.green.Lmax;
ds.LUM(:,3) = (ds.RGB(:,3).^ds.blue.gamma).*ds.blue.Lmax;


%Convert to XYZ
ds.XYZ = (ds.LUM2XYZ' * ds.LUM')';


%Convert to xyz/Y
ds = cerulean_XYZ2xyY(ds);



%Reshape back
if (ndimensions > 2)
  ds.RGB = reshape(ds.RGB,s1,s2,s3);
  ds.LUM = reshape(ds.LUM,s1,s2,s3);
  ds.XYZ = reshape(ds.XYZ,s1,s2,s3);
  ds.xyz = reshape(ds.xyz,s1,s2,s3);
  ds.Y = reshape(ds.Y,s1,s2);
end