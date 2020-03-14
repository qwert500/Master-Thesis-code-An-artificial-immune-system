function [ExtraTCell,ExtraThCell,ExtraBCell,Phagocyte]=...
  ThCellActivation2(phagocyte, Th, extraTCell, extraThCell, extraBCell,gridSize,timeStep...
  ,maxNumberOfExtraBCells,maxNumberOfExtraTCells,maxNumberOfExtraThCells)
% when Th cells are activated more Th cells with maching antigen receptor
% is produced, as well ass corresponing T-cells and B cells
% Does not kill any infected cells, i.e. helper cells;)
numberOfNewTCells=4;
numberOfNewThCells=8;
numberOfNewBCells=4;

if isempty(phagocyte)==0
  antigen=phagocyte(1,3); % all phagocytes have the same antigen!
  
  if isempty(extraThCell)==0
    [~,iPhagocyte, iExtraThCell] = intersect(phagocyte,extraThCell(:,1:3),'rows'); % matching rows
    
    for i=1:size(iExtraThCell,1) % For the extra T cells
      if extraThCell(iExtraThCell(i),3) == antigen
        
        for j=1:numberOfNewThCells
          extraThCell=[extraThCell;randi(gridSize,1,1) randi(gridSize,1,1) antigen timeStep];
        end
        
        for j=1:numberOfNewTCells
          extraTCell=[extraTCell;randi(gridSize,1,1) randi(gridSize,1,1) antigen timeStep];
        end
        
        for j=1:numberOfNewBCells
          extraBCell=[extraBCell; randi(gridSize,1,1) randi(gridSize,1,1) antigen timeStep];
        end
        %Does not attack the grid
      end
      phagocyte(iPhagocyte,:)=[];
      break
    end
    
  end
  
  if isempty(phagocyte)==0
    [~,iPhagocyte,iThCell] = intersect(phagocyte,Th,'rows'); % Finding matching elements
    for i=1:size(iThCell,1) % For the standard T cells
      
      if Th(iThCell(i),3)==antigen
        
        for j=1:numberOfNewTCells
          extraTCell=[extraTCell;randi(gridSize,1,1) randi(gridSize,1,1) antigen timeStep];
        end
        
        for j=1:numberOfNewThCells
          extraThCell=[extraThCell;randi(gridSize,1,1) randi(gridSize,1,1) antigen timeStep];
        end
        
        for j=1:numberOfNewBCells
          extraBCell=[extraBCell; randi(gridSize,1,1) randi(gridSize,1,1) antigen timeStep];
        end
        % Does not attack the grid
        phagocyte(iPhagocyte,:)=[];
        break
      end
    end
  end
  
  
  if size(extraTCell,1)>maxNumberOfExtraTCells
    extraTCell(maxNumberOfExtraTCells:end,:)=[];
  end
  
  if size(extraThCell,1)>maxNumberOfExtraThCells
    extraThCell(maxNumberOfExtraThCells:end,:)=[];
  end
  
  if size(extraBCell,1)>maxNumberOfExtraBCells
    extraBCell(maxNumberOfExtraBCells:end,:)=[];
  end
  
end
ExtraTCell=extraTCell;
ExtraThCell=extraThCell;
ExtraBCell=extraBCell;
Phagocyte=phagocyte;
end


