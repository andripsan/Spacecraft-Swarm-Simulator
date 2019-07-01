%--------------------------AE-AE5810 Space Thesis--------------------------
%
%
% Function            : Controller Class Definition
% Programing Language : MatLab R2018a 
% Project             : MSc. Thesis
% Copyright           : Andrés Ripoll Sánchez
% Year                : 2019
%
%--------------------------------------------------------------------------
%
% Synopsis : This script defines the properties and functions associated
% with the different low level controllers of the spacecraft
%
%--------------------------------------------------------------------------

classdef controller < handle
    
    % General Properties of the Controller
    properties 
        % Control Tolerances [x,y,z,vx,vy,vz] in Hill's Frame
        arTolerance
        
        % Controller Type
        csType
                
    end
    
    % PID Related
    properties
        % Proportional Gain ([P;I;D)
        arKp
        
        % Derivative Gain
        arKd
        
        % Integral Gain
        arKi
        
        % Memory of the Error for integration
        arMemory
        
        % Integrals of the Error
        arInt
                
    end
    
    % MPC Related
    properties
        
        % Sampling Time
        rSamplingTime
        
        % Minimum Control Horizon
        iNc
        
        % Horizon of the Controller
        iN
        
        % Minimum Cost Horizon
        iNm
        
        % State Weight Matrix
        arQ
        
        % Control Weight Matrix
        arR
        
        % Output Constrain u < umax
        rUmax
        
        % Input Constrain 
        
        % State Constrain 

    end
    
    % Public Methods
    methods (Access = public)
        
        % Create Controller
        function obj = controller(csType)
           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
           % Synopsis: creation of the controller.
           %
           % Inputs    controller : object 
           %
           %
           % Outputs   
           %
           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

           obj.csType = csType;
           
           if csType == 'PID'
               
               %arGains = [-0.09,-0.09,-0.04;0 0 0;-1.6 -1.6 -1.6];
               % Short Distance 50m BIT-3
%                Kp = [-0.000252124450108908 -0.000252124450108908 -0.000242124450108908];
%                Ki = [-1.47708305899997e-07 -1.47708305899997e-07 -1.47708305899997e-07];
%                Kd = [-0.6042252304574286 -0.6042252304574286 -0.1642252304574286];
%                K = [Kp;Ki;Kd];

               % BIT-7
               Kp = [-0.000275371534485476 -0.000275371534485476        ...
                   -0.000275371534485476];
               Ki = [-18.29586613931737e-07 -36.29586613931737e-07      ...
                   -36.29586613931737e-07];
               Kd = [-0.0856598299898347 -0.0856598299898347            ...
                   -0.0856598299898347];
               K = [Kp;Ki;Kd];
               
               % CANSAT-4 50mN
%                Kp = [-0.000275371534485476 -0.000575371534485476 -0.000575371534485476];
%                Ki = [-3.29586613931737e-07 -3.29586613931737e-07 -3.29586613931737e-07];
%                Kd = [-0.0456598299898347 -0.0456598299898347 -0.0456598299898347];
%                K = [Kp;Ki;Kd];
               
                % bgt-x5 (up to 1km)
                % Slow
%                 Kp = [-0.000275371534485476 -0.000575371534485476 -0.000575371534485476];
%                 Ki = [-18.29586613931737e-07 -18.29586613931737e-07 -18.29586613931737e-07];
%                 Kd = [-0.0856598299898347 -0.0856598299898347 -0.0856598299898347];
%                 K = [Kp;Ki;Kd];

%                 % Fast
%                  Kp = [-0.000564130197112355 -0.000564130197112355 -0.000564130197112355];
%                  Ki = [-1.52115288208233e-06 -1.52115288208233e-06 -1.52115288208233e-06];
%                  Kd = [-0.051117310716962 -0.051117310716962 -0.051117310716962];
%                  K = [Kp;Ki;Kd];

                arGains = K;

                obj.createPID(arGains)
               
           elseif csType == 'MPC'
               
           else
               
               error('Controller type not identified')
               
           end
            
            
        end
        
        % Control 
        function arThrust = control(controller, oAgent)
           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
           % Synopsis: Low level Controller. This function selects and
           %    launch the control process and returns the corresponding
           %    control output.
           %
           % Inputs    controller : agent 
           %
           %           oAgent     : Array of Real size = 2,1 .Control 
           %                        tolerance of position (first 
           %                        component) and velocity (second   
           %                        component).
           %
           % Outputs   arTrhust   : Thrust output in the x-y-z directions
           %                        of Hill's reference frame (in N)
           %
           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

           % Select Controller
           if controller.csType == 'PID'
               
               arThrust = controller.PIDControl(oAgent);
               
           elseif controller.csType == 'MPC'
               
           end
           
        end
        
        % Create MPC controller
        function createMPC(csDyna, rSamplingTime, thruster)
           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
           % Synopsis: creation of the MPC controller.
           %
           % Inputs    controller    : object 
           %
           %           csDyna        : 
           %
           %           rSamplingTime :
           %
           % Outputs   
           %
           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            % Deactivate MPC verbosity
            mpcverbosity('off')
            % Obtain the Plant
            oPlant = controller.GetPlant(csDyna);
            % Sampling time
            T = rSamplingTime;
            % Create MPC controller
            MPCobj = mpc(oPlant,T);
            % Tune Max and Min
            MPCobj.ManipulatedVariables(1).Min = oThruster.rMaxThrust;
            MPCobj.ManipulatedVariables(1).Max = oThruster.rMaxThrust;
            MPCobj.ManipulatedVariables(2).Min = oThruster.rMaxThrust;
            MPCobj.ManipulatedVariables(2).Max = oThruster.rMaxThrust; 
            MPCobj.ManipulatedVariables(3).Min = oThruster.rMaxThrust; 
            MPCobj.ManipulatedVariables(3).Max = oThruster.rMaxThrust; 
            
            MPCobj.ManipulatedVariables(1).RateMin = oThruster.rMinThrust;
            MPCobj.ManipulatedVariables(1).RateMax = oThruster.rMinThrust;
            MPCobj.ManipulatedVariables(2).RateMin = oThruster.rMinThrust;
            MPCobj.ManipulatedVariables(2).RateMax = oThruster.rMinThrust;        
            MPCobj.ManipulatedVariables(3).RateMin = oThruster.rMinThrust;
            MPCobj.ManipulatedVariables(3).RateMax = oThruster.rMinThrust; 
            
            % Tune Weights
            MPCobj.W.ManipulatedVariables  = [0.4 0.4 0.4];
            MPCobj.W.OutputVariables       = [1 1 1 1 1 1];
                        
        end
        
        % Create PID Controller
        function createPID(controller,arGains)
           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
           % Synopsis: creation of the PID controller.
           %
           % Inputs    controller : object 
           %
           %           arGains    : 3x6 matrix with the proportional (first
           %                        row), integral (second row) and 
           %                        derivative (third row).
           %
           % Outputs   
           %
           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
           controller.arKp = arGains(1,:);
           controller.arKi = arGains(2,:);
           controller.arKd = arGains(3,:);
                          
           controller.arMemory = zeros(1,3);
           controller.arInt    = zeros(1,3);
                                     
        end
        
        % Variate PID Gains
        function variatePIDGain(controller,arNewGains)
            
           controller.arKp = arNewGains(1,:);
           controller.arKi = arNewGains(2,:);
           controller.arKd = arNewGains(3,:);
            
        end
        
        % Reset the Integral and the Memory
        function lReset = resetMemory(controller,arTolerance)
                        
            %lReset = false;
            % If in the last 30 moves the error is bellow the tolerance
            % deactivate the contorller
            %if size(controller.arMemory,1) >  30
            %    arDeltaError = controller.arMemory(end,:) - controller. ...
            %        arMemory(end-30,:);
            %else
            %    arDeltaError = controller.arMemory(end,:) - controller. ...
            %        arMemory(1,:);
            %end
            
           %if all(arDeltaError < arTolerance)
                controller.arMemory = zeros(1,3);
                controller.arInt    = zeros(1,3);
                lReset = true;
           %end
            
        end
        
    end
    
    % Private Methods
    methods (Access = private)
        
        % PD Control
        function arThrust = PIDControl(controller, oAgent )
           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
           % Synopsis: Low level PID Controller. Converts the input from
           %           DESHA into thrusting actions.
           %
           % Inputs    controller : this controller object
           %
           % Outputs   arThrust   : Thrust vector generated by the
           %                        controller.
           %
           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
           % Control the Orbit of the Spacecraft through Thrusting
           global SSlo_rTimeStep 
                      
                % Initialize Thrust Output
                arThrust = [0; 0; 0];
                 
                 % Generate Error
                               
                    %In Position
                    arError(1:3) = oAgent.Position' - oAgent.arTarget(1:3);
                
                    % In Velocity
                    arError(4:6) = oAgent.Velocity' - oAgent.arTarget(4:6);
                    
                % Save error in memory
                controller.arMemory(end+1,:) = arError(1:3);

                % Get Derivative of the Error
                arDerivative =  arError(4:6);

                % Get Integrated Error
                controller.arInt(end+1,:) = ( controller.arMemory(end,:)...
                     - controller.arMemory(end-1,:) ) .* SSlo_rTimeStep /2;
                arIntegral = sum(controller.arInt,1);
                
                % Generate Output                
                arThrust = controller.arKp .* arError(1:3) +            ...
                    controller.arKi.* arIntegral + controller.arKd .*   ...
                    arDerivative;
                    
        end
                
        % Get the Plant of the MPC Controller
        function oPlant = GetPlant(controller, csDynam)
           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
           % Synopsis: This function outputs the plant desing of the 
           %           selected  dynamic model.
           %
           % Inputs    controller  : controller object 
           %
           %           csDynam     : Character string indicating the    
           %                         dynamic model used
           %
           % Outputs   oPlant      : Plant object 
           %
           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            
            if csDynam == 'C-W'
                
                A = zeros(6,6);
                A(1:3,1:3) = eye(3);
                A(4,1) = 3*n^2;
                A(4,5) = 2*n;
                A(5,4) = -2*n;
                A(6,3) = -n^2;

                B =[ zeros(3,3);eye(3)];

                C = eye(6);
                D = zeros(size(B));
                
            elseif csDynam == 'GVE'
                
                A = [0 0 0 0 0 0;
                   0 0 0 0 0 0;
                   0 0 0 0 0 0;
                   0 0 0 0 0 0;
                   0 0 0 0 0 0;
                   ((a * (-(epsilon ^ 2 + eta ^ 2) ^ 2 + 1) * Mu) ^ (-0.1e1 / 0.2e1)) / (a ^ 2) / (-(epsilon ^ 2 + eta ^ 2) ^ 2 + 1) * (0.1e1 + eta * cos(lambda) + epsilon * sin(lambda)) ^ 2 * Mu / 0.2e1 - 0.2e1 * sqrt((a * (-(epsilon ^ 2 + eta ^ 2) ^ 2 + 1) * Mu)) / (a ^ 3) / ((-(epsilon ^ 2 + eta ^ 2) ^ 2 + 1) ^ 2) * (0.1e1 + eta * cos(lambda) + epsilon * sin(lambda)) ^ 2 -0.2e1 * ((a * (-(epsilon ^ 2 + eta ^ 2) ^ 2 + 1) * Mu) ^ (-0.1e1 / 0.2e1)) / a / ((-(epsilon ^ 2 + eta ^ 2) ^ 2 + 1) ^ 2) * (0.1e1 + eta * cos(lambda) + epsilon * sin(lambda)) ^ 2 * epsilon * (epsilon ^ 2 + eta ^ 2) * Mu + 0.8e1 * sqrt((a * (-(epsilon ^ 2 + eta ^ 2) ^ 2 + 1) * Mu)) / (a ^ 2) / ((-(epsilon ^ 2 + eta ^ 2) ^ 2 + 1) ^ 3) * (0.1e1 + eta * cos(lambda) + epsilon * sin(lambda)) ^ 2 * epsilon * (epsilon ^ 2 + eta ^ 2) + 0.2e1 * sqrt((a * (-(epsilon ^ 2 + eta ^ 2) ^ 2 + 1) * Mu)) / (a ^ 2) / ((-(epsilon ^ 2 + eta ^ 2) ^ 2 + 1) ^ 2) * (0.1e1 + eta * cos(lambda) + epsilon * sin(lambda)) * sin(lambda) -0.2e1 * ((a * (-(epsilon ^ 2 + eta ^ 2) ^ 2 + 1) * Mu) ^ (-0.1e1 / 0.2e1)) / a / ((-(epsilon ^ 2 + eta ^ 2) ^ 2 + 1) ^ 2) * (0.1e1 + eta * cos(lambda) + epsilon * sin(lambda)) ^ 2 * (epsilon ^ 2 + eta ^ 2) * eta * Mu + 0.8e1 * sqrt((a * (-(epsilon ^ 2 + eta ^ 2) ^ 2 + 1) * Mu)) / (a ^ 2) / ((-(epsilon ^ 2 + eta ^ 2) ^ 2 + 1) ^ 3) * (0.1e1 + eta * cos(lambda) + epsilon * sin(lambda)) ^ 2 * (epsilon ^ 2 + eta ^ 2) * eta + 0.2e1 * sqrt((a * (-(epsilon ^ 2 + eta ^ 2) ^ 2 + 1) * Mu)) / (a ^ 2) / ((-(epsilon ^ 2 + eta ^ 2) ^ 2 + 1) ^ 2) * (0.1e1 + eta * cos(lambda) + epsilon * sin(lambda)) * cos(lambda) 0 0 0.2e1 * sqrt((a * (-(epsilon ^ 2 + eta ^ 2) ^ 2 + 1) * Mu)) / (a ^ 2) / ((-(epsilon ^ 2 + eta ^ 2) ^ 2 + 1) ^ 2) * (0.1e1 + eta * cos(lambda) + epsilon * sin(lambda)) * (-eta * sin(lambda) + epsilon * cos(lambda));];

                B = zeros(6,3);
                B(1,1) = 2 * oe(1) ^ 2 / h *( oe(3) * sin(oe(6)) -      ...
                    oe(2) * cos(oe(6)));
                B(1,2) = 2*oe(1)^2*p / (r * h);
                B(2,1) = -p * cos(oe(6)) / h;
                B(2,2) = ((p + r) * sin(oe(6)) + r * oe(2))/h;
                B(2,3) = -r/h * oe(3) * ( oe(4) * cos(oe(6)) - oe(5) *  ...
                    sin(oe(6)) ) / ...
                    sqrt( 1 - oe(4)^2 - oe(5)^2 );
                B(3,1) = p * sin(oe(6)) / h;
                B(3,2) = ( (p + r) * cos(oe(6)) + r * oe(3) ) / h;
                B(3,3) = r/h * oe(2) * ( oe(4) * cos(oe(6)) - oe(5) *   ...
                    sin(oe(6)) ) /  ...
                    sqrt( 1 - oe(4)^2 - oe(5)^2 );
                B(4,3) = r / ( 2 * h * sqrt( 1 - oe(4)^2 - oe(5)^2 ) ) *...
                    ( (1-oe(4)^2) * sin(oe(6)) - oe(4) * oe(5) *        ...
                    cos(oe(6)) );
                B(5,3) = r / ( 2 * h * sqrt( 1 - oe(4)^2 - oe(5)^2 ) ) *...
                    ( (1-oe(5)^2) * cos(oe(6)) - oe(4) * oe(5) *        ...
                    sin(oe(6)) );
                B(6,3) = -r / h * ( oe(4) * cos(oe(6)) - oe(5) *        ...
                    sin(oe(6)) ) / sqrt( 1 - oe(4)^2 - oe(5)^2 );

                B11 = zeros(6,6);
                B12 = zeros(6,6);

                C = eye(6);

                D = zeros(6,3);

            else
                error('Dynamic model not recognized');
            end
            
            oPlant = ss(A,B,C,D);
        
        end
    end
    
end