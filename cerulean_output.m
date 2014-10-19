function ds = cerulean_output(ds)

cd('output data');
fid = fopen([ds.monitorid '_LUM2XYZ.con'],'w');
for i=1:3
    fprintf(fid,'%f\t%f\t%f\n',ds.LUM2XYZ(i,:));
end
fclose(fid);

fid = fopen([ds.monitorid '_XYZ2LUM.con'],'w');
for i=1:3
    fprintf(fid,'%f\t%f\t%f\n',ds.XYZ2LUM(i,:));
end
fclose(fid);

fid = fopen([ds.monitorid '_XYZ2LMS.con'],'w');
for i=1:3
    fprintf(fid,'%f\t%f\t%f\n',ds.XYZ2LMS(i,:));
end
fclose(fid);

fid = fopen([ds.monitorid '_LMS2XYZ.con'],'w');
for i=1:3
    fprintf(fid,'%f\t%f\t%f\n',ds.LMS2XYZ(i,:));
end
fclose(fid);

fid = fopen([ds.monitorid '_LMS2DKL.con'],'w');
for i=1:3
    fprintf(fid,'%f\t%f\t%f\n',ds.LMS2DKL(i,:));
end
fclose(fid);

fid = fopen([ds.monitorid '_DKL2LMS.con'],'w');
for i=1:3
    fprintf(fid,'%f\t%f\t%f\n',ds.DKL2LMS(i,:));
end
fclose(fid);

fid = fopen([ds.monitorid '_Luminances.con'],'w');
fprintf(fid,'%f\n',ds.red.Lmax);
fprintf(fid,'%f\n',ds.green.Lmax);
fprintf(fid,'%f\n',ds.blue.Lmax);
fclose(fid);

fid = fopen([ds.monitorid '_Gammas.con'],'w');
fprintf(fid,'%f\n',ds.red.gamma);
fprintf(fid,'%f\n',ds.green.gamma);
fprintf(fid,'%f\n',ds.blue.gamma);
fclose(fid);

fid = fopen([ds.monitorid '_Whitepoint.con'],'w');
fprintf(fid,'%f\n',ds.whitepoints.XYZ(1));
fprintf(fid,'%f\n',ds.whitepoints.XYZ(2));
fprintf(fid,'%f\n',ds.whitepoints.XYZ(3));
fprintf(fid,'%f\n',ds.whitepoints.xyz(1));
fprintf(fid,'%f\n',ds.whitepoints.xyz(2));
fprintf(fid,'%f\n',ds.whitepoints.xyz(3));
fclose(fid);
cd ..