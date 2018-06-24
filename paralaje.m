function [px_a_mm] = paralaje()
load('plantilla.mat')

img = squeeze(plantilla(:,:,1,25));
%img = (255-img(716, 290:730));
img = (255-img(716, 290:850));
img(img<120) = 0;
img=double(img);%filter tiene problema con unit8
w = gausswin(10);
imagen = filter(w,1,img);

%figure(2)
%plot(imagen);
%hold on
[pks, loc] = findpeaks(imagen);

dist_start = loc(2)-loc(1);
dist_end = loc(end)-loc(end-1);
error_per_distance = dist_start/dist_end;
error_per_distance = error_per_distance;%/(loc(end)-loc(end-1))

px_a_mm =((size(loc,2)-1)*5)/(loc(end)-loc(1)); %10mm dividido la cant de px
error_px_a_mm = 2*((size(loc,2)-1)*5)/(loc(end)-loc(1))^2; %tomo el error de determinar un max como 2px por ser un flanco

% lineas = 255-plantilla(590,:,5);
% plantilla2 = imread('plantilla_lookup.png');
% plantilla2 = double(plantilla2);%filter tiene problema con unit8
% plantilla2(590,plantilla2(590,:)>60) = 255;
% plantilla2(590,plantilla2(590,:)<60) = 80;
% plantilla2(590,:) = (255 - plantilla2(590,:));% - min(plantilla2(590,:)) + min(lineas)
% plantilla2(590,:) = filter(gausswin(15),1,plantilla2(590,:));
% plot(plantilla2(590,10:end));
% lineas(plantilla2(590,:)==0) = 0;
% lineas = filter(gausswin(30),1,double(lineas));
% hold on;
% plot(lineas(10:end), 'r')
% [pks, loc] = findpeaks(lineas);

msg1 = sprintf('Error paralaje = %s px \nPx en un cm = %s\nPx a mm = %s mm/px \nError conversion = %s mm/px\nError paralaje en mm = %s mm',num2str(error_per_distance),num2str(2*dist_start),num2str(px_a_mm),num2str(error_px_a_mm),num2str(error_per_distance*px_a_mm));
msgbox(msg1,'Resultados');
end