%pkg load image; Solo para octave
%pkg load signal; 

ranura = imread('Caracterización ranuras/D_doble.tif');
ranura = rgb2gray(ranura(:,:,1:3));
ranura = im2double(ranura);
ranura = imgaussfilt(ranura, 10);
threshold = (max(max(ranura))-min(min(ranura)))/10;
mascara = imoverlay(ranura, ranura<threshold, 'black');
mascara = imoverlay(mascara, ranura>threshold, 'white');

imshow(mascara);
ranura(ranura<threshold) = 0;
ranura(ranura>threshold) = 100;

d_medidas = [];
x_offset = 0;

for i = 1:size(ranura, 1)
    corte_transversal = ranura(i, :);
    
    % nos aseguramos que siempre sean dos flancos ascendentes y dos
    % descendentes
    flancos = abs(diff(corte_transversal));
    assert(sum(flancos>0)==4);

    x = find(flancos == max(flancos));
    if i == 1
        x_offset = x_offset-x(1);
    elseif i == size(ranura, 1)
        x_offset = x_offset+x(1);
    end

%     plot(corte_transversal, 'b');
%     height = max(corte_transversal);
%     hold on;
%     scatter(x(1), height, 'r');
%     scatter(x(2), height, 'r');
%     scatter(x(3), height, 'r');
%     scatter(x(4), height, 'r');

    abertura_1 = x(1) + (x(2)-x(1))/2;
    abertura_2 = x(3) + (x(4)-x(3))/2;
    %hold on;
    %handle = plot([abertura_1 abertura_2],[i i], 'r');
    %handle.Color(4) = 0.2; % plot with a little transparency
    
    d_medidas = [d_medidas (abertura_2 - abertura_1)];
end
d_medido = mean(d_medidas);
sd = std(d_medidas);

theta = atan(size(ranura, 1)/x_offset);
d_real = cos(pi/2-theta)*d_medido;