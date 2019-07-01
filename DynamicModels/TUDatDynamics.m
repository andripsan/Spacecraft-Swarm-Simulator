%--------------------------AE-AE5810 Space Thesis--------------------------
%
%
% Function            : Orbit Dynamics -- TUDatDynamics
% Programing Language : MatLab R2018a 
% Project             : MSc. Thesis
% Copyright           : Andrés Ripoll Sánchez
% Year                : 2019
%
%--------------------------------------------------------------------------
%
% Synopsis : 
%
% Inputs:  oAgent .: Agent object.
%
% Outputs: arTime  : Real array with the times of the propagation.
%          arOrbit : Real array with the orbit (relative to the Moon in
%                    J2000). First the position and the velocity second.                     
%
%--------------------------------------------------------------------------

function [arTime, arOrbit] = TUDatDynamics(oAgent)

    % Load Global Variables Used
    global SSmp_rTime SSlo_rTimeStep

    % Load Position and Mass
    agent.initialState.x = oAgent.Position(1);
    agent.initialState.y = oAgent.Position(2);
    agent.initialState.z = oAgent.Position(3);
    agent.initialState.vx = oAgent.Velocity(1);
    agent.initialState.vy = oAgent.Velocity(2);
    agent.initialState.vz = oAgent.Velocity(3);

    % Create Simulation
    simulation.initialEpoch = SSmp_rTime;
    simulation.finalEpoch = SSmp_rTime + SSlo_rTimeStep;

    % Run Simulation
    simulation.run();
    
    % Save in Output the New Position and Velocity
    arTime     = simulation.results.numericalSolution(:,1);
    arOrbit = simulation.results.numericalSolution(:,2:7);    
    
end