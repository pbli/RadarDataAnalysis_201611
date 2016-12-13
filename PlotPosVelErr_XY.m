function [  ] = PlotPosVelErr_XY(refPV_XY,radPV_XY,errPV_XY,t)

for i=1:4
    FigH = figure;
    plot(t,refPV_XY(:,i),'r','LineWidth',3) 
    hold on
    plot(t,radPV_XY(:,i),'b','LineWidth',1.5)
    set(gca,'FontSize',13)
    grid on
    legend('Reference Data','Radar Data')    
    xlabel('t(s)')
    set(gcf,'PaperType','usletter', ...
        'paperOrientation', 'landscape', ...
        'paperunits','CENTIMETERS', ...
        'PaperPosition',[-1, 0, 29, 22]);
    switch i
        case 1
            title('Position on X axis')
            ylabel('m') 
            legend('Reference Data','Radar Data' ,'Location','SouthEast')
            print(FigH,'-dpdf','Position on X axis.pdf')
        case 2
            title('Position on Y axis')
            ylabel('m')            
            print(FigH,'-dpdf','Position on Y axis.pdf')
        case 3
            title('Velocity on X axis')
            ylabel('m/s')            
            print(FigH,'-dpdf','Velocity on X axis.pdf')
        case 4
            title('Velocity on Y axis')
            ylabel('m/s')            
            print(FigH,'-dpdf','Velocity on Y axis.pdf')
    end

    FigH = figure;
    plot(t,errPV_XY(:,i),'b','LineWidth',1.5) 
    set(gca,'FontSize',13)
    xlabel('t(s)')
    grid on
    set(gcf,'PaperType','usletter', ...
        'paperOrientation', 'landscape', ...
        'paperunits','CENTIMETERS', ...
        'PaperPosition',[-1, 0, 29, 22]);
    switch i
        case 1
            title('Position error on X axis')
            ylabel('m')
            print(FigH,'-dpdf','Possition error on X axis.pdf')
        case 2
            title('Position error on Y axis')
            ylabel('m')
            print(FigH,'-dpdf','Position error on Y axis.pdf')            
        case 3
            title('Velocity error on X axis')
            ylabel('m/s')
            print(FigH,'-dpdf','Velocity error on X axis.pdf')            
        case 4
            title('Velocity error on Y axis')
            ylabel('m/s')
            print(FigH,'-dpdf','Velocity error on Y axis.pdf')            
    end
end

end

