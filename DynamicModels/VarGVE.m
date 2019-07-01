%--------------------------AE-AE5810 Space Thesis--------------------------
%
%
% Function            : Orbit Dynamics -- Non-Singular Gaus Variational
%                       Equations 
% Programing Language : MatLab R2018a 
% Project             : MSc. Thesis
% Copyright           : Andrés Ripoll Sánchez
% Year                : 2019
%
%--------------------------------------------------------------------------
%
% Synopsis : This script defines a function that models the Modified    ...
%            Equinoctial Gauss Variational Equations (without J2 effects)
%            as presented  in N-Impulse Formation Flying Feedback Control 
%            Using Nonsingular Element Description by Anderson & Schaub 
%            (DOI: 10.2514/1.60766)
%
% Formulation: see aforeementioned article
%
% Inputs: chi = current state difference (column vector)
%         t = time (for integration)
%         u = Control vector in (1), and  (column vector)
%         oe = desired state in Modified Orbital Elements
%         mu= gravitational parameter
%
% Outputs: chidot: rate of change of the state difference in modified
%                  orbital elements (use varorb2caart after integrating
%                  this equation)
%
%--------------------------------------------------------------------------

function chidot = VarGVE(chi,t,u,oe,mu)
    
    % Obtain the derived parameters
    p = oe(1) * (1 - oe(2)^2 - oe(3)^2);
    h = sqrt(p * mu);
    r = p / ( 1 + oe(3) * cos(oe(6)) + oe(2) * sin(oe(6)) );
    
    %Define Matrices of the equation chidot = A*chi + B*u

   % A (generated with Maple)
   
   a = oe(1);
   epsilon = oe(2);
   eta = oe(3);
   lambda = oe(6);
   
   A = [0 0 0 0 0 0;
       0 0 0 0 0 0;
       0 0 0 0 0 0;
       0 0 0 0 0 0;
       0 0 0 0 0 0;
       ((a * (-(epsilon ^ 2 + eta ^ 2) ^ 2 + 1) * mu) ^ (-0.1e1 / 0.2e1)) / (a ^ 2) / (-(epsilon ^ 2 + eta ^ 2) ^ 2 + 1) * (0.1e1 + eta * cos(lambda) + epsilon * sin(lambda)) ^ 2 * mu / 0.2e1 - 0.2e1 * sqrt((a * (-(epsilon ^ 2 + eta ^ 2) ^ 2 + 1) * mu)) / (a ^ 3) / ((-(epsilon ^ 2 + eta ^ 2) ^ 2 + 1) ^ 2) * (0.1e1 + eta * cos(lambda) + epsilon * sin(lambda)) ^ 2 -0.2e1 * ((a * (-(epsilon ^ 2 + eta ^ 2) ^ 2 + 1) * mu) ^ (-0.1e1 / 0.2e1)) / a / ((-(epsilon ^ 2 + eta ^ 2) ^ 2 + 1) ^ 2) * (0.1e1 + eta * cos(lambda) + epsilon * sin(lambda)) ^ 2 * epsilon * (epsilon ^ 2 + eta ^ 2) * mu + 0.8e1 * sqrt((a * (-(epsilon ^ 2 + eta ^ 2) ^ 2 + 1) * mu)) / (a ^ 2) / ((-(epsilon ^ 2 + eta ^ 2) ^ 2 + 1) ^ 3) * (0.1e1 + eta * cos(lambda) + epsilon * sin(lambda)) ^ 2 * epsilon * (epsilon ^ 2 + eta ^ 2) + 0.2e1 * sqrt((a * (-(epsilon ^ 2 + eta ^ 2) ^ 2 + 1) * mu)) / (a ^ 2) / ((-(epsilon ^ 2 + eta ^ 2) ^ 2 + 1) ^ 2) * (0.1e1 + eta * cos(lambda) + epsilon * sin(lambda)) * sin(lambda) -0.2e1 * ((a * (-(epsilon ^ 2 + eta ^ 2) ^ 2 + 1) * mu) ^ (-0.1e1 / 0.2e1)) / a / ((-(epsilon ^ 2 + eta ^ 2) ^ 2 + 1) ^ 2) * (0.1e1 + eta * cos(lambda) + epsilon * sin(lambda)) ^ 2 * (epsilon ^ 2 + eta ^ 2) * eta * mu + 0.8e1 * sqrt((a * (-(epsilon ^ 2 + eta ^ 2) ^ 2 + 1) * mu)) / (a ^ 2) / ((-(epsilon ^ 2 + eta ^ 2) ^ 2 + 1) ^ 3) * (0.1e1 + eta * cos(lambda) + epsilon * sin(lambda)) ^ 2 * (epsilon ^ 2 + eta ^ 2) * eta + 0.2e1 * sqrt((a * (-(epsilon ^ 2 + eta ^ 2) ^ 2 + 1) * mu)) / (a ^ 2) / ((-(epsilon ^ 2 + eta ^ 2) ^ 2 + 1) ^ 2) * (0.1e1 + eta * cos(lambda) + epsilon * sin(lambda)) * cos(lambda) 0 0 0.2e1 * sqrt((a * (-(epsilon ^ 2 + eta ^ 2) ^ 2 + 1) * mu)) / (a ^ 2) / ((-(epsilon ^ 2 + eta ^ 2) ^ 2 + 1) ^ 2) * (0.1e1 + eta * cos(lambda) + epsilon * sin(lambda)) * (-eta * sin(lambda) + epsilon * cos(lambda));];

    % Control influence matrix B
    B = zeros(6,3);
    B(1,1) = 2 * oe(1) ^ 2 / h *( oe(3) * sin(oe(6)) - oe(2) * cos(oe(6)));
    B(1,2) = 2*oe(1)^2*p / (r * h);
    B(2,1) = -p * cos(oe(6)) / h;
    B(2,2) = ((p + r) * sin(oe(6)) + r * oe(2))/h;
    B(2,3) = -r/h * oe(3) * ( oe(4) * cos(oe(6)) - oe(5) * sin(oe(6)) ) / ...
        sqrt( 1 - oe(4)^2 - oe(5)^2 );
    B(3,1) = p * sin(oe(6)) / h;
    B(3,2) = ( (p + r) * cos(oe(6)) + r * oe(3) ) / h;
    B(3,3) = r/h * oe(2) * ( oe(4) * cos(oe(6)) - oe(5) * sin(oe(6)) ) /  ...
        sqrt( 1 - oe(4)^2 - oe(5)^2 );
    B(4,3) = r / ( 2 * h * sqrt( 1 - oe(4)^2 - oe(5)^2 ) ) *            ...
        ( (1-oe(4)^2) * sin(oe(6)) - oe(4) * oe(5) * cos(oe(6)) );
    B(5,3) = r / ( 2 * h * sqrt( 1 - oe(4)^2 - oe(5)^2 ) ) *            ...
        ( (1-oe(5)^2) * cos(oe(6)) - oe(4) * oe(5) * sin(oe(6)) );
    B(6,3) = -r / h * ( oe(4) * cos(oe(6)) - oe(5) * sin(oe(6)) ) /     ...
        sqrt( 1 - oe(4)^2 - oe(5)^2 );

    % Obtain the output
    chidot = A*chi + B*u;
        
end