function [  ] = PlotPosVelErr_XY(refPV_XY,radPV_XY,errPV_XY,t)

% make sure all plots in same scale for comparision
radMinP=min( min(radPV_XY(:,1)), min(radPV_XY(:,2)));
refMinP=min(min(refPV_XY(:,1)), min(refPV_XY(:,2)) );
Pmin=min(radMinP,refMinP)-5;

radMaxP=max(max(radPV_XY(:,1)),max(radPV_XY(:,2)));
refMaxP=max(max(refPV_XY(:,1)),max(refPV_XY(:,2)));
Pmax=max(radMaxP,refMaxP)+5;

radMinV=min( min(radPV_XY(:,3)), min(radPV_XY(:,4)));
refMinV=min(min(refPV_XY(:,3)), min(refPV_XY(:,4)) );
Vmin=min(radMinV,refMinV)-0.5;

radMaxV=max(max(radPV_XY(:,3)),max(radPV_XY(:,4)));
refMaxV=max(max(refPV_XY(:,3)),max(refPV_XY(:,4)));
Vmax=max(radMaxV,refMaxV)+0.5;

ePmin=min(min(errPV_XY(:,1)),min(errPV_XY(:,2)));
ePmax=max(max(errPV_XY(:,1)),max(errPV_XY(:,2)));

eVmin=min(min(errPV_XY(:,3)),min(errPV_XY(:,4)));
eVmax=max(max(errPV_XY(:,3)),max(errPV_XY(:,4)));


for i=1:4
    FigH = figure('Position', [200, 200, 1200, 600]);
    subplot(1,2,1)
    plot(t,radPV_XY(:,i),'b','LineWidth',3)
    hold on
    plot(t,refPV_XY(:,i),'r','LineWidth',1.5)
    axis square;
    set(gca,'FontSize',15)
    grid on
    legend('rad','ref')
    switch i
        case 1
            title('Position X')
            ylabel('m')
            ylim([Pmin Pmax])        
            legend('rad','ref' ,'Location','SouthEast')
        case 2
            title('Position Y')
            ylabel('m')
            ylim([Pmin Pmax])
        case 3
            title('Velocity X')
            ylim([Vmin Vmax])
            ylabel('m/s')
        case 4
            title('Velocity Y')
            ylim([Vmin Vmax])
            ylabel('m/s')
    end
    xlim([0 max(t)+3] )% make sure the legend will not cover the plot
    xlabel('t(s)')
    subplot(1,2,2)
    bar(t,errPV_XY(:,i))
    set(gca,'FontSize',15)
    xlim([0 max(t)+3])
    xlabel('t(s)')
    grid on
    axis square;
    set(gcf,'PaperType','usletter', ...
        'paperOrientation', 'landscape', ...
        'paperunits','CENTIMETERS', ...
        'PaperPosition',[0, 4, 28, 14]);
    switch i
        case 1
            title('Position error X')
            ylabel('m')
            ylim([ePmin ePmax])
            print(FigH,'-dpdf','X position and error.pdf')
        case 2
            title('Position error Y')
            ylabel('m')
            ylim([ePmin ePmax])
            print(FigH,'-dpdf','Y position and error.pdf')            
        case 3
            title('Velocity error X')
            ylabel('m/s')            
            ylim([eVmin eVmax])
            print(FigH,'-dpdf','X velocity and error.pdf')            
        case 4
            title('Velocity error Y')
            ylabel('m/s')
            ylim([eVmin eVmax])
            print(FigH,'-dpdf','Y velocity and error.pdf')
            
    end
end

end

