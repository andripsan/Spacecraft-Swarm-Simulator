%--------------------------AE-AE5810 Space Thesis--------------------------
%
%
% Function            : Main Program
% Programing Language : MatLab R2018a 
% Project             : MSc. Thesis
% Copyright           : Andrés Ripoll Sánchez
% Year                : 2019
%
%--------------------------------------------------------------------------
%
% Synopsis : This is the main module that guides the simulation of the
% swarm. First it initializes the swarm in a random position. Then the
% control loop starts. The current measured status is compared to the 
% desired status, a control action is taken and the dynamics of the 
% swarm is propagated forward. The loop is repeated until reaching the 
% desired status.
%
%--------------------------------------------------------------------------

% Define Global Variables Used in this Script
global SSmp_rTime SSlo_rTimeStep SSlo_lDebug SSlo_rMaxTime              ...
    SSlo_lRealTime SSlo_lRealTimeLocal SSis_iNumAgents SSmp_lEnd        ...
    SSmp_arError SSmp_arErrorVel SSmp_iIterationNumber                  ...
    SSlo_arStateTolerance SSlo_arStationTolerance SSlo_rDSSAFrequency

% Initialize Needed Variables
SSmp_rTime = 0;
SSmp_lEnd  = 0;
SSmp_arResults = zeros(1,7,SSis_iNumAgents);
lConverged = false;
SSmp_iIterationNumber = 0;

%----Simulation Loop----%

% Gridding Loop
    % Send the Agents to Points of the Grid
    % Generate Initial Targets in Grid Points
    for iLoop = 1:SSis_iNumAgents
        
        SSis_arAgents(iLoop).arTarget = SSis_arAgents(iLoop).           ...
            gridpoint([SSis_arAgents(iLoop).Position' 0 0 0]);

    end
    
    % Initialize Gridding
    mp_lGridding = true;
    
    % Control the Agents until all of them are Gridded
    while( mp_lGridding )
        
        if ~SSlo_lDebug
            clc
        elseif SSlo_lRealTime || SSlo_lRealTimeLocal
            cla
        end
    
        disp('Time : ' + string(SSmp_rTime) );
        
        % Advance Time Step
        SSmp_rTime = SSmp_rTime + SSlo_rTimeStep;
        
        % Create the States
        for iLoop = 1:SSis_iNumAgents
            SSis_arAgents(iLoop).oState.Create(SSis_arAgents,iLoop);
        end
        
        % Station Keeping Maneuver Generation
        SSsk_StationKeeping(SSis_arAgents)
        
        % Control to send the Agents to the Grid Points
        SSlc_LowLevelControl(SSis_arAgents)    
     
        % Stop the Loop if all Agents are set in Grid Points
        for iLoop = 1:SSis_iNumAgents
           
            if SSis_arAgents(iLoop).lActive
                break
            end
            
            mp_lGridding = false;
            
        end
        
        % Plot Data Acordingly
        SSpt_Plotting
        
        pause(0.001)
        
    end

%Reset iLoop Variable    
iLoop = 0;
rTimer = 1;
% Actuation Loop
    for SSmp_rTime = SSmp_rTime:SSlo_rTimeStep:SSlo_rMaxTime

        if ~SSlo_lDebug
            clc
        end

        disp('Time : ' + string(SSmp_rTime) );
        disp('Num Actions: ' + string(SSmp_iIterationNumber));

        % Advance the Orbit Iterator
        iLoop = iLoop + 1;

        % Clean the Axis from Previous Iterations
        if SSlo_lRealTime || SSlo_lRealTimeLocal
            cla
        end

        % Create States for this Iteration
        for i=1:SSis_iNumAgents
            SSis_arAgents(i).oState.Create(SSis_arAgents,i);
        end
        
        % Launch DSSA to Obtain Targets
        if mod( SSmp_rTime, SSlo_rDSSAFrequency) == 0
            DSSA_Main(SSis_arAgents);
        end
        
        % Lauch Station Keeping Maneuver Generation
        SSsk_StationKeeping(SSis_arAgents)

        % Launch the Low Level Controller to Move the agents to the Targets
        SSlc_LowLevelControl(SSis_arAgents)
        
        % Calculate the Error
        for iLoop2 = 1:SSis_iNumAgents
           
            SSmp_arError(iLoop,:,iLoop2) = SSis_arAgents(iLoop2).       ...
                Position' - SSis_arAgents(iLoop2).arTarget(1:3);
        
            SSmp_arErrorVel(iLoop,:,iLoop2) = SSis_arAgents(iLoop2).    ...
                Velocity' - SSis_arAgents(iLoop2).arTarget(4:6);
             
        end
        
        for iLoop2 = 1:SSis_iNumAgents
        
            SSmp_SwarmStatus(iLoop2) = SSis_arAgents(iLoop2).           ...
                CheckLocalState(SSlo_csPattern);
        
        end
    
        if all(SSmp_SwarmStatus) && ~lConverged

            disp('Convergence Achieved in ' +                           ...
                string(SSmp_iIterationNumber) );
% ARIS -b            
%               SSlo_arStationTolerance =  SSlo_arStateTolerance;
% ARIS -e

            
            for iLoop1 = 1:SSis_iNumAgents

                disp('Fuel Remaining for Agent ' + string(iLoop1) + ' :'...
                     + string(SSis_arAgents(iLoop1).Thruster.rPropMass) );

            end
            
            beep
            lConverged = true;
            
        end
        
        % Propagate for 20 more seconds and stop the simulation after conv.
        if lConverged
            
            rTimer = rTimer - 1;
            if rTimer == 0
                
                disp('Convergence Achieved in ' +                       ...
                    string(SSmp_iIterationNumber) );
                break
                
            end
            
        end
        
        % Plot Data Acordingly
        SSpt_Plotting
                
    end
    
% Set the End flag to true
SSmp_lEnd = true;