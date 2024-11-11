%%% Basic preparations
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
gammaBar = -10:0.5:30;

gammaBarPlotdB = 5;
numIplot = 500;
simLength = 1e7;

u = rand(noofAntennas, simLength);

% First PLot
gammaLin = 10.^(gammaBar/10);
tiledlayout(2,2);
nexttile;
semilogy(gammaBar, 1/2*erfc(sqrt(gammaLin)));
grid on;
xlim([min(gammaBar) max(gammaBar)]);
ylim([10^(-10) 10^(0)]);
xlabel('$\bar{\gamma}$/dB','Interpreter','Latex','FontSize', 14);
ylabel('BER','FontSize', 12);
title('Theoretical BER without fading','FontSize', 14);
legend('BER(BPSK)', 'FontSize', 14, 'location', 'southwest');

% Second Plot
gamma=(-10.^(gammaBarPlotdB/10)).*log(1-u(1,:));
plotMean = 10*log10(mean(gamma(1:numIplot)));
nexttile;
instantBER = 1/2*erfc(sqrt(gamma(1:numIplot)));
semilogy(instantBER, 'Color',[0 0.4470 0.7410]);
grid on;
title(['Instantaneous values of BER  when \gamma = ', num2str(gammaBarPlotdB), ' dB and no:of Antenna = 1'], 'FontSize', 14);
ylim([10^(-10) 10^(0)]);
xlabel('i', 'FontSize', 14);
ylabel('BER', 'FontSize', 14);
yline(mean(instantBER), 'LineWidth',3,'Color', 'blue');
yline(1/2*erfc(sqrt(10.^(plotMean/10))), 'LineWidth',3,'Color', 'green');
legend('BER(i)', 'BER_M_e_a_n','BER(\gamma_m_e_a_n)', 'FontSize', 14, 'location', 'southwest');

% Third Plot
nexttile;
plot(10*log10(gamma(1:numIplot)), 1:numIplot);
grid on;
xlim([min(gammaBar) max(gammaBar)]);
xline(plotMean, 'LineWidth',3);
xlabel('\gamma/dB', 'FontSize', 14);
ylabel('i', 'FontSize', 14);
title([' Time variant \gamma when \gamma_B_a_r = ', num2str(gammaBarPlotdB) ' dB and no:of Antenna = 1'], 'FontSize', 14);
legend('\gamma(i)','\gamma_m_e_a_n', 'FontSize', 14, 'location', 'southwest');

% Fourth PLot
nexttile;
semilogy(gammaBar,1/2*erfc(sqrt(gammaLin)),'LineWidth',3, 'DisplayName', 'Nr= 1 No Fading');
hold on;
plot(gammaBar,1/2.*(1-sqrt(gammaLin./(1+gammaLin))),'LineWidth',3, 'DisplayName', 'Theoretical Fading');
for i=1:length(gammaBar)
    gamma=-gammaLin(i).*log(1-u);
    for j=1:noofAntennas
        
        if j~=1
            gammaMax=max(gamma(1:j,:));
            gammaequalgain=1/2.*(sum(gamma(1:j,:))).^2;
            gammamrc=sum(gamma(1:j,:));
        else
            gammaMax=gamma(1,:);
        end
        BER(j,i)=mean(1/2* erfc(sqrt(gammaMax)));
        if j~=1
        BEREQ(j,i)=mean(1/2* erfc(sqrt(gammaequalgain)));
        BERMRC(j,i)=mean(1/2* erfc(sqrt(gammamrc)));
        end

    end
end
for j=1:noofAntennas
    
    if j==1
        semilogy(gammaBar,BER(j,:),'*-','LineWidth',3, 'DisplayName', strcat('Nr= ', num2str(j),' Fading'));
    else
        semilogy(gammaBar,BER(j,:),'*-','LineWidth',3, 'DisplayName', strcat('Nr= ', num2str(j),' Fading with Selection Combining'));
        semilogy(gammaBar,BEREQ(j,:),'o-','LineWidth',3, 'DisplayName', strcat('Nr= ', num2str(j),' Fading with Equal Gain Combining'));
        semilogy(gammaBar,BERMRC(j,:),'x-','LineWidth',3, 'DisplayName', strcat('Nr= ', num2str(j),' Fading with Maximum Ratio Combining'));
    end
end

grid on;
% title('BER for fading / non fading', 'FontSize', 16);
% xlabel('$\bar{\gamma}$/dB','Interpreter','Latex','FontSize', 18);
% ylabel('BER','FontSize', 18);
ylim([1e-6 1]);
xlim([-10 30]);
plot(gammaBar,1/2.*(1-sqrt(gammaLin./(1+gammaLin))),'LineWidth',3);
plot(gammaBar,1/2* erfc(sqrt(gammaLin)),'LineWidth',3);
legend('show','FontSize', 12, 'location', 'northeast');
set(gca,'fontsize',20);
hold off;

