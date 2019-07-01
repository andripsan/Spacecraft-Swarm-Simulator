%--------------------------AE-AE5810 Space Thesis--------------------------
%
%
% Function            : PFSM
% Programing Language : MatLab R2018a 
% Project             : MSc. Thesis
% Copyright           : Andrés Ripoll Sánchez
% Year                : 2019
%
%--------------------------------------------------------------------------
%
% Synopsis : This script generates a FSM with the possible moves of the
%            spacecraft and uses a random number to choose an action to 
%            perform.
%
% Inputs  :   oAgent        :  agent object whose state is to be modified.
%
% Outputs :   DSsa_arAction : 2-D array with the action to take
%
%--------------------------------------------------------------------------

function DSpf_arAction = PFSM(oAgent)
    
    % Create a local copy of the Movement Matrix of the Agent
    arMoveMat = oAgent.oState.arMoveMat;
           
    % Initialzie Aproval Flag
    lMovementApproved = false;
    
    % Randomly Select one Movement and Ensure its Viability
    while lMovementApproved~=true
        
        % Initialize Variables for this Iteration
        DSpf_arAction = zeros(size(oAgent.oState.arState));

        % Select one of the possible movements
        iElemSel = randperm(size(arMoveMat,1),1);

        % Load Movement
        if all(oAgent.oState.csType == 'Cube')
            DSpf_arAction( arMoveMat(iElemSel,1), arMoveMat(iElemSel,2))...
                = 1;
        elseif all(oAgent.oState.csType == 'Squa') || all(oAgent.       ...
                oState.csType == 'Hexa')
            DSpf_arAction( arMoveMat(iElemSel) ) = 1;
        end
            
        %Check that the movement generates a connected ouput
        %lMovementApproved = CheckConnectivity(oAgent,DSpf_arAction);
        lMovementApproved = oAgent.oState.CheckConnectivity(DSpf_arAction);

        % If the movement has not been approved, erase the indexes from the
        % possible movements for next iteration
        if ~lMovementApproved
        
            arMoveMat(iElemSel,:) = [];                        

       end


        % If all maneuvers break the connectivity of the swarm, set the
        % agent as blocked and generate a null output maneuver
        if isempty(arMoveMat)
            
            oAgent.lActive = false;
            
            % Does not matter to define the maneuver, as it will be
            % discarted by the low level controller since this agent is not
            % moving
            DSpf_arAction = zeros(size(oAgent.oState.arState));

            return
            
        end
       
    end
    
end
