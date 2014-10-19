function ds = cerulean_XYZ2LAB(ds)

%Reshape if more than 2 dimensions
ds.LAB = [];
ndimensions = ndims(ds.XYZ);
if (ndimensions > 2)
  [s1,s2,s3] = size(ds.XYZ);
  ds.XYZ = reshape(ds.XYZ,s1*s2,s3);
end



%L
L = ds.XYZ(:,2) ./ ds.whitepoints.XYZ(2);
sigma = (6/29).^3;
dum = (L > sigma);
L(dum) = L(dum).^(1/3);
L(~dum) = (1/3).*((29/6).^2).*L(~dum) + 4/29;
L = (L .* 116) - 16;



%A
A1 = ds.XYZ(:,1) ./ ds.whitepoints.XYZ(1);
A2 = ds.XYZ(:,2) ./ ds.whitepoints.XYZ(2);
sigma = (6/29).^3;
dum1 = (A1 > sigma);
dum2 = (A2 > sigma);
A1(dum) = A1(dum).^(1/3);
A2(dum) = A2(dum).^(1/3);
A1(~dum) = (1/3).*((29/6).^2).*A1(~dum) + 4/29;
A2(~dum) = (1/3).*((29/6).^2).*A2(~dum) + 4/29;
A = (A1 - A2).*500;



%B
B1 = ds.XYZ(:,2) ./ ds.whitepoints.XYZ(2);
B2 = ds.XYZ(:,3) ./ ds.whitepoints.XYZ(3);
sigma = (6/29).^3;
dum1 = (B1 > sigma);
dum2 = (B2 > sigma);
B1(dum) = B1(dum).^(1/3);
B2(dum) = B2(dum).^(1/3);
B1(~dum) = (1/3).*((29/6).^2).*B1(~dum) + 4/29;
B2(~dum) = (1/3).*((29/6).^2).*B2(~dum) + 4/29;
B = (B1 - B2).*200;



%Combine
ds.LAB = [L A B];



%Reshape back
if (ndimensions > 2)
  ds.XYZ = reshape(ds.XYZ,s1,s2,s3);
  ds.LAB = reshape(ds.LAB,s1,s2,s3);
end

