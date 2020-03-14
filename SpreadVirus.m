function [CellGrid,Virus]=SpreadVirus(cellGrid,virus,infectionRisk)
% arbitrarly large virus population dimension 1. 
%made for 2D cellgrids
%might solve it in a better way but i dont think så
randomVector=rand(size(virus,1),1);
k=[];
for i=1:size(virus,1)
  size(virus,1);
  if randomVector(i)<infectionRisk
    cellGrid(virus(i,1),virus(i,2))=virus(i,3);
    k=[k i];
  end
end
virus(k,:)=[]; %free floating virus infects cell and occupy the cell grid instead
CellGrid=cellGrid;
Virus=virus;
end
