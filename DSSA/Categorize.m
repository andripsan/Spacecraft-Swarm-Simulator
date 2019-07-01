%--------------------------AE-AE5810 Space Thesis--------------------------
%
%
% Function            : Categorize 
% Programing Language : MatLab R2018a 
% Project             : MSc. Thesis
% Copyright           : Andrés Ripoll Sánchez
% Year                : 2019
%
%--------------------------------------------------------------------------
%
% Synopsis : This function catagorizes the agent between blocked and
%            active.
%
% Inputs  :   iAgID : Identifier of the current agent.
%
%             oAgent : object with the agent information.
%
%--------------------------------------------------------------------------

function Categorize(oAgent)

    % Describe global variables used in this function
    global SSlo_csPattern  

        % Check if the Agent has one or more states free
        if sum( oAgent.oState.arState ) == size( oAgent.oState.arState, ...
                1 ) .* size( oAgent.oState.arState,2 )
            
            oAgent.lActive = false;
            
        % Check if the Agent is in a desired state
        elseif oAgent.CheckLocalState(SSlo_csPattern)
           
            oAgent.lActive = false;
                        
        % If the agent is free to move and is not in a desired state, save
        % it as active.
        else
            
            oAgent.lActive = true;

        end

end

