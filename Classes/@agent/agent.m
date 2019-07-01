%--------------------------AE-AE5810 Space Thesis--------------------------
%
%
% Function            : Agent Class Definition
% Programing Language : MatLab R2018a 
% Project             : MSc. Thesis
% Copyright           : Andrés Ripoll Sánchez
% Year                : 2019
%
%--------------------------------------------------------------------------
%
% Synopsis : This script defines the properties and functions associated
% with each agent of the swarm
%
%--------------------------------------------------------------------------

classdef agent < handle & matlab.mixin.SetGet
   % Design
   properties
       % Number of thrusters
       %NumThrust
       % Axis actuated by the thruster in Body Ref Frame (array Nx3)(x,y,z)
       %ThrusterAxis
       % Array containing all the thruster objects
       Thruster
       % Number of reaction wheels
       %NumReacWheel
       % Axis actuated by the wheel in Body Ref Frame (array Nx3)(x,y,z)
       %ReacAxis
       % Controller
       oController
       % Array containing all reaction wheels
       Wheel
       % Number of antennas
       %NumAnt
       % Antenna possitioning in Body Ref Frame(array Nx3)
       AntPos
       % Array containing all antennas
       Antenna
       % Dry Mass of the Spacecraft (kg)
       Mass
       % Orbit Dynamics Model
       OrbitDynamics
   end
   
   % DSSA Related
   properties
       % Positon 3-D
       Position
       % Velocity 3-D
       Velocity   
       % Attitude quaternion
       Attitude
       % State (object state)
       oState
       % Knowledge Radius
       rKnowledgeRadius
       % Movement Radius
       rMovementRadius
       % Array Description of the next Position/Velocity Required
       arTarget
       % Status Flag: Active = 1 or Blocked = 0
       lActive
       % Thrust Used
       rTotalDeltaV
   end
   
   % Collision Avoidance
   properties
       % Safety Mode ON(1)/OFF(0)
       lPriority
       % Original Target (Stored to be Used by DSSA later)
       arSafetyTarget
   end
       
   % Various functions of the class
   methods
       % Design this agent
       function obj = agent( NThrust ,Mass )
        
            % Define Global Variables to be used
            global SSis_rKnowledgeRadius SSis_rMovementRadius           ...
                SSlo_csMovShape

% ARIS -b
            % Hardcoded Values of TAxis, NReacWheel, NAnt, RAxis and APos.
            % TO BECHANGED IN FURTHER ITERATIONS OF THE SOFTWARE
            TAxis = zeros(3,1);
            NReacWheel = 0;
            NAnt  = 0;
            RAxis = zeros(3,1);
            APos  = zeros(3,1);
% ARIS -e

            if nargin < 0
                error('Input Arguments Required')
            end
                         
            if ~isnumeric( NThrust + NReacWheel + NAnt + Mass )

                error('The number arguments and mass must be single ' + ...
                    'real/integer positive numbers');
            
            end

            if ~( (length(TAxis)==3) && (length(RAxis)==3) &&           ...
                (length(APos)==3) )

                error('Must be a 3 element vector')

            end

% ARIS -b
% So far 1 thruster per agent which is 3-axis actuated is supposed
% ARIS -e
            % Load Agent Dry Mass
            obj.Mass = Mass;
            
            % Create Thruster               'CANSAT-5  ''BGT-X5    '
            obj = obj.CreateThruster(NThrust,'BIT-7     ');
            
            % Create Controller
            obj.oController = controller('PID');

            % Create Reaction Wheels
            obj = obj.CreateReactionWheels( NReacWheel );

            % Create Antennas
            obj = obj.CreateAntennas( NAnt );
            
            % Create State Object
            obj.oState = state(SSlo_csMovShape);
            
            % Extra Initializations
            obj.rKnowledgeRadius = SSis_rKnowledgeRadius;
            obj.lActive   = false;
            obj.lPriority = false;
            obj.rTotalDeltaV = 0;

       end
                     
       function status = CheckLocalState(thisagent, csPattern)
           
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %
            % Synopsis: This function checks if the Local State of the 
            %           agent is part of the desired states. Returns a 
            %           boolean array with true in the desired states.
            %
            % Inputs    thisagent :   agent 
            %
            %           csPattern :   Character String. Description of the 
            %                         global pattern tobe achieved
            %         
            % Outputs   status    :   Boolean. True when the local state
            %                         matches the desired state.
            %
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
           if ~thisagent.lActive
                status = CheckState(thisagent.oState.arState,csPattern);
           else
               status = false;
           end
       end
              
       function [t,y] = propagateorbit (thisagent, rDeltaT, rTimeStep,  ...
               rMeanMot, arImpulse)
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %
            % Synopsis: This function generates an orbit propagation of the
            %           agent. To do so, a defined time span is given. A
            %           propagation of a thousand elements (hardcoded) is
            %           done. Depending on the dynamics selected for the
            %           agent either a two body dynamics, an osculating
            %           orbit dynamics (to be implemented) or a relative
            %           motion through a Clohessy-Wiltshire dynamics is
            %           done.
            %
            % Inputs    thisagent :   agent 
            %
            %           rDeltaT   :   Real. Time span of the propagation
            %
            %           rTimeStep :   Real. Time step of the propagation
            %                         (for Clohessy-Witlshire equations).
            %
            %           rMeanMot  :   Real. Mean motion of the orbit (just
            %                         used on relative dynamics).
            %
            %           arImpulse :   Impulse force applyed to the system.
            %
            %         
            % Outputs   t         :   Real vector with the set of times
            %                         integrated
            %
            %           y         :   Real vector with the positions and 
            %                         velocities of the agent for the
            %                         corresponding instant in t.
            %
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

          % Define the initial conditions of the propagation              
          arInitialConditions = [thisagent.Position; thisagent.     ...
              Velocity];
                     
          % Two Body system
          if thisagent.OrbitDynamics == 'T-B'
              
              [t,y] = ode45(@(t,y) TwoBodyOrbitDynamics,rDeltaT, ...
                  arInitialConditions);                
              
          % Clohessy-Wiltshire (relative to the design orbit of the swarm) 
          elseif thisagent.OrbitDynamics == 'C-W'              
              
              % As this model is not differential, but it is already
              % analytical, it is necessary to select a time step to
              % obtain the state. It is hardcoded to DeltaT/1000, which 
              % gives a fairly large set of points, but for computational 
              % speed it can be risen to higher values.
              
              k = 1;

              for time=0:rTimeStep:rDeltaT
                                    
              [y(k,1:3), y(k,4:6)] = ClohessyWiltshireOrbitDynamics(    ...
                  time, arInitialConditions(1:3),                       ...
                  arInitialConditions(4:6), rMeanMot, arImpulse);
              
              t(k) = time;
              k = k + 1;
              
              end
              
          % TUDAT Propagators    
          elseif thisagent.OrbitDynamics == 'TUD'
              % This Option allows to use the Tudat astrodynamics package
              % through the usage of the MatLab interface for Tudat
              % (originaly in C++). Be aware that this does not use the
              % Tudat software itself, but generates the input files in
              % json for Tudat. Then Tudat is executed on the background an
              % the output is loaded into MatLab variables. It is expected
              % that this propagation method will take longer than any of
              % the otehrs
              
              % Load the TUDAT MatLab Interface
              tudat.load()
              
          % Gauss Variational Equations in Modified Equinoctial Elements    
          elseif thisagent.OrbitDynamics == 'GVE'
              
              
              
          end
                     
       end
       
       function [t,y] = propagateattitude(thisagent,rTimeInterval,      ...
               rMeanMot, arInertia, arControIn)

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %
            % Synopsis: This function generates an integration of the 
            %           AtttidudeDynamics function is done (optionaly a
            %           fixed time step can be implemented).
            %
            % Inputs    thisagent       : agent 
            %
            %           rTimeInterval   : Real. Time span of the 
            %                             propagation
            %
            %           rMeanMot        : Real. Mean motion of the 
            %                             reference orbit.
            %
            %           arInertia       : Real vector. Inertia matrix.
            %
            %           arControlIn     : Impulse force applyed to the 
            %                             system.
            %
            %         
            % Outputs   t               : Real vector with the set of times
            %                             integrated.
            %
            %           y               : Real vector with the quaternions 
            %                             and angular velocities of the  
            %                             agent for the corresponding 
            %                             instant in t.
            %
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
           
           
            % Dynamics Based on Circular Reference Orbit
            
            % Initial Condition (the current attitude)
            arInitialAttitude = thisagent.Attitude;            
            
            % Time Span
            arTimeSpan = [0 rTimeInterval];
            
            % Integrate with RKF 4(5)
            [t,y] = ode45(@(t,X) AttitudeDynamics(t,X,arInertia,        ...
                 rMeanMot, arControIn, [0;0;0], [0;0;0] ),              ...
                 arTimeSpan, arInitialAttitude);
                       
       end
               
       function arOrbit = actuateorbit(thisagent, arTolerance, rMeanMot,...
               rTimestep)
           
           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
           % Synopsis: Low level controller. Converts the input from DSSA
           %           into thrusting actions.
           %
           % Inputs    thisagent   : agent 
           %
           %           arTolerance : Array of Real size = 2,1 .Control 
           %                         tolerance of position (first 
           %                         component) and velocity (second   
           %                         component).
           %
           %           rMeanMot    : Mean motion of the reference orbit.
           %        
           %           rTimestep   : Time step of this iteration in
           %                         seconds.
           %
           % Outputs   arOrbit     : Actuated orbit of the agent.
           %
           %           arAttitude  : Quaternions of the actuated agent.
           %
           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
           
           % Control the Orbit of the Spacecraft through Thrusting
           global SSlo_lLog 
                      
                % Control Loop

                % Initialize Thrust
                arThrust = [0; 0; 0];
                 
                 % Measure the Error and Define Actuation if Necessary
                               
                    %In Position
                    arError(1:3) = thisagent.Position' - thisagent.     ...
                        arTarget(1:3);
                
                    % In Velocity
                    arError(4:6) = thisagent.Velocity' - thisagent.     ...
                        arTarget(4:6);
                   
                % Actuate if Necessary
                if ( abs( norm( arError(1:3) ) ) > arTolerance(1) * 1)  ...
                        || ( abs( norm( arError(4:6) ) ) >              ...
                        arTolerance(2) )
                    
                    % Generate Thrust Action
                     arThrust = thisagent.oController.control(thisagent); 

                    % Limit thrust by thruster
                    %for iLoop = 1:size(thisagent.Thruster,2)
                    for iLoop = 1:size(arThrust,2)
 % Change if the 1 thruster 3 axis is changed erase second for and iLoop2
 % == iLoop         
                        if abs( arThrust(iLoop) ) >= thisagent.         ...
                                Thruster(1).rMaxThrust

                            if arThrust(iLoop) < 0
                                arThrust(iLoop) = -thisagent.           ...
                                    Thruster(1).rMaxThrust;
                            else
                               
                                arThrust(iLoop) = thisagent.            ...
                                    Thruster(1).rMaxThrust;
                            end
                            
                            if SSlo_lLog
                                disp('Thrust Cut Short')
                            end
                            
                          elseif abs( arThrust(iLoop) ) < thisagent.   ... 
                              Thruster(1).rMinThrust
                              arThrust(iLoop) = 0;
                        end
                     end   
                       
                        if thisagent.OrbitDynamics == 'C-W'
                            
                            thisagent.Thruster(1).updatepropellant( ...
                                sum( abs(arThrust) .* (thisagent.Mass + ...
                                thisagent.Thruster(1).rPropMass ) ) );
                        else
                            
                            thisagent.Thruster(1).updatepropellant( ...
                                sum( abs(arThrust) ) );
                            
                        end
                                                
                    

                    thisagent.rTotalDeltaV = thisagent.rTotalDeltaV +   ...
                        norm(arThrust);

                    if SSlo_lLog
                    
                        disp( 'Thrust used ' + string( arThrust(1) ) +  ...
                           ' ' + string( arThrust(2) ) + ' ' + string(  ...
                           arThrust(3) ) );
                        disp( 'Total AV : ' + string(thisagent.         ...
                            rTotalDeltaV) );
                       
                    end
                    
                end
                    
                % Propagete Orbit with the Defined Impulse 

                [t0, X0] = thisagent.propagateorbit(rTimestep,rTimestep,...
                    rMeanMot, arThrust);

                % Update the Error
 
                    % In Position
                    arError(1:3) = X0(end,1:3) - thisagent.arTarget(1:3);
                
                    % In Velocity
                    arError(4:6) = X0(end,4:6) - thisagent.arTarget(4:6);
                    
                % Update the Position and Velocity of the Agent

                    % In Position
                    thisagent.Position = X0(end,1:3)';
                    
                    % In Velocity
                    thisagent.Velocity = X0(end,4:6)';
                    
                % If the control action has achieved the required position,
                % deactivate the system and report the Logs
                if ( abs( norm( arError(1:3) ) ) < arTolerance(1) *     ...
                        0.99 ) && ( abs( norm( arError(4:6) ) ) <       ...
                        arTolerance(2) * 0.99 )

                    %Output Log if Requested
                    if SSlo_lLog

                        disp( 'Position Error = ' + string( norm(       ...
                            arError(1:3) ) ) );
                        disp( 'Velocity Error = ' + string( norm(       ...
                            arError(4:6) ) ) );

                    end
                    
                       % Deactivate the agent
                      
                       
                       % Run reset of the controller
                       lReset = thisagent.oController.resetMemory(      ...
                           arTolerance(1));
                       
                       % Deactivate if reset has resulted in possitive
                      % if lReset
                           
                            thisagent.lActive = false;
                            thisagent.lPriority = false;
                            
                       %end
                                              
                end                
                
                % Save Result in Output
                arOrbit = X0(end,:);

       end
       
       function collisionavoidance(thisagent, aoAgents,iID)
           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
           % Synopsis: Algorithm to avoid collisions with nearby agents.
           %           Assumes knowledge of a spherical environment around
           %           the agent.
           %
           % Inputs    thisagent   : agent
           %
           %           aoAgents    : 1-D array containing all agent
           %                         objects.
           %
           %           iID         : this agent's ID.
           %
           % Outputs   
           %
           % Note:     Small movements are assumed per time step.
           %
           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
           
           % Initialize Global Variables to be Used
           global SSlo_lLog SSlo_rSafetyLimit SSis_iNumAgents           ...
               SSmp_iIterationNumber SSlo_lUseOptimziedPFSM
           
           % If the agent is already in safe mode exit
           if thisagent.lPriority
               return
           end
           
           % Measure the Distance between this and all other agents.
           for iLoop = 1:SSis_iNumAgents
               
               if aoAgents(iLoop) == thisagent
                   continue
               end
               
               %If the other agent is already static  there  is no  need
               %for this
               if aoAgents(iLoop).lPriority

                   break
                   
               end
               
               rDistance = norm( aoAgents(iLoop).Position - thisagent.  ...
                   Position );
               
               % Whenever two close agents are detected set safety
               % preferences
               if rDistance <= SSlo_rSafetyLimit %&&  all(thisagent.    ...
                       %gridpoint(aoAgents(iLoop).arTarget(1:3)) ==      ...
                       %thisagent.gridpoint(thisagent.arTarget(1:3)) )
                   
                   % The agent will be set to stay static unitl the next
                   % DSSA run. The original target is stored to be used for
                   % DSSA in the next run.

%                    thisagent.arSafetyTarget = thisagent.arTarget;
%                    thisagent.arTarget = [thisagent.Position' 0 0 0];
                   thisagent.arTarget = thisagent.arSafetyTarget;
                   thisagent.arSafetyTarget = thisagent.arTarget;
                   thisagent.lPriority = true;
                   
                   % Set the Counterpart in Priority too
                   aoAgents(iLoop).lPriority = true;
                   
                   if SSlo_lLog
                       disp('ATTENTION: Counter Collision Measures Taken');
                   end
                   
                   % Once the controller is on safe mode there is no need
                   % for more actions
                   return
                   
               end
               
           end
               
       end
       
       function arAttitude = actuateatt(thisagent, rTolerance, rMeanMot)
           
           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
           % Synopsis: Low level controller. Converts the input from DSSA
           %           into thrusting actions.
           %
           % Inputs    thisagent    :   agent 
           %
           %           rTolerance   :   Control tolerance of position
           %                             (first three components) and 
           %                             attitude (last 3 components, in 
           %                             Euler Angles).
           %
           %           rMeanMot      :   Mean motion of the reference
           %                             orbit.
           %         
           % Outputs   arAttitude    :   Quaternions of the actuated agent.
           %
           %           
           %
           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            
            % Attitude Controller
            arAttitude =zeros(1,8);
            
            %Save Inertia Matrix
            arInertia  = [1000; 1000; 1000];
            
            % Initialize Contro Input
            arControlIn = [0;0;0];
            
            % Initial Attitude
            A0 = zeros(1,4);
            
            % Re-Initialzie Error
            arError = [100;100;100;100;100;100;100];
            
            % Proportional and Derivative Gains
            arKpA = [0;0;0;0];
            arKdA = [0;0;0];            
            
            % Initialize End Flag
            lEnd = false;
            
            while (lEnd == false)
                               
                 % Advance in Time
                rTime = rTime + 0.5; %s
                
                % Obtain Current Attitude
                [t0, A0] = thisagent.propagateattitude(0.5, rMeanMot,   ...
                    arInertia, arControlIn);
                
                % Save Current Attitude
                arAttitude(end+1,:) = [rTime,A0(end,:)];
                
                % Set this Attitude as Initial Attitude
                thisagent.Attitude = A0(end,:) ;
                
                % Calculate Error
                arError(1:4) = A0(end,1:4) - reference(4:7);
                arError(1:3) = A0(end,5:7);
                
                % Obain Control Input
                if ( sum(arError) > rTolerance )
                    
                    arControIn(1:4) = arKpA .* arError(1:4);
                    arControIn(5:7) = arKdA .* arError(5:7);
                    
                else
                    
                    % If the error is bellow the tolerance end
                    lEnd = true;
                    
                end  
                
                % If there are too many interations exit 
                if rTime == rMaxIter
                    error('Maximum number of iterations reached in ' +  ...
                        'attitude')
                    break
                end
                
            end                  
                      
       end
              
       function lAnswer = doIknowyou(thisagent, oAgent2)
           
            %-------------------------- Description -----------------------
            % Synopsis: This function checks if the oAgent2 is within the
            %           radius of knolwedge of this agent.
            %
            % Inputs
            %
            %       oAgent2 : agent objet to be compared with this one
            %
            % Outputs
            %
            %       lAnswer : Logical. True if oAgent2 is within the 
            %                 radius of knowledge of this agent.
            %
            %---------------------------- Function ------------------------

            % Initialize Output
            lAnswer = false;
            
            % Obtain the distance between both agents
            rDistance = oAgent2.Position - thisagent.Position;
            
            % Compare distance with knowledge radius 
            if norm(rDistance) <= thisagent.rKnowledgeRadius
                
                lAnswer = true;
                
            end  
       end
       
       function arArray = gridpoint(thisagent, arInitialPoint)
                      
            %-------------------------- Description -----------------------
            % Synopsis: This function transforms a given  point to a grid 
            %           point. Accepts 1-D arrays
            %
            % Inputs
            %
            %       arInitialPoint : agent objet to be compared with this
            %                        one
            %
            % Outputs
            %
            %       arArray        : Logical. True if oAgent2 is within the
            %                        radius of knowledge of this agent.
            %
            %---------------------------- Function ------------------------

            % Load global variables
            global SSis_rMovementRadius
            
             % Initialize Output
             arArray = zeros( size(arInitialPoint) );
            
            % ----------------- MultiShape Generalization-----------------%
            
            % Assumption: The points of the grid are equally distributed 
            % each Movement Radious horizontally from the reference oribit
            % i.e.: the origin(reference orbit) is one of them.
            % The points outside the horizontal axis are equally spaced 
            % vertically a fraction of the movement radius. Also they can
            % be shifted horizontally from the horizontal origin line of
            % centres. Both the spacing and shift are measured with an
            % angle. For example in an hexagon = 60deg or pi/3
            %
            % Assumption 2: Only prisms are considered in the third
            % dimension. These points are equally spaced every Movement
            % Radius
            %
            % Assumption 3: Velocities are considered by the gridding does
            % only uses so far the Movement Radius
            
            % Select the shift angle
            if all(thisagent.oState.csType == 'Squa') || all(thisagent. ...
                    oState.csType == 'Cube')
                
                rFactor = pi / 2; %rad
                
            elseif all(thisagent.oState.csType == 'Hexa') 
                
                rFactor = pi / 3; %rad
                
            end

            % Go over each element and round it to  the Movement Radius
            % with the corresponding factor
             for iLoop = 1:max( size(arInitialPoint) )
                 
                 % Horizontal Component Z (in 2-D shapes)
                 if iLoop == 3
                     
                    % Check for shifting
                    if (mod( round( arInitialPoint(2)  /                ...
                        ( SSis_rMovementRadius .* sin(rFactor) ) ),2) == 0)

                        arArray(3) = round( arInitialPoint(3) /         ...
                            SSis_rMovementRadius ) .* SSis_rMovementRadius;

                    else
                        
                        % The rounding in .5 regions generates
                        % descompensation in the shift. +COS in .5 positive
                        % number shifts too  much and -COS in -XX.5 does
                        % the oppositie in the negative direction. The
                        % sign operation is used to correct for this.

                        % rK = number or Movement Radius 
                        rK = round( arInitialPoint(3) /                 ...
                            SSis_rMovementRadius );
                        % rDelta selects if a factor is to be added or
                        % subtracted
                        rDelta = sign( arInitialPoint(3) - rK .*        ...
                            SSis_rMovementRadius );
                        %
                        arArray(3) = ( rK + rDelta * cos(rFactor) ) .*  ...
                            SSis_rMovementRadius;

                    end
                    
                 % Vertical Component Y (in 2-D shapes)
                 elseif iLoop == 2
                                 
                    arArray(2) = round( arInitialPoint(2) / (           ...
                        SSis_rMovementRadius .* sin(rFactor) ) ) .*     ...
                        SSis_rMovementRadius .* sin(rFactor);

                 % Other Components   
                 else                 
                    arArray(iLoop) = round( arInitialPoint(iLoop) /     ...
                         SSis_rMovementRadius ) .* SSis_rMovementRadius;  
                 
                 end
             end
                        
       end
           
       
   end 
   
   % Set of functions to create actuators such as reaction wheels or
   % thrusters in the spacecraft model
   methods(Access = public)
   
       function obj = CreateReactionWheels(obj,Num)
           for i = 1:Num
                if ~isempty(obj.Wheel)
                     obj.Wheel(end+1) = reactionwheel;
                else
                     obj.Wheel = reactionwheel;
                end
           end
       end
       
       function obj = CreateThruster(obj,iNum,csType)

           for iLoop = 1:iNum
               if ~isempty(obj.Thruster)

                   obj.Thruster(end + 1) = thruster(csType);
                   obj.Thruster(end + 1).rDryMass = obj.Mass;

               else

                   obj.Thruster = thruster(csType);
                   obj.Thruster.rDryMass = obj.Mass;

               end
           end
       end
       
       function obj = CreateAntennas(obj,Num)
           for i = 1:Num
                if ~isempty(obj.Antenna)
                     obj.Antenna(end+1) = antenna;
                else
                     obj.Antenna = antenna;
                end
           end           
       end
             
   end
end