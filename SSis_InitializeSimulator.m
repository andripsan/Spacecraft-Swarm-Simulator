%--------------------------AE-AE5810 Space Thesis--------------------------
%
%
% Function            : Initialize Simulator
% Programing Language : MatLab R2018a 
% Project             : MSc. Thesis
% Copyright           : Andrés Ripoll Sánchez
% Year                : 2019
%
%--------------------------------------------------------------------------
%
% Synopsis : This script initializes the simulator.
%
%--------------------------------------------------------------------------
%% Main Initialization Process

% Define Global Variables Used in this Script
  global SSis_rKnowledgeRadius SSis_rMovementRadius SSis_iNumAgents     ...
      SSis_oReferenceOrbit SSis_iOperationPrec  SSlo_lUsePreLoadedPFSM  ...
      SSlo_rMaxTime SSlo_rTimeStep SSis_arRefOrbit SSlo_lRealTimeLocal  ...
      SSlo_lRealTime SSis_oRealTimePlotter SSis_oRealTimeLocalPlotter   ...
      SSlo_csMovShape SSlo_lUseOptimziedPFSM SSis_arLoadedPFSM          ...
      SSlo_csOptMat
% Add DSSA, Test_Scripts, Movement Shapes and DynamicModels paths to work 
%with them
  addpath('./DSSA/','DynamicModels/','./Classes/');
  
% Define the precision used to avoid errors in the calculation processes
% So far 6 digit precision is considered more than enough for the
% calculations done in this program. Less than these might cause problems
% in the translation of the states from 1 and 0s to spherical and cartesian
  SSis_iOperationPrec = 7;
  
  % Radius of knowledge and movement
  SSis_rKnowledgeRadius = 450;%810;%29;%15;%790;%790;%150;%7.9%m
  SSis_rMovementRadius  = 300;%20;%10;%500;%5;%100;%m

  SSis_iNumAgents = 52;
  
  % ------------Load Agent Design
  
  is_iNumThrusters  = 1;
  is_arThrustAxis   = zeros(3,1);
  is_iNumReacWheels = 0;
  is_arWheelAxis    = zeros(3,1);
  is_iNumAntennas   = 0;
  is_arAntennaAxis  = zeros(3,1);
  is_rMass          = 6;
  is_sOrbitDynamics = 'C-W';
  
% ARIS -b  
  % ------ Initialization of the TUDat in Swarm Simulator ---
     % If the model used is TUDAT load the TUDAT
     if is_sOrbitDynamics == 'TUD'
       
        tudat.load()

        % Create Agent
        agent = Body('Agent');

        % Create Simulation
        simulation = Simulation();
        simulation.globalFrameOrientation = 'J2000';
        simulation.globalFrameOrigin = 'Moon';
        simulation.addBodies(Sun,Earth,Moon,agent);

        % Load Accelerations
        accelerationsOnAgent.Earth = {PointMassGravity()};
        accelerationsOnAgent.Sun = {PointMassGravity()};
        accelerationsOnAgent.Moon = {SphericalHarmonicGravity(5,5)};

        % Create Propagator
        translationalPropagator = TranslationalPropagator();
        translationalPropagator.bodiesToPropagate = {agent};
        translationalPropagator.centralBodies = {Moon};
        translationalPropagator.accelerations.vehicle =                 ...
            accelerationsOnAgent;
        
        % Create Integrator. In this case a R-K4 fixed step size it is
        % deemed sufficient
        simulation.integrator.type = Integrators.rungeKutta4;
        simulation.integrator.stepSize = SSlo_rTimeStep;

     end
% ARIS -e
     
% ------------Load Design & Initialize Agents

  % Initialize Looper
  is_iLoop = 0;
  
  % Loop over as many agents as needed and create each one of them
  for is_iLoop = 1:SSis_iNumAgents
      SSis_arAgents(is_iLoop) = agent(is_iNumThrusters, is_rMass);
      SSis_arAgents(is_iLoop).OrbitDynamics = is_sOrbitDynamics;      
  end
  
% Create Reference Orbit
  is_rSMAxis = 3000000 + 1738100;%m
  is_rEc     = 0;
  is_rIn     = 0;
  is_rArgPer = 0;
  is_rRAAN   = 0;
  is_rTau    = 0;

  % Moon Gravitational Parameter
  SSis_rMu = 4.904E12; %km^3/s^2

  SSis_oReferenceOrbit = orbit([is_rSMAxis;is_rEc;is_rIn;is_rArgPer;    ...
      is_rRAAN;is_rTau],SSis_rMu,'Keplerian');
  
  % Create the Propagatio of the Reference Orbit
  [is_rDummy SSis_arRefOrbit] = SSis_oReferenceOrbit.propagate(         ...
      SSlo_rTimeStep,SSlo_rMaxTime);
  
% ------------Load Initial States around the Reference Orbit

SSri_RandomInitialization(SSis_arAgents)

% ------------Load Plotter Objects

    % Real Time Local Plotter
    if SSlo_lRealTimeLocal
        SSis_oRealTimeLocalPlotter = OrbitPlotter('Rel');
    end
    
    % Real Time Plotter
    if SSlo_lRealTime
        SSis_oRealTimePlotter = OrbitPlotter('Abs');
    end
    
% ------------Create Desired States
    DSgd_GenerateDesiredStates(SSlo_csPattern)
    
% ------------Load Optimized PFSM

    if SSlo_lUseOptimziedPFSM || SSlo_lUsePreLoadedPFSM
        
        addpath('./DSSA/OptiMove/')      
        load( strcat('./DSSA/OptiMove/', SSlo_csOptMat) )
        clear SSlo_csOptMat 
        SSis_arLoadedPFSM = Qopt;
        clear Qopt
    end
    
    if SSlo_lUseOptimziedPFSM
        
        OMpp_PreProcessPFSM()
        
    end

% Clear local variables

  clear is_iNumThrusters is_arThrustAxis is_iNumReacWheels              ...
      is_arWheelAxis is_iNumAntennas is_arAntennaAxis is_rFuel is_iLoop ...
      is_rSMAxis is_rEc is_rIn is_rArgPer is_rRAAN is_rTau              ...
      is_OrbitDynamics is_arPosApogee is_arAvError is_arInitialStates   ...
      is_arErrors is_arVelApogee is_sOrbitDynamics is_arAvErrorAttEA    ...
      is_arErrors is_arQuater is_arErrorsAtt is_arAvErrorOrb is_rDummy  ...
      is_rMass
