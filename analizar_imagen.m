%function analizar_imagen(archivo)
clc
clear

archivo='D.mat';
addpath('scripts');
addpath('rendijas');

img = load(archivo);
img = struct2cell(img);
img = cell2mat(img(1));
img = squeeze(img);

figure(1)
subplot(1, 2, 2);
subplot_y_start = 510;
subplot_x_start = 290;
imshow(255-squeeze(img(subplot_y_start:530,subplot_x_start:320,5)));
subplot(1,2,1);
imshow(255-squeeze(img(:,:,5)));
hold on;
%colors = {'yellow', 'magenta', 'cyan', 'red', 'green', 'blue', 'white'};
X = [];
Y = [];
PKS = [];
start = 4;

for i = (1+start):size(img,3)
    imagen = im2double(squeeze(img(:,:,i)));
    %plot(img(516, :));
    %[valores_maximos x y] = buscar_maximos(imagen);
    
    
    imagen = imgaussfilt(imagen, 10);
    [y_max, x_max] = find(imagen == max(max(imagen)));
    [valores_maximos, x] = findpeaks(imagen(y_max, 110:940));
    y = y_max*ones(1, size(x, 2));
    x = x + 110;
    
    %figure_handle = plot(imagen(y_max, :), char(colors(mod(i,size(colors,2))+1)));
    %hold on;
    
    %scatter(x, y, char(colors(mod(i,size(colors,2))+1)), 'filled'); 
    
    n = find(valores_maximos == max(valores_maximos));
    
    ancho = x(n)-x(n-1);
    for j = 1:size(x, 2)
       [valores_maximos(j), x(j), y(j)] = loc_maximo(imagen, x(j), ancho); 
    end
    subplot(1, 2, 2);
    hold on;
    scatter(x-subplot_x_start, y-subplot_y_start, [], 'filled');
    subplot(1, 2, 1);
    hold on;
    scatter(x, y, [], 'filled');
    X(i-start,:) = x;
    Y(i-start,:) = y;
    PKS(i-start,:) = valores_maximos;
end

x = [];
y = [];
valores_maximos = [];

%--- Dibuja el circulo del desvio estandar ---
for i = 1:size(X,2)
    mx = mean(X(:,i));
    my = mean(Y(:,i));
    valores_maximos = [ valores_maximos mean(PKS(:,i)) ];
    x = [x mx];
    y = [y my];
    sx = std(X(:,i));
    sy = std(Y(:,i));
    subplot(1, 2, 2);
    hold on;
    circleplot(mx-subplot_x_start, my-subplot_y_start, sqrt(sx^2+sy^2));
    subplot(1, 2, 1);
    hold on;
    circleplot(mx, my, sqrt(sx^2+sy^2));
end

%d=129.1456 viejo, esta mal
d = 12.9146;%um
%d=medir_distancia_rendija(); %um
px_a_mm = 0.0496;%mm/px
%px_a_mm = paralaje();%mm/px
L=540;%mm

n = find(valores_maximos == max(valores_maximos));
cantidad_de_maximos = n-1;
distancia_entre_maximos = mean(diff(x(1:end)));%(mx(end)-mx(1))/(size(mx, 2)-1) %cantidad_de_maximos;
distancia_entre_maximos = distancia_entre_maximos*px_a_mm; % arreglar

%distancia_entre_maximos = x(end)-x(1);
%distancia_entre_maximos = distancia_entre_maximos/cantidad_de_maximos;
%distancia_entre_maximos = distancia_entre_maximos*px_a_mm;

lambda = d*(distancia_entre_maximos/L);%um
lambda = lambda*1000%paso a nm
%end