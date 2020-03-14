function CellGrid=...
  InfectGridAndUpdateVeto(cellGrid, InfectedCell,antigen)

% FUNCTION FOR VIRUS DIFFUSION FUNCTION.
% THIS FUNCTION SPREAD THE DICEASE AND UPDATE THE diffusionVetoList

% InfectedCells are in vector form from the function find in the cellGrid
% 3rd element in virus is the antigen combination which is spreading
gridSize=size(cellGrid,1);
position=zeros(4,1);
I=[];
position(1)=InfectedCell-1;
position(2)=InfectedCell+1;
position(3)=InfectedCell-gridSize;
position(4)=InfectedCell+gridSize;

for i=1:size(position,1) %Boundary conditions
  if position(i)<1
    I=[I i];
  end
  
  if position(i)>gridSize*gridSize
    I=[I i];
  end
  
  if mod(InfectedCell,gridSize)==0 % These two must be here!
    I=[I 2];
  end
  
  if mod(InfectedCell,gridSize+1)==0
    I=[I 1];
  end
  
end
position(I)=[];
II=[];

for i=1:size(position,1) % Finding already infected cells
  if cellGrid(position(i))>0
    II=[II i];
  end
end
position(II)=[];

if isempty(position)==0
  r=randi(size(position,1)); % randomize the valid positions thats left 
  cellGrid(position(r))=antigen;
end
CellGrid=cellGrid;
end

    
    
    



  
  