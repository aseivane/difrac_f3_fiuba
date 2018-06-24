function [micras_por_pixel, error] = medir_calibracion 

%ranura = imread('Caracterización ranuras/calibracion10xescala10micras.tif');
ranura = imread('calibracion10xescala10micras.tif');
ranura = rgb2gray(ranura(:,:,1:3));
ranura = im2double(ranura);
ranura = max(max(ranura)) - ranura; % invertimos valles y picos

% 630 es una columna con poco ruido, encontrada de forma visual
ranura = ranura(:,630);
ranura = filter(gausswin(2),1,ranura);
% 0.04 es un buen threshold para eliminar el ruido, encontrado de forma
% visual

ranura(ranura<0.04) = 0;%quita el ruido poniendolo en 0
ranura(ranura>max(ranura)/2) = 10;%limpia diferencia de altura en los maximos

%plot(ranura);
flancos_ascendentes = diff(ranura); %busca las variaciones de los flancos
%plot(flancos_ascendentes)
x = find(flancos_ascendentes == max(flancos_ascendentes));  %vector con los indices de los max
cuantos = size(x, 1)-1; %cuantos max hay, entre cada uno hay una micra
micras_por_pixel = cuantos/(x(end)-x(1));
error =2*cuantos/(x(end)-x(1))^2; %tomo el error de determinar un max como 2px
%error/micras_por_pixel
end