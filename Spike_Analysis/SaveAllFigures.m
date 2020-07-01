function SaveAllFigures(Folder, EPS_Directory)
%Folder = fullfile('I:\Christian\Code_Exp35_CIE_Hold_Eth\Code\Paper Code\Plots');

AllFigH = allchild(groot);
for iFig = 1:numel(AllFigH)
  fig = AllFigH(iFig);
  ax  = fig.CurrentAxes;
  ax.FontName = 'Arial';
  ax.FontSize = 8;
  ax.TickDir = 'out';
  ax.Box = 'off';
  fig.PaperUnits = 'centimeter';
  %fig.PaperSize = [4 2];
  %fig.PaperPosition = [0 0 10 6];
  FigName = fig.Name;
  FigName = strrep(FigName, ' ', '_');
  FigName = erase(FigName,":");
  cd(EPS_Directory)
  %print(FigName, '-depsc');

  saveas(fig, FigName, 'epsc');
  % try .pdf
   %export_fig(filename)
  cd(Folder)
  %print(FigName, '-djpeg');
  saveas(fig, FigName, 'png');
  
end
end
