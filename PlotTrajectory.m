function [  ] =PlotTrajectory( radPV_XY,refPV_XY )
 FigH = figure;
plot(refPV_XY(:,1),refPV_XY(:,2),'r','LineWidth',2)
hold on
plot(radPV_XY(:,1),radPV_XY(:,2),'b','LineWidth',2)
set(gca,'FontSize',13)
legend('Reference trajectory','Radar measured trajectory','location','South');
title('Trajectory plot')
xlabel('X (m)')
ylabel('Y (m)')
grid on
set(gcf,'PaperType','usletter', ...
         'paperOrientation', 'landscape', ...
         'paperunits','CENTIMETERS',...         
         'PaperPosition',[-1, 0, 29, 22]);
print(FigH,'-dpdf','Trajectory.pdf')

end

