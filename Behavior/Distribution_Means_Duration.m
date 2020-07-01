

% 800 distribution
% Air
Day = Air_Grouped.Day;
mean_distribution = [];
for day = [1 2 3 4 5]
    distribution = [];
    for mouse = 1:size(Day(day).Name,2)
        if day == 4 && mouse == 6
            distribution = [distribution];
        else
            distribution = [distribution; Day(day).Duration_Distribution{mouse}];
        end
    end
    mean_distribution = [mean_distribution; mean(distribution)];
end
% 1600 distribution
% Air
Day = Air_Grouped.Day;
mean_distribution = [];
for day = [6 7 8 9 10]
    distribution = [];
    for mouse = 1:size(Day(day).Name,2)
        distribution = [distribution; Day(day).Duration_Distribution{mouse}];
    end
    mean_distribution = [mean_distribution; mean(distribution)];
end







% 800 distribution
% CIE
Day = Eth_Grouped.Day;
mean_distribution = [];
for day = [1 2 3 4 5]
    distribution = [];
    for mouse = 1:size(Day(day).Name,2)
        if day == 1 && mouse == 5
            distribution = [distribution];
        else
            distribution = [distribution; Day(day).Duration_Distribution{mouse}];
        end

    end
    mean_distribution = [mean_distribution; mean(distribution)];
end
% 1600 distribution
% CIE
Day = Eth_Grouped.Day;
mean_distribution = [];
for day = [6 7 8 9 10]
    distribution = [];
    for mouse = 1:size(Day(day).Name,2)
        distribution = [distribution; Day(day).Duration_Distribution{mouse}];
    end
    mean_distribution = [mean_distribution; mean(distribution)];
end