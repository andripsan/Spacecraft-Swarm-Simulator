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

classdef thruster < handle
    properties
     % Name
     csName
     % Maximum Thrust(N)
     rMaxThrust
     % Minimum Thrust Step(N)
     rMinThrust
     % Specific Impulse (s)
     rIsp
     % Propellant Mass (kg)
     rPropMass
     % Max Mass Flow (kg/s)
     rMassFlow
     % Delta V (m/s)
     rDeltaV
     % Dry Mass of the System(kg)
     rDryMass
    end
    methods

        function obj = thruster(csThrusterName,varargin)
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %
            % Synopsis: This function is a constructor of the class. Its
            %           goal is to create a thruster defined in the
            %           literature. To do so the name of the Thruster is
            %           input as a 10 character string. 
            %
            % Inputs    csThrusterName : Commercial name of the thruster.
            %           vargin         : If the name is 'NEW       ', input
            %                            here all parameters.
            %           
            % Outputs   obj            :   thuster object created
            %
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            % Ensure that the number of arguments is correct
            if ~any([(size(varargin,1) == 5) (size(varargin,1) == 0)])
                error('Incorrect number of input arguments')
            end
            
            % Create the appropiate thruster
            if csThrusterName == 'NEW       '
                
                obj = obj.newthruster(csThrusterName, varargin(1),      ...
                    varargin(2),varargin(3), varargin(4),varargin(5));
                
            elseif csThrusterName == 'BIT-3     '
                obj = obj.newthruster(csThrusterName, 0.00002,1e-6,2500, ...
                    1.5,48e-9);
                
            elseif csThrusterName == 'BIT-7     '
                                             
                obj = obj.newthruster(csThrusterName, 11e-3/10,1e-6,3300,...
                    1.5,290e-9);
                
            elseif csThrusterName == 'CANSAT-5  '
                
                obj = obj.newthruster(csThrusterName, 50e-3/6,0,46,...
                    0.250,0);
                
            elseif csThrusterName == 'BGT-X5    '
                
                obj = obj.newthruster(csThrusterName, 500e-3/10,5e-3/10,...
                    225, 3,0);%0.260,0);   
                                                               
            end
                
        end

        function thisthruster = newthruster(thisthruster,  csName,      ...
                        rMaxThrust, rMinThrust, rIsp, rPropMass, rMassFlow)
            
            thisthruster.csName     = csName;
            thisthruster.rMaxThrust = rMaxThrust;
            thisthruster.rMinThrust = rMinThrust;
            thisthruster.rIsp       = rIsp;
            thisthruster.rPropMass  = rPropMass;
            thisthruster.rMassFlow  = rMassFlow;
            thisthruster.rDeltaV    = 0;
            
        end
                 
        function updatepropellant(thisthruster, rThrust)
                        
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %
            % Synopsis: This function updates the remaining mass of the
            %           propellants (fuel & oxidizer if needed) given the
            %           (specific) thrust used.
            %
            % Inputs    rThrust : Real Number. Absolute value of the norm 
            %                     of the specific thrust (in N) used.
            %           
            % Outputs   
            %
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            % Load Global Variables to be Used
            global SSlo_rTimeStep
            
           % It is supposed that the thrust is always varied through the
           % variation of the mass flow of the engine
           
           % It is supposed that the mission takes place in the Moon
           % It is supposed that the mass flow is constant (no need for a
           % variation of the current to compensate for variations in the
           % plasma flow)
           rCurrentMassFlow = rThrust / (thisthruster.rIsp .* 9.81);
           
           % The time of operation is considered as the time step.
           rConsumedProp = rCurrentMassFlow .* SSlo_rTimeStep;

           % Update the Delta V used
           thisthruster.rDeltaV = thisthruster.rIsp .* 9.81 .* log( 1 + ...
               rConsumedProp / ( thisthruster.rPropMass + thisthruster. ...
               rDryMass + 5 ) ) +  thisthruster.rDeltaV;
           
           % Update the propelant mass in the thruster unit
           thisthruster.rPropMass = thisthruster.rPropMass - rConsumedProp;
           
        end
    end
end
    