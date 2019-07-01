%--------------------------AE-AE5810 Space Thesis--------------------------
%
%
% Function            : State Class Definition
% Programing Language : MatLab R2018a 
% Project             : MSc. Thesis
% Copyright           : Andrés Ripoll Sánchez
% Year                : 2019
%--------------------------------------------------------------------------
%
% Synopsis : This script defines the properties and functions associated
%            with each state object of the swarm of the swarm
%
%--------------------------------------------------------------------------

classdef state < handle
    
    properties
        
        % Array containing the state
        arState
        
        % State Type
        csType
        
        % Radius Factor
        rRadiusFactor
        
        % Movement Matrix (Matrix with the posible movements)
        arMoveMat
        
    end
    
    methods (Access = public)
        
        function obj = state(csType)
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Synopsis: Class creator. Only loads the state type
            %
            % Inputs    obj    : state object 
            %
            %           csType : character string of 4 elements. Type of 
            %                    movement and state used.  
            %          
            % Outputs   
            %
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            obj.csType = csType;
            obj.GenerateMoveMat
            
        end
        
        function Create(obj, aoAgents, iAgID)
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Synopsis: Create a state for the agent identified as iAgID
            %           with its position with respect to the rest of
            %           agents.
            %
            % Inputs    obj   : state object 
            %
            %           aoAgents : Array of agent objects with their 
            %                      information.
            %
            %           iAgID    : integer identifying the current agent.
            %        
            % Outputs   
            %
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            % Selec the state to create
            % 2-D
            if all(obj.csType == 'Hexa') || all(obj.csType == 'Squa')

                obj.Create2D(aoAgents, iAgID)

            elseif obj.csType == 'Cube'

                   obj.CreateCube(aoAgents, iAgID)            
            end
        
        end
        
        function arCartesianCoord = TranslateState(obj, arInputState)
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Synopsis: This function translates a given maneuver  to
            %           a cartesian position.
            %
            % Inputs    obj              : state object 
            %
            %           arInputState     : Array of real/integers with the 
            %                              state/maneuver to be translated.
            %
            % Outputs   arCartesianCoord : Array of real elements size 3,1 
            %                              containing the state in
            %                              cartesian coordinates X,Y,Z
            %
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            % Initialize Variables
            arCartesianCoord = zeros( nnz(arInputState), 3 );
            k = 0;

            % Obtain the indexes of all non-zero elements of the state
            [arRow, arCol] = find(arInputState);

            % If both rows and columns are empty (for example blocked all
            % maneuvers), the function shall return a 0 0 0 position
            if isempty( arRow ) && isempty( arCol )

                arCartesianCoord = [0, 0, 0];
                return

            end
            
            for iLoop = 1:size(arRow,1)
                for iLoop1 = 1:size(arCol,1)
                    
                    % Get the State en Spherical Coordinates
                    [rAz,rEl,rRad] = obj.State2Sph([arRow(iLoop),       ...
                        arCol(iLoop1)]);
                    [rX, rY, rZ]   = sph2cart(rAz,rEl,rRad);
                    k = k + 1;
                    % Since the Azimuth is defined in this simulator in the
                    % Y-Z plane to minimize relative orbit drift, transform
                    % the vector generate by sph2cart
                    if all(obj.csType =='Hexa') || all(obj.csType ==    ...
                            'Squa')

                        arCartesianCoord(k,:)  = obj.ShiftCaart([rX;   ...
                           rY; rZ],'INV');
                       
                    elseif all(obj.csType == 'Cube')
                        
                        arCartesianCoord(k,:) = [rX rY rZ];
                        
                    end
                    
                end
            end
            
        end
        
        function Reset(obj)
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Synopsis: This function is used to reset the state to empty. 
            %           The type and radius factor stay the same.
            %
            % Inputs    obj   : state object 
            %        
            % Outputs   
            %
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            obj.arState = [];
            
        end
        
        function lConnectivityFlag = CheckConnectivity(obj,arManeuver)
           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
           % Synopsis: This script checks if the swarm is connected at a 
           %           given state. In case it is not, it gives the output
           %           flag a "false" value.
           %
           % Inputs    obj        : state object 
           %
           %           arManeuver : Array of real indicating the maneuver
           %                        to analyze.
           %        
           % Outputs   lConnectivityFlag : boolean set to true if the
           %                               maneuver does not disconnect the
           %                               state.
           %
           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
           % Initialize output to false as a security measure
           lConnectivityFlag = false;

            % Generate the Temptative State
            arTentativeState = obj.arState + arManeuver;   

            % Analyze the conectivity
            % ARIS -b
                % Needs to be made more efficient
            % ARIS -e

            % Get all the active states on the tentative state
            arActives = zeros(1,2);
            k = 0;

            for i = 1:size(obj.arState,1)
                for j = 1:size(obj.arState,2)

                    if arTentativeState(i,j) == 1
                        k = k + 1;
                        arActives(k,:) = [i j];

                    % If the state and the action are coincident return 
                    % false    
                    elseif arTentativeState(i,j) > 1

                        lConnectivityFlag = false;
                        return

                    end

                end
            end
            
            % Check the distance between the active elements of the 
            % tentative state The last one is excluded as there should not 
            % be any other agent left to chain with it.

            % Number of agents found chained (the last one does not count 
            % as it is the end of the chain)
            [aiFoundConnections,lConnected] = obj.FindMyConnections(    ...
                arActives,1);
                        
            % If the first element already has no conections break
            if ~lConnected
                return
            end

           i = 0;
           while i ~= size(aiFoundConnections,2)

               i = i + 1;

               [aiNewConnections,lConnected] = obj.FindMyConnections(   ...
                   arActives, aiFoundConnections(i));

               if ~lConnected

                   return

               end

               % Check if any of the new connections are not in the
               % aiFoundConnections. If so, add them both to Found and 
               % aiLoop
               for j = 1:size(aiNewConnections,2)

                   lItIsNotNew = false;

                   for k = 1:size(aiFoundConnections,2)

                       if aiNewConnections(j) == aiFoundConnections(k)
                           lItIsNotNew = true;
                       end

                   end  

                   if ~lItIsNotNew

                       aiFoundConnections(end + 1) = aiNewConnections(j);

                   end

               end     

           end

            % Only if all the elements of the swarm are connected the
            % aiFoundConnections vector will have all the identifiers of
            % the active states.
            if size(aiFoundConnections,2) == size(arActives,1)
                lConnectivityFlag = true;
            end

            
        end
        
        function GenerateMoveMat(obj)
           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
           % Synopsis: This function generates the movement matrix of the 
           %           associated to the current state
           %
           % Inputs    obj        : state object 
           %        
           % Outputs   
           %
           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

           % Generate the matrix according to the state type
           if all(obj.csType == 'Squa')
               
               obj.arMoveMat = [1; 2; 3; 4; 5; 6; 7; 8];
           
           elseif all(obj.csType == 'Hexa')
               
               obj.arMoveMat = [1; 2; 3; 4; 5; 6];
               
           elseif all(obj.csType == 'Cube')
               
               obj.arMoveMat(1:5,:) = [ 1 1; 1 2; 1 3; 1 4; 1 5];
               
               k = 5;
               for iLoop = 2:8
                   for iLoop1 = 2:4
                       
                       k = k + 1;
                       obj.arMoveMat(k,:) = [iLoop,iLoop1];
                       
                   end
               end
              
           else
               
               error('Unrecognized State Type')
               
           end
           
        end
        
    end
    
    
    methods (Access = private)
        
        % State Creation
        function Create2D(obj, aoAgents, iAgID)
           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
           % Synopsis: Create a 2D state for the agent identified as iAgID
           %           with its position with respect to the rest of
           %           agents. NOTE THAT THE 2-D PLANE SELECTED IS THE Y-Z 
           %           SINCE IT DOES NOT PRESENT DRIFTS ON THE  ORBIT
           %           MECHANICS ACCORDING TO C-W Equs.
           %
           % Inputs    obj   : state object 
           %
           %           aoAgents : Array of agent objects with their 
           %                      information.
           %
           %           iAgID    : integer identifying the current agent.
           %        
           % Outputs   
           %
           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            % Select the number of divisions with the corresponding type
            % Hexagon
            if obj.csType == 'Hexa'
                rSeparation = 6;
            elseif obj.csType == 'Squa'
                rSeparation = 8;
            end
            
            % Create State array
            obj.arState = zeros(1,rSeparation);
            
            % Get distance with all other elements 
            for iLoop = 1:size(aoAgents,2)

                % Skip if it is the very same agent
                if iLoop == iAgID                
                    continue
                end

                % To avoid that small errors of the effects of the dynamic 
                % model generate spureous solutions, round the distance 
                % vector.

                rDistanceVector = round( aoAgents(iLoop).Position -     ...
                  aoAgents(iAgID).Position );

                % Transform to spherical coordinates the distance vector
                % Y = X, Z = Y, X = Z TO GENERATE THE AZIMUTH IN THE X-Z
                % PLANEto AS IT RANGES 0-2PI            
                rDistanceVector = obj.ShiftCaart(rDistanceVector);
                [rAz, rEl, rR] = cart2sph(rDistanceVector(1),           ...
                        rDistanceVector(2), rDistanceVector(3));

                % Save where are the agents within the known
                % region. Select from their position the state.
                if rR < aoAgents(iAgID).rKnowledgeRadius
                    
                    % Transform the angles by adding 2*pi to the azimuth
                    % so the result is in the interval 0 to 2 * pi.
                    if rAz < 0
                        rAz = rAz + pi*2;
                    end

                    % For the elevation the states will be selected from 
                    % the closest pi/4 in the -pi/2 pi/2 interval
                    rPosition = round(rAz / ( 2 *pi/rSeparation) ) + 1;
                    if rPosition == rSeparation + 1 ||  rPosition == 0
                        rPosition = 1;
                    end

                    % Asign the state. In an octacimal system the azimuth
                    % determines the "tenths" and the elevation the "units"
                    obj.arState(rPosition)  = 1;

                end

            end

        end
        
        function CreateCube(obj, aoAgents, iAgID)
           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
           % Synopsis: Create a 3D state for the agent identified as iAgID
           %           with its position with respect to the rest of
           %           agents.
           %
           % Inputs    obj   : state object 
           %
           %           aoAgents : Array of agent objects with their 
           %                      information.
           %
           %           iAgID    : integer identifying the current agent.
           %        
           % Outputs   
           %
           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
           % Initialize State
           obj.arState =  zeros(8,5);
           
           % Get distance with all other elements 
           for iLoop = 1:size(aoAgents,2)

               % Skip if it is the very same agent
               if iLoop == iAgID                
                   continue
               end
               
               % To avoid that small errors of the effects of the dynamic 
               % model generate spureous solutions, round the distance 
               % vector.
               rDistanceVector = round( aoAgents(iLoop).Position -      ...
                 aoAgents(iAgID).Position );

               % Transform to spherical coordinates the distance vector
               [rAz, rEl, rR] = cart2sph(rDistanceVector(1),            ...
                   rDistanceVector(2), rDistanceVector(3));


               % Save where are the agents within the known
               % region. Select from their position the state.
               if rR < aoAgents(iAgID).rKnowledgeRadius


                   % Transform the angles by adding pi/2 to the elevation 
                   % so the result is in the interval 0 to pi.
                   rEl = rEl + pi/2;

                   if rAz < 0 
                       rAz = rAz + 2*pi;
                   end

                   % Select the state from the azimuth.The
                   % states will correspond to the closest angle
                   % 8 possible states, each assigned to the nearest pi/4  
                   % evenly around the number

                   % For the elevation the states will be selected from the
                   % closest pi/4 in the -pi/2 pi/2 interval
                   rLatitude  = floor(rAz / (pi/8));
                   rLongitude = floor(rEl / (pi/8));

                   if rLatitude == 16 || rLatitude == 15
                       rLatitude  = 0;
                   end
                   if mod(rLatitude,2)~=0
                       rLatitude = rLatitude + 1;
                   end
                   if mod(rLongitude,2)~=0
                       rLongitude = rLongitude + 1;
                   end


                   %Plus one to avoid the 0 index assigining the state
                   rLatitude  = rLatitude  / 2 + 1;
                   rLongitude = rLongitude / 2 + 1;

                   % Asign the state. In an octacimal system the azimuth
                   % determines the "tenths" and the elevation the "units"
                   obj.arState(rLatitude,rLongitude)  = 1;

               end

           end

        end
        
        % From State to Geometry
        function [rAz, rEl, rRad] = State2Sph(obj,arStateIdx)
           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
           % Synopsis: This function allows transforms a state into a
           %           vector of azimuth, elevation and radius.
           %
           % Inputs    obj        : state object 
           %
           %           arStateIdx : Array with the indexes of the state to
           %                        be transformed to spherical.
           %                        Shape: [Row, Column]
           %
           % Outputs   rAz        : Real. Azimuth in rad.
           %
           %           rEl        : Real. Elevation in rad.
           %
           %           rRad       : Real. Radius in the units of the 
           %                        knowledge radius.
           %
           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        
            % Select according to the type of state
            if obj.csType == 'Hexa'
                
                [rAz, rEl, rRad] = State2SphHex(obj, arStateIdx);
                
            elseif obj.csType == 'Squa'
                
                [rAz, rEl, rRad] = State2SphSqu(obj, arStateIdx);
                
            end
            
        end
     
        function [rAz, rEl, rRad] = State2SphHex(obj, arStateIdx)
           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
           % Synopsis: This function allows transforms a hexagonal state 
           %           into a vector of azimuth, elevation and radius.
           %
           % Inputs    obj        : state object 
           %
           %           arStateIdx : Array with the indexes of the state to
           %                        be transformed to spherical.
           %                        Shape: [Row, Column]
           %
           % Outputs   rAz        : Real. Azimuth in rad.
           %
           %           rEl        : Real. Elevation in rad.
           %
           %           rRad       : Real. Radius in the units of the 
           %                        knowledge radius.
           %
           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
           
           % Load Global Variables
           global SSis_rMovementRadius 
           
           rRad = SSis_rMovementRadius;
           
           % Get index of the non zero element representing the maneuver
           rAz  = (arStateIdx(2) -1) .* pi / 3;
           rEl  = 0;           
           
        end 
        
        function [rAz, rEl, rRad] = State2SphSqu(obj, arStateIdx)
           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
           % Synopsis: This function allows transforms a square state 
           %           into a vector of azimuth, elevation and radius.
           %
           % Inputs    obj        : state object 
           %
           %           arStateIdx : Array with the indexes of the state to
           %                        be transformed to spherical.
           %                        Shape: [Row, Column]
           %
           % Outputs   rAz        : Real. Azimuth in rad.
           %
           %           rEl        : Real. Elevation in rad.
           %
           %           rRad       : Real. Radius in the units of the 
           %                        knowledge radius.
           %
           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
           
           % Load Global Variables
           global SSis_rMovementRadius 
          
           rMultFactor = obj.GetRadiusFactor(arStateIdx);
           rRad = rMultFactor .* SSis_rMovementRadius;

           % Calculate elevation and Azimuth of the Challenger Agent
           % Correct Elevation for cube diagonals
           % Improve for multiple state shapes in future versions
           rAz = pi/4 .* (arStateIdx(2) - 1);
           rEl = 0;
            
        end
        
        function [rAz, rEl, rRad] = State2SphCub(obj, arStateIdx)
           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
           % Synopsis: This function allows transforms a cubic state 
           %           into a vector of azimuth, elevation and radius.
           %
           % Inputs    obj        : state object 
           %
           %           arStateIdx : Array with the indexes of the state to
           %                        be transformed to spherical.
           %                        Shape: [Row, Column]
           %
           % Outputs   rAz        : Real. Azimuth in rad.
           %
           %           rEl        : Real. Elevation in rad.
           %
           %           rRad       : Real. Radius in the units of the 
           %                        knowledge radius.
           %
           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
           
           % Load Global Variables
           global SSis_rMovementRadius 
          
           rMultFactor = obj.GetRadiusFactor(arStateIdx);
           rRad = rMultFactor .* SSis_rMovementRadius;

           % Calculate elevation and Azimuth of the Challenger Agent
           % Correct Elevation for cube diagonals
           % Improve for multiple state shapes in future versions
             if ( mod(obj.arState(2),2) == 0 ) && ( mod(                ...
                     obj.arState(1),2) == 0 )

                rEl = (arStateIdx(2) - 3) .* ( pi/4 - 0.1699);

             else

                rEl = pi/4 .* (arStateIdx(2) - 1) - pi/2;

             end

             rAz    = pi/4 .* (arStateIdx(1) - 1);
            
        end
        
        % Other Functions
        function [arConnections,lConnectionsFound] = FindMyConnections( ...
            obj, arActiveState, iIndex)
           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
           % Synopsis: This scripts finds who is connected to a given agent
           %            and returns their ids as a vector.
           %
           % Inputs    obj            : state object 
           %
           %           arActiveState  : Array of agent objects with their 
           %                            information.
           %
           %           iIndex         : integer identifying the current
           %                            agent.
           %        
           % Outputs   arConnections     : 1-D real array. Connections of 
           %                               the agent
           %
           %           lConnectionsFound : Boolean flag, set to true if any
           %                                connections were found.
           %
           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            % Defined Global Variables to be used
            global SSis_rKnowledgeRadius

            % Initialize iterator
            k = 0;
            arConnections(1,1) = 0;
            lConnectionsFound  = false;
            
            % Decode the position of the agent with respect to the 
            % agent who is going to maneuver
            [rAz, rEl, rRadius] = obj.State2Sph(arActiveState(iIndex,:));

            % Transform the coordinates to cartesian
            [arCurrent(1), arCurrent(2), arCurrent(3)] = sph2cart(rAz,  ...
                rEl, rRadius);
            % Since the Azimuth is defined in this simulator in the Y-Z
            % plane to minimize relative orbit drift, transform the vector
            % generate by sph2cart
            arCurrent = ( obj.ShiftCaart(arCurrent','INV') )';

            % Loop over all active agents to find the distances between 
            % them and the current agent
            for j = 1:size(arActiveState,1)

                %Exclude the current agent itself
                if j == iIndex
                    continue
                end

                [rAzC, rElC, rRadiusC] = obj.State2Sph(arActiveState(j,:));

                % Transform the coordinates to cartesian    
                [arChallenger(1), arChallenger(2), arChallenger(3)] =   ...
                    sph2cart(rAzC,rElC,rRadiusC);
                
                % Since the Azimuth is defined in this simulator in the Y-Z
                % plane to minimize relative orbit drift, transform the 
                % vector generate by sph2cart
                arChallenger  = ( obj.ShiftCaart(arChallenger','INV') )';

                % Obtain the distance between the challenger and the 
                % current
                rDistance = norm(arChallenger - arCurrent);

                % If the intersatellite distance is smaller than the 
                % knowledge radius, there is a connection
                if rDistance < SSis_rKnowledgeRadius

                    k = k + 1;
                    arConnections(k) = j;
                    lConnectionsFound = true;

                end

            end  

        end 
        
        function arNewCoord = ShiftCaart(obj,arOldCoord,varargin)
           % Note From the Developper: This function could be easily 
           %      replaced for a property with the shape of the coordinate 
           %      change matrix. It is kept to remark the importance of the
           %      rationale behind the existance of such coordinate change.
           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
           % Synopsis: This script generates a coordinates change such that
           %           X' = Y Y' = Z Z' = X being the prime coordinates the
           %           new ones. It is used to be able to generate the
           %           Azimuths in the Y-Z plane with the usage of the
           %           built in functions of MatLab.
           %
           % Inputs    arOldCoord : 1-D Colum array of real. old cartesian 
           %                        coordinates.
           %
           %           varargin   : variable input. If equal to "INV" uses
           %                        the inverse transform.
           %
           % Outputs   arNewCoord : 1-D Colum array of real. New modified 
           %                        cartesian coordinates.
           %
           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
           
           % ARIS -b
               % For X-Z Plane
               arNewCoord = [1 0 0;0 0 1;0 1 0] * arOldCoord;
               % For Y-Z Plane
               arNewCoord = [0 0 1;0 1 0;1 0 0] * arOldCoord;
               % For X-Y
               %arNewCoord = arOldCoord;
               
               if ~isempty(varargin) && all(varargin{1} == 'INV')
                   
                   % For X-Z Plane
                   arNewCoord = [ 1 0 0; 0 0 1; 0 1 0] * arOldCoord;
                   %For Y-Z Plane
                   arNewCoord = [0 0 1; 0 1 0; 1 0 0] * arOldCoord;
                   % For X-Y
                   %arNewCoord = arOldCoord;
                   
               elseif ~isempty(varargin)
                   
                   error('Variable Input Not Understood')
                   
               end
          % ARIS -e
                      
        end
        
        function rRadiusFactor = GetRadiusFactor(obj, arStateIdx)

            % Select the type of movement shape
            if all(obj.csType == 'Cube') || all(obj.csType == 'Squa')

                % Create the Movement Factor Matrix 
                if all(obj.csType == 'Cube')
                    arMoves = ones(8,5);

                        % Add cube diagonal moves
                        arMoves(2:2:end,2:2:end) = sqrt(3);
                        % Add square diagonal moves
                        arMoves(1:2:end,2:2:end) = sqrt(2);
                        % Add diagonal horizontal moves (i.e., Az:45 El:0)
                        arMoves(2:2:end,3) = sqrt(2);
                        
                elseif all(obj.csType == 'Squa')
                    arMoves = ones(1,8);

                        % Add square diagonal moves
                        arMoves(1,2:2:end) = sqrt(2);

                end

               % Obtain the Multiplication Factor of the  Movement Radius
               rRadiusFactor = arMoves(arStateIdx(1),arStateIdx(2));

            end
            
        end
        
    end
        
end