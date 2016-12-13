function [  ] = PlotSegmentationResult( t,radPV_XY,refPV_XY,isMove )

FigH = figure;
plot(t,isMove,'r','LineWidth',2)
hold on
%normalized position (range)
plot(t,sqrt(radPV_XY(:,1).^2+radPV_XY(:,2).^2)/...
    max(sqrt(radPV_XY(:,1).^2+radPV_XY(:,2).^2)),'b','LineWidth',2)
set(gca,'FontSize',15)
title('Sgmenattion based on range')
xlabel('t(s)')
grid on
legend('Move1Static0','Normalized range','Location','South')
set(gcf,'PaperType','usletter', ...
    'paperOrientation', 'landscape', ...
    'paperunits','CENTIMETERS', ...
    'PaperPosition',[-1, 0, 29, 22]);
print(FigH,'-dpdf','Segmentation.pdf')

end

