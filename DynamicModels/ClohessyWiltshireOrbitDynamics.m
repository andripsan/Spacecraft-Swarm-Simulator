%--------------------------AE-AE5810 Space Thesis--------------------------
%
%
% Function            : Orbit Dynamics -- Clohessy-Wiltshire Equations
% Programing Language : MatLab R2018a 
% Project             : MSc. Thesis
% Copyright           : Andrés Ripoll Sánchez
% Year                : 2019
%
%--------------------------------------------------------------------------
%
% Synopsis : This script defines a function that models the orbital 
% dynamics of the spacecraft in a Clohessy-Wiltshire model, being the
% reference spacecraft 
%
% Formulation: R is a vector containing in its first element the derivative
% of the radial vector and in its second position the radial vector. dRdt =
% A * R.
%
% Inputs: t  = Time
%         r0 = Initial Position
%         V0 = Initial Velocity
%         n  = Mean Motion
%         f  = External Force
%
%--------------------------------------------------------------------------

function [r, V] = ClohessyWiltshireOrbitDynamics(t,r0,V0,n,f)

r(1) = r0(1) * ( 4 - 3 * cos(n*t) ) + V0(1)/n * sin(n*t) + 2 * V0(2) / n...
    * ( 1 - cos(n*t) ) + f(1) / n.^2 * ( 1 - cos(n*t) ) + 2 * f(2) /    ...
    n.^2  * ( n * t - sin(n*t) );
    
r(2) = r0(2) - V0(2) / n * ( 3 * n * t - 4 * sin(n*t) ) - 6 * r0(1) *   ...
    ( n * t - sin(n*t) ) - 2 * V0(1) / n * ( 1 - cos(n*t) ) - 2 * f(1) /...
    n.^2 * ( n*t - sin(n*t) ) + 2 * f(2) / n.^2 * ( 2 - 3 / 4 * n.^2 *  ...
    t.^2 - 2 * cos(n*t) );
r(3) = r0(3) * cos(n*t) + V0(3) / n * sin(n*t) + f(3) / n.^2 * ( 1 -    ...
    cos(n*t) ) ;
V(1) = 3 * r0(1) * n * sin(n*t) + V0(1) * cos(n*t) + 2 * V0(2) *        ...
    sin(n*t) + f(1) / n * sin(n*t) + 2*f(2) / n * ( 1 - cos(n*t) );
V(2) = -V0(2) * ( 3 - 4 * cos(n*t) ) - 6 * r0(1) * n * ( 1 - cos(n*t) )-...
    2 * V0(1) * sin(n*t) - 2 * f(1) / n * ( 1 - cos(n*t) ) - 2 * f(2) / ...
    n * ( 3 / 2 * n * t - 2 * sin(n*t) );
V(3) = - r0(3) * n * sin(n*t) + V0(3) * cos(n*t) + f(3) / n * sin(n*t);

 