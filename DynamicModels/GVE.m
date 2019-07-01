%--------------------------AE-AE5810 Space Thesis--------------------------
%
%
% Function            : Orbit Dynamics -- Gaus Variational Equations 
% Programing Language : MatLab R2018a 
% Project             : MSc. Thesis
% Copyright           : Andrés Ripoll Sánchez
% Year                : 2019
%
%--------------------------------------------------------------------------
%
% Synopsis : This script defines a function that models the Gaus
% Variational Equations (without J2 effects) as presented in 
%
% Formulation: 
%
% Inputs: chi = current state difference (column vector)
%         t = time (for integration)
%         oe = desired state
%         f = true anomaly
%         mu= gravitational parameter
%         u = Control vector in radial(1),intrack(2) and crostrack(3). 
%             (column vector)
%
%--------------------------------------------------------------------------

function chidot = GVE(chi,t,u,oe,mu)

    % Obtain the derived parameters
    b = oe(1) * sqrt(1 - oe(2)^2);
    p = oe(1) * (1 - oe(2)^2);
    h = sqrt(p * mu);
    n = sqrt(mu/oe(1)^3);
    
    % Obtain the true anomaly
    rError = 1;
    % Initialize the guess for the eccentric anomaly
    E = 0;
    
    % Solve Kepler's Equation
    while rError > 1e-6
        
        E1 = E - ( E - oe(2)*sin(E) - oe(6) )/(1 - oe(2)*cos(E) );
        rError = abs(E1 - E);
        E = E1;
        
    end
    
    % Obtain the True Anomaly
    f = 2 * atan2( sqrt(1+oe(2))*tan(E/2), sqrt(1-oe(2)) );

    theta = oe(5) + f;
    r = p / ( 1 + oe(2) * cos(theta) );


    %Define Matrices of the equation chidot = A*chi + B*u

    A = zeros(6,6);
    A(6,1) = -3 / (2*oe(1)) * n;

    B = zeros(6,3);
    B(1,1) = 2*oe(1)^2*oe(2)*sin(f)/h;
    B(1,2) = 2*oe(1)^2*p / (r*h);
    B(2,1) = p*sin(f)/h;
    B(2,2) = ( (p+r)*cos(f) + r*oe(2) ) / h;
    B(3,3) = r * cos(theta) / h;
    B(4,3) = r * sin(theta)/( h*sin(oe(3)) );
    B(5,1) = -p*cos(f)/(h*oe(2));
    B(5,2) = (p+r)*sin(f)/(h*oe(2));
    B(5,3) = - r * sin(theta) * cos(oe(3)) / (h*sin(oe(3)));
    B(6,1) = b * ( p*cos(f) - 2*r*oe(2) )/(oe(1)*h*oe(2));
    B(6,2) = -b*(p+r)*sin(f)/(oe(1)*h*oe(2));
            
    % Obtain the output
    chidot = A*chi + B*u;
    
end