%--------------------------AE-AE5810 Space Thesis--------------------------
%
%
% Function            : Orbit Dynamics -- Orbital Elements To Caartesian
% Programing Language : MatLab R2018a 
% Project             : MSc. Thesis
% Copyright           : Andrés Ripoll Sánchez
% Year                : 2019
%
%--------------------------------------------------------------------------
%
% Synopsis : This script defines the transformation from classical orbital 
%            elements to caartesian coordinates as presented in chapter 11
%            of Waker (see bibliography of the associated thesis project)
%
% Formulation: oe: Orbital Elements Vector [a e i Omega omega M]
%              X : Caartesian Elements Vector[x,y,z]
%
% Inputs: oe
%--------------------------------------------------------------------------
function X = orb2caart(oe)

    % Obtain the true anomaly theta
    rError  = 1;
    % Initialize the Eccentric Anomaly
    E = 0;

    % Integrate Kepler's Equation
    while rError > 1e-6
        E1 = E - ( E - oe(2)*sin(E) - oe(6) )/(1 - oe(2)*cos(E) );
        rError = abs(E1 - E);
        E = E1;
    end

    % Obtain the True Anomaly
    Theta = 2 * atan2( sqrt(1+oe(2))*tan(E/2), sqrt(1-oe(2)) );
    
    % Obtain the Orbit Parameter
    p = oe(1) * (1 - oe(2)^2);
    
    % Use the equation of Keplerian orbits to calculate the radius
    r = p / ( 1 + oe(2) * cos(Theta) );
    
    TransforMat(1,1) =  cos(oe(5)) * cos(oe(4)) - sin(oe(5)) *          ...
        sin(oe(4)) * cos(oe(3));
    TransforMat(1,2) = -cos(oe(4)) * sin(oe(5)) - sin(oe(4)) *          ...
        cos(oe(5)) * cos(oe(3));
    TransforMat(1,3) = sin(oe(4)) * sin(oe(3));
    TransforMat(2,1) = sin(oe(4)) * cos(oe(5)) + cos(oe(4)) * sin(oe(5))...
        * cos(oe(3));
    TransforMat(2,2) = -sin(oe(4)) * sin(oe(5)) + cos(oe(4)) *          ...
        cos(oe(5)) * cos(oe(3));
    TransforMat(2,3) = -cos(oe(4)) * sin(oe(3));
    TransforMat(3,1) = sin(oe(5)) * sin(oe(3));
    TransforMat(3,2) = cos(oe(5)) * sin(oe(3));
    TransforMat(3,3) = cos(oe(3));
    
    
    X(1,1) = r * cos(Theta);
    
    X(2,1) = r * sin(Theta);
    
    X(3,1) = 0;
    
    X = TransforMat * X;
    
    
end