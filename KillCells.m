function Cells =KillCells(cells,ageOfImmuneCells,timeStep)
% kill all selected cells 
% Selected cells are 
k=find((cells(:,4)-(timeStep-ageOfImmuneCells))<0);
cells(k,:)=[];

Cells=cells;
end