function [ExtraTCell,ExtraThCell,ExtraBCell]=...
  BCellActivation(B, extraTCell, extraThCell, extraBCell, virus, gridSize,timeStep,...
  maxNumberOfExtraBCells,maxNumberOfExtraTCells,maxNumberOfExtraThCells,probBCellActivation)
% when TB cells are activated more B cells with maching antigen receptor
% is produced, as well as corresponing T-cells and Th-cells
% Does not kill any infected cells, i.e. helper cells;)
numberOfNewTCells=1;
numberOfNewThCells=1;
numberOfNewBCells=2;
antigen=virus(1,3); % All phagocytes have the same antigen!

if isempty(extraBCell)==0
  [~,~, iExtraBCell] = intersect(virus,extraBCell(:,1:3),'rows'); % matching rows
  for i=1:size(iExtraBCell,1) % For the extra B cells that are essential
    if extraBCell(iExtraBCell(i),3)==virus(1,3)
      if rand(1,1)<probBCellActivation
        
        for j=1:numberOfNewThCells
          extraThCell=[extraThCell; randi(gridSize,1,1) randi(gridSize,1,1) antigen timeStep];
        end
        
        for j=1:numberOfNewTCells
          extraTCell=[extraTCell; randi(gridSize,1,1) randi(gridSize,1,1) antigen timeStep];
        end
        
        for j=1:numberOfNewBCells
          extraBCell=[extraBCell; randi(gridSize,1,1) randi(gridSize,1,1) antigen timeStep];
        end
        
      end
      %Does not attack the grid
    end
  end
end
[~,~, iB] = intersect(virus,B,'rows'); % matching rows, check antigen at the same time!

if isempty(iB)==0
  for i=1:size(iB,1) % For the standard B cells
    if rand(1,1)<probBCellActivation
      for j=1:numberOfNewTCells
        extraTCell=[extraTCell;randi(gridSize,1,1) randi(gridSize,1,1) antigen timeStep];
      end
      
      for j=1:numberOfNewThCells
        extraThCell=[extraThCell;randi(gridSize,1,1) randi(gridSize,1,1) antigen timeStep];
      end
      
      for j=1:numberOfNewBCells
        extraBCell=[extraBCell; randi(gridSize,1,1) randi(gridSize,1,1) antigen timeStep];
      end
    end
    % Does not attack the grid
  end
end

%Limit the number Of Extra Immune Cells (Energy maximum)
if size(extraTCell,1)>maxNumberOfExtraTCells
  extraTCell(maxNumberOfExtraTCells:end,:)=[];
end

if size(extraThCell,1)>maxNumberOfExtraThCells
  extraThCell(maxNumberOfExtraThCells:end,:)=[];
end

if size(extraBCell,1)>maxNumberOfExtraBCells
  extraBCell(maxNumberOfExtraBCells:end,:)=[];
end

ExtraTCell=extraTCell;
ExtraThCell=extraThCell;
ExtraBCell=extraBCell;
end
