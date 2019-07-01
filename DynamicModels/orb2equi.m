%--------------------------AE-AE5810 Space Thesis--------------------------
%
%
% Function            : Orbit Dynamics -- Elements To Classical Orbital 
%                       Elements to Modified Equinocatial Orbital
% Programing Language : MatLab R2018a 
% Project             : MSc. Thesis
% Copyright           : Andrés Ripoll Sánchez
% Year                : 2019
%
%--------------------------------------------------------------------------
%
% Synopsis : This script defines the transformation from clasical orbital 
%            elemnts modified equinoctial orbital elements to. See
%            associated thesis project
%
% Formulation: oe  : Orbital Elements Vector [a e i Omega omega f]
%              oeq : Modified Equinoctial Orbital Elements [a epsilon eta 
%                    xi chi lambda]
%
% Inputs : oe
%
% Ouptus : oeq
%--------------------------------------------------------------------------
function oeq = orb2equi(oe)

%a
oeq(1) = oe(1);
%epsilon
oeq(2) = oe(2) * sin( oe(5) + oe(4) );
%eta
oeq(3) = oe(2) * cos( oe(5) + oe(4) );
%xi
oeq(4) = sin( oe(3) / 2 ) * sin( oe(4) );
%chi
oeq(5) = sin( oe(3) / 2 ) * cos( oe(4) );
%lambda
oeq(6) = oe(6) + oe(5) + oe(4);
if oeq(6) >= 2*pi
    oeq(6) = oeq(6) - 2*pi;
end

end