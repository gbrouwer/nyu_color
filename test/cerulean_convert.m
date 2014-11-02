function cerulean_convert


%Init
clc;
strength = 80;
load('cerulean_LCD at scanner - 10262010');



%Create Space
A = sin(linspace(0,2*pi,101));
B = cos(linspace(0,2*pi,101));
A = A(1:end-1) .* strength;
B = B(1:end-1) .* strength;



%Set LAB
ds.LAB = [];
ds.LAB(:,2) = A;
ds.LAB(:,3) = B;
ds.LAB(:,1) = 100;



%Convert
ds = cerulean_LAB2XYZ(ds);
ds = cerulean_XYZ2RGB(ds);



%Plot
scatter(ds.LAB(:,2),ds.LAB(:,3),ds.LAB(:,1),ds.RGB,'filled');
axis([-strength*1.2 strength*1.2 -strength*1.2 strength*1.2]);
grid on; box on;
xlabel('A');
ylabel('B');