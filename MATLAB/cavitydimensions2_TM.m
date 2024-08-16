% Cavity dimensions 2 - only TM modes

% Cavity dimentions

purity=0.95:0.01:1;
T=0:5:35;
p=[1,10:10:200];
load('/Users/annamatheaskar/Desktop/Master/Teoretiske datasett/Dielektrisk konstant/hydrogen-methane-de_p6-T8-p21.mat');

c=3*10.^8;

% verdier for p_nm for TM moder av sirkulær bølgeleder
p_TM=[2.405,5.520,8.654,11.792; 3.832,7.016,10.174,13.324; ...
    5.135,8.417,11.620,14.796;6.380,9.761,13.015,16.223]; % for 0<n<2 og 1<m<3

T_c=20; % degrees [C] at which conductivity and theoretical relative permittivity is from
p_c=1; % pressure [bar] at which conductivity and theoretical relative permittivity is from

my_r=1; % samme som vakuum (wikipedia permeability (electromagnetism))
e_0=8.85*10.^(-12); % permittivitet vakuum
e_r_v=1; % relativ permittivitet vakuum
e_r_h=de(find(purity==1),find(T==T_c),find(p==p_c)); % relativ permittivitet hydrogen ved 20C og 1atm

% radius:
a=0.01:0.0001:0.05; % m, 1:5 cm

% estimat av lengde:
h=0.05:0.0001:0.2; % m, 5:20 cm

s=2.63*10.^7; %conductivity of aluminium EN AW 6082 at 20C
my_m=1.257*10.^(-6); %permeability of pure aluminium/alloy 6082
eta=377; % intrinsic impedance til hydrogen: samme som vakuum da my_r=e_r=1

%%
for i=1:length(a)
    f_TM010(i)=(c./(2*pi*sqrt(my_r*e_r_h)))*(p_TM(1,1)./a(i));    
    f_TM110(i)=(c./(2*pi*sqrt(my_r*e_r_h)))*(p_TM(2,1)./a(i));
    
    % ANDRE MODUSER HYDROGEN
    f_TM120(i)=(c./(2*pi*sqrt(my_r*e_r_h)))*(p_TM(2,2)./a(i));
    f_TM210(i)=(c./(2*pi*sqrt(my_r*e_r_h)))*(p_TM(3,1)./a(i));
    f_TM220(i)=(c./(2*pi*sqrt(my_r*e_r_h)))*(p_TM(3,2)./a(i));
    
    for j=1:length(h)
        f_TM011(i,j)=(c./(2*pi*sqrt(my_r*e_r_h)))*sqrt((p_TM(1,1)./a(i)).^2+(1*pi./h(j)).^2);
        % ADD MORE TM01X
        f_TM012(i,j)=(c./(2*pi*sqrt(my_r*e_r_h)))*sqrt((p_TM(1,1)./a(i)).^2+(2*pi./h(j)).^2);
        f_TM013(i,j)=(c./(2*pi*sqrt(my_r*e_r_h)))*sqrt((p_TM(1,1)./a(i)).^2+(3*pi./h(j)).^2);
        f_TM014(i,j)=(c./(2*pi*sqrt(my_r*e_r_h)))*sqrt((p_TM(1,1)./a(i)).^2+(4*pi./h(j)).^2);
        f_TM015(i,j)=(c./(2*pi*sqrt(my_r*e_r_h)))*sqrt((p_TM(1,1)./a(i)).^2+(5*pi./h(j)).^2);
        f_TM016(i,j)=(c./(2*pi*sqrt(my_r*e_r_h)))*sqrt((p_TM(1,1)./a(i)).^2+(6*pi./h(j)).^2);
        f_TM017(i,j)=(c./(2*pi*sqrt(my_r*e_r_h)))*sqrt((p_TM(1,1)./a(i)).^2+(7*pi./h(j)).^2);
        
        f_TM021(i,j)=(c./(2*pi*sqrt(my_r*e_r_h)))*sqrt((p_TM(1,2)./a(i)).^2+(1*pi./h(j)).^2);
        f_TM022(i,j)=(c./(2*pi*sqrt(my_r*e_r_h)))*sqrt((p_TM(1,1)./a(i)).^2+(2*pi./h(j)).^2);
        
        f_TM111(i,j)=(c./(2*pi*sqrt(my_r*e_r_h)))*sqrt((p_TM(2,1)./a(i)).^2+(1*pi./h(j)).^2);        
        
        f_TM121(i,j)=(c./(2*pi*sqrt(my_r*e_r_h)))*sqrt((p_TM(2,2)./a(i)).^2+(1*pi./h(j)).^2);
        f_TM211(i,j)=(c./(2*pi*sqrt(my_r*e_r_h)))*sqrt((p_TM(3,1)./a(i)).^2+(1*pi./h(j)).^2);
        f_TM212(i,j)=(c./(2*pi*sqrt(my_r*e_r_h)))*sqrt((p_TM(3,1)./a(i)).^2+(2*pi./h(j)).^2);

        f_TM311(i,j)=(c./(2*pi*sqrt(my_r*e_r_h)))*sqrt((p_TM(4,1)./a(i)).^2+(1*pi./h(j)).^2);

    end
end


% HYDROGEN AT l=10CM 
figure 
plot(a*100,f_TM010./10e8); hold on;
plot(a*100,squeeze(f_TM011(:,find(h==0.1)))./10e8); hold on;
plot(a*100,squeeze(f_TM012(:,find(h==0.1)))./10e8); hold on;
plot(a*100,squeeze(f_TM013(:,find(h==0.1)))./10e8); hold on;
plot(a*100,squeeze(f_TM014(:,find(h==0.1)))./10e8); hold on;
plot(a*100,squeeze(f_TM015(:,find(h==0.1)))./10e8); hold on;
plot(a*100,squeeze(f_TM016(:,find(h==0.1)))./10e8); hold on;
plot(a*100,squeeze(f_TM017(:,find(h==0.1)))./10e8, '--'); hold on;

plot(a*100,squeeze(f_TM021(:,find(h==0.1)))./10e8, '--'); hold on;
plot(a*100,squeeze(f_TM022(:,find(h==0.1)))./10e8, '--'); hold on;

plot(a*100,f_TM110./10e8, '--'); hold on;

plot(a*100,f_TM111(:,find(h==0.1))./10e8, '--'); hold on;

plot(a*100,f_TM210./10e8, '--'); hold on;
plot(a*100,squeeze(f_TM211(:,find(h==0.1)))./10e8, '--'); hold on;
%plot(a*100,squeeze(f_TM212(:,find(h==0.1)))./10e8, '--'); hold on;

set(gca,'TickLabelInterpreter','latex')

ylim([2, 16]);

legend({'TM$_{010}$', 'TM$_{011}$', 'TM$_{012}$', 'TM$_{013}$', 'TM$_{014}$', 'TM$_{015}$', ...
    'TM$_{016}$', 'TM$_{017}$', 'TM$_{021}$', 'TM$_{022}$', 'TM$_{110}$', 'TM$_{111}$', 'TM$_{210}$', ...
    'TM$_{211}$'},'fontsize',11,'interpreter','latex');
% 'TM$_{220}$', 'TM$_{120}$', 'TM$_{121}$', 'TM$_{311}$', 'TM$_{212}$'

%legend show
xlabel('Radius [cm]','fontsize',14,'interpreter','latex');
ylabel('Resonance frequency [GHz]','fontsize',14,'interpreter','latex');
%title(sprintf('hydrogen resonance frequency at T=%d C, p=%d bar (cylinder h=10cm)', T_c, p_c));

directory = '/Users/annamatheaskar/Desktop/Master/figurer_master';
filename = fullfile(directory, 'modes_10cm.eps');
saveas(gcf, filename, 'epsc')

