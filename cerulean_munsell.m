function cerulean_munsell

%load the monitor information and Munsell chip data
clc;
load('cerulean_LCD at scanner - 10262010');
 


%Open and Read
cd('colorimetric data');
fid = fopen('cerulean_Munsell.dat','r');
fgetl(fid);
tel = 0;
while 1
    tline = fgetl(fid);
    if ~ischar(tline), break, end
        tel = tel + 1;
        [f1,f2] = strtok(tline,' ');
        colornames{tel} = f1;
        munsell(tel,:) = sscanf(f2,'%f %f %f %f %f');
end
fclose(fid);
cd ..
 
 

%Convert Munsell to RGB
ds.xyz = munsell(:,end-2:end-1);
ds.xyz(:,end+1) = 1 - ds.xyz(:,1) - ds.xyz(:,2);
ds.Y = (munsell(:,end));
ds = cerulean_xyY2XYZ(ds);
ds = cerulean_XYZ2RGB(ds);
 



%Plot
sizer = ds.xyz(:,1);
sizer(:) = 30;
scatter3(ds.xyz(:,1),ds.xyz(:,2),ds.Y,sizer,ds.RGB,'filled');
hold on;
plot(ds.colormetric.ciexi,ds.colormetric.cieyi,'k');
axis([0 1 0 1]);
grid on;
box on;
