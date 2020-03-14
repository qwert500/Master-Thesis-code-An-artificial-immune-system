clc, clear all
%======================================
%          INPUT PARAMETERS
%======================================

%Grid set-up
gridSize = 300; % Parameterm Squared cell scape
numberOfMaxTimeSteps = 20000; % The time the simulation runs
gridDim = 2; % 2D

% Immune Cell set-up, maximum number of new immune cells.
maxNumberOfExtraBCells = gridSize*gridSize; %Parameter (energy limit)
maxNumberOfExtraTCells = gridSize*gridSize; %Parameter (energy limit)
maxNumberOfExtraThCells = gridSize*gridSize; %Parameter (energy limit)

%Various constants
totalNumberOfLymphocytesInBody = 2*10^(12); %constant
totalNumberOfOtherPhagocytes = round((2*10^(12)/0.25-2*10^(12))); % constant
proportionOfThCells = 0.46; % constant
proportionOfTCells = 0.19; % constant
proportionOfBCells = 0.23; % constant
numberOfCombinations = 10^(5); % constant, number of different receptors and antigens
totalCellsInBody = 3*10^(13); % constant

%Pathogen setup
virusPopulationSize = 3000; % constant

%Rate in which dicease spreads cell to cell
diffusionRate = 0.001; % Constant, spread from cell to cell
infectionRisk = 0.001; % Constant, virus infects cell

%New immune cell set-up
updateInterval = 10; % Time steps between creation of new antigen receptors
updateFraction = 0.50; % Percent that get a new antigen receptor
maxNumberOfMemoryTCells = gridSize*gridSize/10; % Constant

%Cell death set-up
ageOfImmuneCells = 800; %Constant, age of the extra immune cells

%Chance for immune cell activation
probTCellActivation=0.005; % Constant
probBCellActivation=0.005; % Constant
probThCellActivation=0.005; % Constat

%======================================
%            INITIALIZATION
%======================================
hh = 0; % dummy variable.

%For the plots
numberOfExtraTCellsPlot = zeros(numberOfMaxTimeSteps,1);
numberOfExtraBCellsPlot = zeros(numberOfMaxTimeSteps,1);
numberOfExtraThCellsPlot = zeros(numberOfMaxTimeSteps,1);
numberOfInfectedCellsPlot = zeros(numberOfMaxTimeSteps,1);
numberOfPhagocytesPlot = zeros(numberOfMaxTimeSteps,1);
numberOfTMemoryCellsPlot = zeros(numberOfMaxTimeSteps,1);

% Initialize immune cells
gridFraction = gridSize^2/totalCellsInBody;

numberOfThCells = ...
  round(totalNumberOfLymphocytesInBody*proportionOfThCells*gridFraction);
numberOfTCells = ...
  round(totalNumberOfLymphocytesInBody*proportionOfTCells*gridFraction);
numberOfBCells = ...
  round(totalNumberOfLymphocytesInBody*proportionOfBCells*gridFraction);
numberOfPhagocytes = ...
  round(totalNumberOfOtherPhagocytes*gridFraction);

% Coordinates + antigen combination on last column
Th = zeros(numberOfThCells, gridDim+1);
T = zeros(numberOfTCells, gridDim+1);
B = zeros(numberOfBCells, gridDim+1);
phagocyte = zeros(numberOfPhagocytes, gridDim);

extraTCell = [];
extraThCell = [];
memoryTCell = [];
extraBCell = [];

% Initial immune cells
Th(:, 1:gridDim)=randi(gridSize, numberOfThCells, gridDim);
Th(:, gridDim+1)=randi(numberOfCombinations, numberOfThCells, 1);
T(:, 1:gridDim)=randi(gridSize, numberOfTCells, gridDim);
T(:, gridDim+1)=randi(numberOfCombinations, numberOfTCells,1);
B(:, 1:gridDim)=randi(gridSize, numberOfBCells, gridDim);
B(:, gridDim+1) = randi(numberOfCombinations, numberOfBCells, 1);

% Spawn virus
virus = zeros(virusPopulationSize, gridDim+1);
virus(:, 1:gridDim) = randi(gridSize, virusPopulationSize, gridDim);
virus(:, gridDim+1) = randi(numberOfCombinations);

%Spawn phagocytes
phagocyte(:,1:gridDim) = randi(gridSize, numberOfPhagocytes, gridDim);
phagocyte(:,3) = virus(1, 3); % all viruses have the same antigen

%MAKE GRID
%An element on the grid equal to zero means healthy cell, then if infected
%by virus the element of the corresponing antigen will be assinged to that
%element, ie [0 0 0;0 0 10^10; 0 0 0], enables T-cells to cause apoptosis
cellGrid = zeros(gridSize,gridSize);

antigen = virus(1,3); % same antigen for all viruses!

time = 1:numberOfMaxTimeSteps; % for plot
%======================================
%        FOR LOOP OVER ALL EVENTS
%======================================
for timeStep = 1:numberOfMaxTimeSteps
  if isempty(virus) == 1 ...
      && isempty(find(cellGrid>0)) == 1 ...
      && isempty(extraTCell) == 1 ...
      && isempty(extraBCell) ...
      && isempty(extraThCell) == 1
    
    break
    
  end
  %======================================
  %             RANDOM WALK
  %======================================
  
  Th(:, 1:gridDim)=randomCellWalk(Th(:, 1:gridDim), gridSize);
  B(:, 1:gridDim)=randomCellWalk(B(:, 1:gridDim), gridSize);
  T(:, 1:gridDim)=randomCellWalk(T(:, 1:gridDim), gridSize);
  
  if isempty(extraThCell) == 0
    extraThCell(:,1:gridDim) = ...
      randomCellWalk(extraThCell(:, 1:gridDim), gridSize);
  end
  
  if isempty(extraBCell) == 0
    extraBCell(:,1:gridDim)= ...
      randomCellWalk(extraBCell(:, 1:gridDim), gridSize);
  end
  
  if isempty(extraTCell) == 0
    extraTCell(:,1:gridDim) =...
      randomCellWalk(extraTCell(:,1:gridDim),gridSize);
  end
  
  if isempty(virus)==0
    virus(:, 1:gridDim) = randomCellWalk(virus(:, 1:gridDim), gridSize);
  end
  
  if isempty(phagocyte) == 0
    phagocyte(:, 1:gridDim) = ...
      randomCellWalk(phagocyte(:,1:gridDim), gridSize);
  end
  
  
  %======================================
  %  Kill immune cells that are too old
  %           Spread dicease
  %       Immune cell activation
  %======================================
  if isempty(extraTCell) == 0
    extraTCell = KillCells(extraTCell,ageOfImmuneCells,timeStep);
  end
  
  if isempty(extraThCell) == 0
    extraThCell = KillCells(extraThCell,ageOfImmuneCells,timeStep);
  end
  
  if isempty(extraBCell) == 0
    extraBCell = KillCells(extraBCell,ageOfImmuneCells,timeStep);
  end
  
  cellGrid = VirusDiffusion(cellGrid, diffusionRate, antigen);
  
  if isempty(virus) == 0
    [cellGrid,virus] = SpreadVirus(cellGrid, virus, infectionRisk);
  end
  
  [cellGrid, extraTCell, extraThCell, memoryTCell]=...
    TCellActivation(cellGrid, T, extraTCell, extraThCell, memoryTCell,...
    timeStep, maxNumberOfExtraTCells, maxNumberOfExtraThCells, ...
    maxNumberOfMemoryTCells,  probTCellActivation);
  
  if isempty(phagocyte) == 0
    [extraTCell, extraThCell, extraBCell, phagocyte]=...
      ThCellActivation(phagocyte, Th, extraTCell, extraThCell,...
      extraBCell, gridSize, timeStep, maxNumberOfExtraBCells, ...
      maxNumberOfExtraTCells, maxNumberOfExtraThCells, ...
      probThCellActivation);
  end
  
  if isempty(virus) == 0
    [extraTCell, extraThCell, extraBCell]=...
      BCellActivation(B, extraTCell, extraThCell, extraBCell,...
      virus,gridSize,timeStep, maxNumberOfExtraBCells, ...
      maxNumberOfExtraTCells, maxNumberOfExtraThCells,...
      probBCellActivation);
  end
  
  
  %======================================
  %        PICK IMPORTANT NUMBERS
  %======================================
  if (isempty(extraBCell) == 0 || isempty(extraTCell) == 0 ||...
      isempty(extraThCell) == 0) && hh == 0
    %Sound of a gong gong when receptor connects to antigen the first time
    S(1) = load('gong');
    sound(S(1).y,S(1).Fs)
    hh = 1;
    
  end
  
  numberOfExtraTCellsPlot(timeStep) = size(extraTCell,1);
  numberOfExtraBCellsPlot(timeStep) = size(extraBCell,1);
  numberOfExtraThCellsPlot(timeStep) = size(extraThCell,1);
  numberOfTMemoryCellsPlot(timeStep) = size(memoryTCell,1);
  
  numberOfPhagocytesPlot(timeStep) = size(phagocyte,1);
  numberOfInfectedCellsPlot(timeStep) = nnz(cellGrid);
  
  %======================================
  %           UPDATE CELL GRID
  %======================================
  %if mod(timeStep,updateInterval)==0
  %updateCellScape(cellGrid,T,Th,B,extraTCell,extraThCell,extraBCell,virus, phagocyte)
  %pause(0.0001)
  %end
  %======================================
  %          NEW RECEPTORS FOR
  %            IMMUNE CELLS
  %======================================
  % Have decided that it is only necessary to generate new antigenreceptors
  % , to keep the coordinates of the antibodies, it shouldn't make any big
  % difference.
  
  if mod(timeStep,updateInterval)==0
    
    numberOfNewTCells = round(numberOfTCells*updateFraction);
    numberOfNewThCells = round(numberOfThCells*updateFraction);
    numberOfNewBCells = round(numberOfBCells*updateFraction);
    
    T(randi(numberOfTCells, numberOfNewTCells, 1), 3) = ...
      randi(numberOfCombinations, numberOfNewTCells, 1);
    Th(randi(numberOfThCells, numberOfNewThCells, 1), 3) = ...
      randi(numberOfCombinations, numberOfNewThCells, 1);
    B(randi(numberOfBCells,numberOfNewBCells, 1), 3) = ...
      randi(numberOfCombinations,numberOfNewBCells, 1);
    
  end
end
S(1) = load('train');
sound(S(1).y,S(1).Fs)
%% PLOTTING
figure(2)
nCells=gridSize*gridSize;
[~,peak]=max(numberOfInfectedCellsPlot);
time=1:numberOfMaxTimeSteps;
%peak=1;
hold on
grid on
plot(time./peak, numberOfExtraTCellsPlot./nCells, 'g');
plot(time./peak, numberOfExtraBCellsPlot./nCells, 'b');
plot(time./peak, numberOfExtraThCellsPlot./nCells, 'c');
plot(time./peak, numberOfInfectedCellsPlot./nCells, 'r');
plot(time./peak, numberOfTMemoryCellsPlot./nCells, 'm');
plot(time./peak, numberOfPhagocytesPlot./nCells, 'k');

legend('T-cells', 'B-cells', 'Th-cells',...
  'Infected cells', 'Memory T Cells', 'Phagocytes',...
  'Location','northeast','NumColumns',2)
xlabel('Time')
ylabel('Fraction of total cells on grid')
title('Number of immune cells and infected cells')
hold off





