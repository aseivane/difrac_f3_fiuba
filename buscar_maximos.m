function [valores_maximos x y] = buscar_maximos(imagen)

imagen = im2double(imagen); % convertimos los valores de uint8 a double

imagen = imgaussfilt(imagen, 1);
imagen(imagen < max(max(imagen(50:100,800:900)))*1.02) = 0;
imagen([1:480 570:end], :) = 0;

% Aplicamos un filtro gaussiano para 
% reducir el efecto del ruido y suavizar la imagen
imagen = imgaussfilt(imagen, 10);
% Encontramos los picos
[valores_maximos, indice_maximos, valores_minimos, indice_minimos] = extrema2(imagen);
% Aplicamos un umbral para prevenir que máximos locales pequeños (generados
% por el ruido) sean considerados

%under_threshold = valores_maximos < max(max(valores_maximos))/3;
% eliminamos esos máximos
%indice_maximos(under_threshold) = [];
%valores_maximos(under_threshold) = [];

[y, x] = ind2sub(size(imagen), indice_maximos);

[x, x_order] = sort(x);
y = y(x_order,:);
valores_maximos = valores_maximos(x_order,:);

end
