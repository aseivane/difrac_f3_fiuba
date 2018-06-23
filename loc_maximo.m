function [maximo x y] = loc_maximo(imagen, x_pos, ancho)
x_min = round(x_pos-ancho/4);
x_max = round(x_pos+ancho/4);

franja = imagen(:,x_min:x_max);
maximo = max(max(franja));
[y x] = find(franja == maximo);
x = x + x_min;
end
