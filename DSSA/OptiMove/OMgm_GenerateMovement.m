%--------------------------AE-AE5810 Space Thesis--------------------------
%
%
% Function            : Classify State
% Programing Language : MatLab R2018a 
% Project             : MSc. Thesis
% Copyright           : Andrés Ripoll Sánchez
% Year                : 2019
%
%--------------------------------------------------------------------------
%
% Synopsis : 
%
% Inputs  :   iStateID   : State ID (corresponding colum in PFSM)
%             oAgent     :  agent object whose state is to be modified.
%
% Outputs :   arMovement : Movement expressed as a state 
%
%--------------------------------------------------------------------------

function arMovement = OMgm_GenerateMovement(iStateID, oAgent)

    % Load the copy of the PFSM in this script
    global SSis_arLoadedPFSM SSlo_lUsePreLoadedPFSM SSlo_lUseOptimziedPFSM
    
    % Initialize Output
    arMovement = zeros( size(oAgent.oState.arState) );
    
    % Choose, according to the distribution of probability, a movement
    % Select wich translation to use according to the type of PFSM
    if SSlo_lUseOptimziedPFSM && all(oAgent.oState.csType == 'Cube')
        arTranslationSwarmulatorSS = [ 5 4 3 2 1 6 7 8 0];
    elseif SSlo_lUsePreLoadedPFSM && all(oAgent.oState.csType == 'Cube')
        arTranslationSwarmulatorSS = [ 5 4 3 2 1 6 7 8];
    elseif SSlo_lUseOptimziedPFSM && all(oAgent.oState.csType == 'Squa')
        arTranslationSwarmulatorSS = [ 3 2 1 8 7 6 5 4 0];
    elseif SSlo_lUsePreLoadedPFSM && all(oAgent.oState.csType == 'Squa')
        arTranslationSwarmulatorSS = [ 3 2 1 8 7 6 5 4];
    end
    iActionChosen = randsample( arTranslationSwarmulatorSS, 1, true,    ...
        SSis_arLoadedPFSM(iStateID,:) );
    
    % Transform into output
    if iActionChosen == 0
        
        return
        
    % Cube States in 2-D    
    elseif iActionChosen < 6 && size(oAgent.oState.arState,1) ~= 1
        
        iRow = 1;
        iCol = iActionChosen;
        
    elseif iActionChosen > 5 && size(oAgent.oState.arState,1) ~= 1
        
        iRow = 5;
        iCol = iActionChosen - 4;
     
    % Square State    
    else

        iRow = 1;
        iCol = iActionChosen;
        
    end

    arMovement(iRow,iCol) = 1;
         
end