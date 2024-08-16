% di_const

cd('/Users/annamatheaskar/Desktop/Master/teoretiske datasett/Dielektrisk konstant/');

hyd_methane_mix=importdata('hydrogen-methane-de_p6-T8-p21.mat');

% purity:
pur = 0.95:0.01:1.00; % [molfraksjon]
% 
% temperature:
T = 0:5:35; % [grader celcius]
% 
% pressure:
p = [1,10:10:200]; % [bar]

figure

for i=1:length(pur)
    plot(p(1:11), squeeze(hyd_methane_mix(i, find(T==20), 1:11)));
    hold on;
end

%xline(50);
%yline(1.01329)

set(gca,'fontsize',19, 'TickLabelInterpreter','latex')

legend({'$x_h=0.95$', '$x_h=0.96$', '$x_h=0.97$', '$x_h=0.98$', '$x_h=0.99$', '$x_h=1.00$'}, 'location', 'southeast','fontsize',19,'interpreter','latex');
%title('Pressure effect on gas permittivity at room temperature (20$^{\circ}$C)','fontsize',14,'interpreter','latex');
xlabel('Pressure [bar]','fontsize',22,'interpreter','latex');
ylabel('Dielectric constant','fontsize',22,'interpreter','latex');

directory = '/Users/annamatheaskar/Desktop/Master/figurer_master';
filename = fullfile(directory, 'pressure_impact_e.eps');
saveas(gcf, filename, 'epsc')


figure

for i=1:length(pur)
    plot(T, squeeze(hyd_methane_mix(i, :, find(p==50))));
    hold on;
end

xlim([0,35]);
set(gca, 'fontsize',19,'TickLabelInterpreter','latex')

legend({'$x_h=0.95$', '$x_h=0.96$', '$x_h=0.97$', '$x_h=0.98$', '$x_h=0.99$', '$x_h=1.00$'},'fontsize',19,'interpreter','latex');
%title('Pressure effect on gas permittivity at room temperature (20$^\circ$C)','fontsize',14,'interpreter','latex');
xlabel('Temperature [$^{\circ}$C]','fontsize',22,'interpreter','latex');
ylabel('Dielectric constant','fontsize',22,'interpreter','latex');

directory = '/Users/annamatheaskar/Desktop/Master/figurer_master';
filename = fullfile(directory, 'temperature_impact_e.eps');
saveas(gcf, filename, 'epsc')


