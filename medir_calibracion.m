%pkg load image; Solo para octave
%pkg load signal; 

ranura = imread('Caracterización ranuras/calibracion10xescala10micras.tif');
ranura = rgb2gray(ranura(:,:,1:3));
ranura = im2double(ranura);
ranura = max(max(ranura)) - ranura; % invertimos valles y picos
%ranura = imgaussfilt(ranura, 1);
%threshold = (max(max(ranura))-min(min(ranura)))/2;
%mascara = imoverlay(ranura, ranura<threshold, 'black');
%mascara = imoverlay(mascara, ranura>threshold, 'white');

%imshow(mascara);
%ranura(ranura<threshold) = 0;
%ranura(ranura>threshold) = 100;


% 630 es una columna con poco ruido, encontrada de forma visual
ranura = ranura(:,630);
ranura = filter(gausswin(2),1,ranura);
% 0.04 es un buen threshold para eliminar el ruido, encontrado de forma
% visual
ranura(ranura<0.04) = 0;
ranura(ranura>max(ranura)/2) = 10;
plot(ranura);
flancos_ascendentes = diff(ranura);
x = find(flancos_ascendentes == max(flancos_ascendentes));
cuantos = size(x, 1)-1;
micras_por_pixel = (10*cuantos)/(x(end)-x(1))

% d_medidas = [];
% x_offset = 0;

% for i = 1:size(ranura, 1)
%     corte_transversal = ranura(i, :);
%     
%     % nos aseguramos que siempre sean dos flancos ascendentes y dos
%     % descendentes
%     flancos = abs(diff(corte_transversal));
%     assert(sum(flancos>0)==4);
% 
%     x = find(flancos == max(flancos));
%     if i == 1
%         x_offset = x_offset-x(1);
%     elseif i == size(ranura, 1)
%         x_offset = x_offset+x(1);
%     end
% 
% %     plot(corte_transversal, 'b');
% %     height = max(corte_transversal);
% %     hold on;
% %     scatter(x(1), height, 'r');
% %     scatter(x(2), height, 'r');
% %     scatter(x(3), height, 'r');
% %     scatter(x(4), height, 'r');
% 
%     abertura_1 = x(1) + (x(2)-x(1))/2;
%     abertura_2 = x(3) + (x(4)-x(3))/2;
%     hold on;
%     handle = plot([abertura_1 abertura_2],[i i], 'r');
%     handle.Color(4) = 0.2; % plot with a little transparency
%     
%     d_medidas = [d_medidas (abertura_2 - abertura_1)];
% end
% d_medido = mean(d_medidas);
% 
% theta = atan(size(ranura, 1)/x_offset);
% d_real = cos(pi/2-theta)*d_medido;