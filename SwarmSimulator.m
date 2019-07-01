%--------------------------AE-AE5810 Space Thesis--------------------------
%
%
% Function            : Swarm Simulator
% Programing Language : MatLab R2018a 
% Project             : MSc. Thesis
% Copyright           : Andrés Ripoll Sánchez
% Year                : 2019
%
%--------------------------------------------------------------------------
%
% Synopsis : This script contains, on a really high level, the whole
%            simulator flow down.
%
%--------------------------------------------------------------------------

clear all
close all
clc

% Load Options
SSlo_LoadOptions

% Initialize Simulator
SSis_InitializeSimulator

% Main Simulation Process
SSmp_MainProgram

% Show Results
SSpt_Plotting

% Beep when the Simulation has ended
beep