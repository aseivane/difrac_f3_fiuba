function [d_real_um] = medir_distancia_rendija()
clc%limpia consola
clear%limpia variables

%ranura = imread('rendijas/D_doble.tif'); lo dejo comentado por si se
%cambia de carpeta otra vez
ranura = imread('D_doble.tif');
ranura = rgb2gray(ranura(:,:,1:3));
ranura = im2double(ranura);
ranura = imgaussfilt(ranura, 10);
threshold = (max(max(ranura))-min(min(ranura)))/10;
mascara = imoverlay(ranura, ranura<threshold, 'black');
mascara = imoverlay(mascara, ranura>threshold, 'white');

%imshow(mascara);
ranura(ranura<threshold) = 0;
ranura(ranura>threshold) = 100;

d_medidas = [];
x_offset = 0;

for i = 1:size(ranura, 1)
    corte_transversal = ranura(i, :);%toma una linea
    
    % nos aseguramos que siempre sean dos flancos ascendentes y dos
    % descendentes
    flancos = abs(diff(corte_transversal));%deriva cada punto, donde esta el salto empieza o termina la ranuara
    assert(sum(flancos>0)==4);%tira error si no encuentra los cuatro flancos

    x = find(flancos == max(flancos));%guarda en un vector los lugares donde estan los flancos
    
    if i == 1
        x_offset = x_offset-x(1);%le da el primer valor con el indice del primer flanco
    elseif i == size(ranura, 1)
        x_offset = x_offset+x(1);%hace la diferencia entre el indice de la primera linea y la ultima
    end

    abertura_1 = x(1) + (x(2)-x(1))/2;  %calcula el centro de cada abertura
    abertura_2 = x(3) + (x(4)-x(3))/2;
    
    d_medidas = [d_medidas (abertura_2 - abertura_1)]; %arma un vector con la distancia entre la dos aberturas de cada linea
end
d_medido = mean(d_medidas); %valor medio de las distancias
sd = std(d_medidas);%desvio estandar de las distancias

z=size(ranura, 1)/x_offset; %simplifico escritura
theta = atan(z);    %angulo
err_theta = abs(size(ranura, 1)/((1+z^2)*x_offset^2))*2; %derivada parcial con respecto al offset, tomo error 2px
err_d_medido = 2;%tomo el errror medido como 2px

d_real = cos(pi/2-theta)*d_medido;

prop_err_theta = sin(pi/2-theta)*d_medido; %propagacion del error de tita
prop_err_d = cos(pi/2-theta);%propagaciond del error de d medida
err_d_px = sqrt(abs(prop_err_theta)^2*err_theta^2+abs(prop_err_d)^2*err_d_medido^2);    %todo adentro de la propagacion no correlacionada

%busca la relacion segun la plantilla
[px_a_um, error_px] = medir_calibracion();

%usa la ralacion para pasar de pixeles a micras
d_medido_um = d_medido*px_a_um;
sd_um = sd*px_a_um;
d_real_um = d_real*px_a_um;
err_d=err_d_px*px_a_um;

msg1 = sprintf('Pixeles:\nDistancia ranuras media medida = %s px \nDesvio estandar = %s px \nAngulo = %s rad\nError angulo = %s rad\nDistancia ranuras real media = %s px\nError distancia ranuras real media = %s px\n',num2str(d_medido),num2str(sd),num2str(theta),num2str(err_theta),num2str(d_real),num2str(err_d_px));
msg2 = sprintf('Micras:\nCambio de unidad = %s um/px\nError cambio de unidad = %s um/px\nDistancia ranuras media medida = %s um \nDesvio estandar = %s um \nDistancia ranuras real media = %s um\nError distancia ranuras real media = %s um',num2str(px_a_um),num2str(error_px),num2str(d_medido_um),num2str(sd_um),num2str(d_real_um),num2str(err_d));
h = msgbox({msg1 msg2},'Resultados');
end