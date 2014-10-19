function ds = cerulean_plot_calibration(ds)


%Init
figure('Position',[100 100 1200 800]);



%Plot Gamma Curves
subplot(3,4,1);hold on;
h = scatter(ds.calibration.xdata(1:3:end),ds.red.luminances(1:3:end),'filled');
set(h,'MarkerEdgeColor',[1 0 0],'MarkerFaceColor',[1 0 0]);
h = scatter(ds.calibration.xdata(1:3:end),ds.green.luminances(1:3:end),'filled');
set(h,'MarkerEdgeColor',[0 1 0],'MarkerFaceColor',[0 1 0]);
h = scatter(ds.calibration.xdata(1:3:end),ds.blue.luminances(1:3:end),'filled');
set(h,'MarkerEdgeColor',[0 0 1],'MarkerFaceColor',[0 0 1]);
axis([0 1 0 ceil(ds.green.Lmax)]);
box on; grid on;
xvals = linspace(0,1,100);
yvals = (xvals .^ ds.red.gamma) .* ds.red.Lmax;
plot(xvals,yvals,'r');
yvals = (xvals .^ ds.green.gamma) .* ds.green.Lmax;
plot(xvals,yvals,'g');
yvals = (xvals .^ ds.blue.gamma) .* ds.blue.Lmax;
plot(xvals,yvals,'b');
xlabel('RGB gun intensity');
ylabel('Luminance (cd/m2');
title('Gamma Functions');



%Testing RGB->XYZ->xyY
res = 7;
[R,G,B] = meshgrid(linspace(0.1,1,res),linspace(0.1,1,res),linspace(0.1,1,res));
R = reshape(R,numel(R),1);
G = reshape(G,numel(G),1);
B = reshape(B,numel(B),1);
ds.RGB = [R G B];
ds = cerulean_RGB2XYZ(ds);
ds = cerulean_XYZ2xyY(ds);
subplot(3,4,2);
scatter(ds.xyz(:,1),ds.xyz(:,2),ds.Y,ds.RGB,'filled');
axis([0 0.8 0 0.9]);
grid on; box on; hold on;
plot(ds.colormetric.ciexi,ds.colormetric.cieyi,'k');
xlabel('CIE 1976 x');
ylabel('CIE 1976 y');
title('CIE Space');



%Testing XYZ to LAB
ds = cerulean_XYZ2LAB(ds);
ds = cerulean_LAB2XYZ(ds);
ds = cerulean_XYZ2RGB(ds);
ds.Y(:) = 30;
subplot(3,4,3);
scatter3(ds.LAB(:,2),ds.LAB(:,3),ds.LAB(:,1),ds.Y+1,ds.RGB,'filled');
axis([-120 120 -120 120 0 150]);
xlabel('CIE a*');
ylabel('CIE b*');
zlabel('CIE L*');
grid on; box on; hold on;
title('L*a*b* Space');



%Testing XYZ to LMS
ds = cerulean_XYZ2LMS(ds);
ds = cerulean_LMS2XYZ(ds);
ds.Y(:) = 30;
subplot(3,4,4);
scatter3(ds.LMS(:,1),ds.LMS(:,2),ds.LMS(:,3),ds.Y+1,ds.RGB,'filled');
xlabel('L');
ylabel('M');
zlabel('S');
grid on; box on; hold on;
title('LMS Space');



%Test RGB to DKL image capabilities
random_image = ceil(rand * 600);
im = imread(['image data/jpgs/' num2str(random_image) '.jpg'],'jpg');
im = im2double(im);
subplot(3,4,5);
imagesc(im);
ds.RGB = im;
title('Original Image');



%To Isoluminance
ds = cerulean_RGB2ALL(ds);
ds.LAB(:,:,1) = ds.whitepoints.LAB(1);
ds = cerulean_LAB2XYZ(ds);
ds = cerulean_XYZ2RGB(ds);
subplot(3,4,6);
imagesc(ds.RGB);
title('Isoluminant Version');
subplot(3,4,7);
[s1,s2,s3] = size(ds.DKL);
ds.DKL = reshape(ds.DKL,s1*s2,s3);
ds.RGB = reshape(ds.RGB,s1*s2,s3);
sizer = ds.DKL(:,2);sizer(:) = 30;
scatter3(ds.DKL(1:1000:end,2),ds.DKL(1:1000:end,3),ds.DKL(1:1000:end,1),sizer(1:1000:end),ds.RGB(1:1000:end,:),'filled');
box on;grid on;
title('DKL scatter plot of image');



%DKL axis in CIE space
ds.DKL = [];res = 20;
ds.DKL(:,3) = linspace(-1,1,res);
ds = cerulean_DKL2ALL(ds);
subplot(3,4,8);
title('DKL axis in CIE xyz');
plot(ds.colormetric.ciexi,ds.colormetric.cieyi,'Color',[0 0 0]);
hold on; sizer = ds.DKL(:,1); sizer(:) = 22;
scatter(ds.xyz(:,1),ds.xyz(:,2),sizer,ds.RGB,'filled');
ds.DKL = [];
ds.DKL(:,2) = linspace(-0.20,0.20,res);
ds.DKL(:,3) = 0;
ds = cerulean_DKL2ALL(ds);
scatter(ds.xyz(:,1),ds.xyz(:,2),sizer,ds.RGB,'filled');
axis([0 0.8 0 0.9]);
h = line([ds.green.gamut(1) ds.red.gamut(1)],[ds.green.gamut(2) ds.red.gamut(2)]);
set(h,'Color',[0 0 0]);
h = line([ds.green.gamut(1) ds.blue.gamut(1)],[ds.green.gamut(2) ds.blue.gamut(2)]);
set(h,'Color',[0 0 0]);
h = line([ds.blue.gamut(1) ds.red.gamut(1)],[ds.blue.gamut(2) ds.red.gamut(2)]);
set(h,'Color',[0 0 0]);
h = scatter(ds.red.gamut(1),ds.red.gamut(2),'filled');
set(h,'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[1 0 0]);
h = scatter(ds.green.gamut(1),ds.green.gamut(2),'filled');
set(h,'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[0 1 0]);
h = scatter(ds.blue.gamut(1),ds.blue.gamut(2),'filled');
set(h,'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[0 0 1]);



%DKL manipulations
ds.RGB = im;
ds = cerulean_RGB2ALL(ds);
ds.DKL(:,:,3) = 0;
ds.DKL(:,:,2) = 0;
ds = cerulean_DKL2ALL(ds);
subplot(3,4,9);
imagesc(ds.RGB);
title('Luminance Image');



%Gray Point Image
ds.DKL = zeros(16,16,3);
ds = cerulean_DKL2ALL(ds);
subplot(3,4,10);
imagesc(ds.RGB);
title('White point');



%DKL isoluminant plane
res = 100;
[X,Y] = meshgrid(linspace(-1,1,res),linspace(-1,1,res));
dis = sqrt(X.^2 + Y.^2);
X(dis > 1) = 0;
Y(dis > 1) = 0;
ds.DKL = [];
ds.DKL(:,:,2) = X.*0.20;
ds.DKL(:,:,3) = Y.*1.00;
ds = cerulean_DKL2ALL(ds);
subplot(3,4,11);
imagesc(ds.RGB);



%DKL isoluminant plane
res = 100;
[X,Y] = meshgrid(linspace(-1,1,res),linspace(-1,1,res));
dis = sqrt(X.^2 + Y.^2);
X(dis > 1) = 0;
Y(dis > 1) = 0;
ds.DKL = [];
ds.DKL(:,:,2) = X.*0.20;
ds.DKL(:,:,3) = Y.*1.00;
ds = cerulean_DKL2ALL(ds);
subplot(3,4,11);
imagesc(ds.RGB);
title('DKL isoluminant plane');
subplot(3,4,12);
ds.RGB = reshape(ds.RGB,res*res,3);
ds.xyz = reshape(ds.xyz,res*res,3);
ds.yv = reshape(ds.uv,res*res,2);
sizer = ds.RGB(:,1);
sizer(:) = 50;
scatter(ds.xyz(1:10:end,1),ds.xyz(1:10:end,2),sizer(1:10:end),ds.RGB(1:10:end,:),'filled');
hold on;
plot(ds.colormetric.ciexi,ds.colormetric.cieyi,'Color',[0 0 0]);
axis([0 0.8 0 0.9]);
grid on; box on; hold on;
title('DKL isoluminant plane in CIE xyz');

