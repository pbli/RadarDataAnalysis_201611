function [  ] = PlotPosVelErr_XY(refPV_XY,radPV_XY,errPV_XY,t)

for i=1:4
    figure
    subplot(2,1,1)
    plot(t,radPV_XY(:,i),'b','LineWidth',3)
    hold on
    plot(t,refPV_XY(:,i),'r','LineWidth',1.5)
    set(gca,'FontSize',15)
    grid on
    switch i
        case 1
            title('Position X')
            ylabel('m')
        case 2
            title('Position Y')
            ylabel('m')
        case 3
            title('Velocity X')
            ylabel('m/s')
        case 4
            title('Velocity Y')
            ylabel('m/s')
    end
    legend('rad','ref')
    xlim([0 max(t)+10] )% make sure the legend will not cover the plot
    xlabel('t(s)')
    subplot(2,1,2)    
    bar(t,errPV_XY(:,i))
    set(gca,'FontSize',15)
    xlim([0 max(t)+10])
    xlabel('t(s)')
    grid on
    switch i
        case 1
            title('Position error X')
            ylabel('m')
            print('Position and error at X axis','-dpng')
        case 2
            title('Position error Y')
            ylabel('m')
            print('Position and error at Y axis','-dpng')
        case 3
            title('Velocity error X')
            ylabel('m/s')
            print('Velocity and error at X axis','-dpng')
        case 4
            title('Velocity error Y')
            ylabel('m/s')
            print('Velocity and error at Y axis','-dpng')
    end
end

end

