function cerulean_colornames

%Load
clc;
count = 0;
load('cerulean_LCD at scanner - 10262010');
fid = fopen('cerulean_colornames_short.txt','r');
count = 0;
for i=1:320
    tline0 = fgetl(fid);
    namelist{i} = tline0;
    tline1 = fgetl(fid);
    tline2 = fgetl(fid);
    tline3 = fgetl(fid);
    tline4 = fgetl(fid);
    tline5 = fgetl(fid);
    tline6 = fgetl(fid);
    tline7 = fgetl(fid);
    count = count + 1;
    colornames{count} = tline0;
    RGB(i,:) = [str2num(tline1) str2num(tline2) str2num(tline3)];
end
fclose(fid);
RGB = RGB ./ 255;
ds.RGB = RGB;
ds = Cerulean_RGB2XYZ(ds);
ds = Cerulean_XYZ2LAB(ds);
hold on;



%Convert
string = [];
for m=1:320
  string = colornames{m};
  while (strcmp(string(end),' '))
    string = string(1:end-1);
  end
  for d=1:numel(string)
    if (strcmp(string(d),' '))
      string(d) = '-';
    end
  end
  newlist{m} = upper(string);
end




%Find Frequencies
count = 0;
fid = fopen('cerulean_color_frequencies.txt','r');
while 1
  tline = fgetl(fid);
  if ~ischar(tline), break, end

      %Seperate
      [t1,t2] = strtok(tline,' ');
      freq = str2num(t2);
      
      %Find
      for m=1:320
        if (strcmp(t1,newlist{m}))
          count = count + 1;
          ds.namelist{count} = t1;
          ds.rgb(count,:) = RGB(m,:);
          ds.freq(count) = freq;
        end
      end
      
end
fclose(fid);






[s1,s2] = size(ds.freq);
ds.freq(2,:) = 1:s2;
ds.freq = sortrows(ds.freq',1);
ds.freq = flipud(ds.freq);
ds.rgb = ds.rgb(ds.freq(:,2),:);
for m=1:s2
  ds.snamelist{m} = ds.namelist{ds.freq(m,2)};

end
ds.freq(:,1) = ds.freq(:,1) ./ sum(ds.freq(:,1))
ds.RGB = ds.rgb;
ds = cerulean_RGB2ALL(ds);


%Plot
subplot(1,2,1);
for i=1:1:145
  h = text(ds.LAB(i,2),ds.LAB(i,3),ds.LAB(i,1),ds.snamelist{i});
  set(h,'Color',ds.RGB(i,:));
end
grid on; box on;
axis([-220 220 -220 220 0 200]);


subplot(1,2,2);
scatter3(ds.LAB(:,2),ds.LAB(:,3),ds.LAB(:,1),ds.freq(:,1).*3000,ds.RGB,'filled');
grid on; box on;
axis([-220 220 -220 220 0 200]);


%     
% 
% fid=fopen('cerulean_wikipedia.txt');
% while 1
%     tline = fgetl(fid);
%     if ~ischar(tline), break, end
%         line1 = fgetl(fid);
%         line2 = fgetl(fid);
%         line3 = fgetl(fid);
%         line4 = fgetl(fid);
%         line5 = fgetl(fid);
%         line6 = fgetl(fid);
%         line7 = fgetl(fid);
%         line8 = fgetl(fid);
%         line9 = fgetl(fid);
%         count = count + 1;
%         colornames{count} = tline;
%         colors(count,1) = str2num(line2(1:end-1)) ./ 100;
%         colors(count,2) = str2num(line3(1:end-1)) ./ 100;
%         colors(count,3) = str2num(line4(1:end-1)) ./ 100;
%     end
% fclose(fid);
% 
% 
% size(string)
% 
% 
% %Plot 1
% subplot(2,2,1);
% sizer = colors(:,1);
% sizer(:) = 30;
% scatter3(colors(:,1),colors(:,2),colors(:,3),sizer,colors,'filled');
% grid on;box on;