%--------------------------AE-AE5810 Space Thesis--------------------------
%
%
% Function            : Orbit Dynamics -- Modified Equinocatial Orbital to
%                       Hill Frame Cartesian elements
% Programing Language : MatLab R2018a 
% Project             : MSc. Thesis
% Copyright           : Andrés Ripoll Sánchez
% Year                : 2019
%
%--------------------------------------------------------------------------
%
% Synopsis : This script defines the transformation from modified 
%            equinoctial orbital elements to caartesian coordinates. See
%            Impulsive Feedback Control of Nonsingular Elements in the 
%            Geostationary Regime by Anderson and Schaub.
%
% Formulation: X   : Cartesian coordinates and velocities [x y z vx vy vz]
%              doeq : Rates of Modified Equinoctial Orbital Elements 
%                    [da depsilon deta dxi dchi dlambda]
%              oeq : reference Orbit modified Equinoctial Orbital Elements
%
% Inputs : doeq
%
%          oeq
%
%          mu : gravitational parameter
%
% Ouptus : X
%--------------------------------------------------------------------------
function X = equi2caar(doeq, oeq, mu)

% Define auxiliary parameters
    %Radius
    r = oeq(1) * ( 1 -  oeq(2)^2 - oeq(3)^2) / ( 1 + oeq(3) *           ...
        cos(oeq(6)) + oeq(2) * sin(oeq(6)) );
    % Semi-Latus Rectum
    p = oeq(1) * ( 1 -  oeq(2)^2 - oeq(3)^2);
    % Angular Momentum
    h = sqrt( p * mu );
    % Radial Velocity
    Vr = h / p * ( oeq(3) * sin(oeq(6)) - oeq(2) * cos(oeq(6)) );
    % Tangencial Velocity
    Vt = h / p * ( 1 + oeq(3) * cos(oeq(6)) + oeq(2) * sin(oeq(6)) );

    alpha = oeq(1) / r;
    rho = r / p;
    nu = Vr / Vt;

%x
X(1) = 1 / alpha * doeq(1) - rho * ( 2 * oeq(1) * oeq(2) + r *          ...
    sin(oeq(6))) * doeq(2) - rho * ( 2 * oeq(1) * oeq(3) + r *          ...
    cos(oeq(6)) ) * doeq(3) + r * nu * doeq(6);
%y
X(2) = r * ( -2 * oeq(5) * doeq(4) + 2 * oeq(4) * doeq(5) + doeq(6) );
%z
X(3) = 2 * r / sqrt( 1 - oeq(4)^2 - oeq(5)^2 ) * ( ( ( oeq(5)^2 - 1 ) * ...
    cos(oeq(6)) + oeq(4) * oeq(5) * sin(oeq(6)) ) * doeq(4) -           ...
    ( (oeq(4)^2 - 1) * sin(oeq(6)) + oeq(4) * oeq(5) * cos(oeq(6)) ) *  ...
    doeq(5) );
%vx
X(4) = -Vr / ( 2 * oeq(1) ) * doeq(1) + ( Vr * oeq(1) * oeq(2) - h *    ...
    cos(oeq(6)) ) * doeq(2) / p + ( Vr * oeq(1) * oeq(3) + h *          ...
    sin(oeq(6)) ) * doeq(3) / p + ( 1 / r - 1 / p ) * h * doeq(6);
%vy
(3 * Vt * oeq(1) * oeq(3) + 2 * h *cos(oeq(6)) ) * doeq(3) / p;

X(5) = -3 * Vr / (2 * oeq(1)) * doeq(1) + (3 * Vt * oeq(1) * oeq(2) +   ...
    2 * h *sin(oeq(6)) ) * doeq(2) / p + (3 * Vt * oeq(1) * oeq(3) +    ...
    2 * h *cos(oeq(6)) ) * doeq(3) / p - 2 * Vr * oeq(5) * doeq(4) + 2 *...
    Vr * oeq(4) * doeq(5) - Vr * doeq(6);
%vz
X(6) = 2 * h / ( p * sqrt( 1 - oeq(4)^2 - oeq(5)^2 ) ) * ( ( (1 -       ...
    oeq(5)^2) * (oeq(2) + sin(oeq(6))) + oeq(4) * oeq(5) *              ...
    (oeq(3) + cos(oeq(6))) ) * doeq(4) + ( (1 - oeq(4)^2) * (oeq(3) +   ...
    cos(oeq(6))) + oeq(4) * oeq(5) * (oeq(2) + sin(oeq(6))) ) * doeq(5) );

end