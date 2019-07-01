%--------------------------AE-AE5810 Space Thesis--------------------------
%
%
% Function            : Attitude Dynamics
% Programing Language : MatLab R2018a 
% Project             : MSc. Thesis
% Copyright           : Andrés Ripoll Sánchez
% Year                : 2019
%
%--------------------------------------------------------------------------
%
% Synopsis : This script defines a function that models the attitude 
% dynamics of the spacecraft. It is parametrized in quaternions, which
% later would, if necessary, be converted into Euler Angles. The model used
% will be a circular orbit around the Moon.
%
% Formulation: X' = A*X where X' = dX/dt and X = [omega q]' being omega the
% angular velocities among the two reference frames and q the quaternions
% of the movement in body reference frame.
%
% Inputs: X  = Current State
%         t  = Time (for integration purposes)
%         J  = Inertia diagonal
%         n  = Mean motion of the orbit
%         u  = Control input vector
%         Mc = Control Momentum
%         Md = Disturbance Momentum
%
%--------------------------------------------------------------------------


function Xdot = AttitudeDynamics( t, X, J, n, u, Mc, Md)

% Initialize C (cosine) matrix and output vector
C = zeros(3,3);
Xdot = zeros (7,1);

% Define the used terms of the cosine matrix
C(1,3) = 2 * ( X(4) * X(6) - X(5) * X(7) );
C(2,3) = 2 * ( X(5) * X(6) + X(4) * X(7) );
C(3,3) = 1 - 2 * ( X(4) .^ 2 + X(5) .^2 );

% Diferential Equation for Omega 1
Xdot(1) = 1/J(1) * ( Mc(1) + Md(1) - 3 * n.^2 * ( J(2) - J(1) ) *       ...
    C(2,3) * C(3,3) - (J(3) - J(2) ) * X(1) * X(3) + u(1) );

% Diferential Equation for Omega 2
Xdot(2) = 1/J(2) * ( Mc(2) + Md(2) + 3 * n.^2 * ( J(3) - J(1) ) *       ...
    C(3,3) * C(1,3) - X(1)*X(3) * ( J(1) - J(3) ) + u(2) );

% Diferential Equation for Omega 3
Xdot(3) = 1/J(3) * ( Mc(3) + Md(3) + 3 * n.^2 * ( J(1) - J(2) ) *       ...
    C(1,3) * C(2,3) - ( J(2) - J(1) ) * X(2) * X(1) + u(3) );

% Diferential Equation for q1
Xdot(4) = 1/2 * ( X(5) * X(3) - X(2) * X(6) + X(7) * X(1) );

% Diferential Equation for q2
Xdot(5) = 1/2 * ( X(1) * X(6) - X(3) * X(4) + X(2) * X(7) );

% Diferential Equation for q3
Xdot(6) = 1/2 * ( X(2) * X(4) - X(1) * X(5) + X(3) * X(7) );

% DiferentiaL Equation for q4
Xdot(7) = 1/2 * ( X(1) * X(4) + X(2) * X(5) + X(3) * X(7) );
