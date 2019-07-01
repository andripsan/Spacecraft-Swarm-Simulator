%--------------------------AE-AE5810 Space Thesis--------------------------
%
%
% Function            : Orbit Dynamics -- Two Body
% Programing Language : MatLab R2018a 
% Project             : MSc. Thesis
% Copyright           : Andrés Ripoll Sánchez
% Year                : 2019
%
%--------------------------------------------------------------------------
%
% Synopsis : This script defines a function that models the orbital 
% dynamics of the spacecraft in a two body problem being the second body
% the spacecraft. 
%
% Formulation: R is a vector containing in its first 3 components the
% position vector and in the second 3 components the velocity. The
% formulation is dR/dt = A * R being A a matrix of coeficients
%
% Inputs: r     = Position and Velocity at a given time
%         rMu   = Gravitational Parameter of the Main Body 
%         t     = Time
%--------------------------------------------------------------------------

function drdt = TwoBodyOrbitDynamics(t,y,rMu)

rModulus = sqrt(y(1).^2 + y(2).^2 + y(3).^2);

drdt(1) = y(4) ;
drdt(2) = y(5) ;
drdt(3) = y(6) ;
drdt(4) = - rMu / (rModulus).^3 * y(1) ;
drdt(5) = - rMu / (rModulus).^3 * y(2) ;
drdt(6) = - rMu / (rModulus).^3 * y(3) ;

drdt = drdt';

