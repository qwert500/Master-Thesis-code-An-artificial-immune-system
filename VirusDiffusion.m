function CellGrid= VirusDiffusion(cellGrid,diffusionRate,antigen)

k=find(cellGrid>0);
random=rand(size(k,1),1);
I=[];

for i=1:size(k,1)
  if rand(1,1)<diffusionRate
    cellGrid=InfectGrid(cellGrid, k(i),antigen);
  end
end

CellGrid=cellGrid;
end

