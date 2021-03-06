function UpdateCellScape(cellGrid,T,Th,B,extraTCell,extraThCell,extraBCell,virus,phagocyte)
    [xCell,yCell]=ind2sub(size(cellGrid),find(cellGrid>0));
    clf;
    sz=30; %Size of immune cells 
    
    
    hold on;
    axis([1 size(cellGrid,1) 1 size(cellGrid,2)])
    scatter(xCell,yCell,'r','filled');
    set(gca,'color',[1 1 0.6])
    scatter(phagocyte(:,1),phagocyte(:,2),4,...
                         'MarkerEdgeColor',[0 0 0],...
                         'MarkerFaceColor',[1 1 0]);
    scatter(T(:,1),T(:,2),sz,...
                        'MarkerEdgeColor',[0 0 0],...
                        'MarkerFaceColor',[1, 0.0784, 0.5765]);
    scatter(Th(:,1),Th(:,2),sz,...
                        'MarkerEdgeColor',[0 0 0],...
                        'MarkerFaceColor',[1, 0.4118, 0.7059]);
    scatter(B(:,1),B(:,2),sz,...
                        'MarkerEdgeColor',[0 0 0],...
                        'MarkerFaceColor',[0.5940, 0.2840, 0.6560]);
    
    scatter(virus(:,1),virus(:,2),sz,...
                        'MarkerEdgeColor',[0 0 0],...
                        'MarkerFaceColor',[0 1 0]);
                      
    if isempty(extraTCell)==0
    scatter(extraTCell(:,1),extraTCell(:,2),sz,...
                        'MarkerEdgeColor',[0 0 1],...
                        'MarkerFaceColor',[1, 0.0784, 0.5765]);
    end
    if isempty(extraThCell)==0
    scatter(extraThCell(:,1),extraThCell(:,2),sz,...
                        'MarkerEdgeColor',[0 0 1],...
                        'MarkerFaceColor',[1, 0.4118, 0.7059]);
    end
    if isempty(extraBCell)==0
    scatter(extraBCell(:,1),extraBCell(:,2),sz,...
                        'MarkerEdgeColor',[0 0 1],...
                        'MarkerFaceColor',[0.5940, 0.2840, 0.6560]);
    end
    hold off;
end
