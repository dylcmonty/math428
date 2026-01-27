% Example  of differentiating noisy data
clear all; 
clc;
clf;

set(0,'DefaultAxesFontName', 'Times New Roman');
axes('FontSize',14);


h = 0.01;
x = 0:h:2*pi;
l = length(x);
sinx = sin(x);
sinp = (1+.01*randn(1,l)).*sinx;

cosx = (sinx(3:l)-sinx(1:l-2))/(2*h);
cosp = (sinp(3:l)-sinp(1:l-2))/(2*h);
err_f = max(abs(sinx-sinp))
err_fp = max(abs(cosx-cosp))

subplot(1,2,1)
plot(x,sinp,x,sinx,'r')
xlabel('x')
legend('noisy sin(x)','sin(x)');
%title('sin (x) with 1% noise')

subplot(1,2,2)
plot(x(2:l-1),cosp,x(2:l-1),cosx,'r')
xlabel('x')
legend('derivative of noisy sin(x)','derivative of sin(x)');
%title('cos (x) by noisy numerical differentiation')