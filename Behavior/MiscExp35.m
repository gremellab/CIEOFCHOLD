grouped = [];
for mouse = 1:size(Air.Day(9).Mouse,2)
    data = Air.Day(9).Mouse(mouse).Lever_Press_Length_After_Success_Change ./ 1000;
    mean_N = mean(data);
    N = size(data,1);
    SEM = std(data)/sqrt(length(data));
    grouped = [grouped; mean_N SEM N];
end


grouped = [];
for mouse = 1:size(Eth.Day(9).Mouse,2)
    data = Eth.Day(9).Mouse(mouse).Lever_Press_Length_After_Success_Change ./ 1000;
    mean_N = mean(data);
    N = size(data,1);
    SEM = std(data)/sqrt(length(data));
    grouped = [grouped; mean_N SEM N];
end


grouped = [];
for mouse = 1:size(Air.Day(10).Mouse,2)
    data = Air.Day(10).Mouse(mouse).Lever_Press_Length_After_Success_Change ./ 1000;
    mean_N = mean(data);
    N = size(data,1);
    SEM = std(data)/sqrt(length(data));
    grouped = [grouped; mean_N SEM N];
end


grouped = [];
for mouse = 1:size(Eth.Day(10).Mouse,2)
    data = Eth.Day(10).Mouse(mouse).Lever_Press_Length_After_Success_Change ./ 1000;
    mean_N = mean(data);
    N = size(data,1);
    SEM = std(data)/sqrt(length(data));
    grouped = [grouped; mean_N SEM N];
end


grouped = [];
day = 10;
for mouse = 1:size(Air.Day(day).Mouse,2)
    data = Air_Grouped.Day(day).Duration_Distribution{mouse}';
    grouped = [grouped data];
end


grouped = [];
day = 10;
for mouse = 1:size(Eth.Day(day).Mouse,2)
    data = Eth_Grouped.Day(day).Duration_Distribution{mouse}';
    grouped = [grouped data];
end



grouped = [];
for day = 6:10
    data = [Air_Grouped.Day(day).Median_Duration{:}] ./ 1000;
    grouped = [grouped; data];
end


grouped = [];
for day = 6:10
    data = [Eth_Grouped.Day(day).Median_Duration{:}] ./ 1000;
    grouped = [grouped; data];
end



