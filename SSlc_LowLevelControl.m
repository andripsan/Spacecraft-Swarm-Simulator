%--------------------------AE-AE5810 Space Thesis--------------------------
%
%
% Function            : SSlc_LowLevelControl
% Programing Language : MatLab R2018a 
% Project             : MSc. Thesis
% Copyright           : Andrés Ripoll Sánchez
% Year                : 2019
%
%--------------------------------------------------------------------------
%
% Synopsis : This script comprises the process of the control and
%            propagation of the spacecraft dynamics per unit of time.
%
% Inputs  :  SSis_arAgents : 1-D object array with the agents information.
%
%--------------------------------------------------------------------------

function SSlc_LowLevelControl(SSis_arAgents)

    % Define Global Variables to be Used in this Script
    global SSis_iNumAgents SSmp_rTime SSlo_rTimeStep                    ...
        SSlo_arStateTolerance SSis_oReferenceOrbit SSlo_rControlFreq    ...
        SSmp_arResults SSlo_lLog
    
     for iLoop = 1:SSis_iNumAgents
       
        % Control the movement of the agent at the controller frequency
        if SSis_arAgents(iLoop).lActive && ( mod( SSmp_rTime,           ...
                SSlo_rControlFreq ) == 0 )
             
            if SSlo_lLog
                disp('Moving Agent ' + string(iLoop) + ' ...');
            end
            arOrbitStep = SSis_arAgents(iLoop).actuateorbit(            ...
                SSlo_arStateTolerance, SSis_oReferenceOrbit.rN,         ...
                SSlo_rTimeStep);
            
            % Correct Time Stamp
            arOrbitStep = [SSmp_rTime arOrbitStep];
            
            % Safety Check the Movement
            SSis_arAgents(iLoop).collisionavoidance(SSis_arAgents,iLoop);

        % For time steps oustide of the control frequency or for blocked
        % agents only propagate their orbit
       
        else

            if SSlo_lLog
                disp('Propagating Agent ' + string(iLoop) + ' ...');
            end 

            [arDummy,arOrbitStep] = SSis_arAgents(iLoop).propagateorbit(...
            SSlo_rTimeStep, SSlo_rTimeStep, SSis_oReferenceOrbit.rN,    ...
            [0,0,0]);

            % Update position and velocity of the agent
            SSis_arAgents(iLoop).Position = arOrbitStep(2,1:3)';
            SSis_arAgents(iLoop).Velocity = arOrbitStep(2,4:6)';
            clear arDummy

            % Take only the last step of the orbit propagation, as in this
            % case it is the one at the right frequency
             arOrbitStep = [SSmp_rTime arOrbitStep(end,:)];
             
            % Safety Check the Movement
            SSis_arAgents(iLoop).collisionavoidance(SSis_arAgents,iLoop);

        end
        
        % Save OrbitStep in the Output Structure
        % Create new row if this is the first element or the first time
        if (exist('SSmp_arResults', 'var') == 1 )  && (iLoop == 1)

            SSmp_arResults(end + 1,:,iLoop) = arOrbitStep;
            
        else
            
            SSmp_arResults(end,:,iLoop) = arOrbitStep;
            
        end

        clear arOrbitStep

     end

end