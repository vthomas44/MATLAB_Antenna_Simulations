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
%%
%clear BERP;

BERP_Var=zeros(1,noofAntennas);
BERP_Mean=zeros(1,noofAntennas);
gammaBar = 10; % set scale of x-axis in dB
simLength = 50;  % set simulation duration and accuracy
gamma = zeros(noofAntennas,simLength);
gammaLin = 10.^(gammaBar/10);
u = rand(noofAntennas,simLength);
figure;
for j = 1:noofAntennas
    ax1 = nexttile;
    for i = 1:j
            gamma(i,:) = -gammaLin.*log(1-u(i,:));
       hold('on')
       grid on;
       semilogy(gamma(i,:), 'Color', rand(1,3),'LineWidth',2)
       title('Gamma plot when no:of Antenna= 1')
       xlabel('i','FontSize', 18)
       set(gca,'fontsize',20);
       ylabel('gamma(dB)','FontSize', 18)
       hold off
    end

    if j == 1
        BERP = (0.5.*erfc(sqrt(gamma(i,:))));
        BERP_Var(j) = var(BERP);
        BERP_Mean(j) = mean2(BERP);

    elseif j == 2 && noofAntennas == 2  
        max_gammaMat = max(gamma(1,:),gamma(2,:)) ;
        for i = 1:simLength
            max_BERPMat(:,i) = mean(0.5.*erfc(sqrt(max_gammaMat(:,i))));
        end
        hold('on')
        grid on;
        semilogy(max_gammaMat, 'Color', [0 0 0],'LineWidth',3);
        title('Gamma plot when no:of Antenna=', num2str(j));
        xlabel('i','FontSize', 18)
        set(gca,'fontsize',20);
        ylabel('gamma(dB)','FontSize', 18)
        hold off
        BERP_Var(j) = var(max_gammaMat);
        BERP_Mean(j) = mean2(max_gammaMat);

    else
        max_gammaMat = max(max(gamma,[],noofAntennas));

        for i = 1:simLength
            max_BERPMat(:,i) = mean(0.5.*erfc(sqrt(max_gammaMat(:,i))));
        end

        hold('on')
        plot(max_gammaMat, 'Color', [0 0 0],'LineWidth',2);
        title('Gamma plot when no:of Antenna=', num2str(j));
        xlabel('i','FontSize', 18)
        ylabel('gamma','FontSize', 18)
        hold off

        BERP_Var(j) = var(max_gammaMat);
        BERP_Mean(j) = mean2(max_gammaMat);
    end
end
figure;

subplot (2,1,1)
ylim([0 0.02]);
plot(smooth(BERP_Var),'LineWidth',3);
grid on;
dummyh = line(nan, nan, 'Linestyle', 'none', 'Marker', 'none', 'Color', 'none');
legend(dummyh,'$\bar{\gamma}$ = 0 dB','Interpreter','Latex');
legend show;
title('Variance [\sigma ^{2}] depends on No:of Antennas');
xlabel('No:of Antennas->')
ylabel('VAR[\sigma ^{2}]')

subplot (2,1,2)
plot(smooth(BERP_Mean),'LineWidth',3);
grid on;
title('Diversity Gain');
xlabel('No:of Antennas->')
ylabel('E[\gamma]')
dummyh = line(nan, nan, 'Linestyle', 'none', 'Marker', 'none', 'Color', 'none');
leg=legend(dummyh,'$\bar{\gamma}$ = 0 dB','Interpreter','Latex');
set(leg,'location','southeast')
legend show;
hold off

figure;
semilogy(max_BERPMat, 'color', [0 0.5 0]);
