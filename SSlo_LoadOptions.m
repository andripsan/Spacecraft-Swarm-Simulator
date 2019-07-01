%--------------------------AE-AE5810 Space Thesis--------------------------
%
%
% Function            : Load Options
% Programing Language : MatLab R2018a 
% Project             : MSc. Thesis
% Copyright           : Andrés Ripoll Sánchez
% Year                : 2019
%
%--------------------------------------------------------------------------
%
% Synopsis : This script contains and generates all the options for the 
%            simulation.
%
%--------------------------------------------------------------------------


global SSlo_rMaxTime SSlo_rControlFreq SSlo_rDSSAFrequency              ...
    SSlo_rSafetyLimit SSlo_arStationTolerance SSlo_csPattern SSlo_lLog  ...
    SSlo_lDebug SSlo_lRealTime SSlo_lRealTimeLocal SSlo_arStateTolerance...
    SSlo_rTimeStep SSlo_csMovShape SSlo_lUseOptimziedPFSM SSlo_csOptMat ...
    SSlo_lUsePreLoadedPFSM SSlo_lUseExtremeScale

% Main Options

    % Pattern Used  HEXACE_7  HEXTRI_3 SHEXNC_6 SSQUAR_4 ATVXZ__3 SSQUAR_4
    %     TriaYZ_4  LineInfi TriaYZ_9
    SSlo_csPattern = 'SHEXNC_6';
                          
    % State/Movement Shape (4 Characters) (Squa, Cube, Hexa)
    SSlo_csMovShape = 'Hexa';
    
    % Use Extreme Scale Patterns
    SSlo_lUseExtremeScale = true;

    % Use Optimized PFSM
    SSlo_lUseOptimziedPFSM = false;
    
    % Use PreLoaded PFSM
    SSlo_lUsePreLoadedPFSM = false;
    
    % Name of the Optimized Matrix
    SSlo_csOptMat = 'Qopt_triangle4_ANTS2018';%'Q_triangle9_ALT4';%

% Simulation Time Related

    % Maximum Time Allowed.
      SSlo_rMaxTime = 3110400; %s
    
    % Time Step  
      SSlo_rTimeStep = 20; %s

    % Frequency of the (Low Level) Controller
      SSlo_rControlFreq = 20; %s

    % Frequency of DSSA
      SSlo_rDSSAFrequency = 700; %s
      
% Safety Related      

    % Minimum intesatellite distance
      SSlo_rSafetyLimit =  50;%300;%120;%;%120;%24.038; %m

    % Tolerance in Station Keeping
      SSlo_arStationTolerance = [30 30 30];%4.5 4.5 4.5];%[9 9 9];%[ 10 10 10];%[9 9 9];%; %m 
      
    % Tolerance in State Generation
                               %0.5 0.5
      SSlo_arStateTolerance = [5 5];%[100 100];%[5 5];%[60 60];%[10 10];%;[50 50] %m 
    
% Output Options

    % Generate Log
      SSlo_lLog = false;
      
    % Debug Mode
      SSlo_lDebug = false;
      
    % Real Time Plot (Abs)
      SSlo_lRealTime = false;
      
    % Real Time Plot (Rel)
      SSlo_lRealTimeLocal = false;
      