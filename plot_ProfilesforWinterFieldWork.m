% make winter Torrey Pines projected P sensor map
%% load and prep data for plotting
load historic_binned_profiles_for_winter19_20_runup_lines.mat
load datums


t = datetime(dnNoNourish,'ConvertFrom','datenum');
winterMonths = find(month(t)>=11 | month(t)<=3);

nlines = length(winterMonths);
cmap = cool(nlines);

%% plot transect lines
clf
for i=1:nlines
plot(crossshore,z582_NAVD88(:,winterMonths(i)),'color',cmap(i,:))
hold on
end

plot(crossshore,z582_NAVD88(:,end),'k','linewidth',2)

%% annotate
plot([-500 100], [MSL MSL],':k')
text(-400,MSL,'MSL','background','w')

plot([-500 100], [MHHW MHHW],':k')
text(-400,MHHW,'MHHW','background','w')

plot([-500 100], [MLLW MLLW],':k')
text(-400,MLLW,'MLLW','background','w')


xlabel('Cross-shore Distance (m)')
ylabel('Z NAVD88 (m)')
title('Torrey Pines: MOP 582')


%% add UTM on x-axis
ax1 = gca;
ax2 = axes('Position',ax1.Position);
ax1.Position(2) = ax1.Position(2)+0.05;
ax1.Position(4) = ax1.Position(4)-0.05;
ax2.YTick = [];
ax2.YTickLabel = [];
ax2.TickDir = 'out';
ax2.XLabel.String = 'UTM';
ax2.YColor = 'none';

ax1.XLabel.Position(2) = -9;
ax2.YLim = ax1.YLim;
ax2.Color = 'none';
ax2.Box = 'off';
% truncate x axis to 500 max offshore
offshore = find(crossshore>=-500,1);
ax2.XLim = x582_UTM([offshore end]);
ax1.XLim = crossshore([offshore end]);
%% pressure sensors
P.label = {'P1','P2','P3','P4','P5','P6','P7'};
P.x = [30 20 10 -10 -50 -100 -450];

xind = knnsearch(crossshore(:),P.x(:));
meanLine = nanmean(z582_NAVD88(:,winterMonths),2);

P.z = meanLine(xind);
P.z(4) = -0.2;
P.z(3) = 0;
P.z(2) = 0.2;
P.z(1) = MSL;

axes(ax1)
scatter(P.x,P.z,'k','filled')
text(P.x+5,P.z-0.3,P.label)



