%all_meas

clear all;

name1 = 'nitrogen';
name2 = 'carbondioxid';
name3 = 'mixture';

date1 = '20240206';
date2 = '20240404';

lab_adj1= '010504'; %meas 1
lab_adj2= '020555'; %meas 2

start_time1_1 = '111530'; %ni 
start_time1_2 = '131420'; %co2 

start_time2_1 = '101302'; %ni
start_time2_2 = '124439'; %co2
start_time2_3 = '141230'; %mix

% IMPORTING THEORETICAL DIELECTRIC CONSTANT
de_file1_1 = 'nitrogen-de_p1-T1-p100.mat';
de_file1_2 = 'co2-de_p1-T1-p100.mat';

de_file2_1 = 'nitrogen-de_p1-T1-p100.mat';
de_file2_2 = 'co2-de_p1-T1-p100.mat';
de_file2_3 = 'mixture-de_p5-T1-p100.mat';

% SMALLER FREQUENCY AREA - SECTIONS TO FIND RESONANCE FREQUENCY
mid_values1 = [5.5, 5.78, 6.1, 6.8, 7.7, 8.8, 9.9, 11, 12]; %meas 1
mid_values2 = [5.5, 5.78, 6.1, 6.8, 7.7, 8.8]; %meas 2

measurement_time=88;
half_time=44;

% START TIME PRESSURE
time_start_p1_1 = datetime(sprintf('%s%s', date1, start_time1_1), 'InputFormat', 'yyyyMMddHHmmss', 'Timezone','local');
time_start_p1_2 = datetime(sprintf('%s%s', date1, start_time1_2), 'InputFormat', 'yyyyMMddHHmmss', 'Timezone','local');

time_start_p2_1 = datetime(sprintf('%s%s', date2, start_time2_1), 'InputFormat', 'yyyyMMddHHmmss', 'Timezone','local');
time_start_p2_2 = datetime(sprintf('%s%s', date2, start_time2_2), 'InputFormat', 'yyyyMMddHHmmss', 'Timezone','local');
time_start_p2_3 = datetime(sprintf('%s%s', date2, start_time2_3), 'InputFormat', 'yyyyMMddHHmmss', 'Timezone','local');

no_time1 = datetime(sprintf('%s000000', date1), 'InputFormat', 'yyyyMMddHHmmss', 'Timezone','local');
no_time2 = datetime(sprintf('%s000000', date2), 'InputFormat', 'yyyyMMddHHmmss', 'Timezone','local');

labPC_adj1 = datetime(sprintf('%s%s', date1, lab_adj1), 'InputFormat', 'yyyyMMddHHmmss', 'Timezone','local')-no_time1;
labPC_adj2 = datetime(sprintf('%s%s', date2, lab_adj2), 'InputFormat', 'yyyyMMddHHmmss', 'Timezone','local')-no_time2;

% SMALLER FREQUENCY AREA
freq_start=5; %GHz
freq_stop1=12; %GHz 
freq_stop2=9; %GHz 

% IMPORTING PRESSURE DATA - NITROGEN 1

cd(sprintf('/Users/annamatheaskar/Desktop/Master/Measurements/%s/', date1));
pressure_name1_1=append(name1, '_pressure.txt');
pressure_data1_1 = importdata(pressure_name1_1);
pressure_data1_1 = erase(pressure_data1_1(2:end), '*0001'); % string in cell [bara]
pressure_time1_1 = time_start_p1_1 + seconds(1:1:length(pressure_data1_1));

% IMPORTING PRESSURE DATA - CARBON DIOXIDE 1

cd(sprintf('/Users/annamatheaskar/Desktop/Master/Measurements/%s/', date1));
pressure_name1_2=append(name2, '_pressure.txt');
pressure_data1_2 = importdata(pressure_name1_2);
pressure_data1_2 = erase(pressure_data1_2(2:end), '*0001'); % string in cell [bara]
pressure_time1_2 = time_start_p1_2 + seconds(1:1:length(pressure_data1_2));

% IMPORTING PRESSURE DATA - NITROGEN 2

cd(sprintf('/Users/annamatheaskar/Desktop/Master/Measurements/%s/', date2));
pressure_name2_1=append(name1, '_pressure.txt');
pressure_data2_1 = importdata(pressure_name2_1);
pressure_data2_1 = erase(pressure_data2_1(:), '*0001'); % string in cell [bara]
pressure_time2_1 = time_start_p2_1 + seconds(1:1:length(pressure_data2_1));

% IMPORTING PRESSURE DATA - CARBON DIOXIDE 2

cd(sprintf('/Users/annamatheaskar/Desktop/Master/Measurements/%s/', date2));
pressure_name2_2=append(name2, '_pressure.txt');
pressure_data2_2 = importdata(pressure_name2_2);
pressure_data2_2 = erase(pressure_data2_2(:), '*0001'); % string in cell [bara]
pressure_time2_2 = time_start_p2_2 + seconds(1:1:length(pressure_data2_2));

% IMPORTING PRESSURE DATA - MIXTURE 2

cd(sprintf('/Users/annamatheaskar/Desktop/Master/Measurements/%s/', date2));
pressure_name2_3=append(name3, '_pressure.txt');
pressure_data2_3 = importdata(pressure_name2_3);
pressure_data2_3 = erase(pressure_data2_3(:), '*0001'); % string in cell [bara]
pressure_time2_3 = time_start_p2_3 + seconds(1:1:length(pressure_data2_3));
for z=1:length(pressure_data2_3)
    if str2double(pressure_data2_3(z)) > 100 % pga. noen helt rare trykkmålinger i slutten...
        pressure_data2_3{z}=pressure_data2_3{z+1};
    end
end

% IMPORTING THEORETICAL DIELECTRIC CONSTANT - NITROGEN 1

cd('/Users/annamatheaskar/Desktop/Master/teoretiske datasett/Dielektrisk konstant/T=20.8/');
de1_1=load(append('/Users/annamatheaskar/Desktop/Master/teoretiske datasett/Dielektrisk konstant/T=20.8/', de_file1_1)); %henter "de"
p=1:1:100;

for n=1:length(p)
    de_p1_1(n)=de1_1.de(1,1,n); %find(purity==1)
end

% curve fit
p_fit1_1=polyfit(p(1:60)', de_p1_1(1:60)', 5); %5th polynomial at pressures 1-60
xfit1_1=1:0.0001:60; %picking out wanted pressures
yfit1_1=polyval(p_fit1_1,xfit1_1); % ALL THEORETICAL PERMITTIVITY-VALUES

% IMPORTING THEORETICAL DIELECTRIC CONSTANT - CARBON DIOXIDE 1

cd('/Users/annamatheaskar/Desktop/Master/teoretiske datasett/Dielektrisk konstant/T=20.8/');
de1_2=load(append('/Users/annamatheaskar/Desktop/Master/teoretiske datasett/Dielektrisk konstant/T=20.8/', de_file1_2)); %henter "de"
%purity=0.95:0.01:1;
p=1:1:100;

for n=1:length(p)
    de_p1_2(n)=de1_2.de(1,1,n);
end

% curve fit
p_fit1_2=polyfit(p(1:50)', de_p1_2(1:50)', 5); %5th polynomial at pressures 1-50 (får feil når jeg tar trykk over 50)
xfit1_2=1:0.0001:50; %picking out wanted pressures
yfit1_2=polyval(p_fit1_2,xfit1_2); % ALL THEORETICAL PERMITTIVITY-VALUES

% IMPORTING THEORETICAL DIELECTRIC CONSTANT - NITROGEN 2

cd('/Users/annamatheaskar/Desktop/Master/teoretiske datasett/Dielektrisk konstant/T=21.1/');
de2_1=load(append('/Users/annamatheaskar/Desktop/Master/teoretiske datasett/Dielektrisk konstant/T=21.1/', de_file2_1)); %henter "de"
p=1:1:100;

for n=1:length(p)
    de_p2_1(n)=de2_1.de(1,1,n);
end

% curve fit
p_fit2_1=polyfit(p(1:55)', de_p2_1(1:55)', 5); %5th polynomial at pressures 1-50
xfit2_1=1:0.0001:55; %picking out wanted pressures
yfit2_1=polyval(p_fit2_1,xfit2_1); % ALL THEORETICAL PERMITTIVITY-VALUES

% IMPORTING THEORETICAL DIELECTRIC CONSTANT - CARBON DIOXIDE 2

cd('/Users/annamatheaskar/Desktop/Master/teoretiske datasett/Dielektrisk konstant/T=21.1/');
de2_2=load(append('/Users/annamatheaskar/Desktop/Master/teoretiske datasett/Dielektrisk konstant/T=21.1/', de_file2_2)); %henter "de"
p=1:1:100;

for n=1:length(p)
    de_p2_2(n)=de2_2.de(1,1,n);
end

% curve fit
p_fit2_2=polyfit(p(1:50)', de_p2_2(1:50)', 5); %5th polynomial at pressures 1-50
xfit2_2=1:0.0001:50; %picking out wanted pressures
yfit2_2=polyval(p_fit2_2,xfit2_2); % ALL THEORETICAL PERMITTIVITY-VALUES

% IMPORTING THEORETICAL DIELECTRIC CONSTANT - MIXTURE 2

cd('/Users/annamatheaskar/Desktop/Master/teoretiske datasett/Dielektrisk konstant/T=21.1/');
de2_3=load(append('/Users/annamatheaskar/Desktop/Master/teoretiske datasett/Dielektrisk konstant/T=21.1/', de_file2_3)); %henter "de"
purity=0.18:0.01:0.22;
p=1:1:100;

for n=1:length(p)
    de_p2_3(n)=de2_3.de(find(purity==0.20),1,n); % CHANGING THE MIXTURE
    de_p2_3_low(n)=de2_3.de(find(purity==0.18),1,n);
    de_p2_3_high(n)=de2_3.de(find(purity==0.22),1,n);
end

% curve fit
p_fit2_3=polyfit(p(1:55)', de_p2_3(1:55)', 5); %5th polynomial at pressures 1-50
xfit2_3=1:0.0001:55; %picking out wanted pressures
yfit2_3=polyval(p_fit2_3,xfit2_3); % ALL THEORETICAL PERMITTIVITY-VALUES


%% FINDING RESONANCE FREQUENCY IN NARROW FREQUENCY WINDOW
% NITROGEN 1
cd(sprintf('/Users/annamatheaskar/Desktop/Master/Measurements/%s/%s/', date1, name1));

files = dir('*.txt') ;   % you are in the folder of files 
N1 = length(files) ;

% LISTING START AND END TIMES
time_start={}; %Start of measurement + 88 seconds
time_stop={};
index_start=[];
index_stop=[];
% FREQUENCY WINDOW
f_narrow={};
S11c_narrow={};
min_f1_1={}; %minimum frequency in narrow area
% PRESSURE AVERAGE + MAX/MIN
p_all={};
p_add=[];
p_avg1_1=[];
min_p1_1=[];
max_p1_1=[];

for i = 1:N1
    thisfile = files(i).name; % just the name
    
    data = importdata(thisfile); % loading the file
    timedate_name=erase(thisfile, {name1, '_', '.txt'});
    timedate(i)=datetime(timedate_name, 'InputFormat', 'yyyyMMddHHmmss', 'Timezone','local');
    % FINDING START AND STOP FREQUENCIES
    f = data(:,1);
    f = f./10e8;

    for m=1:length(mid_values1)-1 % FOR ALL INTERVALS
    
        f_round = round(f,3);
        if isempty(find(f_round==mid_values1(m)))
            f_round = round(f,2);
            from = find(f_round==mid_values1(m));
        else
            from = find(f_round==mid_values1(m));
        end
        if isempty(find(f_round==mid_values1(m+1)))
            f_round = round(f,2);
            to = find(f_round==mid_values1(m+1));
        else
            to = find(f_round==mid_values1(m+1));
        end
        
        % NARROW
        f_narrow{i}{m} = f(from:to);
        S11_Re = data(:,2) ; 
        S11_Re_narrow = S11_Re(from:to);
        S11_Im = data(:,3) ;
        S11_Im_narrow = S11_Im(from:to);
        S11c_narrow{i}{m}=S11_Re_narrow+1i*S11_Im_narrow;

        % finding min frequency value - HAVE TO FIND THIS MIN VALUE OVER ALL POINTS
        [M,I] = min(20*log10(abs(S11c_narrow{i}{m})));
        min_f1_1{i}{m}=f_narrow{i}{m}(I);

        %FINDING START AND STOP TIMES
        time=erase(thisfile, {name1, '_', date1, '.txt'});
        start=datetime(sprintf('%s%s', date1, time), 'InputFormat', 'yyyyMMddHHmmss', 'Timezone','local');
        start = start - labPC_adj1;
        time_start(i)= cellstr(start); %Adjusting wrong lab-PC time
        stop = start + seconds(measurement_time);
        time_stop(i)=cellstr(stop);
        time_half1_1(i)=start + seconds(half_time);
        
        % FINDING PRESSURES AT TIMES OF MW MEASUREMENTS
        if find(string(cellstr(pressure_time1_1)) == string(time_start(i)))
            index_start(i)=find(string(cellstr(pressure_time1_1)) == string(time_start(i)));
        else
            index_start(i)=0;
        end
        if find(string(cellstr(pressure_time1_1)) == string(time_stop(i)))
            index_stop(i)=find(string(cellstr(pressure_time1_1)) == string(time_stop(i)));
        else
            index_stop(i)=0;
        end
        % FINDING AVERAGE PRESSURE AND MIN/MAX
        if (index_start(i) ~= 0 && index_stop(i) ~= 0)
            p_add(i)=sum(str2double(pressure_data1_1(index_start(i):index_stop(i))));
            p_avg1_1(i)=p_add(i)/length(pressure_data1_1(index_start(i):index_stop(i))); %bara

            min_p1_1(i)=min(str2double(pressure_data1_1(index_start(i):index_stop(i))));
            max_p1_1(i)=max(str2double(pressure_data1_1(index_start(i):index_stop(i))));

            diff_p1_1(i)=max_p1_1(i)-min_p1_1(i); % big is over 0.2 or 0.1 bara
            if diff_p1_1(i)>0.2 || p_avg1_1(i)==0
                diff1_1_idx(i)=0;
            else
                diff1_1_idx(i)=1;
            end
        end
        % FINDING NEAREST PRESSURE VALUE MATCH
        if i<=length(p_avg1_1) && p_avg1_1(i) ~= 0
            [val,id]=min(abs(xfit1_1-p_avg1_1(i)));
            %THEORETICAL DIELECTRIC CONSTANT FOR EACH PRESSURE/MEASUREMENT
            e_r1_1(i)=yfit1_1(id);        
        end
        
        % FINDING NEAREST PRESSURE VALUE MATCH MINIMUM P VALUE
        if i<=length(min_p1_1) && min_p1_1(i) ~= 0
            [val,id]=min(abs(xfit1_1-min_p1_1(i)));
            %THEORETICAL DIELECTRIC CONSTANT FOR EACH PRESSURE
            e_r_min1_1(i)=yfit1_1(id);        
        end
        
        % FINDING NEAREST PRESSURE VALUE MATCH MAXIMUM P VALUE
        if i<=length(max_p1_1) && max_p1_1(i) ~= 0
            [val,id]=min(abs(xfit1_1-max_p1_1(i)));
            %THEORETICAL DIELECTRIC CONSTANT FOR EACH PRESSURE
            e_r_max1_1(i)=yfit1_1(id);        
        end
    end
end

while pressure_time1_1(end) < time_stop(end) %chech if MW measurements go on for longer than P
    N1=N1-1;
    time_start(end) = [];
    time_stop(end) = [];
end


%% FINDING RESONANCE FREQUENCY IN NARROW FREQUENCY WINDOW
% CARBON DIOXIDE 1
cd(sprintf('/Users/annamatheaskar/Desktop/Master/Measurements/%s/%s/', date1, name2));

files = dir('*.txt') ;   % you are in the folder of files 
N2 = length(files) ;

% LISTING START AND END TIMES
time_start={}; %Start of measurement + 88 seconds
time_stop={};
index_start=[];
index_stop=[];
% FREQUENCY WINDOW
f_narrow={};
S11c_narrow={};
min_f1_2={}; %minimum frequency in narrow area
% PRESSURE AVERAGE + MAX/MIN
p_all={};
p_add=[];
p_avg1_2=[];
min_p1_2=[];
max_p1_2=[];

for i = 1:N2
    thisfile = files(i).name ; % just the name
    
    data = importdata(thisfile); % loading the file
    timedate_name=erase(thisfile, {name2, '_', '.txt'});
    timedate(i)=datetime(timedate_name, 'InputFormat', 'yyyyMMddHHmmss', 'Timezone','local');
    % FINDING START AND STOP FREQUENCIES
    f = data(:,1);
    f = f./10e8;

    for m=1:length(mid_values1)-1 % FOR ALL INTERVALS
    
        f_round = round(f,3);
        if isempty(find(f_round==mid_values1(m)))
            f_round = round(f,2);
            from = find(f_round==mid_values1(m));
        else
            from = find(f_round==mid_values1(m));
        end
        if isempty(find(f_round==mid_values1(m+1)))
            f_round = round(f,2);
            to = find(f_round==mid_values1(m+1));
        else
            to = find(f_round==mid_values1(m+1));
        end
        
        % NARROW
        f_narrow{i}{m} = f(from:to);
        S11_Re = data(:,2) ; 
        S11_Re_narrow = S11_Re(from:to);
        S11_Im = data(:,3) ;
        S11_Im_narrow = S11_Im(from:to);
        S11c_narrow{i}{m}=S11_Re_narrow+1i*S11_Im_narrow;

        % finding min frequency value - HAVE TO FIND THIS MIN VALUE OVER ALL POINTS
        [M,I] = min(20*log10(abs(S11c_narrow{i}{m})));
        min_f1_2{i}{m}=f_narrow{i}{m}(I);

        %FINDING START AND STOP TIMES
        time=erase(thisfile, {name2, '_', date1, '.txt'});
        start=datetime(sprintf('%s%s', date1, time), 'InputFormat', 'yyyyMMddHHmmss', 'Timezone','local');
        start = start - labPC_adj1;
        time_start(i)= cellstr(start); %Adjusting wrong lab-PC time
        stop = start + seconds(measurement_time);
        time_stop(i)=cellstr(stop);
        time_half1_2(i)=start + seconds(half_time);

        % FINDING PRESSURES AT TIMES OF MW MEASUREMENTS
        if find(string(cellstr(pressure_time1_2)) == string(time_start(i)))
            index_start(i)=find(string(cellstr(pressure_time1_2)) == string(time_start(i)));
        else
            index_start(i)=0;
        end
        if find(string(cellstr(pressure_time1_2)) == string(time_stop(i)))
            index_stop(i)=find(string(cellstr(pressure_time1_2)) == string(time_stop(i)));
        else
            index_stop(i)=0;
        end
        
        % FINDING AVERAGE PRESSURE AND MIN/MAX
        if (index_start(i) ~= 0 && index_stop(i) ~= 0)
            p_add(i)=sum(str2double(pressure_data1_2(index_start(i):index_stop(i))));
            p_avg1_2(i)=p_add(i)/length(pressure_data1_2(index_start(i):index_stop(i))); %bara

            min_p1_2(i)=min(str2double(pressure_data1_2(index_start(i):index_stop(i))));
            max_p1_2(i)=max(str2double(pressure_data1_2(index_start(i):index_stop(i))));

            diff_p1_2(i)=max_p1_2(i)-min_p1_2(i); % big is over 0.2 or 0.1 bara
            if diff_p1_2(i)>0.2 || p_avg1_2(i)==0
                diff1_2_idx(i)=0;
            else
                diff1_2_idx(i)=1;
            end
        end
        % FINDING NEAREST PRESSURE VALUE MATCH
        if i<=length(p_avg1_2) && p_avg1_2(i) ~= 0
            [val,id]=min(abs(xfit1_2-p_avg1_2(i)));
            %THEORETICAL DIELECTRIC CONSTANT FOR EACH PRESSURE
            e_r1_2(i)=yfit1_2(id);        
        end
        
        % FINDING NEAREST PRESSURE VALUE MATCH MINIMUM P VALUE
        if i<=length(min_p1_2) && min_p1_2(i) ~= 0
            [val,id]=min(abs(xfit1_2-min_p1_2(i)));
            %THEORETICAL DIELECTRIC CONSTANT FOR EACH PRESSURE
            e_r_min1_2(i)=yfit1_2(id);        
        end
        
        % FINDING NEAREST PRESSURE VALUE MATCH MAXIMUM P VALUE
        if i<=length(max_p1_2) && max_p1_2(i) ~= 0
            [val,id]=min(abs(xfit1_2-max_p1_2(i)));
            %THEORETICAL DIELECTRIC CONSTANT FOR EACH PRESSURE
            e_r_max1_2(i)=yfit1_2(id);        
        end
        
        % E_R1 at P2 - FINDING NEAREST PRESSURE VALUE MATCH
        if i<=length(p_avg1_2) && p_avg1_2(i) ~= 0
            [val,id]=min(abs(xfit1_1-p_avg1_2(i)));
            %THEORETICAL DIELECTRIC CONSTANT FOR EACH PRESSURE/MEASUREMENT
            e_r1_p1_2(i)=yfit1_1(id);        
        end
    end
end

while pressure_time1_2(end) < time_stop(end) %chech if MW measurements go on for longer than P
    N=N-1;
    time_start(end) = [];
    time_stop(end) = [];
end

% NITROGEN 2
cd(sprintf('/Users/annamatheaskar/Desktop/Master/Measurements/%s/%s/', date2, name1));

files = dir('*.txt') ;   % you are in the folder of files 
N1 = length(files) ;

% LISTING START AND END TIMES
time_start={}; %Start of measurement + 88 seconds
time_stop={};
index_start=[];
index_stop=[];
% FREQUENCY WINDOW
f_narrow={};
S11c_narrow={};
min_f2_1={}; %minimum frequency in narrow area
% PRESSURE AVERAGE + MAX/MIN
p_all={};
p_add2_1=[];
p_avg2_1=[];
min_p2_1=[];
max_p2_1=[];

for i = 1:N1
    thisfile = files(i).name; % just the name
    
    data = importdata(thisfile); % loading the file
    timedate_name=erase(thisfile, {name1, '_', '.txt'});
    timedate(i)=datetime(timedate_name, 'InputFormat', 'yyyyMMddHHmmss', 'Timezone','local');
    % FINDING START AND STOP FREQUENCIES
    f = data(:,1);
    f = f./10e8;

    for m=1:length(mid_values2)-1 % FOR ALL INTERVALS
    
        f_round = round(f,3);
        if isempty(find(f_round==mid_values2(m)))
            f_round = round(f,2);
            from = find(f_round==mid_values2(m));
        else
            from = find(f_round==mid_values2(m));
        end
        if isempty(find(f_round==mid_values2(m+1)))
            f_round = round(f,2);
            to = find(f_round==mid_values2(m+1));
        else
            to = find(f_round==mid_values2(m+1));
        end
        
        % NARROW
        f_narrow{i}{m} = f(from:to);
        S11_Re = data(:,2) ; 
        S11_Re_narrow = S11_Re(from:to);
        S11_Im = data(:,3) ;
        S11_Im_narrow = S11_Im(from:to);
        S11c_narrow{i}{m}=S11_Re_narrow+1i*S11_Im_narrow;

        % finding min frequency value - HAVE TO FIND THIS MIN VALUE OVER ALL POINTS
        [M,I] = min(20*log10(abs(S11c_narrow{i}{m})));
        min_f2_1{i}{m}=f_narrow{i}{m}(I);

        %FINDING START AND STOP TIMES
        time=erase(thisfile, {name1, '_', date2, '.txt'});
        start=datetime(sprintf('%s%s', date2, time), 'InputFormat', 'yyyyMMddHHmmss', 'Timezone','local');
        start = start - labPC_adj2;
        time_start(i)= cellstr(start); %Adjusting wrong lab-PC time
        stop = start + seconds(measurement_time);
        time_stop(i)=cellstr(stop);

        % FINDING PRESSURES AT TIMES OF MW MEASUREMENTS
        if find(string(cellstr(pressure_time2_1)) == string(time_start(i)))
            index_start(i)=find(string(cellstr(pressure_time2_1)) == string(time_start(i)));
        else
            index_start(i)=0;
        end
        if find(string(cellstr(pressure_time2_1)) == string(time_stop(i)))
            index_stop(i)=find(string(cellstr(pressure_time2_1)) == string(time_stop(i)));
        else
            index_stop(i)=0;
        end
        % FINDING AVERAGE PRESSURE AND MIN/MAX
        if (index_start(i) ~= 0 && index_stop(i) ~= 0)
            p_add2_1(i)=sum(str2double(pressure_data2_1(index_start(i):index_stop(i))));
            p_avg2_1(i)=p_add2_1(i)/length(pressure_data2_1(index_start(i):index_stop(i))); %bara

            min_p2_1(i)=min(str2double(pressure_data2_1(index_start(i):index_stop(i))));
            max_p2_1(i)=max(str2double(pressure_data2_1(index_start(i):index_stop(i))));

            diff_p2_1(i)=max_p2_1(i)-min_p2_1(i); % big is over 0.2 or 0.1 bara
            if diff_p2_1(i)>0.2 || p_avg2_1(i)==0
                diff2_1_idx(i)=0;
            else
                diff2_1_idx(i)=1;
            end
            
            time_half2_1(i)=start + seconds(half_time); % flyttet hit...
        end
        % FINDING NEAREST PRESSURE VALUE MATCH
        if i<=length(p_avg2_1) && p_avg2_1(i) ~= 0
            [val,id]=min(abs(xfit2_1-p_avg2_1(i)));
            %THEORETICAL DIELECTRIC CONSTANT FOR EACH PRESSURE/MEASUREMENT
            e_r2_1(i)=yfit2_1(id);        
        end
        
        % FINDING NEAREST PRESSURE VALUE MATCH MINIMUM P VALUE
        if i<=length(min_p2_1) && min_p2_1(i) ~= 0
            [val,id]=min(abs(xfit2_1-min_p2_1(i)));
            %THEORETICAL DIELECTRIC CONSTANT FOR EACH PRESSURE
            e_r_min2_1(i)=yfit2_1(id);        
        end
        
        % FINDING NEAREST PRESSURE VALUE MATCH MAXIMUM P VALUE
        if i<=length(max_p2_1) && max_p2_1(i) ~= 0
            [val,id]=min(abs(xfit2_1-max_p2_1(i)));
            %THEORETICAL DIELECTRIC CONSTANT FOR EACH PRESSURE
            e_r_max2_1(i)=yfit2_1(id);        
        end
    end
end

while pressure_time2_1(end) < time_stop(end) %chech if MW measurements go on for longer than P
    N1=N1-1;
    time_start(end) = [];
    time_stop(end) = [];
end

% CARBON DIOXIDE 2
cd(sprintf('/Users/annamatheaskar/Desktop/Master/Measurements/%s/%s/', date2, name2));

files = dir('*.txt') ;   % you are in the folder of files 
N2 = length(files) ;

% LISTING START AND END TIMES
time_start={}; %Start of measurement + 88 seconds
time_stop={};
index_start=[];
index_stop=[];
% FREQUENCY WINDOW
f_narrow={};
S11c_narrow={};
min_f2_2={}; %minimum frequency in narrow area
% PRESSURE AVERAGE + MAX/MIN
p_all={};
p_add2_2=[];
p_avg2_2=[];
min_p2_2=[];
max_p2_2=[];

for i = 1:N2
    thisfile = files(i).name ; % just the name
    
    data = importdata(thisfile); % loading the file
    timedate_name=erase(thisfile, {name2, '_', '.txt'});
    timedate(i)=datetime(timedate_name, 'InputFormat', 'yyyyMMddHHmmss', 'Timezone','local');
    % FINDING START AND STOP FREQUENCIES
    f = data(:,1);
    f = f./10e8;

    for m=1:length(mid_values2)-1 % FOR ALL INTERVALS
    
        f_round = round(f,3);
        if isempty(find(f_round==mid_values2(m)))
            f_round = round(f,2);
            from = find(f_round==mid_values2(m));
        else
            from = find(f_round==mid_values2(m));
        end
        if isempty(find(f_round==mid_values2(m+1)))
            f_round = round(f,2);
            to = find(f_round==mid_values2(m+1));
        else
            to = find(f_round==mid_values2(m+1));
        end
        
        % NARROW
        f_narrow{i}{m} = f(from:to);
        S11_Re = data(:,2) ; 
        S11_Re_narrow = S11_Re(from:to);
        S11_Im = data(:,3) ;
        S11_Im_narrow = S11_Im(from:to);
        S11c_narrow{i}{m}=S11_Re_narrow+1i*S11_Im_narrow;

        % finding min frequency value - HAVE TO FIND THIS MIN VALUE OVER ALL POINTS
        [M,I] = min(20*log10(abs(S11c_narrow{i}{m})));
        min_f2_2{i}{m}=f_narrow{i}{m}(I);

        %FINDING START AND STOP TIMES
        time=erase(thisfile, {name2, '_', date2, '.txt'});
        start=datetime(sprintf('%s%s', date2, time), 'InputFormat', 'yyyyMMddHHmmss', 'Timezone','local');
        start = start - labPC_adj2;
        time_start(i)= cellstr(start); %Adjusting wrong lab-PC time
        stop = start + seconds(measurement_time);
        time_stop(i)=cellstr(stop);
        time_half2_2(i)= start + seconds(half_time);

        % FINDING PRESSURES AT TIMES OF MW MEASUREMENTS
        if find(string(cellstr(pressure_time2_2)) == string(time_start(i)))
            index_start(i)=find(string(cellstr(pressure_time2_2)) == string(time_start(i)));
        else
            index_start(i)=0;
        end
        if find(string(cellstr(pressure_time2_2)) == string(time_stop(i)))
            index_stop(i)=find(string(cellstr(pressure_time2_2)) == string(time_stop(i)));
        else
            index_stop(i)=0;
        end
        
        % FINDING AVERAGE PRESSURE AND MIN/MAX
        if (index_start(i) ~= 0 && index_stop(i) ~= 0)
            p_add2_2(i)=sum(str2double(pressure_data2_2(index_start(i):index_stop(i))));
            p_avg2_2(i)=p_add2_2(i)/length(pressure_data2_2(index_start(i):index_stop(i))); %bara

            min_p2_2(i)=min(str2double(pressure_data2_2(index_start(i):index_stop(i))));
            max_p2_2(i)=max(str2double(pressure_data2_2(index_start(i):index_stop(i))));

            diff_p2_2(i)=max_p2_2(i)-min_p2_2(i); % big is over 0.2 or 0.1 bara
            if diff_p2_2(i)>0.2 || p_avg2_2(i)==0
                diff2_2_idx(i)=0;
            else
                diff2_2_idx(i)=1;
            end
        end
        % FINDING NEAREST PRESSURE VALUE MATCH
        if i<=length(p_avg2_2) && p_avg2_2(i) ~= 0
            [val,id]=min(abs(xfit2_2-p_avg2_2(i)));
            %THEORETICAL DIELECTRIC CONSTANT FOR EACH PRESSURE
            e_r2_2(i)=yfit2_2(id);        
        end
        
        % FINDING NEAREST PRESSURE VALUE MATCH MINIMUM P VALUE
        if i<=length(min_p2_2) && min_p2_2(i) ~= 0
            [val,id]=min(abs(xfit2_2-min_p2_2(i)));
            %THEORETICAL DIELECTRIC CONSTANT FOR EACH PRESSURE
            e_r_min2_2(i)=yfit2_2(id);        
        end
        
        % FINDING NEAREST PRESSURE VALUE MATCH MAXIMUM P VALUE
        if i<=length(max_p2_2) && max_p2_2(i) ~= 0
            [val,id]=min(abs(xfit2_2-max_p2_2(i)));
            %THEORETICAL DIELECTRIC CONSTANT FOR EACH PRESSURE
            e_r_max2_2(i)=yfit2_2(id);        
        end
        
        
        % E_R1 at P2 - FINDING NEAREST PRESSURE VALUE MATCH
        if i<=length(p_avg2_2) && p_avg2_2(i) ~= 0
            [val,id]=min(abs(xfit2_1-p_avg2_2(i)));
            %THEORETICAL DIELECTRIC CONSTANT FOR EACH PRESSURE/MEASUREMENT
            e_r1_p2_2(i)=yfit2_1(id);        
        end
    end
end


%% FINDING RESONANCE FREQUENCY IN NARROW FREQUENCY WINDOW
% MIXTURE 2
cd(sprintf('/Users/annamatheaskar/Desktop/Master/Measurements/%s/%s/', date2, name3));

files = dir('*.txt') ;   % you are in the folder of files 
N3 = length(files) ;

% LISTING START AND END TIMES
time_start={}; %Start of measurement + 88 seconds
time_stop={};
index_start=[];
index_stop=[];
% FREQUENCY WINDOW
f_narrow={};
S11c_narrow={};
min_f2_3={}; %minimum frequency in narrow area
% PRESSURE AVERAGE + MAX/MIN
p_all={};
p_add2_3=[];
p_avg2_3=[];
min_p2_3=[];
max_p2_3=[];

for i = 1:N3
    thisfile = files(i).name ; % just the name
    
    data = importdata(thisfile); % loading the file
    timedate_name=erase(thisfile, {name3, '_', '.txt'});
    timedate(i)=datetime(timedate_name, 'InputFormat', 'yyyyMMddHHmmss', 'Timezone','local');
    % FINDING START AND STOP FREQUENCIES
    f = data(:,1);
    f = f./10e8;

    for m=1:length(mid_values2)-1 % FOR ALL INTERVALS
    
        f_round = round(f,3);
        if isempty(find(f_round==mid_values2(m)))
            f_round = round(f,2);
            from = find(f_round==mid_values2(m));
        else
            from = find(f_round==mid_values2(m));
        end
        if isempty(find(f_round==mid_values2(m+1)))
            f_round = round(f,2);
            to = find(f_round==mid_values2(m+1));
        else
            to = find(f_round==mid_values2(m+1));
        end
        
        % NARROW
        f_narrow{i}{m} = f(from:to);
        S11_Re = data(:,2) ; 
        S11_Re_narrow = S11_Re(from:to);
        S11_Im = data(:,3) ;
        S11_Im_narrow = S11_Im(from:to);
        S11c_narrow{i}{m}=S11_Re_narrow+1i*S11_Im_narrow;

        % finding min frequency value - HAVE TO FIND THIS MIN VALUE OVER ALL POINTS
        [M,I] = min(20*log10(abs(S11c_narrow{i}{m})));
        min_f2_3{i}{m}=f_narrow{i}{m}(I);

        %FINDING START AND STOP TIMES
        time=erase(thisfile, {name3, '_', date2, '.txt'});
        start=datetime(sprintf('%s%s', date2, time), 'InputFormat', 'yyyyMMddHHmmss', 'Timezone','local');
        start = start - labPC_adj2;
        time_start(i)= cellstr(start); %Adjusting wrong lab-PC time
        stop = start + seconds(measurement_time);
        time_stop(i)=cellstr(stop);
        time_half2_3(i)= start + seconds(half_time);

        % FINDING PRESSURES AT TIMES OF MW MEASUREMENTS
        if find(string(cellstr(pressure_time2_3)) == string(time_start(i)))
            index_start(i)=find(string(cellstr(pressure_time2_3)) == string(time_start(i)));
        else
            index_start(i)=0;
        end
        if find(string(cellstr(pressure_time2_3)) == string(time_stop(i)))
            index_stop(i)=find(string(cellstr(pressure_time2_3)) == string(time_stop(i)));
        else
            index_stop(i)=0;
        end
        
        % FINDING AVERAGE PRESSURE AND MIN/MAX
        if (index_start(i) ~= 0 && index_stop(i) ~= 0)
            p_add2_3(i)=sum(str2double(pressure_data2_3(index_start(i):index_stop(i))));
            p_avg2_3(i)=p_add2_3(i)/length(pressure_data2_3(index_start(i):index_stop(i))); %bara

            min_p2_3(i)=min(str2double(pressure_data2_3(index_start(i):index_stop(i))));
            max_p2_3(i)=max(str2double(pressure_data2_3(index_start(i):index_stop(i))));

            diff_p2_3(i)=max_p2_3(i)-min_p2_3(i); % big is over 0.2 or 0.1 bara
            if diff_p2_3(i)>0.2 || p_avg2_3(i)==0
                diff2_3_idx(i)=0;
            else
                diff2_3_idx(i)=1;
            end
        end
        % FINDING NEAREST PRESSURE VALUE MATCH
        if i<=length(p_avg2_3) && p_avg2_3(i) ~= 0
            [val,id]=min(abs(xfit2_3-p_avg2_3(i)));
            %THEORETICAL DIELECTRIC CONSTANT FOR EACH PRESSURE
            e_r2_3(i)=yfit2_3(id);        
        end
        
        % FINDING NEAREST PRESSURE VALUE MATCH MINIMUM P VALUE
        if i<=length(min_p2_3) && min_p2_3(i) ~= 0
            [val,id]=min(abs(xfit2_3-min_p2_3(i)));
            %THEORETICAL DIELECTRIC CONSTANT FOR EACH PRESSURE
            e_r_min2_3(i)=yfit2_3(id);        
        end
        
        % FINDING NEAREST PRESSURE VALUE MATCH MAXIMUM P VALUE
        if i<=length(max_p2_3) && max_p2_3(i) ~= 0
            [val,id]=min(abs(xfit2_3-max_p2_3(i)));
            %THEORETICAL DIELECTRIC CONSTANT FOR EACH PRESSURE
            e_r_max2_3(i)=yfit2_3(id);        
        end
        
        % E_R1 at P3 - FINDING NEAREST PRESSURE VALUE MATCH
        if i<=length(p_avg2_3) && p_avg2_3(i) ~= 0
            [val,id]=min(abs(xfit2_1-p_avg2_3(i)));
            %THEORETICAL DIELECTRIC CONSTANT FOR EACH PRESSURE/MEASUREMENT
            e_r1_p2_3(i)=yfit2_1(id);        
        end
    end
end

%% MODES
% NIROGEN 1

% ARRAY OF PLOTS
offsetPlot = [];

% MODES DATA
c=3*10.^8;
p_TM=[2.405,5.520,8.654,11.792; 3.832,7.016,10.174,13.324; ...
    5.135,8.417,11.620,14.796;6.380,9.761,13.015,16.223]; % for 0<n<2 og 1<m<3
my_r=1;
a=0.02; % + 0.00003;
%h=0.1;
h=0.1;

for i = 1:length(e_r1_1)
    if e_r1_1(i) ~= 0

        Dat1_1(1,i).name  = 'TM$_{010}$'; % ER LIK FOR HVER HELE MÅLING
        Dat1_1(1,i).value = (c./(2*pi*sqrt(my_r*e_r1_1(i))))*(p_TM(1,1)./a); % f0
        Dat1_1(2,i).name  = 'TM$_{011}$';
        Dat1_1(2,i).value = (c./(2*pi*sqrt(my_r*e_r1_1(i))))*sqrt((p_TM(1,1)./a).^2+(1*pi./h).^2);     
        Dat1_1(3,i).name  = 'TM$_{012}$';
        Dat1_1(3,i).value = (c./(2*pi*sqrt(my_r*e_r1_1(i))))*sqrt((p_TM(1,1)./a).^2+(2*pi./h).^2);
        Dat1_1(4,i).name  = 'TM$_{013}$';
        Dat1_1(4,i).value = (c./(2*pi*sqrt(my_r*e_r1_1(i))))*sqrt((p_TM(1,1)./a).^2+(3*pi./h).^2);
        Dat1_1(5,i).name  = 'TM$_{014}$';
        Dat1_1(5,i).value = (c./(2*pi*sqrt(my_r*e_r1_1(i))))*sqrt((p_TM(1,1)./a).^2+(4*pi./h).^2);
        Dat1_1(6,i).name  = 'TM$_{015}$';
        Dat1_1(6,i).value = (c./(2*pi*sqrt(my_r*e_r1_1(i))))*sqrt((p_TM(1,1)./a).^2+(5*pi./h).^2);
        Dat1_1(7,i).name  = 'TM$_{016}$';
        Dat1_1(7,i).value = (c./(2*pi*sqrt(my_r*e_r1_1(i))))*sqrt((p_TM(1,1)./a).^2+(6*pi./h).^2);
        Dat1_1(8,i).name  = 'TM$_{017}$';
        Dat1_1(8,i).value = (c./(2*pi*sqrt(my_r*e_r1_1(i))))*sqrt((p_TM(1,1)./a).^2+(7*pi./h).^2);
        Dat1_1(9,i).name  = 'TM$_{018}$';
        Dat1_1(9,i).value = (c./(2*pi*sqrt(my_r*e_r1_1(i))))*sqrt((p_TM(1,1)./a).^2+(8*pi./h).^2);
        Dat1_1(10,i).name  = 'TM$_{019}$';
        Dat1_1(10,i).value = (c./(2*pi*sqrt(my_r*e_r1_1(i))))*sqrt((p_TM(1,1)./a).^2+(9*pi./h).^2);
        Dat1_1(11,i).name  = 'TM$_{020}$';
        Dat1_1(11,i).value = (c./(2*pi*sqrt(my_r*e_r1_1(i))))*(p_TM(1,2)./a);
        Dat1_1(12,i).name  = 'TM$_{021}$';
        Dat1_1(12,i).value = (c./(2*pi*sqrt(my_r*e_r1_1(i))))*sqrt((p_TM(1,2)./a).^2+(1*pi./h).^2);
        Dat1_1(13,i).name  = 'TM$_{022}$';
        Dat1_1(13,i).value = (c./(2*pi*sqrt(my_r*e_r1_1(i))))*sqrt((p_TM(1,2)./a).^2+(2*pi./h).^2);
        
        % SORTED STRUCT ARRAY
        x_m=0;
        idx_m=0;
        [x,idx]=sort([Dat1_1(:,i).value]);
        Dat1_1(:,i)=Dat1_1(idx,i);
        
        for m=1:length(Dat1_1(:,i))
            Dat1_1(m,i).value=Dat1_1(m,i).value./10e8;
        end
      
        % Create a logical index to identify elements to keep
        keep_indices = [Dat1_1(:,i).value] >= freq_start & [Dat1_1(:,i).value] <= freq_stop1;

        % Filter Dat1_1 based on the logical index
        Dat1_1_new(:,i) = Dat1_1(keep_indices,i);
        
    end
end


% CO2 1

for i = 1:length(e_r1_2)
    if e_r1_2(i) ~= 0
        
        Dat1_2(1,i).name  = 'TM$_{010}$'; % ER LIK FOR HVER HELE MÅLING
        Dat1_2(1,i).value = (c./(2*pi*sqrt(my_r*e_r1_2(i))))*(p_TM(1,1)./a); % f0
        Dat1_2(2,i).name  = 'TM$_{011}$';
        Dat1_2(2,i).value = (c./(2*pi*sqrt(my_r*e_r1_2(i))))*sqrt((p_TM(1,1)./a).^2+(1*pi./h).^2);     
        Dat1_2(3,i).name  = 'TM$_{012}$';
        Dat1_2(3,i).value = (c./(2*pi*sqrt(my_r*e_r1_2(i))))*sqrt((p_TM(1,1)./a).^2+(2*pi./h).^2);
        Dat1_2(4,i).name  = 'TM$_{013}$';
        Dat1_2(4,i).value = (c./(2*pi*sqrt(my_r*e_r1_2(i))))*sqrt((p_TM(1,1)./a).^2+(3*pi./h).^2);
        Dat1_2(5,i).name  = 'TM$_{014}$';
        Dat1_2(5,i).value = (c./(2*pi*sqrt(my_r*e_r1_2(i))))*sqrt((p_TM(1,1)./a).^2+(4*pi./h).^2);
        Dat1_2(6,i).name  = 'TM$_{015}$';
        Dat1_2(6,i).value = (c./(2*pi*sqrt(my_r*e_r1_2(i))))*sqrt((p_TM(1,1)./a).^2+(5*pi./h).^2);
        Dat1_2(7,i).name  = 'TM$_{016}$';
        Dat1_2(7,i).value = (c./(2*pi*sqrt(my_r*e_r1_2(i))))*sqrt((p_TM(1,1)./a).^2+(6*pi./h).^2);
        Dat1_2(8,i).name  = 'TM$_{017}$';
        Dat1_2(8,i).value = (c./(2*pi*sqrt(my_r*e_r1_2(i))))*sqrt((p_TM(1,1)./a).^2+(7*pi./h).^2);
        Dat1_2(9,i).name  = 'TM$_{018}$';
        Dat1_2(9,i).value = (c./(2*pi*sqrt(my_r*e_r1_2(i))))*sqrt((p_TM(1,1)./a).^2+(8*pi./h).^2);
        Dat1_2(10,i).name  = 'TM$_{019}$';
        Dat1_2(10,i).value = (c./(2*pi*sqrt(my_r*e_r1_2(i))))*sqrt((p_TM(1,1)./a).^2+(9*pi./h).^2);
        Dat1_2(11,i).name  = 'TM$_{020}$';
        Dat1_2(11,i).value = (c./(2*pi*sqrt(my_r*e_r1_2(i))))*(p_TM(1,2)./a);
        Dat1_2(12,i).name  = 'TM$_{021}$';
        Dat1_2(12,i).value = (c./(2*pi*sqrt(my_r*e_r1_2(i))))*sqrt((p_TM(1,2)./a).^2+(1*pi./h).^2);
        Dat1_2(13,i).name  = 'TM$_{022}$';
        Dat1_2(13,i).value = (c./(2*pi*sqrt(my_r*e_r1_2(i))))*sqrt((p_TM(1,2)./a).^2+(2*pi./h).^2);
        
        % SORTED STRUCT ARRAY
        x_m=0;
        idx_m=0;
        [x,idx]=sort([Dat1_2(:,i).value]);
        Dat1_2(:,i)=Dat1_2(idx,i);
        
        for m=1:length(Dat1_2(:,i))
            Dat1_2(m,i).value=Dat1_2(m,i).value./10e8;
        end
        
        % Create a logical index to identify elements to keep
        keep_indices = [Dat1_2(:,i).value] >= freq_start & [Dat1_2(:,i).value] <= freq_stop1;

        % Filter Dat1_1 based on the logical index
        Dat1_2_new(:,i) = Dat1_2(keep_indices,i);

    end
end

% NITROGEN 2

a=0.0200;
h=0.1;

for i = 1:length(e_r2_1)
    if e_r2_1(i) ~= 0

        Dat2_1(1,i).name  = 'TM$_{010}$'; 
        Dat2_1(1,i).value = (c./(2*pi*sqrt(my_r*e_r2_1(i))))*(p_TM(1,1)./a);
        Dat2_1(2,i).name  = 'TM$_{011}$';
        Dat2_1(2,i).value = (c./(2*pi*sqrt(my_r*e_r2_1(i))))*sqrt((p_TM(1,1)./a).^2+(1*pi./h).^2);     
        Dat2_1(3,i).name  = 'TM$_{012}$';
        Dat2_1(3,i).value = (c./(2*pi*sqrt(my_r*e_r2_1(i))))*sqrt((p_TM(1,1)./a).^2+(2*pi./h).^2);
        Dat2_1(4,i).name  = 'TM$_{013}$';
        Dat2_1(4,i).value = (c./(2*pi*sqrt(my_r*e_r2_1(i))))*sqrt((p_TM(1,1)./a).^2+(3*pi./h).^2);
        Dat2_1(5,i).name  = 'TM$_{014}$';
        Dat2_1(5,i).value = (c./(2*pi*sqrt(my_r*e_r2_1(i))))*sqrt((p_TM(1,1)./a).^2+(4*pi./h).^2);
        Dat2_1(6,i).name  = 'TM$_{015}$';
        Dat2_1(6,i).value = (c./(2*pi*sqrt(my_r*e_r2_1(i))))*sqrt((p_TM(1,1)./a).^2+(5*pi./h).^2);
        Dat2_1(7,i).name  = 'TM$_{016}$';
        Dat2_1(7,i).value = (c./(2*pi*sqrt(my_r*e_r2_1(i))))*sqrt((p_TM(1,1)./a).^2+(6*pi./h).^2);
        Dat2_1(8,i).name  = 'TM$_{017}$';
        Dat2_1(8,i).value = (c./(2*pi*sqrt(my_r*e_r2_1(i))))*sqrt((p_TM(1,1)./a).^2+(7*pi./h).^2);
        Dat2_1(9,i).name  = 'TM$_{018}$';
        Dat2_1(9,i).value = (c./(2*pi*sqrt(my_r*e_r2_1(i))))*sqrt((p_TM(1,1)./a).^2+(8*pi./h).^2);
        Dat2_1(10,i).name  = 'TM$_{019}$';
        Dat2_1(10,i).value = (c./(2*pi*sqrt(my_r*e_r2_1(i))))*sqrt((p_TM(1,1)./a).^2+(9*pi./h).^2);
        Dat2_1(11,i).name  = 'TM$_{020}$';
        Dat2_1(11,i).value = (c./(2*pi*sqrt(my_r*e_r2_1(i))))*(p_TM(1,2)./a);
        Dat2_1(12,i).name  = 'TM$_{021}$';
        Dat2_1(12,i).value = (c./(2*pi*sqrt(my_r*e_r2_1(i))))*sqrt((p_TM(1,2)./a).^2+(1*pi./h).^2);
        Dat2_1(13,i).name  = 'TM$_{022}$';
        Dat2_1(13,i).value = (c./(2*pi*sqrt(my_r*e_r2_1(i))))*sqrt((p_TM(1,2)./a).^2+(2*pi./h).^2);
        
        % SORTED STRUCT ARRAY
        x_m=0;
        idx_m=0;
        [x,idx]=sort([Dat2_1(:,i).value]);
        Dat2_1(:,i)=Dat2_1(idx,i);
        
        for m=1:length(Dat2_1(:,i))
            Dat2_1(m,i).value=Dat2_1(m,i).value./10e8;
        end
      
        % Create a logical index to identify elements to keep
        keep_indices = [Dat2_1(:,i).value] >= freq_start & [Dat2_1(:,i).value] <= freq_stop2;

        % Filter Dat2_1 based on the logical index
        Dat2_1_new(:,i) = Dat2_1(keep_indices,i);        
    end
end

% CO2 2

for i = 1:length(e_r2_2)
    if e_r2_2(i) ~= 0
        
        Dat2_2(1,i).name  = 'TM$_{010}$';
        Dat2_2(1,i).value = (c./(2*pi*sqrt(my_r*e_r2_2(i))))*(p_TM(1,1)./a); % f0
        Dat2_2(2,i).name  = 'TM$_{011}$';
        Dat2_2(2,i).value = (c./(2*pi*sqrt(my_r*e_r2_2(i))))*sqrt((p_TM(1,1)./a).^2+(1*pi./h).^2);     
        Dat2_2(3,i).name  = 'TM$_{012}$';
        Dat2_2(3,i).value = (c./(2*pi*sqrt(my_r*e_r2_2(i))))*sqrt((p_TM(1,1)./a).^2+(2*pi./h).^2);
        Dat2_2(4,i).name  = 'TM$_{013}$';
        Dat2_2(4,i).value = (c./(2*pi*sqrt(my_r*e_r2_2(i))))*sqrt((p_TM(1,1)./a).^2+(3*pi./h).^2);
        Dat2_2(5,i).name  = 'TM$_{014}$';
        Dat2_2(5,i).value = (c./(2*pi*sqrt(my_r*e_r2_2(i))))*sqrt((p_TM(1,1)./a).^2+(4*pi./h).^2);
        Dat2_2(6,i).name  = 'TM$_{015}$';
        Dat2_2(6,i).value = (c./(2*pi*sqrt(my_r*e_r2_2(i))))*sqrt((p_TM(1,1)./a).^2+(5*pi./h).^2);
        Dat2_2(7,i).name  = 'TM$_{016}$';
        Dat2_2(7,i).value = (c./(2*pi*sqrt(my_r*e_r2_2(i))))*sqrt((p_TM(1,1)./a).^2+(6*pi./h).^2);
        Dat2_2(8,i).name  = 'TM$_{017}$';
        Dat2_2(8,i).value = (c./(2*pi*sqrt(my_r*e_r2_2(i))))*sqrt((p_TM(1,1)./a).^2+(7*pi./h).^2);
        Dat2_2(9,i).name  = 'TM$_{018}$';
        Dat2_2(9,i).value = (c./(2*pi*sqrt(my_r*e_r2_2(i))))*sqrt((p_TM(1,1)./a).^2+(8*pi./h).^2);
        Dat2_2(10,i).name  = 'TM$_{019}$';
        Dat2_2(10,i).value = (c./(2*pi*sqrt(my_r*e_r2_2(i))))*sqrt((p_TM(1,1)./a).^2+(9*pi./h).^2);
        Dat2_2(11,i).name  = 'TM$_{020}$';
        Dat2_2(11,i).value = (c./(2*pi*sqrt(my_r*e_r2_2(i))))*(p_TM(1,2)./a);
        Dat2_2(12,i).name  = 'TM$_{021}$';
        Dat2_2(12,i).value = (c./(2*pi*sqrt(my_r*e_r2_2(i))))*sqrt((p_TM(1,2)./a).^2+(1*pi./h).^2);
        Dat2_2(13,i).name  = 'TM$_{022}$';
        Dat2_2(13,i).value = (c./(2*pi*sqrt(my_r*e_r2_2(i))))*sqrt((p_TM(1,2)./a).^2+(2*pi./h).^2);
        
        % SORTED STRUCT ARRAY
        x_m=0;
        idx_m=0;
        [x,idx]=sort([Dat2_2(:,i).value]);
        Dat2_2(:,i)=Dat2_2(idx,i);
        
        for m=1:length(Dat2_2(:,i))
            Dat2_2(m,i).value=Dat2_2(m,i).value./10e8;
        end
        
        % Create a logical index to identify elements to keep
        keep_indices = [Dat2_2(:,i).value] >= freq_start & [Dat2_2(:,i).value] <= freq_stop2;

        % Filter Dat1 based on the logical index
        Dat2_2_new(:,i) = Dat2_2(keep_indices,i);
    end
end

% MIX 2

for i = 1:length(e_r2_3)
    if e_r2_3(i) ~= 0
        
        Dat2_3(1,i).name  = 'TM$_{010}$'; 
        Dat2_3(1,i).value = (c./(2*pi*sqrt(my_r*e_r2_3(i))))*(p_TM(1,1)./a); % f0
        Dat2_3(2,i).name  = 'TM$_{011}$';
        Dat2_3(2,i).value = (c./(2*pi*sqrt(my_r*e_r2_3(i))))*sqrt((p_TM(1,1)./a).^2+(1*pi./h).^2);     
        Dat2_3(3,i).name  = 'TM$_{012}$';
        Dat2_3(3,i).value = (c./(2*pi*sqrt(my_r*e_r2_3(i))))*sqrt((p_TM(1,1)./a).^2+(2*pi./h).^2);
        Dat2_3(4,i).name  = 'TM$_{013}$';
        Dat2_3(4,i).value = (c./(2*pi*sqrt(my_r*e_r2_3(i))))*sqrt((p_TM(1,1)./a).^2+(3*pi./h).^2);
        Dat2_3(5,i).name  = 'TM$_{014}$';
        Dat2_3(5,i).value = (c./(2*pi*sqrt(my_r*e_r2_3(i))))*sqrt((p_TM(1,1)./a).^2+(4*pi./h).^2);
        Dat2_3(6,i).name  = 'TM$_{015}$';
        Dat2_3(6,i).value = (c./(2*pi*sqrt(my_r*e_r2_3(i))))*sqrt((p_TM(1,1)./a).^2+(5*pi./h).^2);
        Dat2_3(7,i).name  = 'TM$_{016}$';
        Dat2_3(7,i).value = (c./(2*pi*sqrt(my_r*e_r2_3(i))))*sqrt((p_TM(1,1)./a).^2+(6*pi./h).^2);
        Dat2_3(8,i).name  = 'TM$_{017}$';
        Dat2_3(8,i).value = (c./(2*pi*sqrt(my_r*e_r2_3(i))))*sqrt((p_TM(1,1)./a).^2+(7*pi./h).^2);
        Dat2_3(9,i).name  = 'TM$_{018}$';
        Dat2_3(9,i).value = (c./(2*pi*sqrt(my_r*e_r2_3(i))))*sqrt((p_TM(1,1)./a).^2+(8*pi./h).^2);
        Dat2_3(10,i).name  = 'TM$_{019}$';
        Dat2_3(10,i).value = (c./(2*pi*sqrt(my_r*e_r2_3(i))))*sqrt((p_TM(1,1)./a).^2+(9*pi./h).^2);
        Dat2_3(11,i).name  = 'TM$_{020}$';
        Dat2_3(11,i).value = (c./(2*pi*sqrt(my_r*e_r2_3(i))))*(p_TM(1,2)./a);
        Dat2_3(12,i).name  = 'TM$_{021}$';
        Dat2_3(12,i).value = (c./(2*pi*sqrt(my_r*e_r2_3(i))))*sqrt((p_TM(1,2)./a).^2+(1*pi./h).^2);
        Dat2_3(13,i).name  = 'TM$_{022}$';
        Dat2_3(13,i).value = (c./(2*pi*sqrt(my_r*e_r2_3(i))))*sqrt((p_TM(1,2)./a).^2+(2*pi./h).^2);
        
        % SORTED STRUCT ARRAY
        x_m=0;
        idx_m=0;
        [x,idx]=sort([Dat2_3(:,i).value]);
        Dat2_3(:,i)=Dat2_3(idx,i);
        
        for m=1:length(Dat2_3(:,i))
            Dat2_3(m,i).value=Dat2_3(m,i).value./10e8;
        end
        
        % Create a logical index to identify elements to keep
        keep_indices = [Dat2_3(:,i).value] >= freq_start & [Dat2_3(:,i).value] <= freq_stop2;

        % Filter Dat1 based on the logical index
        Dat2_3_new(:,i) = Dat2_3(keep_indices,i);
    end
end


%% REMOVING EMPTY P_AVG - no need

% NITROGEN 1
% SWITCHING M AND I
min_f1_1_switched = cell(length(min_f1_1{1}), length(min_f1_1));
w=0;
% SWITCHING M AND I -AND- REMOVING EMPTY P_AVG
for i = 1:length(min_f1_1)
    for m = 1:length(min_f1_1{1})
        min_f1_1_switched{m}{i} = min_f1_1{i}{m};
    end
end

% CO2 1
% SWITCHING M AND I
min_f1_2_switched = cell(length(min_f1_2{1}), length(min_f1_2));
w=0;
% SWITCHING M AND I -AND- REMOVING EMPTY P_AVG
for i = 1:length(min_f1_2)
    for m = 1:length(min_f1_2{1})
        min_f1_2_switched{m}{i} = min_f1_2{i}{m};
    end
end

% NITROGEN 2
% SWITCHING M AND I
min_f2_1_switched = cell(length(min_f2_1{1}), length(min_f2_1));
w=0;
% SWITCHING M AND I -AND- REMOVING EMPTY P_AVG
for i = 1:length(min_f2_1)
    for m = 1:length(min_f2_1{1})
        min_f2_1_switched{m}{i} = min_f2_1{i}{m};
    end
end

% CO2 2
% SWITCHING M AND I
min_f2_2_switched = cell(length(min_f2_2{1}), length(min_f2_2));
w=0;
% SWITCHING M AND I -AND- REMOVING EMPTY P_AVG
for i = 1:length(min_f2_2)
    for m = 1:length(min_f2_2{1})
        min_f2_2_switched{m}{i} = min_f2_2{i}{m};
    end
end

% MIXTURE 2
% SWITCHING M AND I
min_f2_3_switched = cell(length(min_f2_3{1}), length(min_f2_3));
w=0;
% SWITCHING M AND I -AND- REMOVING EMPTY P_AVG
for i = 1:length(min_f2_3)
    for m = 1:length(min_f2_3{1})
        min_f2_3_switched{m}{i} = min_f2_3{i}{m};
    end
end

%% FINDING MEASURED PERMITTIVITY CO2 MEAS 1

val=0;
idx=0;
e_co2={};

% FINDING NITROGEN F0 AT CO2 PRESSURE POINTS BY INTERPOLATION

p_avg1_1_new=p_avg1_1;
diff_p1_1_new=diff_p1_1;
w=0; 

for i=1:length(p_avg1_1)
    if diff1_1_idx(i)==0
        p_avg1_1_new(i-w)=[];
        e_r1_1(i-w)=[];
        diff_p1_1_new(i-w)=[];
        Dat1_1_new(:,i-w)=[];
        for m=1:length(Dat1_1_new(:,1))
            min_f1_1_switched{m}{i}=[];
        end
        w=w+1;
    end
end
min_f1_1_switched_new=cell(length(Dat1_1_new(:,1)), length(p_avg1_1_new));
%Dat1_1_new1=cell(length(Dat1_1_new(:,1)),length(p_avg1_1_new));

p_avg1_2_new=p_avg1_2;
diff_p1_2_new=diff_p1_2;
w=0; 
for i=1:length(p_avg1_2)
    if diff1_2_idx(i)==0 || p_avg1_2_new(i-w) <= min(p_avg1_1) || p_avg1_2_new(i-w) >= max(p_avg1_1) % because of interpolation later
        p_avg1_2_new(i-w)=[];
        diff_p1_2_new(i-w)=[];
        e_r1_p1_2(i-w)=[];
        e_r1_2(i-w)=[]; % teoretiske verdier av e_co2
        Dat1_2_new(:,i-w)=[];
        for m=1:length(Dat1_2_new(:,1))
            min_f1_2_switched{m}{i}=[];
        end
        w=w+1;
    end
end
min_f1_2_switched_new=cell(length(Dat1_2_new(:,1)), length(p_avg1_2_new));

%% INDIVIDUAL RESONANCE 

for m=1:length(Dat1_1_new(:,1)) %-3
    non_empty_indices1_1 = find(~cellfun(@isempty, min_f1_1_switched{m}));
    non_empty_indices1_2 = find(~cellfun(@isempty, min_f1_2_switched{m}));
    
    for i=1:length(p_avg1_1_new)
        min_f1_1_switched_new{m}{i}=min_f1_1_switched{m}{non_empty_indices1_1(i)};
    end
    for i=1:length(p_avg1_2_new)
        min_f1_2_switched_new{m}{i}=min_f1_2_switched{m}{non_empty_indices1_2(i)};
    end
    for i=1:length(p_avg1_2_new)
        f0_ni_1(m,i) = interp1(p_avg1_1_new', [min_f1_1_switched_new{m}{:}]', p_avg1_2_new(i));
        e_co2_1{m}{i} = (f0_ni_1(m,i)./[min_f1_2_switched_new{m}{i}]).^2 * e_r1_p1_2(i); 
    end
end

%% REMOVING UNWANTED VALUES OF ALL STRUCTS AND LISTS

val=0;
idx=0;
e_co2_2={};
e_mix_2={};
p_avg2_1_new=p_avg2_1;
diff_p2_1_new=diff_p2_1;

w=0; 
for i=1:length(p_avg2_1)
    if diff2_1_idx(i)==0
        p_avg2_1_new(i-w)=[];
        e_r2_1(i-w)=[];
        diff_p2_1_new(i-w)=[];
        Dat2_1_new(:,i-w)=[];
        for m=1:length(Dat2_1_new(:,1))
            min_f2_1_switched{m}{i}=[];
        end
        w=w+1;
    end
end
min_f2_1_switched_new=cell(length(Dat2_1_new(:,1)), length(p_avg2_1_new));

w=0; 
p_avg2_2_new=p_avg2_2;
diff_p2_2_new=diff_p2_2;

for i=1:length(p_avg2_2)
    if diff2_2_idx(i)==0 || p_avg2_2_new(i-w) <= min(p_avg2_1_new) || p_avg2_2_new(i-w) >= max(p_avg2_1_new) % because of interpolation later
        p_avg2_2_new(i-w)=[];
        diff_p2_2_new(i-w)=[];
        e_r1_p2_2(i-w)=[];
        e_r2_2(i-w)=[];
        Dat2_2_new(:,i-w)=[];
        for m=1:length(Dat2_2_new(:,1))
            min_f2_2_switched{m}{i}=[];
        end
        w=w+1;
    end
end
min_f2_2_switched_new=cell(length(Dat2_2_new(:,1)), length(p_avg2_2_new));

w=0; 
p_avg2_3_new=p_avg2_3;
diff_p2_3_new=diff_p2_3;

for i=1:length(p_avg2_3)
    if diff2_3_idx(i)==0 || p_avg2_3_new(i-w) <= min(p_avg2_1_new) || p_avg2_3_new(i-w) >= max(p_avg2_1_new) % because of interpolation later
        p_avg2_3_new(i-w)=[];
        diff_p2_3_new(i-w)=[];
        e_r1_p2_3(i-w)=[];
        e_r2_3(i-w)=[];
        Dat2_3_new(:,i-w)=[];
        for m=1:length(Dat2_3_new(:,1))
            min_f2_3_switched{m}{i}=[];
        end
        w=w+1;
    end
end
min_f2_3_switched_new=cell(length(Dat2_3_new(:,1)), length(p_avg2_3_new));

p=1:1:100;

%% FINDING MEASURED PERMITTIVITY CO2 AND MIXTURE MEAS 2

for m=1:length(Dat2_1_new(:,1))
    non_empty_indices2_1 = find(~cellfun(@isempty, min_f2_1_switched{m}));
    non_empty_indices2_2 = find(~cellfun(@isempty, min_f2_2_switched{m}));
    non_empty_indices2_3 = find(~cellfun(@isempty, min_f2_3_switched{m}));
    
    for i=1:length(p_avg2_1_new)
        min_f2_1_switched_new{m}{i}=min_f2_1_switched{m}{non_empty_indices2_1(i)};
    end
    for i=1:length(p_avg2_2_new)
        min_f2_2_switched_new{m}{i}=min_f2_2_switched{m}{non_empty_indices2_2(i)};
    end
    for i=1:length(p_avg2_3_new)
        min_f2_3_switched_new{m}{i}=min_f2_3_switched{m}{non_empty_indices2_3(i)};
    end
    
    for i=1:length(p_avg2_2_new)
        f0_ni_2(m,i) = interp1(p_avg2_1_new', [min_f2_1_switched_new{m}{:}]', p_avg2_2_new(i));
        e_co2_2{m}{i} = (f0_ni_2(m,i)./[min_f2_2_switched_new{m}{i}]).^2 * e_r1_p2_2(i); 
    end
    for i=1:length(p_avg2_3_new)
        f0_ni_2(m,i) = interp1(p_avg2_1_new', [min_f2_1_switched_new{m}{:}]', p_avg2_3_new(i));
        e_mix_2{m}{i} = (f0_ni_2(m,i)./[min_f2_3_switched_new{m}{i}]).^2 * e_r1_p2_3(i); 
    end
end

%% ALL 3 DIELECTRIC CONSTANTS FOR PRESSURE (ALL MODES MINUS TM015 MODE)

figure
plot(p(1:52)', de_p1_2(1:52)', '--', 'color', [0 0.4470 0.7410]); hold on;
plot(p(1:52)', de_p2_2(1:52)', '--', 'color', [0.8500 0.3250 0.0980]); hold on;
plot(p(1:52)', de_p2_3(1:52)', '--', 'color', [0.9290 0.6940 0.1250]); hold on;
for m=1:length(Dat1_1_new(:,1))
    if m~=6
        if m==1
            plot(p_avg1_2_new, [e_co2_1{m}{:}], '*', 'color', [0 0.4470 0.7410]); hold on;
        else
            b=plot(p_avg1_2_new, [e_co2_1{m}{:}], '*', 'color', [0 0.4470 0.7410]); hold on;
            b = gca; legend(b,'off');
        end
    end
end
for m=1:length(Dat2_1_new(:,1))
    if m==1
        plot(p_avg2_2_new, [e_co2_2{m}{:}], '*', 'color', [0.8500 0.3250 0.0980]); hold on;
        plot(p_avg2_3_new, [e_mix_2{m}{:}], '*', 'color', [0.9290 0.6940 0.1250]); hold on;
    else
        b=plot(p_avg2_2_new, [e_co2_2{m}{:}], '*', 'color', [0.8500 0.3250 0.0980]); hold on;
        b = gca; legend(b,'off');
        b=plot(p_avg2_3_new, [e_mix_2{m}{:}], '*', 'color', [0.9290 0.6940 0.1250]); hold on;
        b = gca; legend(b,'off');
    end
end
xlim([10 52])
set(gca,'fontsize',12,'TickLabelInterpreter','latex')
legend({'$\varepsilon_t$ CO$_{2,1}$', '$\varepsilon_t$ CO$_{2,2}$', '$\varepsilon_t$ Mix$_{2}$', '$\varepsilon^{\prime}_m$ CO$_{2,1}$', '$\varepsilon^{\prime}_m$ CO$_{2,2}$', '$\varepsilon^{\prime}_m$ Mix$_{2}$'},'fontsize',12,'interpreter','latex');
%title('Meas1','fontsize',14,'interpreter','latex');
xlabel('Pressure [bara]','fontsize',14,'interpreter','latex');
ylabel('Relative permittivity','fontsize',14,'interpreter','latex');


%% COMBINED OFFSET PERMITTIVITY AGAINST PRESSURE

figure
clear change;
subplot(3, 1, 1)
for m=1:length(Dat1_1_new(:,1)) % UTENOM TM015
    change=e_r1_2-[e_co2_1{m}{:}];
    if m~=6
        plot(p_avg1_2_new, change, '*'); hold on; 
    end
end
yline(0, 'k--');
xlim([0,45]);
set(gca,'fontsize',12,'TickLabelInterpreter','latex')
title('CO$_{2,1}$','fontsize',14,'interpreter','latex');
xlabel('Pressure [bara]','fontsize',14,'interpreter','latex');
ylabel('$ \varepsilon_{t}-\varepsilon^{\prime}_{m}  $','fontsize',14,'interpreter','latex');

legend({Dat2_2_new(:,3).name, Dat1_2_new(7:end,3).name},'fontsize',14,'interpreter','latex');

clear change;
subplot(3, 1, 2)
for m=1:length(Dat2_2_new(:,1))
    change=e_r2_2-[e_co2_2{m}{:}];
    plot(p_avg2_2_new, change, '*'); hold on;
end
yline(0, 'k--');
xlim([0,45]);
set(gca,'fontsize',12,'TickLabelInterpreter','latex')
title('CO$_{2,2}$','fontsize',14,'interpreter','latex');
xlabel('Pressure [bara]','fontsize',14,'interpreter','latex');
ylabel('$ \varepsilon_{t}-\varepsilon^{\prime}_{m}  $','fontsize',14,'interpreter','latex');

clear change;
subplot(3, 1, 3)
for m=1:length(Dat2_3_new(:,1))
    change=e_r2_3-[e_mix_2{m}{:}];
    plot(p_avg2_3_new, change, '*'); hold on;
end
yline(0, 'k--');
xlim([0,55]);
set(gca,'fontsize',12,'TickLabelInterpreter','latex')
title('Mix$_{2}$','fontsize',14,'interpreter','latex');
xlabel('Pressure [bara]','fontsize',14,'interpreter','latex');
ylabel('$ \varepsilon_{t}-\varepsilon^{\prime}_{m}  $','fontsize',14,'interpreter','latex');

%% COMBINED OFFSET PERMITTIVITY AGAINST FREQUENCY

figure
clear change;
subplot(3, 1, 1)
for m=1:length(Dat1_1_new(:,1)) % except TM015
    if m~=6
        change=e_r1_2-[e_co2_1{m}{:}];
        plot([Dat1_2_new(m,:).value], change, '*'); hold on; 
    end
end
yline(0, 'k--');
xlim([5,12]);
legend({Dat1_2_new([1,2,3,4,5,7,8],3).name},'fontsize',14,'interpreter','latex');

set(gca,'fontsize',12,'TickLabelInterpreter','latex')
title('CO$_{2,1}$','fontsize',14,'interpreter','latex');
xlabel('Frequency [GHz]','fontsize',14,'interpreter','latex');
ylabel('$ \varepsilon_{t}-\varepsilon^{\prime}_{m}  $','fontsize',14,'interpreter','latex');

clear change;
subplot(3, 1, 2)
for m=1:length(Dat2_2_new(:,1)) 
    change=e_r2_2-[e_co2_2{m}{:}];
    plot([Dat2_2_new(m,:).value], change, '*'); hold on;
end
yline(0, 'k--');
xlim([5,9]);
set(gca,'fontsize',12,'TickLabelInterpreter','latex')
title('CO$_{2,2}$','fontsize',14,'interpreter','latex');
xlabel('Frequency [GHz]','fontsize',14,'interpreter','latex');
ylabel('$ \varepsilon_{t}-\varepsilon^{\prime}_{m}  $','fontsize',14,'interpreter','latex');

clear change;
subplot(3, 1, 3)
for m=1:length(Dat2_3_new(:,1))
    change=e_r2_3-[e_mix_2{m}{:}];
    plot([Dat2_3_new(m,:).value], change, '*'); hold on;
end
yline(0, 'k--');
xlim([5,9]);
ylim([-2*10.^(-4),8*10.^(-4)]);
set(gca,'fontsize',12,'TickLabelInterpreter','latex')
title('Mix$_{2}$','fontsize',14,'interpreter','latex');
xlabel('Frequency [GHz]','fontsize',14,'interpreter','latex');
ylabel('$ \varepsilon_{t}-\varepsilon^{\prime}_{m}  $','fontsize',14,'interpreter','latex');


%% FINDING RESONANCE FREQUENCY OFFSETS

[out1_1,idx1_1] = sort(p_avg1_1_new);
[out1_2,idx1_2] = sort(p_avg1_2_new);
[out2_1,idx2_1] = sort(p_avg2_1_new);
[out2_2,idx2_2] = sort(p_avg2_2_new);
[out2_3,idx2_3] = sort(p_avg2_3_new);
idx2_3=idx2_3(1:end-1);

change1_1={}; 
avg_change1_1=[]; %(avg pressure, finding minimum change mode)
avg_c1_1=[]; %(avg mode, finding minimum change pressure)

for m=1:length(Dat1_1_new(:,1))
    change1_1{m}=[Dat1_1_new(m,idx1_1).value]-[min_f1_1_switched_new{m}{idx1_1}];
    avg_change1_1(m)=mean([change1_1{m}], "all");
    min_change1_1(m)=min([change1_1{m}]);
    max_change1_1(m)=max([change1_1{m}]);
    for l=1:length(idx1_1)
        if m==2
            avg_c1_1(end+1) = change1_1{m}(l);
        end
    end   
end

change1_2={};
avg_change1_2=[];
avg_c1_2=[];
for m=1:length(Dat1_2_new(:,1))
    change1_2{m}=[Dat1_2_new(m,idx1_2).value]-[min_f1_2_switched_new{m}{idx1_2}];
    avg_change1_2(m)=mean([change1_2{m}], "all");
    min_change1_2(m)=min([change1_2{m}]);
    max_change1_2(m)=max([change1_2{m}]);
    for l=1:length(idx1_2)
        if m==2
            avg_c1_2(end+1) = change1_2{m}(l);
        end
    end
end

change2_1={};
avg_change2_1=[];
avg_c2_1=[];
for m=1:length(Dat2_1_new(:,1))
    change2_1{m}=[Dat2_1_new(m,idx2_1).value]-[min_f2_1_switched_new{m}{idx2_1}];
    plot(p_avg2_1_new(idx2_1), [change2_1{m}], '*'); hold on;
    avg_change2_1(m)=mean([change2_1{m}], "all");
    min_change2_1(m)=min([change2_1{m}]);
    max_change2_1(m)=max([change2_1{m}]);
    for l=1:length(idx2_1)
        if m==2
            avg_c2_1(end+1) = change2_1{m}(l);
        end
    end
end

change2_2={};
avg_change2_2=[];
avg_c2_2=[];
for m=1:length(Dat2_2_new(:,1))
    change2_2{m}=[Dat2_2_new(m,idx2_2).value]-[min_f2_2_switched_new{m}{idx2_2}];
    avg_change2_2(m)=mean([change2_2{m}], "all");
    min_change2_2(m)=min([change2_2{m}]);
    max_change2_2(m)=max([change2_2{m}]);
    for l=1:length(idx2_2)
        if m==2
            avg_c2_2(end+1) = change2_2{m}(l);
        end
    end
end

change2_3={};
avg_change2_3=[];
avg_c2_3=[];
for m=1:length(Dat2_3_new(:,1))
    change2_3{m}=[Dat2_3_new(m,idx2_3).value]-[min_f2_3_switched_new{m}{idx2_3}];
    avg_change2_3(m)=mean([change2_3{m}], "all");
    min_change2_3(m)=min([change2_3{m}]);
    max_change2_3(m)=max([change2_3{m}]);
    for l=1:length(idx2_3)
        if m==2
            avg_c2_3(end+1) = change2_3{m}(l);
        end
    end
end

%% subplot resonance frequency offset against pressure

figure
for m=1:length(Dat2_2_new(:,1))
    subplot(4, 2, m)

    plot(p_avg1_1_new(idx1_1), [change1_1{m}], '*'); hold on;
    plot(p_avg1_2_new(idx1_2), [change1_2{m}], '*'); hold on;
    plot(p_avg2_1_new(idx2_1), [change2_1{m}], '*'); hold on;
    plot(p_avg2_2_new(idx2_2), [change2_2{m}], '*'); hold on;
    plot(p_avg2_3_new(idx2_3), [change2_3{m}], '*'); hold on;
    
    %yline(0, '--');

    set(gca,'TickLabelInterpreter','latex','fontsize',14)
    title(string(Dat2_2_new(m,1).name),'fontsize',14,'interpreter','latex');
    xlabel('Pressure [bara]','fontsize',14,'interpreter','latex');
    ylabel('$ f_{t}(p)-f_{m}(p) $ [GHz]','fontsize',14,'interpreter','latex');
end
legend({'N$_{2,1}$', 'CO$_{2,1}$', 'N$_{2,2}$', 'CO$_{2,2}$', 'Mix$_2$'}, 'Location','northoutside','fontsize',16,'interpreter','latex');

for m=6:length(Dat1_1_new(:,1))
    subplot(4, 2, m)
    
    plot(p_avg1_1_new(idx1_1), [change1_1{m}], '*'); hold on;
    plot(p_avg1_2_new(idx1_2), [change1_2{m}], '*'); hold on;
    
    %yline(0, '--');
    
    set(gca,'TickLabelInterpreter','latex','fontsize',14)
    title(string(Dat1_1_new(m,1).name),'fontsize',14,'interpreter','latex');
    xlabel('Pressure [bara]','fontsize',14,'interpreter','latex');
    ylabel('$ f_{t}(p)-f_{m}(p) $ [GHz]','fontsize',14,'interpreter','latex');
end


%% ALL RESONANCE FREQUENCIES FOR EACH MODE

figure
for m=1:length(Dat2_1_new(:,1))
    subplot(4, 2, m)
    
    plot(p_avg1_1_new(idx1_1), [min_f1_1_switched_new{m}{idx1_1}], '*', 'color', [0 0.4470 0.7410]); hold on; %b
    plot(p_avg1_1_new(idx1_1), [Dat1_1_new(m,idx1_1).value], '-', 'color', [0 0.4470 0.7410]);
    
    plot(p_avg1_2_new(idx1_2), [min_f1_2_switched_new{m}{idx1_2}], '*', 'color', [0.8500 0.3250 0.0980]); hold on; %r
    plot(p_avg1_2_new(idx1_2), [Dat1_2_new(m,idx1_2).value], '-', 'color', [0.8500 0.3250 0.0980]);
    
    plot(p_avg2_1_new(idx2_1), [min_f2_1_switched_new{m}{idx2_1}], '*', 'color', [0.9290 0.6940 0.1250]); hold on; %g
    plot(p_avg2_1_new(idx2_1), [Dat2_1_new(m,idx2_1).value], '-', 'color', [0.9290 0.6940 0.1250]);
    
    plot(p_avg2_2_new(idx2_2), [min_f2_2_switched_new{m}{idx2_2}], '*', 'color', [0.4940 0.1840 0.5560]); hold on; %c
    plot(p_avg2_2_new(idx2_2), [Dat2_2_new(m,idx2_2).value], '-', 'color', [0.4940 0.1840 0.5560]);
    
    plot(p_avg2_3_new(idx2_3), [min_f2_3_switched_new{m}{idx2_3}], '*', 'color', [0.4660 0.6740 0.1880]); hold on; %m
    plot(p_avg2_3_new(idx2_3), [Dat2_3_new(m,idx2_3).value], '-', 'color', [0.4660 0.6740 0.1880]);
    
    set(gca,'TickLabelInterpreter','latex','fontsize',14)
    title(string(Dat2_2_new(m,1).name),'fontsize',14,'interpreter','latex');
    xlabel('Pressure [bara]','fontsize',14,'interpreter','latex');
    ylabel('Resonance frequency [GHz]','fontsize',14,'interpreter','latex');
end
legend({'$f_m$ N$_{2,1}$', '$f_t$ N$_{2,1}$', '$f_m$ CO$_{2,1}$', '$f_t$ CO$_{2,1}$', '$f_m$ N$_{2,2}$', '$f_t$ N$_{2,2}$', '$f_m$ CO$_{2,2}$', '$f_t$ CO$_{2,2}$', '$f_m$ Mix$_2$', '$f_t$ Mix$_2$'}, 'Location','northoutside','fontsize',16,'interpreter','latex');

for m=6:length(Dat1_1_new(:,1))
    subplot(4, 2, m)
    
    plot(p_avg1_1_new(idx1_1), [min_f1_1_switched_new{m}{idx1_1}], '*', 'color', [0 0.4470 0.7410]); hold on; %b
    plot(p_avg1_1_new(idx1_1), [Dat1_1_new(m,idx1_1).value], '-', 'color', [0 0.4470 0.7410]);

    plot(p_avg1_2_new(idx1_2), [min_f1_2_switched_new{m}{idx1_2}], '*', 'color', [0.8500 0.3250 0.0980]); hold on; %r
    plot(p_avg1_2_new(idx1_2), [Dat1_2_new(m,idx1_2).value], '-', 'color', [0.8500 0.3250 0.0980]);
    
    set(gca,'TickLabelInterpreter','latex','fontsize',14)
    title(string(Dat1_1_new(m,1).name),'fontsize',14,'interpreter','latex');
    xlabel('Pressure [bara]','fontsize',14,'interpreter','latex');
    ylabel('Resonance frequency [GHz]','fontsize',14,'interpreter','latex');
end



%% PRESSURE PLOTS APPENDIX C

figure
plot(pressure_time1_1, str2double(pressure_data1_1)); hold on;
errorbar(time_half1_1, p_avg1_1, abs(min_p1_1-p_avg1_1), abs(max_p1_1-p_avg1_1), 'x', 'color', [0.4660 0.6740 0.1880]);
for i=1:length(p_avg1_1)
    if diff_p1_1(i)>0.2
        errorbar(time_half1_1(i), p_avg1_1(i), abs(min_p1_1(i)-p_avg1_1(i)), abs(max_p1_1(i)-p_avg1_1(i)), '*', 'color', [0.8500 0.3250 0.0980]);
    end
end
ylim([1, max(str2double(pressure_data1_1))]);
xlim([min(time_half1_1)+seconds(460), max(time_half1_1)+seconds(60)]);
set(gca,'fontsize',14,'TickLabelInterpreter','latex')
xlabel('Datetime','fontsize',15,'interpreter','latex');
ylabel('Pressure [bara]','fontsize',15,'interpreter','latex');

figure
plot(pressure_time1_2, str2double(pressure_data1_2)); hold on;
errorbar(time_half1_2, p_avg1_2, abs(min_p1_2-p_avg1_2), abs(max_p1_2-p_avg1_2), 'x', 'color', [0.4660 0.6740 0.1880]);
for i=1:length(p_avg1_2)
    if diff_p1_2(i)>0.2
        errorbar(time_half1_2(i), p_avg1_2(i), abs(min_p1_2(i)-p_avg1_2(i)), abs(max_p1_2(i)-p_avg1_2(i)), '*', 'color', [0.8500 0.3250 0.0980]);
    end
end
ylim([1, max(str2double(pressure_data1_2))]);
xlim([min(time_half1_2)-seconds(60), max(time_half1_2)]+seconds(60));
set(gca,'fontsize',14,'TickLabelInterpreter','latex')
xlabel('Datetime','fontsize',15,'interpreter','latex');
ylabel('Pressure [bara]','fontsize',15,'interpreter','latex');

figure
plot(pressure_time2_1, str2double(pressure_data2_1)); hold on;
errorbar(time_half2_1, p_avg2_1, abs(min_p2_1-p_avg2_1), abs(max_p2_1-p_avg2_1), 'x', 'color', [0.4660 0.6740 0.1880]);
for i=1:length(p_avg2_1)
    if diff_p2_1(i)>0.2
        errorbar(time_half2_1(i), p_avg2_1(i), abs(min_p2_1(i)-p_avg2_1(i)), abs(max_p2_1(i)-p_avg2_1(i)), '*', 'color', [0.8500 0.3250 0.0980]);
    end
end
ylim([1, max(str2double(pressure_data2_1))]);
xlim([min(time_half2_1)-seconds(60), max(time_half2_1)+seconds(60)]);
set(gca,'fontsize',14,'TickLabelInterpreter','latex')
xlabel('Datetime','fontsize',15,'interpreter','latex');
ylabel('Pressure [bara]','fontsize',15,'interpreter','latex');

figure
plot(pressure_time2_2, str2double(pressure_data2_2)); hold on;
errorbar(time_half2_2, p_avg2_2, abs(min_p2_2-p_avg2_2), abs(max_p2_2-p_avg2_2), 'x', 'color', [0.4660 0.6740 0.1880]);
for i=1:length(p_avg2_2)
    if diff_p2_2(i)>0.2
        errorbar(time_half2_2(i), p_avg2_2(i), abs(min_p2_2(i)-p_avg2_2(i)), abs(max_p2_2(i)-p_avg2_2(i)), '*', 'color', [0.8500 0.3250 0.0980]);
    end
end
ylim([1, max(str2double(pressure_data2_2))]);
xlim([min(time_half2_2)-seconds(60), max(time_half2_2)+seconds(60)]);
set(gca,'fontsize',14,'TickLabelInterpreter','latex')
xlabel('Datetime','fontsize',15,'interpreter','latex');
ylabel('Pressure [bara]','fontsize',15,'interpreter','latex');

figure
plot(pressure_time2_3, str2double(pressure_data2_3)); hold on;
errorbar(time_half2_3, p_avg2_3, abs(min_p2_3-p_avg2_3), abs(max_p2_3-p_avg2_3), 'x', 'color', [0.4660 0.6740 0.1880]);
for i=1:length(p_avg2_3)
    if diff_p2_3(i)>0.2
        errorbar(time_half2_3(i), p_avg2_3(i), abs(min_p2_3(i)-p_avg2_3(i)), abs(max_p2_3(i)-p_avg2_3(i)), '*', 'color', [0.8500 0.3250 0.0980]);
    end
end
ylim([1, max(str2double(pressure_data2_3))]);
xlim([min(time_half2_3)-seconds(60), max(time_half2_3)+seconds(60)]);
set(gca,'fontsize',14,'TickLabelInterpreter','latex')
xlabel('Datetime','fontsize',15,'interpreter','latex');
ylabel('Pressure [bara]','fontsize',15,'interpreter','latex');
