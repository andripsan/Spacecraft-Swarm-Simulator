%--------------------------AE-AE5810 Space Thesis--------------------------
%
%
% Function            : SSsk_StationKeeping
% Programing Language : MatLab R2018a 
% Project             : MSc. Thesis
% Copyright           : Andrés Ripoll Sánchez
% Year                : 2019
%
%--------------------------------------------------------------------------
%
% Synopsis : This script ensures that the agents of the swarm do not
%            diverge by activating the low level control on them if needed
%            setting their current relative position as target.
%
% Inputs  :  SSis_arAgents : 1-D object array with the agents information.
%
%--------------------------------------------------------------------------

function SSsk_StationKeeping(SSis_arAgents)

    %Load Global Variables
    global SSis_iNumAgents SSlo_arStationTolerance SSlo_lLog
    
    % Loop over all agents
    for iLoop = 1:SSis_iNumAgents
        
        %Skip already active agents
        if SSis_arAgents(iLoop).lActive
            continue
        end
        
        %Evaluate if the possition of this agent has diverged from the last
        %target more than the tolerance allows
        if any( abs( SSis_arAgents(iLoop).Position' -                   ...
                 SSis_arAgents(iLoop).arTarget(1:3) ) >                 ...
                 SSlo_arStationTolerance)
            
             if SSlo_lLog
                 disp('         Station Keeping for Agent ' +           ...
                     string(iLoop));
             end
             
             SSis_arAgents(iLoop).lActive = true;
            
        end
        
    end
    
end