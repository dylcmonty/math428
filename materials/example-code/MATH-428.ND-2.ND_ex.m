clear all
clc;
clf;

set(0,'DefaultAxesFontName', 'Times New Roman');
axes('FontSize',14);

n = 8;
h = zeros(n,1);
error = zeros(n,1);
hVal = 0;

for i = 1:n
    hVal = 0.1*10^(-(i-1));
    h(i) = hVal;
    Dh = (exp(hVal)-exp(-hVal))/(2.0*hVal);
    error(i) = abs(Dh-1);
end

loglog(h,error,'-bo','LineWidth',1.5);
xlabel('h');
ylabel('Error');
