%--------------------------AE-AE5810 Space Thesis--------------------------
%
%
% Function            : Orbit Class Definition
% Programing Language : MatLab R2018a 
% Project             : MSc. Thesis
% Copyright           : Andrés Ripoll Sánchez
% Year                : 2019
%--------------------------------------------------------------------------
%
% Synopsis : This script defines the properties and functions associated
% with each orbit element.
%
%--------------------------------------------------------------------------

classdef orbit
    % Classic Keplerian Elements
    properties
        
        % Semi-major Axis
        a
        
        % Inclination
        i
        
        % Eccentricity
        e
        
        % Argument of Perigee
        omega
        
        % RAAN
        Omega
        
        % Time Parameter
        tau
    end
    
    % Physical Parameters
    properties
        
        % Gravitational Parameter
        rMu
        
        % Orbital Period
        rT
        
        % Mean Motion
        
        rN
        
    end
    
    methods
                
        function obj = orbit(elem,rMu,type)
            
            % Synopsis: Creates the orbit object based on which type of 
            % elements are inputted. The element argument is a vector of 
            % size 6.
        
            % Inputs: obj  = Object. Object to be defined
            %
            %         elem = Real Array Size (1,6). Orbital elements to be
            %                included.
            %
            %         rMu  = Graviational Parameter of the orbit.
            %
            %         type = Character String with the type of orbit to be
            %                created.
        
            % Output: obj  = Orbit Created
           
            if type == 'Keplerian'
                
                obj.a     = elem(1);
                obj.e     = elem(2);
                obj.i     = elem(3);
                obj.omega = elem(4);
                obj.Omega = elem(5);
                obj.tau   = elem(6);
           
            
                % Physical Properties Derived
            
                obj.rMu = rMu; % m^3/s^2
                obj.rT  = 2*pi*sqrt(obj.a.^3 /  rMu); %s 
                obj.rN  = sqrt( rMu / obj.a.^3 ) ; % s^-1
            
            end
        end
        
        function [x, y, z] = Polar2Cart(thisorbit,arRad,arTheta,iOption)
            
            %------------------------- Description ------------------------
            %
            % Synopsis: This function transforms an orbit from polar to
            % cartesian.
            %
            % Inputs
            %
            %       thisorbit  :   Orbit object with all the orbital
            %                      paramteres
            %       
            %       arRad      :   Vector with the radius.
            %
            %       arTheta    :   Vectori with the corresponding angle.
            %
            %       iOption    :   Option to transform (position or
            %                      velocity)
            %
            % Outputs
            %
            %       x, y, z    :   Cartesian coordinates or velocities.
            %
            %-------------------------- Function --------------------------
            
            % Initialize variables
            
            rH = sqrt( thisorbit.a * thisorbit.rMu * (1 - thisorbit.e.^2));
            x  = zeros(size(arRad,1),1);
            y  = zeros(size(arRad,1),1);
            z  = zeros(size(arRad,1),1);
  
            % Get Constants of the Transformation
            
            rL1 = cos(thisorbit.omega) * cos(thisorbit.Omega) - sin(    ...
                thisorbit.omega) * sin(thisorbit.Omega) * cos(thisorbit.i);
            
            rL2 = - sin(thisorbit.omega) * cos(thisorbit.Omega) - cos(  ...
                thisorbit.omega) * sin(thisorbit.Omega) * cos(thisorbit.i);
            
            rM1 = cos(thisorbit.omega) * sin(thisorbit.Omega) + sin(    ...
                thisorbit.omega) * cos(thisorbit.Omega) * cos(thisorbit.i);
            
            rM2 = - sin(thisorbit.omega) * sin(thisorbit.Omega) + cos(  ...
                thisorbit.omega) * cos(thisorbit.Omega) * cos(thisorbit.i);
            
            rN1 = sin(thisorbit.omega) * sin(thisorbit.i);
            
            rN2 = cos(thisorbit.omega) * sin(thisorbit.i);
            
            
            % Transform Position
            if iOption == 'Position'
                           
            
                x = arRad .* (rL1 .* cos(arTheta) + rL2 .* sin(arTheta));

                y = arRad .* (rM1 .* cos(arTheta) + rM2 .* sin(arTheta));

                z = arRad .* (rN1 .* cos(arTheta) + rN2 .* sin(arTheta));
            
            % Transform Velocity
            elseif iOption == 'Velocity'
            
            x = thisorbit.rMu / rH * ( -rL1 * sin(arTheta) + rL2 * (    ...
                thisorbit.e + cos(arTheta) ) );
            
            y = thisorbit.rMu / rH * ( -rM1 * sin(arTheta) + rM2 * (    ...
                thisorbit.e + cos(arTheta) ) );
            
            z = thisorbit.rMu / rH * ( -rN1 * sin(arTheta) + rN2 * (    ...
                thisorbit.e + cos(arTheta) ) );
            
            end
            
        end
        
        function [Apo, Vel] = GetApogee(thisorbit)
            
            % Synopsis: This function calculates the apogee in cartesian 
            %           coordinates from the orbital elements and its
            %           velocity            
        
            % Inputs    thisorbit :   orbit (in Keplerian)
            %         
            % Outputs   Apo       :   Real vector with the position of the 
            %                         orbit
            %
            %           Vel       :   Real vector with the velocity at the
            %                         apogee of the orbit
        
            % Calculate the radius of the apogee
            Rapo = thisorbit.a * (1 + thisorbit.e);
            Apo(1) = Rapo * ( cos( thisorbit.omega ) * -1 *             ...
                cos( thisorbit.Omega ) - sin( thisorbit.omega ) * -1 *  ...
                cos( thisorbit.i ) * sin( thisorbit.Omega ) );
            
            Apo(2) = Rapo * ( -1 * sin( thisorbit.omega ) *             ...
                cos( thisorbit.Omega ) * cos( thisorbit.i) -            ...
                cos( thisorbit.omega ) * sin( thisorbit.Omega) );
            
            Apo(3) = Rapo * ( sin( thisorbit.omega) * -1 *              ...
                sin( thisorbit.i) );
            
            Vel(1) = sqrt( thisorbit.rMu / ( thisorbit.a * ( 1 -        ...
                thisorbit.e.^2 ) ) ) * ( ( thisorbit.e - 1 ) * ( - sin( ...
                thisorbit.omega )* cos( thisorbit.Omega ) - cos(        ...
                thisorbit.omega) * sin( thisorbit.Omega ) * cos(        ...
                thisorbit.i ) ) ); 
               
            Vel(2) = sqrt( thisorbit.rMu / ( thisorbit.a * ( 1          ...
                - thisorbit.e.^2 ) ) ) * ( ( thisorbit.e - 1 ) * ( -sin(...
                thisorbit.omega) * sin( thisorbit.Omega ) +             ...
                cos( thisorbit.omega ) * cos( thisorbit.Omega ) * cos(  ...
                thisorbit.i ) ) );
            
            Vel(3) = sqrt( thisorbit.rMu / ( thisorbit.a * ( 1 -        ...
                thisorbit.e.^2 ) ) ) * ( ( thisorbit.e - 1 ) * ( cos(   ...
                thisorbit.omega ) * sin( thisorbit.i ) ) );
        end
        
        function [t,y] = propagate(thisorbit,rTimeStep,rTotalTime)

            %------------------------- Description ------------------------
            %
            % Synopsis: This function generates a two vectors. One with the
            % position of the reference point in 3-D (in an intertial 
            % reference frame) and another with the corresponding time.
            %
            % Inputs
            %
            %       rTimeStep :  Time step to obtain the position of the
            %                    reference.
            %
            %       rTotalTime:  Total time for propagation
            %
            %       thisorbit:   Orbit object with the information of the
            %                    orbit.
            %
            % Outputs
            %
            %       t        :    Vector with each instant of time for 
            %                     which the orbit is tracked.
            %
            %       y        :    Vector in 3-D with the position of the
            %                     reference at each instant
            %
            %-------------------------- Function --------------------------
            
            % Initialize variables
            t       = zeros( fix(rTotalTime/rTimeStep)+1,1);
            y       = zeros( fix(rTotalTime/rTimeStep)+1,3);
            arRadius = zeros( fix(rTotalTime/rTimeStep)+1,1);
            arTheta  = zeros( fix(rTotalTime/rTimeStep)+1,1);
            
            % Get Composed Variables
            rMeanMot   = sqrt( thisorbit.rMu / thisorbit.a.^3 );
            rAngleStep = rMeanMot * rTimeStep;
            rFinalAngl = rMeanMot * rTotalTime;
            
            % Propagate (in Polar). It starts from the apogee (expected
            % injection point)
            iLooper = 1;
            
            for rAngle = pi:rAngleStep:(pi + rFinalAngl)
                
                arRadius(iLooper) = thisorbit.a * (1 - thisorbit.e.^2) /...
                    ( 1 + thisorbit.e * cos(rAngle));
                arTheta(iLooper)  = rAngle;
                
                iLooper = iLooper + 1;

            end     
            
            % Transform to Cartesian
            [y(:,1), y(:,2), y(:,3)] = thisorbit.Polar2Cart(arRadius,  ...
                arTheta,'Position');
            
            t = 0:rTimeStep:rTotalTime;
            
        end
        
    end
        
end
