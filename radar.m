close all
clear
clc
delete *.pdf

%read file. fileName, dataRanges may need modification for different scenarios
fileName='Scenario_crossing_left_to_right_50mph.csv';
startRowNO=2;
refStartColumn='C';
radStartColumn='H';
refDataRange='C2..G646';
radDataRange='H2..KA646';
refData=csvread(fileName, startRowNO-1,refStartColumn-65,refDataRange);
radData=csvread(fileName,startRowNO-1,radStartColumn-65,radDataRange);

%define the total number of objects
objTltNum=40;
segThreshold=1.4; % control segmentation: 1.1-1.4 segment to 3, >1.8 no segmentation

%find the number of the relavant object based on range
costFun=zeros(objTltNum,1);
for i=1:objTltNum
    costFun(i)=mean(abs(sqrt(radData(:,i).^2+radData(:,i+objTltNum).^2)-refData(:,1)));
end
[costFunMin, objNum]=min(costFun);
objNum

%position and velocity calculation from DGPS
%ref Px,Py,Vx,Vy
refPV_XY(:,1)=refData(:,1).*cos(-refData(:,3)/180*pi);
refPV_XY(:,2)=refData(:,1).*sin(-refData(:,3)/180*pi);
refPV_XY(:,3)=refData(:,2).*cos(-refData(:,3)/180*pi)/3.6;%km/h -- m/s
refPV_XY(:,4)=refData(:,2).*sin(-refData(:,3)/180*pi)/3.6;
%position and velocity from radar
%rad Px,Py,Vx,Vy
for i=0:3
    radPV_XY(:,i+1)=radData(:,objNum+i*objTltNum);
end

%plot trajectory
PlotTrajectory(radPV_XY,refPV_XY);

%lifetime error calculation
%ePx,ePy,eVx,eVy
errPV_XY=radPV_XY-refPV_XY;
%mean, std(ePx,ePy,eVx,eVy)
meanLifeErrPV_XY=mean(errPV_XY)
stdLifeErrPV_XY=std(errPV_XY)

%get t for uniaxial error ploting, and segmentation
%let time start from 0
t=refData(:,5)-refData(1,5);
%remove wrong points in t, this is a jump in t data
for i=1:length(t)-2
    if abs(t(i+1)-t(i))>0.1% Tsample is about 0.05
        t(i+1)=(t(i)+t(i+2))/2;
    end
end
%call defined function to plot position,velocity at X Y and related errors.
PlotPosVelErr_XY(refPV_XY,radPV_XY,errPV_XY,t);


%segmentation process based on mean speed
sMean=mean(sqrt(radPV_XY(:,3).^2+radPV_XY(:,4).^2));
isMove=zeros(1,length(t));
for i=1:length(t)
    %if currenty velocity is bigger than mean+thresold, then in motion
    if sqrt(radPV_XY(i,3)^2+radPV_XY(i,4)^2)>sMean-segThreshold
        isMove(i)=1;
    end
end

%plot the segmention result with a function
PlotSegmentationResult(t,radPV_XY,refPV_XY,isMove);
%check segmentation result
hasSeg=0;
temp=1;
for i=1:length(t)-1
    if isMove(i+1)-isMove(i)~=0
        indTran(temp)=i;
        hasSeg=1;
        temp=temp+1;
    end
end

if hasSeg==1
    %create variables to store segmented processes' errors
    %time of motion status transition
    tTran=zeros(length(indTran)+1,1);% there is one more segmentation than the number of motion status transiation
    %mean,std of segmented ePx,ePy,eVx,eVy
    meanSegErrPV_XY=zeros(length(indTran)+1,4);
    stdSegErrPV_XY=zeros(length(indTran)+1,4);
    %calculate mean and std of segmented ePx,ePy,eVx,eVy
    temp=1;
    for i=1:length(indTran)+1
        if i==1
            tTran(temp)=t(indTran(1));% from 0 to the first status change
            meanSegErrPV_XY(temp,:)=mean(errPV_XY(1:indTran(i),:));
            stdSegErrPV_XY(temp,:)=std(errPV_XY(1:indTran(i),:));
        elseif i==length(indTran)+1 %last status change to end
            tTran(temp)=max(t)
            meanSegErrPV_XY(temp,:)=mean(errPV_XY(indTran(i-1)+1:length(t),:))
            stdSegErrPV_XY(temp,:)=std(errPV_XY(indTran(i-1)+1:length(t),:))    
        else
            tTran(temp)=t(indTran(i));%others
            meanSegErrPV_XY(temp,:)=mean(errPV_XY(indTran(i-1)+1:indTran(i),:));
            stdSegErrPV_XY(temp,:)=std(errPV_XY(indTran(i-1)+1:indTran(i),:));
        end
        temp=temp+1;
    end
end

%Statistical result report
reportFileName='Report.csv';
fid = fopen(reportFileName, 'w') ;
%lifetime error of Px,Py,Vx,Vy
fprintf(fid,'%s,%s,%s,%s,%s,%s\n',...
    ' ','Time(s)','E_Pos_X(m)','E_Pos_Y(m)','E_Vel_X(m/s)','E_Vel_Y(m/s)');
fprintf(fid,'%s,%s,%f,%f,%f,%f\n','Mean',strcat('0 --  ',num2str(max(t))),...
    meanLifeErrPV_XY(:));
fprintf(fid,'%s,%s,%f,%f,%f,%f\n','Std',strcat('0 --  ',num2str(max(t))),...
    stdLifeErrPV_XY(:));
%if has segmentations, write segmented errors under lifetime results in the form
if hasSeg==1
    fprintf(fid,'%s,%s,%f,%f,%f,%f\n','MeanSeg_1',strcat('0 --  ',num2str(tTran(1))),...
        meanSegErrPV_XY(1,:));
    fprintf(fid,'%s,%s,%f,%f,%f,%f\n','StdSeg_1',strcat('0 --  ',num2str(tTran(1))),...
        stdSegErrPV_XY(1,:));
    for i=2:length(tTran)
        fprintf(fid,'%s,%s,%f,%f,%f,%f\n',strcat('MeanSeg_',num2str(i)),strcat(num2str(tTran(i-1)),...
            strcat(' --  ',num2str(tTran(i)))),meanSegErrPV_XY(i,:));
        fprintf(fid,'%s,%s,%f,%f,%f,%f\n',strcat('StdSeg_',num2str(i)),strcat(num2str(tTran(i-1)),...
            strcat(' --  ',num2str(tTran(i)))),stdSegErrPV_XY(i,:));
    end
end
fclose(fid);
open Report.csv
