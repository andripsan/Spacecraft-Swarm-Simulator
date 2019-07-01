%--------------------------AE-AE5810 Space Thesis--------------------------
%
%
% Function            : Orbit Dynamics -- Modified Equinocatial Orbital to 
%                       Elements To Classical Orbital Elements
% Programing Language : MatLab R2018a (Object Oriented)
% Project             : MSc. Thesis
% Copyright           : Andrés Ripoll Sánchez
% Student Id          : 4631862
% Course              : 2017/2018
%
%--------------------------------------------------------------------------
%
% Synopsis : This script defines the transformation from modified 
%            equinoctial orbital elements to clasical orbital elemtns. See
%            associated thesis project
%
% Formulation: oe  : Orbital Elements Vector [a e i Omega omega f]
%              oeq : Modified Equinoctial Orbital Elements [a epsilon eta 
%                    xi chi lambda]
%
% Inputs : oeq
%
% Ouptus : oe
%--------------------------------------------------------------------------
function oe = equi2orb(oeq)

%a
oe(1) = oeq(1);
%e
oe(2) = sqrt( oeq(2)^2 + oeq(3)^2 );
%i
oe(3) = 2 * asin(oeq(4)^2 + oeq(5)^2);
%Omega
oe(4) = atan2(oeq(4),oeq(5));
%omega
oe(5) = atan2(oeq(2),oeq(3)) - oe(4);
%f
oe(6) = oeq(6) - atan2(oeq(2),oeq(3));

end