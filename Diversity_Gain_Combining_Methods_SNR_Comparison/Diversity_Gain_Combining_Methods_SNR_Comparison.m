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
gammaBar = 10;
gammaLin = 10.^(gammaBar/10);
simLength = 1e6;
u = rand(noofAntennas, simLength);
gammaBarPlotdB = 5;
numIplot = 500;


    gamma=-gammaLin.*log(1-u);

    for j=1:noofAntennas
        gammaequalgain=1/2.*(sum(gamma(1:j,:))).^2;
        gammamrc=sum(gamma(1:j,:));
        if j~=1
            gammaMax=max(gamma(1:j,:));
        else
            gammaMax=gamma(1,:);
        end


        gammaMax=10*log(sum(1/j));
        gammaEqu=10*log(1+((j-1)*0.785));
        gammaMrc=10*log(j);
    end

hold on;
semilogy(gammaMax, 'color', [0 0.5 0], 'DisplayName', strcat(' Selction Combaining'));
semilogy(gammaEqu, 'color', [0.5 0.5 0], 'DisplayName', strcat(' Equal Gain'));
semilogy(gammaMrc, 'color', [1 0.5 0], 'DisplayName', strcat(' Maximum Ratio'));
legend('show','FontSize', 12, 'location', 'northeast');
hold off;
