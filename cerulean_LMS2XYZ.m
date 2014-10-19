function ds = fandango_LMS2XYZ(ds)


%Reshape if more than 2 dimensions
ds.XYZ = [];
ndimensions = ndims(ds.LMS);
if (ndimensions > 2)
  [s1,s2,s3] = size(ds.LMS);
  ds.LMS = reshape(ds.LMS,s1*s2,s3);
end



%Convert to LMS
ds.XYZ = (ds.LMS2XYZ' * ds.LMS')';



%Reshape back
if (ndimensions > 2)
  ds.XYZ = reshape(ds.XYZ,s1,s2,s3);
  ds.LMS = reshape(ds.LMS,s1,s2,s3);
end