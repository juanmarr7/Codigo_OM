% Fit Activation Map with 3rd-order Polynomial
% croppedAmap = Tactmap
% meshgrid(rect) --> adjust for Tact size
TactMap = medfilt2(TactMap, [3,3]);
    TactMap = (TactMap - min(min(TactMap)));
cind = isfinite(TactMap);
[x y]= meshgrid(1:128,1:128);
x = reshape(x,[],1);
y = reshape(y,[],1);
z = reshape(TactMap,[],1);
a = [x.^3 y.^3 x.*y.^2 y.*x.^2 x.^2 y.^2 x.*y x y ones(size(x,1),1)]; % for the whole rectangle
X = x(cind);
Y = y(cind);
Z = z(cind);
A = [X.^3 Y.^3 X.*Y.^2 Y.*X.^2 X.^2 Y.^2 X.*Y X Y ones(size(X,1),1)]; % for the active front
solution = A\Z; % solution is the set of coefficients
Z_fit = a*solution; % Z_fit is a polynome surface on the whole rectangle
Z_fit = reshape(Z_fit,size(cind)); % reshape Z_fit to be rectangle shaped

% Find Gradient of Polynomial Surface
[Tx Ty] = gradient(Z_fit);
Tx=Tx/.05%0.05 default VENT;.08; % handles.activeCamData.xres;  % Important to define this value somehow
Ty=Ty/.05;%0.05 default VENT; % handles.activeCamData.yres;  % Idem
%Atria 0.3-0.6

Vx = Tx./(Tx.^2+Ty.^2);
Vy = -Ty./(Tx.^2+Ty.^2);
V = sqrt(Vx.^2 + Vy.^2);

%%%  %%%   %%%
% Display the regional statistics
disp('Regional conduction velocity statistics:')
meanV=nanmean(V(isfinite(V)));
disp(['The mean value is ' num2str(meanV) ' m/s.'])
medV = median(V(isfinite(V)));
disp(['The median value is ' num2str(medV) ' m/s.'])
stdV = std2(V(isfinite(V)));
disp(['The standard deviation is ' num2str(stdV) '.'])
meanAng = mean(atan2(Vy(isfinite(Vy)),Vx(isfinite(Vy))).*180/pi);
disp(['The mean angle is ' num2str(meanAng) ' degrees.'])
medAng = median(atan2(Vy(isfinite(Vy)),Vx(isfinite(Vy))).*180/pi);
disp(['The median angle is ' num2str(medAng) ' degrees.'])
stdAng = std2(atan2(Vy(isfinite(Vy)),Vx(isfinite(Vy))).*180/pi);
disp(['The standard deviation of the angle is ' num2str(stdAng) '.'])
num_vectors = numel(V(isfinite(V)));
disp(['The number of vectors is ' num2str(num_vectors) '.'])


%%%  %%% %%%
% Displaying the CVmap
fig = figure;
xx = 1:size(TactMap,1); 
yy = size(TactMap,2):-1:1;
[~,h] = contourf(xx,xx,TactMap,100); set(h,'edgecolor','none'); axis off;
b = colorbar;
hold on;
    [~,c] = contour(xx,xx,TactMap,'w');
    c.LineWidth = 1.2;
    c.LevelStep =2; %10
colormap('JET'); caxis([ 0 40]); %% caxis([0 40]) for LQT slow activation
hold on

Y_plot = y(isfinite(Z_fit));
X_plot = x(isfinite(Z_fit));

Vx_plot = Vx(isfinite(Z_fit));
Vx_plot(abs(Vx_plot) > 5) = 5.*sign(Vx_plot(abs(Vx_plot) > 5));

Vy_plot = Vy(isfinite(Z_fit));
Vy_plot(abs(Vy_plot) > 5) = 5.*sign(Vy_plot(abs(Vy_plot) > 5));

V = sqrt(Vx_plot.^2 + Vy_plot.^2);

%Create Vector Array to pass to following functions
VecArray = [X_plot Y_plot Vx_plot Vy_plot V];

% plot vector field
% h = quiver(x{1},x{2},FX*10000,FY*10000,8,'K'); grid off; axis off
quiver_step = 2;
q = quiver(X_plot(1:quiver_step:end),...
           Y_plot(1:quiver_step:end),Vx_plot(1:quiver_step:end),...
           -1.0 * Vy_plot(1:quiver_step:end),'k');
q.LineWidth = 1;
q.AutoScaleFactor = 1;%4;


