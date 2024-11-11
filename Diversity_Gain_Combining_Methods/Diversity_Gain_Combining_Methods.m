clear all   % deletes all variables from workspace
close all   % closes all open figures
clc         % clears the messages in the command window
%%

prompt = {'Enter a number of antennas:'};
dlgtitle = 'Number of Antennas';
dims = [1 50];
definput = {''};
opts.Interpreter = 'tex';
answer = inputdlg(prompt,dlgtitle,dims,definput,opts);
noofAntennas = str2double(answer);

gammaBar = 10;
gammaLin = 10.^(gammaBar/10);
simLength = 1e6;
u = rand(noofAntennas, simLength);
numIplot = 500;

for i=1:length(gammaBar)
    gamma=-gammaLin(i).*log(1-u);
    for j=1:noofAntennas
        plotMean = 10*log10(mean(gamma(1:numIplot)));       

        if j~=1
            gammaMax=max(gamma(1:j,:));
            gammaequalgain=(1/2.*(sum(gamma(1:j,:))).^2);
            gammamrc=sum(gamma(1:j,:));
        else
            gammaMax(j,:)=gamma(1,:);
        end
        
        if j~=1
        plotx = 10*log10(mean(gammaMax(1:numIplot)));
        plotgammaMaxMean(j,i) = 10*log(plotx./plotMean);
        meanz(1,j) = 2.*real(mean(plotgammaMaxMean(j,:)));
        plotgammaequalgainMean(j,i) = 10*log(10*log10(mean(gammaequalgain(1:numIplot)))./plotMean);
        meanx(1,j) = real(mean(plotgammaequalgainMean(j,:)));
        plotgammamrcMean(j,i) = 10*log(10*log10(mean(gammamrc(1:numIplot)))./plotMean);
        meany(1,j) = 3.2.*real(mean(plotgammamrcMean(j,:)));
        end


        if j==1
        x(1,j)=sum(1./j);
        gammamaxeqn(1,j)=10*log(x(1,j));
        else
        x(1,j)=x(1,j-1)+sum(1./j);
        gammamaxeqn(1,j)=10*log(x(1,j));
        end
        gammaEqu(1,j)=10*log(1+((j-1)*0.785));
        gammaMrc(1,j)=10*log(j);
    end
end
% figure ;
hold on;
semilogy(smooth(gammamaxeqn),'*-', 'color', [1 0 1],'LineWidth',3, 'DisplayName', strcat(' Selction Combaining Method'));
semilogy(smooth(gammaEqu),'*-', 'color', [0 1 0],'LineWidth',3, 'DisplayName', strcat(' Equal Gain Combaining Method'));
semilogy(smooth(gammaMrc),'*-', 'color', [0 0.4470 0.7410],'LineWidth',3, 'DisplayName', strcat(' Maximum Ratio Combaining Method'));
% legend('show','FontSize', 12, 'location', 'northwest');
% hold off;
% figure ;
% hold on;
% semilogy(smooth(meanz),'LineWidth',3, 'color', [1 0 1], 'DisplayName', strcat(' Selection Combaining Method'));
% semilogy(smooth(meanx),'LineWidth',3, 'color', [0 1 0], 'DisplayName', strcat(' Equal Gain Combining'));
% semilogy(smooth(meany),'LineWidth',3,'color', [0.75 0.5 0], 'DisplayName', strcat(' Maximum Ratio Combining'));
grid on;
legend('show','FontSize', 18, 'location', 'northwest');
xlim([1 max(noofAntennas)]);
title('Diversity Gain', 'FontSize', 16);
xlabel('No:of Antennas(N_r)', 'FontSize', 18);
set(gca,'fontsize',20);
ylabel('${\it} 10log(\bar{\gamma}_{sc,egc,mrc}/\bar{\gamma_i})$','Interpreter','Latex', 'FontSize', 18);
hold off;
