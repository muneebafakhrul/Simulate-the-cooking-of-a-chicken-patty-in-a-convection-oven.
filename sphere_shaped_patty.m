close all;
clear all;
clc;

thermalModelT = createpde('thermal','transient');

% h = 0.01905; %height in meters
% h_half = h/2;
D = 0.23552; %diameter in meters
r = D/2;
% g = decsg([3 4 0 0 r r -h_half h_half h_half -h_half]');
g = load('Circle.mat');
geometryFromEdges(thermalModelT,g.d2);
figure(1)
pdegplot(thermalModelT,'EdgeLabels','on')
axis equal

msh = generateMesh(thermalModelT);
figure(2)
pdeplot(thermalModelT)
axis equal
thermalModelT.Mesh = msh;

%Define thermal material properties.
Cp = 3462.35; %specific heat [J/kg/K]
rho = 1109.95; %density [kg/m^3]
k = 0.494335; %thermal conductivity [W/m/K]
thermalProperties(thermalModelT,'ThermalConductivity',k,'SpecificHeat',Cp,'MassDensity',rho);

%Define boundary conditions
thermalBC(thermalModelT,'Edge',1,'Temperature',177);
thermalBC(thermalModelT,'Edge',2,'Temperature',177);
thermalBC(thermalModelT,'Edge',3,'Temperature',177);
thermalBC(thermalModelT,'Edge',4,'Temperature',177);

% Set IC as 20 degrees Celsius (293.15K) and solve for from 0 to 5000 time units.
thermalIC(thermalModelT,20);
tfinal = 10000;
tlist = 0:10:tfinal;
result = solve(thermalModelT,tlist);

T = result.Temperature;

figure(3) 
pdeplot(thermalModelT,'XYData',T(:,end),'Contour','on')
axis equal
title(sprintf('Transient Temperature at Final Time (%g seconds)',tfinal))

Tcenter = interpolateTemperature(result,[0.0;0.0],1:numel(tlist));

figure(4)
plot(tlist,Tcenter)
title 'Temperature at Center Point as a Function of Time'
xlabel 'Time, s'
ylabel 'Temperature, C'
grid on
legend('Center Point of Sphere','Location','SouthEast')
Tcenter1=transpose(Tcenter);
tlist1=transpose(tlist);