% GASSER MED PERMITTIVITET

% HYDROGEN, NITROGEN, CO2, ARGON

clear all;

%purity=1;
%T=20; %C
purity=0.95:0.01:1;
T=0:5:35;
p=[1,10:10:200]; %bar = 20 MPa

%Henter gasser
de_1=load('/Users/annamatheaskar/Desktop/Master/teoretiske datasett/Dielektrisk konstant/methane-hydrogen-de_p6-T8-p21.mat'); %henter "de"
%de_2=load('/Users/annamatheaskar/Desktop/Master/teoretiske datasett/Dielektrisk konstant/co2-hydrogen-de_p6-T8-p21.mat'); %henter "de"
de_2=load('/Users/annamatheaskar/Desktop/Master/teoretiske datasett/Dielektrisk konstant/co2-de_p1-T1-p1-0.1-100.mat'); %henter "de"


de_3=load('/Users/annamatheaskar/Desktop/Master/teoretiske datasett/Dielektrisk konstant/nitrogen-hydrogen-de_p6-T8-p21.mat'); %henter "de"
de_4=load('/Users/annamatheaskar/Desktop/Master/teoretiske datasett/Dielektrisk konstant/argon-hydrogen-de_p6-T8-p21.mat'); %henter "de"
de_5=load('/Users/annamatheaskar/Desktop/Master/teoretiske datasett/Dielektrisk konstant/hydrogen-methane-de_p6-T8-p21.mat'); %henter "de"

de_6=load('/Users/annamatheaskar/Desktop/Master/teoretiske datasett/Dielektrisk konstant/nitrogen-co2-de_p6-T8-p21.mat'); %henter "de"
de_7=load('/Users/annamatheaskar/Desktop/Master/teoretiske datasett/Dielektrisk konstant/air(nitrogenoxygen)-de_T8-p21.mat'); %henter "de"

de_8=load('/Users/annamatheaskar/Desktop/Master/teoretiske datasett/Dielektrisk konstant/T=21.1/mixture-de_p5-T1-p100.mat'); %henter "de"


%Permittivitet
e_r_l=1.00059; %relativ permittivitet luft/nitrogen ved romtemp
e_r_co2=1.000921; %relativ permittivitet co2 ved romtemp
e_r_arg=1.000513; %relativ permittivitet argon ved romtemp

de_m=de_1.de(find(purity==1),find(T==20),:);
de_co2=de_2.de(1,1,:);
de_n2=de_3.de(find(purity==1),find(T==20),:);
de_ar=de_4.de(find(purity==1),find(T==20),:);

de_h2=de_5.de(find(purity==1),find(T==20),:);
de_h2_m=de_5.de(find(purity==0.99),find(T==20),:);

de_n2co2_1=de_6.de(find(purity==0.99),find(T==20),:);

de_air=de_7.de(find(T==20),:);

% Carbon Monoxide permittivity at 20C
p_co=[2.0192, 4.0156, 6.0021, 8.0046, 6.0050, 4.0666, 2.0479]*10;
de_co=[1.01300, 1.02610, 1.03928, 1.05262, 1.03933, 1.02644, 1.01319];

p_fit_co=polyfit(p_co', de_co', 1); %5
xfit_co=1:0.1:120;
yfit_co=polyval(p_fit_co,xfit_co);

figure
p=1:0.1:100;
plot(p, [squeeze(de_co2)]); hold on;
%plot(xfit_co2, yfit_co2, '-'); hold on;
%plot(f); hold on;
p=[1,10:10:200];
plot(p,[squeeze(de_m)]); hold on;
plot(xfit_co, yfit_co, '-'); hold on;
%plot(p(1:6),de_co2(1:6), 'o', xfit_co2, yfit_co2, '-', 'DisplayName', 'CO2 permittivity'); hold on;
plot(p,[squeeze(de_n2)]); hold on;
plot(p,[squeeze(de_ar)]); hold on;
%plot(p(1:13),de_h2_m(1:13)); hold on;
%plot(p_co, de_co); hold on;

%plot(p(1:13),de_n2co2_1(1:13)); hold on;
plot(p,[squeeze(de_air)]); hold on;
plot(p,[squeeze(de_h2)]); hold on;

p_mix=[1:1:100]; %bar = 20 MPa

purity_mix = 0.18:0.01:0.22;

de_mix=[de_8.de(find(purity_mix==0.20),1,:)];
plot(p_mix,squeeze(de_mix)); hold on;

set(gca,'TickLabelInterpreter','latex')

ylim([1, 1.15]);
xlim([0,100]);

legend({'Carbon Dioxide', 'Methane', 'Carbon Monoxide', 'Nitrogen', 'Argon', 'Air', 'Hydrogen', 'N2/CO2 mix'},'fontsize',11,'interpreter','latex');
%title('Pressure effect on gas permittivity at room temperature (20$^{\circ}$C)','fontsize',14,'interpreter','latex');
xlabel('Pressure [bar]','fontsize',14,'interpreter','latex');
ylabel('Dielectric constant','fontsize',14,'interpreter','latex');

directory = '/Users/annamatheaskar/Desktop/Master/figurer_master';
filename = fullfile(directory, 'pressure_dependency_gases.eps');
saveas(gcf, filename, 'epsc')


%% HYDROGEN UNCERTAINTY

% figure
% 
% de_h2_99=de_5.de(find(purity==0.99),find(T==20),:);
% de_h2_98=de_5.de(find(purity==0.98),find(T==20),:);
% de_h2_97=de_5.de(find(purity==0.97),find(T==20),:);
% de_h2_96=de_5.de(find(purity==0.96),find(T==20),:);
% de_h2_95=de_5.de(find(purity==0.95),find(T==20),:);
% 
% plot(p,[squeeze(de_h2)]); hold on;
% plot(p,[squeeze(de_h2_99)]); hold on;
% plot(p,[squeeze(de_h2_98)]); hold on;
% plot(p,[squeeze(de_h2_97)]); hold on;
% plot(p,[squeeze(de_h2_96)]); hold on;
% plot(p,[squeeze(de_h2_95)]); hold on;
% 
% plot(p,[squeeze(de_h2)]+0.0002, '--'); hold on;
% plot(p,[squeeze(de_h2)]-0.0002, '--'); hold on;
% 
% xlim([20,100]);
% 
% legend({'H$_2$, 1.00', 'H$_2$, 0.99', 'H$_2$, 0.98', 'H$_2$, 0.97', 'H$_2$, 0.96', 'H$_2$, 0.95', 'H$_2$, max', 'H$_2$, min'},'fontsize',11,'interpreter','latex');
% xlabel('Pressure [bar]','fontsize',14,'interpreter','latex');
% ylabel('Dielectric constant','fontsize',14,'interpreter','latex');
