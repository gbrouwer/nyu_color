function ds = cerulean_LAB2XYZ(ds)

%Reshape if more than 2 dimensions
ds.XYZ = [];
ndimensions = ndims(ds.LAB);
if (ndimensions > 2)
  [s1,s2,s3] = size(ds.LAB);
  ds.LAB = reshape(ds.LAB,s1*s2,s3);
end



%Y
L = ds.LAB(:,1);
L = (L + 16) .* (1/116);
dum = L > (6/29);
L(dum) = L(dum).^3;
L(~dum) = 3.*((6/29).^2).*(L(~dum) - (4/29));
Y = ds.whitepoints.XYZ(2) .* L;


%X
L = ds.LAB(:,1);
L = (L + 16) .* (1/116);
a = ds.LAB(:,2);
a = (1./500).*a;
X = L + a;
dum = X > (6/29);
X(dum) = X(dum).^3;
X(~dum) = 3.*((6/29).^2).*(X(~dum) - (4/29));
X = ds.whitepoints.XYZ(1) .* X;


%Z
L = ds.LAB(:,1);
L = (L + 16) .* (1/116);
b = ds.LAB(:,3);
b = (1./200).*b;
Z = L - b;
dum = Z > (6/29);
Z(dum) = Z(dum).^3;
Z(~dum) = 3.*((6/29).^2).*(Z(~dum) - (4/29));
Z = ds.whitepoints.XYZ(3) .* Z;



%Reshape back
ds.XYZ = [X Y Z];
if (ndimensions > 2)
  ds.XYZ = reshape(ds.XYZ,s1,s2,s3);
  ds.LAB = reshape(ds.LAB,s1,s2,s3);
end

