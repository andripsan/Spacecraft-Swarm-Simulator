%--------------------------AE-AE5810 Space Thesis--------------------------
%
%
% Function            : Select Who Moves
% Programing Language : MatLab R2018a 
% Project             : MSc. Thesis
% Copyright           : Andrés Ripoll Sánchez
% Year                : 2019
%
%--------------------------------------------------------------------------
%
% Synopsis : This script avoids that two agents in the same neighbourhood
%            move at the same time to avoid collisions. To do so it
%            transforms all but one of the conflicting agents in blocked.
%            Unless priority is given to only one agent, the choice of who 
%            moves will be random.
%
% Inputs   : SSis_arAgents : 1-D object array with the information of the
%                            agents.
%
%            iAgID         : integer indicating the agent ID.
%
% Outputs :   
%
%--------------------------------------------------------------------------

function WhoMoves(SSis_arAgents, iAgID)

    global SSis_iNumAgents SSis_rKnowledgeRadius

    % Ensure that the agent is active
    if SSis_arAgents(iAgID).lActive

        % Find all agents next to this one
        for iLoop = 1:SSis_iNumAgents

            % Skip the agent itself
            if iLoop == iAgID
                continue
            end


            if ( norm( SSis_arAgents(iAgID).Position -                  ...
                SSis_arAgents(iLoop).Position ) ) <= SSis_rKnowledgeRadius


                % If another agent of the neighbourhood is moving a
                % confilct is detected. The one with the smallest ID
                % prevails unless one of them has the priority flag
                if SSis_arAgents(iLoop).lActive

                    if (SSis_arAgents(iLoop).lPriority) &&              ...
                            (~SSis_arAgents(iAgID).lPriority)

                        SSis_arAgents(iAgID).lActive = false;

                    elseif (SSis_arAgents(iAgID).lPriority) &&          ...
                            (~SSis_arAgents(iLoop).lPriority)

                        SSis_arAgents(iLoop).lActive = false;

                    else

                        % Choose randomly (uniform distribution)
                        aiIndex = [iAgID iLoop];
                        SSis_arAgents(aiIndex( randi(2) )).lActive = false;

                    end

                end

            end

        end
    end  


end