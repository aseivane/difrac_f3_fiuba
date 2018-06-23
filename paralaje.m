
load('plantilla.mat')

img = squeeze(plantilla(:,:,:,25));
%img = (255-img(716, 290:730));
img = (255-img(716, 290:850));
img(img<120) = 0;
w = gausswin(10);
imagen = filter(w,1,img);
%plot(imagen)    
[pks, loc] = findpeaks(imagen);

dist_start = loc(2)-loc(1);
dist_end = loc(end)-loc(end-1);
error_per_distance = dist_start/dist_end;
error_per_distance = error_per_distance%/(loc(end)-loc(end-1))

%encontre = [];
%for i=1:(size(loc,2)-1)
%    encontre = [encontre loc(i+1) - loc(i)];
%end

%plot(encontre,'x');
%hold on;
%plot(encontre);
%axis([0 size(loc,2) 0 255])
 

lineas = 255-plantilla(590,:,5);
plantilla2 = imread('plantilla_lookup.png');
plantilla2(590,plantilla2(590,:)>60) = 255;
plantilla2(590,plantilla2(590,:)<60) = 80;
plantilla2(590,:) = (255 - plantilla2(590,:));% - min(plantilla2(590,:)) + min(lineas);
plantilla2(590,:) = filter(gausswin(15),1,plantilla2(590,:));
plot(plantilla2(590,10:end));
lineas(plantilla2(590,:)==0) = 0;
lineas = filter(gausswin(30),1,lineas);
hold on;
plot(lineas(10:end), 'r')
[pks, loc] = findpeaks(lineas);




