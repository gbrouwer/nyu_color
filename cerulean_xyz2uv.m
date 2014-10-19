function ds = cerulean_xyz2uv(ds)

%Check Dimensionality of the input
ds.uv = [];
nodim = ndims(ds.xyz);
if (nodim > 2)
    [s1,s2,s3] = size(ds.xyz);
    ds.xyz = reshape(ds.xyz,s1*s2,s3);
end


%xyz -> uv
x = ds.xyz(:,1);
y = ds.xyz(:,2);
u = (4.*x) ./ (-2.*x + 12.*y + 3);
v = (9.*y) ./ (-2.*x + 12.*y + 3);
ds.uv = [u v];


%Transform back
if (nodim > 2)
    ds.uv = reshape(ds.uv,s1,s2,2);
    ds.xyz = reshape(ds.xyz,s1,s2,s3);
end


