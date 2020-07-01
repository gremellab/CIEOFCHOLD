function [All_edges, All_Lengths] = Edges(Day)
%% Quantile Boundaries Histogram
size_w = 100;
size_h = 135;
heat_size_w = 600;
heat_size_h = 500;
blue = [0, 0.4470, 0.7410];
red = [0.8500, 0.3250, 0.0980];
green = [0.4660, 0.6740, 0.1880];
purple = [0.4940, 0.1840, 0.5560];
Colors = {blue, red, green, purple};
%figure('Name',['Lever Press Durations Example'],'NumberTitle','off','rend','painters','pos',[100 100 size_w size_h])
All_edges = [];
All_Lengths = [];
for mouse = 1:length(Day.Mouse)
    %subplot(3,6,mouse)
    Lengths = Day.Mouse(mouse).Session.LP_Length;
    %TF = isoutlier(Lengths,'quartiles');
    %Lengths(TF) = [];
    edge_start = [0 0.25 0.50 0.75];
    edge_end = [0.25 0.50 0.75 1];
    Counts = [];
    True_edges = [];
    for quart = 1:4
        edges = quantile(Lengths,[edge_start(quart) edge_end(quart)]);
        if quart == 1
            quart_lenghts = Lengths(Lengths >= edges(1) & Lengths <= edges(2));
        else
            quart_lenghts = Lengths(Lengths > edges(1) & Lengths <= edges(2));
        end
        True_edges = [True_edges edges];
        hold on
%         [N,~,bin]= histcounts(quart_lenghts, edges);
%         Counts = [Counts N];
%         histogram(quart_lenghts, 5, 'FaceColor', Colors{quart});
%         axis tight
%         xlabel('Duration (s)')
%         ylabel({'Count'})
    end
    All_edges = [All_edges; True_edges];
    All_Lengths = [All_Lengths; Lengths];
%     set(gca,'FontSize',12)
%     set(gca, 'FontName', 'Arial')
%     h = zeros(2, 1);
%     h(1) = plot(NaN,NaN,'-', 'Color', blue);
%     h(2) = plot(NaN,NaN,'-', 'Color', red);
%     h(3) = plot(NaN,NaN,'-', 'Color', green);
%     h(4) = plot(NaN,NaN,'-', 'Color', purple);
%     legend(h,{num2str(Counts(1)),num2str(Counts(2)), num2str(Counts(3)),num2str(Counts(4))})
%     set(h,'LineWidth',2);
%     legend boxoff
%     title([Day.Mouse(mouse).Session.Name])
end
%% Quantile Boundaries Error Bars

% figure('Name',['Quantile Boundaries'],'NumberTitle','off','rend','painters','pos',[100 100 size_w size_h])
% mean_All = mean(All_edges,1);
% err_All = std(All_edges,1) ./ sqrt(size(All_edges,1));
% for i = 1:length(mean_All)
% hold on
% xline(1.6,'-',{'Criteria'}, 'LineWidth', 5);
%     errorbar(mean_All,1:8,err_All,'horizontal','o','LineWidth', 5)
%     errorbar(mean_All,1:8,err_All,'horizontal','-r','LineWidth', 5)
%     ylim([0 10])
%     xlim([0 8])
%         set(gca,'FontSize',20)
%     set(gca, 'FontName', 'Arial')
%     xlabel('Time (s)')
%     ylabel('Edge')
% end
% % 

%% Quantile Boundaries ScatterPlot
figure('Name',['Quantile Boundaries: CIE'],'NumberTitle','off','rend','painters','pos',[100 100 size_w size_h])

hold on
xline(1.6,'-',{'Criteria'}, 'LineWidth', 1);
idx = [1 2];
for i = 1:4
scatter(All_edges(:,idx(1)), All_edges(:,idx(2)), 10, Colors{i}, 'filled') 
idx = idx + 2;
end
    %errorbar(mean_All,1:8,err_All,'horizontal','-r','LineWidth', 5)

        set(gca,'FontSize',8)
    set(gca, 'FontName', 'Arial')
    xlabel('Start Edge (s)')
    ylabel('End Edge (s)')
    d = zeros(2, 1);
d(1) = plot(NaN,NaN,'-', 'Color', blue);
d(2) = plot(NaN,NaN,'-', 'Color', red);
d(3) = plot(NaN,NaN,'-', 'Color', green);
d(4) = plot(NaN,NaN,'-', 'Color', purple);
%legend(d,{'0 - .25', '.25 - .50', '.50 - .75', '.75 - 1.0'})
%legend('Location','northeast')
%set(d,'LineWidth',5)
end
