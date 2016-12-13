function [  ] = PlotSegmentationResult( t,radPV_XY,refPV_XY,isMove )

FigH = figure('Position', [200, 200, 600, 600]);
plot(t,isMove,'LineWidth',2)
hold on
%normalized position (range)
plot(t,sqrt(radPV_XY(:,1).^2+radPV_XY(:,2).^2)/...
    max(sqrt(radPV_XY(:,1).^2+radPV_XY(:,2).^2)),'LineWidth',2)
set(gca,'FontSize',15)
title('Sgmenattion based on range')
xlabel('t(s)')
axis square;
grid on
legend('Move1Static0','Normalized range','Location','South')
set(gcf,'PaperType','usletter', ...
    'paperOrientation', 'landscape', ...
    'paperunits','CENTIMETERS', ...
    'PaperPosition',[6, 4, 14, 14]);
print(FigH,'-dpdf','Segmentation.pdf')

end

