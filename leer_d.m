clc
pkg load image;
pkg load signal;

x=zeros(4,1);

A = imread('Caracterización ranuras/D_doble.tif');
B = rgb2gray(A);
C = B;
C(C<25) = 0;
C(C>80) = 80;
C = C(5,:);

%plot(C(200,:), 'r');

%plot(C(400,:), 'b');
%[pks, loc] = findpeaks(C)

[pks, x(1)] = max(C);
idx = find(C == pks);
temp=diff(idx);
diff_temp= max(temp);

x(2)=idx(find(temp == 198));
x(3)=idx(find(temp == 198)+1);
x(4) = idx(end);

%plot(C);
%hold on

%scatter(x(1),80, 'r');
%scatter(x(2),80, 'r');
%scatter(x(3),80, 'r');
%scatter(x(4),80, 'r');

