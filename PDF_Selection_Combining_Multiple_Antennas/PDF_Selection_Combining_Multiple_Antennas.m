%%% Basic preparations
clear all   % deletes all variables from workspace
close all   % closes all open figures
clc         % clears the messages in the command window
%%
noofAntennas = 4;

gammaBarPlotdB = 5;
numIplot = 500;
simLength = 200;

gammaLin = 10.^(gammaBarPlotdB/10);
u = rand(noofAntennas, simLength);
    hold('on')
for j=1:noofAntennas      
        gamma(j,:) = (-10.^(gammaBarPlotdB/10)).*log(1-u(j,:));
        if j~=1
            gammaMax(j,:)=max(gamma(1:j,:));
        else
            gammaMax(j,:)=gamma(1,:);
        end
    plotMean = mean(gammaMax(j,:));
    y = -10:1:20;
    mu = plotMean;
    sigma = std(gammaMax(j,:));
    f = exp(-(y-mu).^2./(2*sigma^2))./(sigma*sqrt(2*pi));
    grid on;
    plot(y,f,'LineWidth',2.5)
    title('Illustration of Probablity Density Function for Selection Combining Method', 'FontSize', 18);
    xlabel('$\gamma/dB$', 'Interpreter','Latex', 'FontSize', 18);
    ylabel('$p(\gamma)$', 'Interpreter','Latex', 'FontSize', 18);
    legendInfo{j} = ['N_r =' num2str(j')];
end
    legend(legendInfo, 'FontSize', 14);
    set(gca,'fontsize',20);
    hold off
