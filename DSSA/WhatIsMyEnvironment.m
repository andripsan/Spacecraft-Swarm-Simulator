%--------------------------AE-AE5810 Space Thesis--------------------------
%
%
% Function            : WhatIsMyEnvironment
% Programing Language : MatLab R2018a 
% Project             : MSc. Thesis
% Copyright           : Andrés Ripoll Sánchez
% Year                : 2019
%
%--------------------------------------------------------------------------
%
% Synopsis : This script analyzes if the environment around each agent is
%            calmed or if any agent was active on the last iteration of the
%            software. If noone is active, a flag is set to true in the
%            agent so DSSA is launched for it.
%
% Inputs  : SSis_arAgents : 1-D object array with the information of the
%                           agents.
%
% Outputs : arRequestDSSA : 1-D logical array with true in the
%                           corresponding IDs of the agents requesting a 
%                           DSSA for this iteration of time.
%
%--------------------------------------------------------------------------

function arRequestDSSA = WhatIsMyEnvironment(SSis_arAgents)

    %Load global variables to be used in this funciton
    global SSis_iNumAgents
    
    % Initialize Output
    arRequestDSSA(1:SSis_iNumAgents) = false;
    
    %Loop over all agents
    for iLoop = 1:SSis_iNumAgents
             
        % If the agent is active there is no need for DSSA for this agent.
        if SSis_arAgents(iLoop).lActive
           
            continue
            
        % If the agent is in safety mode deactivate it and request DSSA for
        % it.
        elseif  SSis_arAgents(iLoop).lPriority
            
            %SSis_arAgents(iLoop).arTarget = SSis_arAgents(iLoop).       ...
            %    arSafetyTarget;
           % SSis_arAgents(iLoop).arSafetyTarget = [];
            %SSis_arAgents(iLoop).lPriority = false;
            arRequestDSSA(iLoop) = true;            

        end
        
        %Loop over all the agents
        for iLoop2 = 1:SSis_iNumAgents
            
            % Skip the agent itself
            if iLoop == iLoop2
                
                continue
                
            end

            %  Activate agents in a quiet neighbourhood (agents with
            %  lSafety have priority)
            if SSis_arAgents(iLoop2).lPriority
                
                arRequestDSSA(iLoop) = false;
                break
                
            elseif ( abs( norm( SSis_arAgents(iLoop).Position -         ...
                    SSis_arAgents(iLoop2).Position) )  <=               ...
                    SSis_arAgents(iLoop).rKnowledgeRadius ) && (        ...
                    ~SSis_arAgents(iLoop2).lActive ) &&                 ...
                    ~SSis_arAgents(iLoop).lPriority
                
                arRequestDSSA(iLoop) = true;
                
            % To ensure that the whole neighbourhood is steady, if at any 
            %point an active agent is detected turn back to false the
            %output and cycle the iLoop2 loop
            elseif ( abs( norm( SSis_arAgents(iLoop).Position -         ...
                    SSis_arAgents(iLoop2).Position) )  <=               ...
                    SSis_arAgents(iLoop).rKnowledgeRadius ) && (        ...
                    SSis_arAgents(iLoop2).lActive ) &&                  ...
                    ~SSis_arAgents(iLoop).lPriority
                
                 arRequestDSSA(iLoop) = false;
                 break
                
            end
            
        end
        
    end


end