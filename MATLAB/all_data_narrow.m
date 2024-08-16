
% ALL MEASURED PERMITTIVITIES FROM A FOLDER, AND NARROW VIEW

clear all;

date = '20240404';

%name = 'nitrogen'; 
%name = 'carbondioxid';
name = 'mixture';

date = '20240404';
starttime = '141230'; %mix
lab_adj = '02:05:55'; 


temp = 'T=21.1';
purity=1;
goal=1;
T=21.1;
p=1:1:100;

de_file = 'mixture-de_p5-T1-p100.mat';

mid_values = [5.5, 5.78, 6.1, 6.8, 7.7, 8.8]; %measurement 1
measurement_time=88;
half_time=44;
time_start_p = datetime(sprintf('%s%s', date, starttime), 'InputFormat', 'yyyyMMddHHmmss', 'Timezone','local');

%labPC_adj = datetime(sprintf('%s%s', date, lab_adj), 'InputFormat', 'yyyyMMddHHmmss', 'Timezone','local');
labPC_adj = duration(sprintf('%s', lab_adj));
no_time = datetime(sprintf('%s000000', date), 'InputFormat', 'yyyyMMddHHmmss', 'Timezone','local');

freq_start=5; %GHz 10.47
freq_stop=9; %GHz 10.67

% SMALLER FREQUENCY AREA
narrow_start=8.15; %GHz 10.47
narrow_stop=8.35; %GHz 10.67

cd(sprintf('/Users/annamatheaskar/Desktop/Master/Measurements/%s/%s', date, name));

%% PLOT S11 WHOLE DATA FROM SENSOR TXT FILE

files = dir('*.txt') ;   % you are in the folder of files 
N = length(files) ;
% loop for each file 
S11c={};
figure
for i = 1:N
    thisfile = files(i).name ; % just the name
    data = importdata(thisfile); % loading the file
    timedate_name=erase(thisfile, {name, '_', '.txt'});
    timedate(i)=datetime(timedate_name, 'InputFormat', 'yyyyMMddHHmmss', 'Timezone','local')-labPC_adj;
    % do what you want 
    f = data(:,1) ; 
    S11_Re = data(:,2) ; 
    S11_Im = data(:,3) ;
    if i==7
        S11c_second=S11_Re+1i*S11_Im;
    end
    S11c{i}=S11_Re+1i*S11_Im;
    plot(f./10e8, 20*log10(abs(S11c{i}))); hold on; % with the present data
    % 'DisplayName', datestr(timedate(i))
end


%legend show
set(gca,'TickLabelInterpreter','latex')
legend({datestr(timedate(:))},'fontsize',11,'interpreter','latex');

%title(sprintf('Celle med %s S11', name),'fontsize',14,'interpreter','latex');
xlabel('Frequency [GHz]','fontsize',14,'interpreter','latex');
ylabel('$\mid$S11$\mid$ [dB]','fontsize',14,'interpreter','latex');

%% IMPORTING PRESSURE MEASUREMENTS

cd(sprintf('/Users/annamatheaskar/Desktop/Master/Measurements/%s/', date));
pressure_name = append(name, '_pressure.txt');
pressure_data = importdata(pressure_name);
pressure_data = erase(pressure_data(2:end), '*0001'); % string in cell [bara]
pressure_time = time_start_p + seconds(1:1:length(pressure_data));

%% IMPORTING THEORETICAL DIELECTRIC CONSTANT

cd(sprintf('/Users/annamatheaskar/Desktop/Master/teoretiske datasett/Dielektrisk konstant/%s/', temp));
de1=load(sprintf('/Users/annamatheaskar/Desktop/Master/teoretiske datasett/Dielektrisk konstant/%s/%s', temp, de_file)); %henter "de"

for n=1:length(p)
    de_p(n)=de1.de(find(purity==goal),1,n);
end

p_fit=polyfit(p(1:55)', de_p(1:55)', 5); %5th polynomial
xfit=1:0.0001:55; %picking out wanted pressures
yfit=polyval(p_fit,xfit);


%% PLOTTING NARROW FREQUENCY AREA
cd(sprintf('/Users/annamatheaskar/Desktop/Master/Measurements/%s/%s', date, name));

% LISTING START AND END TIMES
time_start={}; %Start of measurement + 90 seconds
time_stop={};
index_start=[];
index_stop=[];
% FREQUENCY WINDOW
f_narrow={};
S11c_narrow={};
min_f={}; %minimum frequency in narrow area
% PRESSURE AVERAGE + MAX/MIN
p_add=[];
p_avg=[];
min_p=[];
max_p=[];
% MODES DATA
c=3*10.^8;
p_TM=[2.405,5.520,8.654,11.792; 3.832,7.016,10.174,13.324; ...
    5.135,8.417,11.620,14.796;6.380,9.761,13.015,16.223]; % for 0<n<2 og 1<m<3
my_r=1;
a=0.02;
h=0.1;

for i = 1:N
    thisfile = files(i).name ; % just the name
    data = importdata(thisfile); % loading the file
    timedate_name=erase(thisfile, {name, '_', '.txt'});
    timedate(i)=datetime(timedate_name, 'InputFormat', 'yyyyMMddHHmmss', 'Timezone','local')-labPC_adj;
    % FINDING START AND STOP FREQUENCIES
    
    f = data(:,1) ;
    f = f./10e8;
    f_round = round(f,3);
    
    for m=1:length(mid_values)-1 % FOR ALL INTERVALS
    
        f_round = round(f,3);
        if isempty(find(f_round==mid_values(m)))
            f_round = round(f,2);
            from = find(f_round==mid_values(m));
        else
            from = find(f_round==mid_values(m));
        end
        if isempty(find(f_round==mid_values(m+1)))
            f_round = round(f,2);
            to = find(f_round==mid_values(m+1));
        else
            to = find(f_round==mid_values(m+1));
        end
        
        % NARROW
        f_narrow{i}{m} = f(from:to);
        S11_Re = data(:,2) ; 
        S11_Re_narrow = S11_Re(from:to);
        S11_Im = data(:,3) ;
        S11_Im_narrow = S11_Im(from:to);
        S11c_narrow{m}{i}=S11_Re_narrow+1i*S11_Im_narrow;

        % finding min frequency value - HAVE TO FIND THIS MIN VALUE OVER ALL POINTS
        [M,I] = min(20*log10(abs(S11c_narrow{m}{i})));
        min_f{m}{i}=f_narrow{i}{m}(I);
        min_S11{m}{i}=S11c_narrow{m}{i}(I);
        
    end
    
    %FINDING START AND STOP TIMES
    time=erase(thisfile, {name, '_', date, '.txt'});
    start=datetime(sprintf('%s%s', date, time), 'InputFormat', 'yyyyMMddHHmmss', 'Timezone','local');
    start= start - labPC_adj;
    time_start(i)= cellstr(start); %Adjusting wrong lab-PC time
    stop = start + seconds(measurement_time);
    time_stop(i)=cellstr(stop);
    time_half(i)=start + seconds(half_time);
    
    % FINDING PRESSURES AT TIMES OF MW MEASUREMENTS
    if find(string(cellstr(pressure_time)) == string(time_start(i)))
        index_start(i)=find(string(cellstr(pressure_time)) == string(time_start(i)));
    else
        index_start(i)=0;
    end
    if find(string(cellstr(pressure_time)) == string(time_stop(i)))
        index_stop(i)=find(string(cellstr(pressure_time)) == string(time_stop(i)));
    else
        index_stop(i)=0;
    end
    % FINDING AVERAGE PRESSURE AND MIN/MAX
    if (index_start(i) ~= 0 && index_stop(i) ~= 0)
        p_add(i)=sum(str2double(pressure_data(index_start(i):index_stop(i))));
        p_avg(i)=p_add(i)/length(pressure_data(index_start(i):index_stop(i))); %bara

        min_p(i)=min(str2double(pressure_data(index_start(i):index_stop(i))));
        max_p(i)=max(str2double(pressure_data(index_start(i):index_stop(i))));
        
        diff_p(i)=max_p(i)-min_p(i); % big is over 0.2 or 0.1 bara
    end
    % FINDING NEAREST PRESSURE VALUE MATCH
    if i<=length(p_avg) && p_avg(i) ~= 0
        [val,id]=min(abs(xfit-p_avg(i)));
        %THEORETICAL DIELECTRIC CONSTANT FOR EACH PRESSURE
        e_r(i)=yfit(id);
    end
end

while pressure_time(end) < time_stop(end) %chech if MW measurements go on for longer than P
    N=N-1;
    time_start(end) = [];
    time_stop(end) = [];
end

% PLOTTING PRESSURE/TIME - MIN/MAX?
p_idx=[];
w=0;
for i=1:length(pressure_data)
    if exist(pressure_data{i}) || str2double(pressure_data{i}) > 55
        p_idx(i)=0;
        pressure_data{i}=[];
        pressure_time(i-w)=[];
    else
        p_idx(i)=1;
    end
    w=w+1;
end
pressure_data=pressure_data(~cellfun('isempty',pressure_data));

%% THEORETICAL MODES

for i = 1:N 
    if e_r(i) ~= 0
        Dat(1,i).name  = 'TM$_{010}$';
        Dat(1,i).value = (c./(2*pi*sqrt(my_r*e_r(i))))*(p_TM(1,1)./a);
        Dat(2,i).name  = 'TM$_{011}$';
        Dat(2,i).value = (c./(2*pi*sqrt(my_r*e_r(i))))*sqrt((p_TM(1,1)./a).^2+(1*pi./h).^2);     
        Dat(3,i).name  = 'TM$_{012}$';
        Dat(3,i).value = (c./(2*pi*sqrt(my_r*e_r(i))))*sqrt((p_TM(1,1)./a).^2+(2*pi./h).^2);
        Dat(4,i).name  = 'TM$_{013}$';
        Dat(4,i).value = (c./(2*pi*sqrt(my_r*e_r(i))))*sqrt((p_TM(1,1)./a).^2+(3*pi./h).^2);
        Dat(5,i).name  = 'TM$_{014}$';
        Dat(5,i).value = (c./(2*pi*sqrt(my_r*e_r(i))))*sqrt((p_TM(1,1)./a).^2+(4*pi./h).^2);
        Dat(6,i).name  = 'TM$_{015}$';
        Dat(6,i).value = (c./(2*pi*sqrt(my_r*e_r(i))))*sqrt((p_TM(1,1)./a).^2+(5*pi./h).^2);
        Dat(7,i).name  = 'TM$_{016}$';
        Dat(7,i).value = (c./(2*pi*sqrt(my_r*e_r(i))))*sqrt((p_TM(1,1)./a).^2+(6*pi./h).^2);
        Dat(8,i).name  = 'TM$_{017}$';
        Dat(8,i).value = (c./(2*pi*sqrt(my_r*e_r(i))))*sqrt((p_TM(1,1)./a).^2+(7*pi./h).^2);
        Dat(9,i).name  = 'TM$_{018}$';
        Dat(9,i).value = (c./(2*pi*sqrt(my_r*e_r(i))))*sqrt((p_TM(1,1)./a).^2+(8*pi./h).^2);
        Dat(10,i).name  = 'TM$_{019}$';
        Dat(10,i).value = (c./(2*pi*sqrt(my_r*e_r(i))))*sqrt((p_TM(1,1)./a).^2+(9*pi./h).^2);
        Dat(11,i).name  = 'TM$_{020}$';
        Dat(11,i).value = (c./(2*pi*sqrt(my_r*e_r(i))))*(p_TM(1,2)./a);
        Dat(12,i).name  = 'TM$_{021}$';
        Dat(12,i).value = (c./(2*pi*sqrt(my_r*e_r(i))))*sqrt((p_TM(1,2)./a).^2+(1*pi./h).^2);
        Dat(13,i).name  = 'TM$_{022}$';
        Dat(13,i).value = (c./(2*pi*sqrt(my_r*e_r(i))))*sqrt((p_TM(1,2)./a).^2+(2*pi./h).^2);

        % SORTED STRUCT ARRAY
        x_m=0;
        idx_m=0;
        [x,idx]=sort([Dat(:,i).value]);
        Dat(:,i)=Dat(idx,i);
        
        for m=1:length(Dat(:,i))
            Dat(m,i).value=Dat(m,i).value./10e8;
        end
        
        % Create a logical index to identify elements to keep
        keep_indices = [Dat(:,i).value] >= freq_start & [Dat(:,i).value] <= freq_stop;

        % Filter Dat1 based on the logical index
        Dat_new(:,i) = Dat(keep_indices,i);
    end

end

%% figure S11 measurement and bottom point
min_f=transpose(min_f); 
min_S11=transpose(min_S11);

min_f_new = cell(length(files), length(Dat_new(:,1)));
min_S11_new = cell(length(files), length(Dat_new(:,1)));

% Nested loop to rearrange the elements
for i = 1:length(files)
    for m = 1:length(Dat_new(:,1))
        min_f_new{i}{m} = min_f{m}{i};
        min_S11_new{i}{m} = min_S11{m}{i};
    end
end

date_yes=[];
figure
for i=1:length(diff_p)-1 %-1 for n2
    if diff_p(i)<0.2
        plot(f, 20*log10(abs(S11c{i})), '-'); hold on;
        %plot([min_f_new{i}{:}], 20*log10(abs([min_S11_new{i}{:}])), '*'); hold on;
        date_yes(i)=i;
    end
end
date_yes(date_yes==0) = [];
xlim([8.12,8.33]);
%xlim([5,9]);

set(gca,'fontsize',14,'TickLabelInterpreter','latex')
%legend({datestr(timedate(date_yes))},'fontsize',11,'interpreter','latex');
%title(name,'fontsize',14,'interpreter','latex');
xlabel('Frequency [GHz]','fontsize',16,'interpreter','latex');
ylabel('$20log_{10}\mid\Gamma\mid$ [dB]','fontsize',16,'interpreter','latex');

