function [] = plot_Edges(Air, CIE)
%% Quantile Boundaries Histogram
size_w = 500;
size_h = 700;
heat_size_w = 600;
heat_size_h = 500;
blue = [0, 0.4470, 0.7410];
red = [0.8500, 0.3250, 0.0980];
green = [0.4660, 0.6740, 0.1880];
purple = [0.4940, 0.1840, 0.5560];
Colors = {blue, red, green, purple};

%% Quantile Boundaries ScatterPlot
figure('Name',['Quantile Boundaries'],'NumberTitle','off','rend','painters','pos',[100 100 size_w size_h])

hold on
xline(1.6,'-',{'Criteria'}, 'LineWidth', 1);


idx = [1 2];
for i = 1:4
scatter(mean(Air(:,idx(1))), mean(Air(:,idx(2))), 400, 'k', 'o') 
idx = idx + 2;
end
    
idx = [1 2];
for i = 1:4
scatter(mean(CIE(:,idx(1))), mean(CIE(:,idx(2))), 400, 'ks','filled')
idx = idx + 2;
end

idx = [1 2];
for i = 1:4
scatter(Air(:,idx(1)), Air(:,idx(2)), 25, Colors{i}, 'o') 
idx = idx + 2;
end
idx = [1 2];
for i = 1:4
scatter(CIE(:,idx(1)), CIE(:,idx(2)), 25, Colors{i}, 's','filled') 
idx = idx + 2;
end

    %errorbar(mean_All,1:8,err_All,'horizontal','-r','LineWidth', 5)

        set(gca,'FontSize',10)
    set(gca, 'FontName', 'Arial')
    xlabel('Start Edge (s)')
    ylabel('End Edge (s)')
    d = zeros(8, 1);
d(1) = plot(NaN,NaN,'o', 'Color', blue);
d(2) = plot(NaN,NaN,'o', 'Color', red);
d(3) = plot(NaN,NaN,'o', 'Color', green);
d(4) = plot(NaN,NaN,'o', 'Color', purple);
d(5) = plot(NaN,NaN,'s', 'Color', blue);
d(6) = plot(NaN,NaN,'s', 'Color', red);
d(7) = plot(NaN,NaN,'s', 'Color', green);
d(8) = plot(NaN,NaN,'s', 'Color', purple);
legend(d,{'Air-1', 'Air-2', 'Air-3', 'Air-4', 'CIE-1', 'CIE-2', 'CIE-3', 'CIE-4'})
legend('Location','northwest')
legend boxoff
set(d,'LineWidth',3)


%% Means Quantile Boundaries ScatterPlot
figure('Name',['Mean Quantile Boundaries'],'NumberTitle','off','rend','painters','pos',[100 100 size_w size_h])

hold on
xline(1.6,'-',{'Criteria'}, 'LineWidth', 1);

idx = [1 2];
for i = 1:4
xneg = std(Air(:,idx(1))) / sqrt(length(Air(:,idx(1))));
xpos = std(Air(:,idx(1))) / sqrt(length(Air(:,idx(1))));
yneg = std(Air(:,idx(2))) / sqrt(length(Air(:,idx(2))));
ypos = std(Air(:,idx(2))) / sqrt(length(Air(:,idx(2))));
e = errorbar(mean(Air(:,idx(1))),mean(Air(:,idx(2))),yneg,ypos,xneg,xpos,'o','MarkerSize',10,...
    'MarkerEdgeColor','k');
e.Color = Colors{i};
e.CapSize = 2;
e.LineWidth = 2;
idx = idx + 2;
end
    
idx = [1 2];
for i = 1:4
xneg = std(CIE(:,idx(1))) / sqrt(length(CIE(:,idx(1))));
xpos = std(CIE(:,idx(1))) / sqrt(length(CIE(:,idx(1))));
yneg = std(CIE(:,idx(2))) / sqrt(length(CIE(:,idx(2))));
ypos = std(CIE(:,idx(2))) / sqrt(length(CIE(:,idx(2))));
e = errorbar(mean(CIE(:,idx(1))),mean(CIE(:,idx(2))),yneg,ypos,xneg,xpos,'s','MarkerSize',10,...
    'MarkerEdgeColor','k');
e.Color = Colors{i};
e.CapSize = 2;
e.LineWidth = 2;
idx = idx + 2;
end


idx = [1 2];
for i = 1:4
scatter(mean(Air(:,idx(1))), mean(Air(:,idx(2))), 50, Colors{i}, 'o','filled') 
idx = idx + 2;
end
    
idx = [1 2];
for i = 1:4
scatter(mean(CIE(:,idx(1))), mean(CIE(:,idx(2))), 50, Colors{i}, 's','filled')
idx = idx + 2;
end

idx = [1 2];
for i = 1:4
scatter(Air(:,idx(1)), Air(:,idx(2)), 50, Colors{i}, 'o') 
idx = idx + 2;
end
idx = [1 2];
for i = 1:4
scatter(CIE(:,idx(1)), CIE(:,idx(2)), 50, Colors{i}, 's') 
idx = idx + 2;
end


    %errorbar(mean_All,1:8,err_All,'horizontal','-r','LineWidth', 5)

        set(gca,'FontSize',10)
    set(gca, 'FontName', 'Arial')
    xlabel('Start Edge (s)')
    ylabel('End Edge (s)')
    d = zeros(8, 1);
d(1) = plot(NaN,NaN,'o', 'Color', blue);
d(2) = plot(NaN,NaN,'o', 'Color', red);
d(3) = plot(NaN,NaN,'o', 'Color', green);
d(4) = plot(NaN,NaN,'o', 'Color', purple);
d(5) = plot(NaN,NaN,'s', 'Color', blue);
d(6) = plot(NaN,NaN,'s', 'Color', red);
d(7) = plot(NaN,NaN,'s', 'Color', green);
d(8) = plot(NaN,NaN,'s', 'Color', purple);
legend(d,{'Air-1', 'Air-2', 'Air-3', 'Air-4', 'CIE-1', 'CIE-2', 'CIE-3', 'CIE-4'})
legend('Location','northwest')
legend boxoff
set(d,'LineWidth',1)
end
