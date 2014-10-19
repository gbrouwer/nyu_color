function cerulean_VonKries


%Init
clc;
method = 1;
vonKries = [0.40024  -0.22630   0.00000 ;  0.70760   1.16532   0.00000 ; -0.08081   0.04570   0.91822];
Bradford = [ 0.8951   -0.7502    0.0389  ;  0.2664    1.7135   -0.0685  ; -0.1614    0.0367    1.0296];


%Read
imsize = [256 256];
randimage = num2str(ceil(rand*600));
im = imread(['/Local/Users/gbrouwer/Toolboxes/cerulean/image data/jpgs/' randimage '.jpg'],'jpg');
load('cerulean_LCD at scanner - 10262010');
im = im2double(im);
im = imresize(im,imsize);
im(im < 0) = 0;
im(im > 1) = 1;
[d1,d2,d3] = size(im);
stepsize = round(sqrt(d1*d2))/2;
 

%Convert
origim = im;
im = reshape(im,d1*d2,d3);
ds.RGB = im;
ds = Cerulean_RGB2XYZ(ds);
ds.origxyz = ds.xyz;
ds.origRGB = ds.RGB;



%Adaptation
meanXYZ = mean(ds.XYZ);
if (method == 1)
    cones_mean = meanXYZ * vonKries;
    cones_whitepoint = ds.whitepoints.XYZ * vonKries;
    matrix = [cones_whitepoint(1)/cones_mean(1) 0 0 ; 0 cones_whitepoint(2)/cones_mean(2) 0 ; 0 0 cones_whitepoint(3)/cones_mean(3)];
    convert_matrix = vonKries * matrix * inv(vonKries);
end
if (method == 2)
    cones_mean = meanXYZ * Bradford;
    cones_whitepoint = ds.whitepoints.XYZ * Bradford;
    matrix = [cones_whitepoint(1)/cones_mean(1) 0 0 ; 0 cones_whitepoint(2)/cones_mean(2) 0 ; 0 0 cones_whitepoint(3)/cones_mean(3)];
    convert_matrix = Bradford * matrix * inv(Bradford);
end



%Convert Back
ds.XYZnew = ds.XYZ * convert_matrix;
ds.XYZ = ds.XYZnew;
ds = Cerulean_XYZ2RGB(ds);
ds = Cerulean_RGB2XYZ(ds);
newim = ds.RGB;
newim = reshape(newim,d1,d2,d3);
correctedim = newim;



%Plot
figure('Position',[1500 100 800 800]);
subplot(2,2,1);
imagesc(origim);
title('Original Image');

subplot(2,2,2);
sizer = ds.origxyz(1:stepsize:end,1) * 200;
scatter(ds.origxyz(1:stepsize:end,1),ds.origxyz(1:stepsize:end,2),sizer,ds.origRGB(1:stepsize:end,:),'filled');
hold on;
plot(ds.colormetric.ciexi,ds.colormetric.cieyi,'k');
axis([0 0.9 0 0.9]);
box on; 

subplot(2,2,3);
imagesc(newim);
title('Corrected Image');    

subplot(2,2,4);
sizer = ds.xyz(1:stepsize:end,1) * 200;
scatter(ds.xyz(1:stepsize:end,1),ds.xyz(1:stepsize:end,2),sizer,ds.RGB(1:stepsize:end,:),'filled');
hold on;
plot(ds.colormetric.ciexi,ds.colormetric.cieyi,'k');
axis([0 0.9 0 0.9]);
box on; 

ds.XYZ = meanXYZ;
ds = Cerulean_XYZ2RGB(ds);
ds = Cerulean_RGB2XYZ(ds);
subplot(2,2,2);
h = scatter(ds.xyz(1,1),ds.xyz(1,2),'filled');
set(h,'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[ds.RGB(1,:)]);
h = get(h,'Children');
set(h,'MarkerSize',20);

subplot(2,2,4);
h = scatter(ds.whitepoints.xyz(1,1),ds.whitepoints.xyz(1,2),'filled');
set(h,'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[ds.whitepoints.RGB(1,:)]);
h = get(h,'Children');
set(h,'MarkerSize',20);    

