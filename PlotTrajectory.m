function [  ] =PlotTrajectory( radPV_XY,refPV_XY )
FigH = figure('Position', [200, 200, 600, 600]);
plot(refPV_XY(:,1),refPV_XY(:,2),'r','LineWidth',2)
hold on
plot(radPV_XY(:,1),radPV_XY(:,2),'b','LineWidth',2)
minRange=min(min(radPV_XY(:,1)),min(radPV_XY(:,2)))-5;
maxRange=max(max(radPV_XY(:,1)),max(radPV_XY(:,2)))+5;
xlim([minRange maxRange ]);%square plot space
ylim([minRange maxRange ]);
set(gca,'FontSize',15)
legend('Reference trajectory','Radar measured trajectory');
title('trajectory plot')
axis square;
xlabel('X (m)')
ylabel('Y (m)')
grid on
set(gcf,'PaperType','usletter', ...
         'paperOrientation', 'landscape', ...
         'paperunits','CENTIMETERS',...         
         'PaperPosition',[6, 4, 14, 14]);
print(FigH,'-dpdf','Trajectory.pdf')

end

