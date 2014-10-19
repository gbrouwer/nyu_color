function ds = fandango_XYZ2LMS(ds)


%Reshape if more than 2 dimensions
ds.LMS = [];
ndimensions = ndims(ds.XYZ);
if (ndimensions > 2)
  [s1,s2,s3] = size(ds.XYZ);
  ds.XYZ = reshape(ds.XYZ,s1*s2,s3);
end



%Convert to LMS
ds.LMS = (ds.XYZ2LMS' * ds.XYZ')';



%Reshape back
if (ndimensions > 2)
  ds.XYZ = reshape(ds.XYZ,s1,s2,s3);
  ds.LMS = reshape(ds.LMS,s1,s2,s3);
end