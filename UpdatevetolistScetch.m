function vetoList=UpdatevetolistScetch(vetolist)

%       %========================
%       % UPDATING VETO LIST
%       %========================
%       k1=[];k2=[];k3=[];k4=[];
%       if extraTCell(i,2)~=1
%         k1=extraTCell(i,1)+(extraTCell(i,2)-1)*gridSize-gridSize;
%       end
%       
%       if extraTCell(i,1)~=1
%         k2=extraTCell(i,1)+(extraTCell(i,2)-1)*gridSize-1;
%       end
%       
%       if extraTCell(i,1)~=gridSize
%         k3=extraTCell(i,1)+(extraTCell(i,2)-1)*gridSize+1;
%       end
%       
%       if extraTCell(i,2)~=gridSize
%         k4=extraTCell(i,1)+(extraTCell(i,2)-1)*gridSize+gridSize;
%       end
%       
%       kk=[k1 k2 k3 k4];
%       
%       for j=1:size(kk,1)
%         if isempty(find(diffusionVetoList==kk(j)))==0
%           matching=find(diffusionVetoList==kk(j));
%           diffusionVetoList(matching)=[];
%         end
%       end
%       %=============================
%       %END OF UPDATING VETO LIST
%       %=============================