x_min = -10;
x_max = 10;
y_min = -10;
y_max = 10;

t = linspace(x_min, x_max, 1000);
subplot(1,2,1);
axis([x_min, x_max, y_min, y_max]);
[x, y] = ginput(1);

z = 10;
n = 10;
prev = [linspace(x_min-z, x_min, n)];
post = [linspace(x_max, x_max+z, n)];
ceros = zeros(1,n);
xx = [x];
yy = [y];
for i=1:(points-1)
  [x, y] = ginput(1);
  xx = [xx x];
  yy = [yy y];
  s = spline([prev xx post],[ceros yy ceros], t);
  subplot(1,2,1);
  plot(xx, yy, 'o', t, s);
  axis([x_min, x_max, y_min, y_max]);
end

offset = (x_max-x_min)*sqrt(2);
t = linspace(x_min, x_max, 100);
[X,Y] = meshgrid(t,t);
t = linspace(x_min-offset, x_max+offset, 100);
s = spline([prev xx post],[ceros yy ceros], t);
Z = sqrt(X.^2+Y.^2);
Z = interp1(t,s,Z);
size(Z)
subplot(1,2,2);
surf(X,Y,Z);
shading interp
