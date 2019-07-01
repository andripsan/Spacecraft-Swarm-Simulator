%--------------------------AE-AE5810 Space Thesis--------------------------
%
%
% Function            : Random Initial Positioning
% Programing Language : MatLab R2018a 
% Project             : MSc. Thesis
% Copyright           : Andrés Ripoll Sánchez
% Year                : 2019
%
%--------------------------------------------------------------------------
%
% Synopsis : This algorithm generates the initial positions
%            of the agents. To do so it randomly poses each agent around
%            one of the grid points under two assupmtions. One agent per
%            grid point and all agents connected.
%
% Inputs   SSis_arAgents: Array with all the agents of the swarm.
%
% Output
%
%--------------------------------------------------------------------------

function SSri_RandomInitialization2(SSis_arAgents)

    % Load Global Variables Used                      
    global SSis_rKnowledgeRadius SSis_rMovementRadius SSis_iNumAgents

    % Initialize Variables
    iLoop = 0;

    % Select the Number of Variables to be Created
    if all(SSis_arAgents(1).oState.csType == 'Squa' )|| ...
                   all( SSis_arAgents(1).oState.csType == 'Hexa' )
               
               iNumVar = 2;
               
    else
        
               iNumVar = 3;
               
    end
    
    % Loop over all agents
    for iLoop = 1:SSis_iNumAgents
        
        if iLoop == 1
                                    
            SSis_arAgents(iLoop).Position = [0 0 0]';
            
            SSis_arAgents(iLoop).Velocity = zeros(3,1);
                
            iCurrentInitialized = 1;
            
            continue
            
        end
        
        while 1>0
            % Select an Agent
            iAgentSelected = randi(iCurrentInitialized);

            % Evaluate State
            SSis_arAgents(iAgentSelected).oState.Create(SSis_arAgents(  ...
                1:iCurrentInitialized),iAgentSelected)
           
            % Check if the state is full
            arTotalAgents = size( SSis_arAgents(iAgentSelected).oState. ...
                arState,1) * size( SSis_arAgents(iAgentSelected).       ...
                oState.arState,2 );
            
            if sum(sum(SSis_arAgents(iAgentSelected).oState.            ...
                    arState,2), 1) < arTotalAgents
                
                break
                
            end
            
        end
               
        % Create Dummy state
        arDummyState = ones( size(SSis_arAgents(iAgentSelected).        ...
            oState.arState) );
        
        % Create State with Empty Positions
        arDummyState = arDummyState - SSis_arAgents(iAgentSelected).    ...
            oState.arState;
        
        % Randomly Pick One
        lFound = false;
        while ~lFound
            pos1 = randi(size( SSis_arAgents(iAgentSelected).oState.    ...
                arState,1));
            pos2 = randi(size( SSis_arAgents(iAgentSelected).oState.    ...
                arState,2));
                        
            if arDummyState(pos1,pos2) == 1
                lFound = true;
            end
        end
        
        % Create State with only the Possition Selected Position
        arDummyState = zeros( size(SSis_arAgents(iAgentSelected).       ...
            oState.arState) );
        arDummyState(pos1,pos2) = 1;
 
        % Set Reference Point to Grid
        arDummyPoint = SSis_arAgents(iAgentSelected).gridpoint(         ...
            SSis_arAgents(iAgentSelected).Position);
        
        % Translate to Cartesian
        SSis_arAgents(iLoop).Position = SSis_arAgents(iLoop).oState.    ...
            TranslateState(arDummyState)' + arDummyPoint;
               
        SSis_arAgents(iLoop).Velocity = zeros(3,1);
        
        iCurrentInitialized = iCurrentInitialized + 1;

    end
    
    % Add Erros
    for iLoop2 = 1:SSis_iNumAgents
        % Create an error within the interval [-SSis_rMovementRadius/4
        % SSis_rMovementRadius/4]
        arError = (rand(iNumVar,1) * (SSis_rMovementRadius) -        ...
            SSis_rMovementRadius/2)/4;
        if iNumVar == 2

            SSis_arAgents(iLoop2).Position = SSis_arAgents(iLoop2).     ...
                Position + [0 arError(1) arError(2)]';

        else

            SSis_arAgents(iLoop2).Position = SSis_arAgents(iLoop2).     ...
                Position + arError;

        end

    end

    
    
end