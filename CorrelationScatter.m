function [plotHandle r p] = CorrelationScatter(x,y,labelx, labely, namesx, namesy, textos)
% [plotHandle r p] = CorrelationScatter(x,y,labely,namesx,namesx,namesy)
% los primeros 4 parametros son obligatorios
error(nargchk(0,7,nargin))
if length(x) ~= length(y)
    warning('X and Y have different sizes');
end

if nargin>4 %if names are provided, they must be paired in both vectors
    i=FindGeneList(namesx,namesy);
    y=y(i);
end

xvalid = find(~isnan(x));
yvalid = find(~isnan(y));

validas = intersect(xvalid,yvalid);
[r p]=corrcoef(x(validas), y(validas));
r=r(2);
p=p(2);

plotHandle = plot(x(validas),y(validas),'o');
title(strcat(' r= ',num2str(r),' p= ',num2str(p), ' n=', num2str(length(validas)) ),'location','best')

fastLabels(labelx, labely, 'Scatter')

if nargin>6
    text(x(validas),y(validas),textos(validas))
end

end

