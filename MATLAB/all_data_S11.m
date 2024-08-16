% PLOTTER ALLE MÅLINGER I EN MAPPE

name = 'tom_celle';

date1 = '20240206';

% FREQUENCY AREA
freq_start=5; %GHz 
freq_stop=12; %GHz 

cd(sprintf('/Users/annamatheaskar/Desktop/Master/Measurements/%s/', date1));

files = dir('tom_celle.txt') ;   % you are in the folder of files 
N = length(files);

figure
for i = 1:N
    thisfile = files(i).name ; % just the name
    data = importdata(thisfile); % loading the file
    timedate_name=erase(thisfile, {name, '_', '.txt'});
    timedate(i)=datetime(timedate_name, 'InputFormat', 'yyyyMMddHHmmss', 'Timezone','local');

    f = data(:,1) ; 
    S11_Re = data(:,2) ; 
    S11_Im = data(:,3) ;
    
    S11c{i}=S11_Re+1i*S11_Im;
    plot(f./10e8, 20*log10(abs(S11c{i}))); hold on;
end

%xlim([5.7, 5.76]);
%ylim([-18, 0]);
set(gca,'fontsize',13,'TickLabelInterpreter','latex')
%title(sprintf('Celle med %s S11', name),'fontsize',14,'interpreter','latex');
xlabel('Frequency [GHz]','fontsize',15,'interpreter','latex');
ylabel('$20log_{10}\mid \Gamma \mid $ [dB]','fontsize',15,'interpreter','latex');



