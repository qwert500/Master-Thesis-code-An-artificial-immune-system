function newCoordinates=RandomCellWalk(agentCoordinates,gridSize)
% Agents are either immune cells or phatogens, NOTE only Coordinates
gridDim=size(agentCoordinates,2);

randomWalk=randi(3,size(agentCoordinates,1),gridDim)-2;
newAgentCoordinates=agentCoordinates+randomWalk;

k=find(newAgentCoordinates>gridSize);
k2=find(newAgentCoordinates<1);

%Can't go out of bounds!
newAgentCoordinates(k)=newAgentCoordinates(k)-1;
newAgentCoordinates(k2)=newAgentCoordinates(k2)+1;

newCoordinates=newAgentCoordinates;
end
  
