close all
clear all
clc

load('cameraCalibration.mat')

spoolFrontCam = webcam('USB Camera #2');
spoolSideCam = webcam('USB Camera');
printName = 'Klein Bottle';
refreshRate = 0.5;
filimentMask = @OrangeFilimentMask;


spinStoppingThreshold = 15;
spinThreshold = 0.25;
lastSpinDetected = 0;

filimentEmptyThreshold = 0.01;

tic;
spinClock = tic;
spinTime = 0;
spinStopFlag = 0;
filimentEmptyFlag = 0;

if(~isfolder('Prints'))
    mkdir('Prints')
end

d = datestr(datetime(now,'ConvertFrom','datenum'));
dataFile = [printName, '-', d, '.mat'];
dataFile = replace(dataFile, ' ', '-');
mkdir(['Prints/', dataFile])
figDir = ['Prints/', dataFile, '/'];

t = [];
i = 0;

spoolAngles = [];
spoolAnglesFiltered = [];
filimentRatios = [];
figure,
while(1 == 1)
    while(toc < refreshRate)
    end
    spoolFront = undistortImage(snapshot(spoolFrontCam), spoolCamFront);
    
    spoolSide = undistortImage(snapshot(spoolSideCam), cameraParamsSpoolSide);
    spoolAngle = getSpoolAngle(spoolFront);
    if(spoolAngle == 'UNABLE TO FIND MARKER')
        ['Heck']
        tic;
        continue;
    end
    [ratio, weight] = getRemainingFiliment(spoolSide, filimentMask, 306, 760, 1.0151e+03);
    t = [t, i*refreshRate];
    i = i+1;
    spoolAngles = [spoolAngles, spoolAngle];
    
    filimentRatios = [filimentRatios, ratio];
    clf
    hold on
    subplot 211
    plot(t, medfilt1(spoolAngles, 20), 'Color', 'Black', 'Linewidth', 3)
    xlabel('Time (sec)')
    ylabel('Angle (rad)')
    ylim([-pi, pi])
    grid on
    subplot 212
    plot(t, medfilt1(filimentRatios, 20), 'Color', 'Black', 'Linewidth', 3)
    xlabel('Time (sec)')
    ylabel('Remaining Filiment (%)')
    ylim([0, 1.05])
    grid on
    
    
    spoolAnglesFiltered = medfilt1(spoolAngles, 20);
    if(t(end) > 1.5*spinStoppingThreshold)
        abs(spoolAnglesFiltered(end) - spoolAnglesFiltered(end - round(spinStoppingThreshold / refreshRate)))
        if (abs(spoolAnglesFiltered(end) - spoolAnglesFiltered(end - round(spinStoppingThreshold / refreshRate))) < spinThreshold)
            spinStopFlag = 1;
        else
            spinStopFlag = 0;
        end
        filimentRatios(end)
        if(filimentRatios(end) < filimentEmptyThreshold)
            filimentEmptyFlag = 1;
        else
            filimentEmptyFlag = 0;
        end
        
        
        if (filimentEmptyFlag == 1 && spinStopFlag == 1)
            beep
            subplot 212
            hold on
            plot(t, medfilt1(filimentRatios, 20), 'Color', 'Black', 'Linewidth', 3)
            xlabel('Time (sec)')
            ylabel('Remaining Filiment (%)')
            ylim([0, 1.05])
            grid on
            plot([t(end), t(end)], [-10, 10], 'Color', 'Red', 'Linewidth', 3)
            hold off
            hold off
            disp('Empty Filiment Detected')
            saveas((gcf), [figDir, num2str(i)])
        elseif (filimentEmptyFlag == 0 && spinStopFlag == 1)
            beep
            disp('Entanglement Detected')
            subplot 211
            hold on
            plot(t, medfilt1(spoolAngles, 10), 'Color', 'Black', 'Linewidth', 3)
            xlabel('Time (sec)')
            ylabel('Angle (rad)')
            ylim([-pi, pi])
            grid on
            plot([t(end), t(end)], [-10, 10], 'Color', 'Red', 'Linewidth', 3)
            hold off
            saveas((gcf), [figDir, num2str(i)])
        end
    end
    
    hold off
    
    tic;
    save([figDir, dataFile]);
end