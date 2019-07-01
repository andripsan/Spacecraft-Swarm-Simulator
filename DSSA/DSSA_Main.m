%--------------------------AE-AE5810 Space Thesis--------------------------
%
%
% Function            : DSSA_Main
% Programing Language : MatLab R2018a 
% Project             : MSc. Thesis
% Copyright           : Andrés Ripoll Sánchez
% Year                : 2019
%
%--------------------------------------------------------------------------
%
% Synopsis : This script comprisses all DSSA process. The function
%            generates and stores in the input object structure the
%            target locations of the agents in the next iteration. 
%
% Inputs  :  SSis_arAgents : 1-D object array with the agents information.
%
% Outputs :
%
%--------------------------------------------------------------------------

function DSSA_Main(SSis_arAgents)

    % Initialize Global Variables to be Used
    global SSis_iNumAgents SSmp_iIterationNumber SSlo_lLog              ...
        SSlo_lUseOptimziedPFSM arHistory
    
    % ARIS -b
    %   Ideally all the main process of the simulator shall loop over the 
    %   agents only once in SSmp_MainProgram. Nevertheless, since it is
    %   necessary to have all the information up to WhoMoves to proceed
    %   with the definition of the maneuvers, it has been decided to
    %   include the loops inside the DSSA_Main and the
    %   SSlc_LowLevelControl. Future solutons might include the usage of
    %   vectorizaiton or similar strategies to reduce the runtime of the
    %   code.
    % ARIS -e
    
    % Find which agents require a run of DSSA
    arRequestDSSA = WhatIsMyEnvironment(SSis_arAgents);
    
    % Deactivate the safety mode of the agents in safety mode to run DSSA
    % on them.

    % Loop over all Agents
    for iLoop = 1:SSis_iNumAgents
        
        % Create Local States of this Iteration
        SSis_arAgents(iLoop).oState.Create(SSis_arAgents,iLoop)
        
        %If an agent requrested DSSA run it
        if arRequestDSSA(iLoop)
             
            if SSlo_lLog
                disp('Generating Commands with DSSA for agent ' +       ...
                    string(iLoop) + ' ...');
            end

            % Categorize agents between active and blocked
            Categorize( SSis_arAgents(iLoop) );
            
            % Avoid that two agents in the same neighbourhood move by
            % switching off the active flag of all but one of them.
            WhoMoves(SSis_arAgents,iLoop);
                     
        end
    end
    
    % Generate Maneuvers for each one of the Active Agents
    for iLoop2  = 1:SSis_iNumAgents
       
        if arRequestDSSA(iLoop2) && SSis_arAgents(iLoop2).lActive
            
            if SSlo_lLog
                
                disp('       Generating Movement for Agent ' +          ...
                    string(iLoop2) + ' ... ');
            end
        
            % The target position is saved as the ouput of the PFSM 
            % translated to cartesian coordinates.
            if SSlo_lUseOptimziedPFSM
                arManeuver = OMpf_PFSMOpt( SSis_arAgents(iLoop2) );
            else
                arManeuver = PFSM( SSis_arAgents(iLoop2) );
            end
   
            % If a movement is created, add one to the iterator number
            if any(any(arManeuver))

                SSmp_iIterationNumber = SSmp_iIterationNumber + 1;
   
            end
            
            % Save previous target as safety target
            SSis_arAgents(iLoop2).arSafetyTarget =                      ...
                SSis_arAgents(iLoop2).arTarget;
            
            % Save the new position in the target variable. The velocity
            % will be for now defined as equal to the circular orbit. The
            % previous target is used as it is a fixed and predictable
            % point in the local space (oposite to the error prone current
            % position)
            SSis_arAgents(iLoop2).arTarget = SSis_arAgents(iLoop2).     ...
                gridpoint( SSis_arAgents(iLoop2).arTarget );

            
            SSis_arAgents(iLoop2).arTarget = SSis_arAgents(iLoop2).     ...
                arTarget + [ SSis_arAgents(iLoop2).oState.              ...
                TranslateState( arManeuver) zeros(1,3) ];
                                   
        end  

    end
    
end