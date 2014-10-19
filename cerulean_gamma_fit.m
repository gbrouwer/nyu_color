function residual = cerulean_gamma_fit(param,xdata,ydata)

%Gamma Function
fit = xdata.^param(1);
ydata_norm = ydata ./ max(ydata);
residual = ydata_norm - fit;