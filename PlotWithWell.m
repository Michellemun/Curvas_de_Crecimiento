function h = PlotWithWell(x, y, color, wells)
% h = PlotWithWell(x, y, color, wells)
	for j=1:length(wells)
        h=plot(x(:,j),y(:,j), 'Color', color);
        hold on
        text(x(8,j), y(8,j), mat2str(wells(j)));
	end
end