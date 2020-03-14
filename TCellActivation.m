function [CellGrid,ExtraTCell,ExtraThCell,MemoryTCell]=...
  TCellActivation(cellGrid, T, extraTCell, extraThCell, memoryTCell,...
  timeStep,maxNumberOfExtraTCells,maxNumberOfExtraThCells,...
  maxNumberOfMemoryTCells, probTCellActivation)
%=============================
%  T-cell activation Set-up
%=============================
numberOfNewTCells=2;
numberOfNewThCells=1;
numberOfNewMemoryTCells=1;
% Letting them spawn randomly
% Both extra and standard T-cells may get activated!

gridSize=size(cellGrid,1);

if isempty(extraTCell)==0
  
  numberOfExtraTCells=size(extraTCell,1); % That is to do something this turn
  for i=1:numberOfExtraTCells % For the extra T cells
    if cellGrid(extraTCell(i,1),extraTCell(i,2))==extraTCell(i,3)
      if rand(1,1)<probTCellActivation
        for j=1:numberOfNewTCells
          extraTCell=[extraTCell;randi(gridSize,1,1)...
            randi(gridSize,1,1)...
            extraTCell(i,3)...
            timeStep];
        end
        
        for j=1:numberOfNewThCells
          extraThCell=[extraThCell;randi(gridSize,1,1)...
            randi(gridSize,1,1)...
            extraTCell(i,3)...
            timeStep];
        end
        
        for j=1:numberOfNewMemoryTCells
          memoryTCell=[memoryTCell; randi(gridSize,1,1)...
            randi(gridSize,1,1)...
            extraTCell(i,3)...
            timeStep];
        end
        cellGrid(extraTCell(i,1),extraTCell(i,2))=0; %Heal/kill cell
      end
    end
  end
end

if isempty(memoryTCell)==0 
  numberOfMemoryTCells=size(memoryTCell,1); % That is to do something 
  for i=1:numberOfMemoryTCells % For the extra T cells
    if cellGrid(memoryTCell(i,1),memoryTCell(i,2))==memoryTCell(i,3)
      if rand(1,1)<probTCellActivation
        for j=1:numberOfNewTCells
          extraTCell=[extraTCell;randi(gridSize,1,1)...
            randi(gridSize,1,1)...
            memoryTCell(i,3)...
            timeStep];
        end
        
        for j=1:numberOfNewThCells
          extraThCell=[extraThCell;randi(gridSize,1,1)...
            randi(gridSize,1,1)...
            memoryTCell(i,3)...
            timeStep];
        end
        
        for j=1:numberOfNewMemoryTCells
          memoryTCell=[memoryTCell; randi(gridSize,1,1)...
            randi(gridSize,1,1)...
            memoryTCell(i,3)...
            timeStep];
        end
        cellGrid(memoryTCell(i,1), memoryTCell(i,2)) = 0; %Heal/kill cell
      end
    end
  end
  
end

for i=1:size(T,1) % For the standard T cells
  
  if cellGrid(T(i,1),T(i,2))==T(i,3)
    if rand(1,1)<probTCellActivation
      for j=1:numberOfNewTCells
        extraTCell=[extraTCell;randi(gridSize,1,1)...
          randi(gridSize,1,1)...
          T(i,3)...
          timeStep];
      end
      
      for j=1:numberOfNewThCells
        extraThCell=[extraThCell;randi(gridSize,1,1)...
          randi(gridSize,1,1)...
          T(i,3)...
          timeStep];
      end
      
      for j=1:numberOfNewMemoryTCells
        memoryTCell=[memoryTCell; randi(gridSize,1,1)...
          randi(gridSize,1,1)...
          T(i,3)...
          timeStep];
      end
      cellGrid(T(i,1),T(i,2))=0; %Heal/kill cell
    end
  end
end

%Limit the number Of Extra Immune Cells (Energy maximum)
if size(extraTCell,1)>maxNumberOfExtraTCells
  extraTCell(maxNumberOfExtraTCells:end,:)=[];
end

if size(extraThCell,1)>maxNumberOfExtraThCells
  extraThCell(maxNumberOfExtraThCells:end,:)=[];
end


if size(memoryTCell,1)>maxNumberOfMemoryTCells
  memoryTCell(maxNumberOfMemoryTCells:end,:)=[];
end

CellGrid=cellGrid;
ExtraTCell=extraTCell;
ExtraThCell=extraThCell;
MemoryTCell=memoryTCell;

end