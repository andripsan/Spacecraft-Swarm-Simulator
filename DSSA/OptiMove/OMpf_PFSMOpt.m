%--------------------------AE-AE5810 Space Thesis--------------------------
%
%
% Function            : PFSMOptimized
% Programing Language : MatLab R2018a 
% Project             : MSc. Thesis
% Copyright           : Andrés Ripoll Sánchez
% Year                : 2019
%
%--------------------------------------------------------------------------
%
% Synopsis : This script generates a FSM with the possible moves of the
%            spacecraft and uses a random number to choose an action to 
%            perform. This script uses an optimized method. A pre-optimized
%            PFSM is loaded with the probability of the action taken with
%            respect to the current state.
%
% Inputs  :   oAgent        :  agent object whose state is to be modified.
%
% Outputs :   DSpf_arAction : 2-D array with the action to take
%
%--------------------------------------------------------------------------



function DSpf_arAction = OMpf_PFSMOpt(oAgent)

    % Classify the Current State
    iStateID = OMcs_ClassifyState(oAgent.oState.arState);
    
    % Generate Movement
    DSpf_arAction = OMgm_GenerateMovement(iStateID,oAgent);
                
end
