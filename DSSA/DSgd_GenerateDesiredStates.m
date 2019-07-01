%--------------------------AE-AE5810 Space Thesis--------------------------
%
%
% Function            : Generate Desired States
% Programing Language : MatLab R2018a 
% Project             : MSc. Thesis
% Copyright           : Andrés Ripoll Sánchez
% Year                : 2019
%
%--------------------------------------------------------------------------
%
% Synopsis: This function generates the set of desired states for the
%           swarm according to the global pattern desired. This function
%           creates the global variable DSgd_arDesiredStates.
%
% Inputs    sGlobalPattern  :  Caracter String. Desired global shape of
%                              the swarm.
%
%--------------------------------------------------------------------------

function GenerateDesiredStates(sGlobalPattern)

    % Describe global variables used in this function
    % Define arDesiresStates as a global variable. In reality it should be 
    % stored in the memory and only generated with a change in the pattern.
    global DSgd_arDesiredStates
    
%   Equilateral Triangle in the X-Z plane with 4 Agents 
    if sGlobalPattern == 'TriaXZ_4'
        
        % Supoosed in the same plane (no X coordinate)
        % Initialize Desired States as a tensor of 4 matrixes
        DSgd_arDesiredStates = zeros(8,5,4);
        
        % Central Bottom
            % Az: 0 El: 0
            DSgd_arDesiredStates(1,3,1) = 1;
            % Az: 0 El: 90
            DSgd_arDesiredStates(1,5,1) = 1;
            % Az: 180 El: 0
            DSgd_arDesiredStates(5,3,1) = 1;
            
        % Left Bottom
            % Az: 0 El: 0
            DSgd_arDesiredStates(1,3,2) = 1;
            % Az: 0 El: 45
            DSgd_arDesiredStates(1,4,2) = 1;
            
        % Right Bottom
            % Az: 180 El: 0
            DSgd_arDesiredStates(5,3,3) = 1;
            % Az: 180 El: 45
            DSgd_arDesiredStates(5,4,3) = 1;
            
        % Top
            % Az: 0 El: -90
            DSgd_arDesiredStates(1,1,4) = 1;
            % Az: 0 El: -45
            DSgd_arDesiredStates(1,2,4) = 1;
            % Az: 180 El: -45
            DSgd_arDesiredStates(5,2,4) = 1;
            
%   Equilateral Triangle in the Y-Z plane with 4 Agents 2-D
    elseif sGlobalPattern == 'TriaYZ_4'
        
        % Supoosed in the same plane (no X coordinate)
        % Initialize Desired States as a tensor of 4 matrixes
        DSgd_arDesiredStates = zeros(1,8,4);
        
        % Central Bottom
            % Az: 0
            DSgd_arDesiredStates(1,1,1) = 1;
            % Az: 90
            DSgd_arDesiredStates(1,3,1) = 1;
            % Az: 180
            DSgd_arDesiredStates(1,5,1) = 1;
            
        % Left Bottom
            % Az: 0
            DSgd_arDesiredStates(1,1,2) = 1;
            % Az: 45
            DSgd_arDesiredStates(1,2,2) = 1;
            
        % Right Bottom
            % Az: 180
            DSgd_arDesiredStates(1,5,3) = 1;
            % Az: 135
            DSgd_arDesiredStates(1,4,3) = 1;
            
        % Top
            % Az: 270
            DSgd_arDesiredStates(1,7,4) = 1;
            % Az: 315
            DSgd_arDesiredStates(1,8,4) = 1;
            % Az: 225 El: -45
            DSgd_arDesiredStates(1,6,4) = 1;   
            
%   Equilateral Triangle 2-D 9 Agents
    elseif sGlobalPattern == 'TriaYZ_9'
        
        % Supoosed in the same plane (no X coordinate)
        % Initialize Desired States as a tensor of 4 matrixes
        DSgd_arDesiredStates = zeros(1,8,9);
        
        % Central Bottom
            % Az: 0
            DSgd_arDesiredStates(1,1,1) = 1;
            % Az: 45
            DSgd_arDesiredStates(1,2,1) = 1;
            % Az: 90
            DSgd_arDesiredStates(1,3,1) = 1;            
            % Az: 135
            DSgd_arDesiredStates(1,4,1) = 1;
            % Az: 180
            DSgd_arDesiredStates(1,5,1) = 1;
            
        % Left Bottom
            % Az: 0
            DSgd_arDesiredStates(1,1,2) = 1;
            % Az: 45
            DSgd_arDesiredStates(1,2,2) = 1;
            
        % Right Bottom
            % Az: 180
            DSgd_arDesiredStates(1,5,3) = 1;
            % Az: 135
            DSgd_arDesiredStates(1,4,3) = 1;
            
        % Mid Left Bottom
            % Az = 0
            DSgd_arDesiredStates(1,1,4) = 1;
            % Az = 45
            DSgd_arDesiredStates(1,2,4) = 1;
            % Az = 90
            DSgd_arDesiredStates(1,3,4) = 1;
            % Az = 180
            DSgd_arDesiredStates(1,5,4) = 1;
            
        % Mid Right Bottom
            % Az = 0
            DSgd_arDesiredStates(1,1,5) = 1;
            % Az = 90
            DSgd_arDesiredStates(1,3,5) = 1;            
            % Az = 135
            DSgd_arDesiredStates(1,4,5) = 1;
            % Az = 180
            DSgd_arDesiredStates(1,5,5) = 1;
            
        % Right Central
            % Az = 135
            DSgd_arDesiredStates(1,4,6) = 1;
            % Az = 180
            DSgd_arDesiredStates(1,5,6) = 1;
            % Az = 225
            DSgd_arDesiredStates(1,6,6) = 1;
            % Az = 270
            DSgd_arDesiredStates(1,7,6) = 1;            
            % Az = 315
            DSgd_arDesiredStates(1,8,6) = 1;
            
        % Mid Central
            % Az = 0
            DSgd_arDesiredStates(1,1,7) = 1;
            % Az = 90
            DSgd_arDesiredStates(1,3,7) = 1;
            % Az = 180
            DSgd_arDesiredStates(1,5,7) = 1;
            % Az = 225
            DSgd_arDesiredStates(1,6,7) = 1;
            % Az = 270
            DSgd_arDesiredStates(1,7,7) = 1;            
            % Az = 315
            DSgd_arDesiredStates(1,8,7) = 1; 

        % Left Central
            % Az = 0
            DSgd_arDesiredStates(1,1,8) = 1;
            % Az = 45
            DSgd_arDesiredStates(1,2,8) = 1;
            % Az = 225
            DSgd_arDesiredStates(1,6,8) = 1;
            % Az = 270
            DSgd_arDesiredStates(1,7,8) = 1;            
            % Az = 315
            DSgd_arDesiredStates(1,8,8) = 1;
            
        % Top
            % Az: 270
            DSgd_arDesiredStates(1,7,9) = 1;
            % Az: 315
            DSgd_arDesiredStates(1,8,9) = 1;
            % Az: 225
            DSgd_arDesiredStates(1,6,9) = 1;   

 
%   Equilateral Triangle in the Y-Z plane with 8 Agents 
    elseif sGlobalPattern == 'TriaXZ_8'
        
        % Supoosed in the same plane (no X coordinate)
        % Initialize Desired States as a tensor of 4 matrixes
        DSgd_arDesiredStates = zeros(8,5,8);
        
        % Central Mid
            % Az: 0   El: 0
            DSgd_arDesiredStates(1,3,1) = 1;
            % Az: 0   El: 90
            DSgd_arDesiredStates(1,5,1) = 1;
            % Az: 0   El: -45
            DSgd_arDesiredStates(1,2,1) = 1;
            % Az: 180 El: 0
            DSgd_arDesiredStates(5,3,1) = 1;
            % Az: 180 El: -45
            DSgd_arDesiredStates(5,2,1) = 1;
            % Az: 180 El: -90
            DSgd_arDesiredStates(5,1,1) = 1;
            
        % Left Mid
            % Az: 0   El: 0
            DSgd_arDesiredStates(1,3,2) = 1;
            % Az: 0   El: 45
            DSgd_arDesiredStates(1,4,2) = 1;
            % Az: 0   El: -45
            DSgd_arDesiredStates(1,2,2) = 1;
            % Az: 180 El: -45
            DSgd_arDesiredStates(5,2,2) = 1;
            % Az: 180 El: -90
            DSgd_arDesiredStates(5,1,2) = 1;
            
        % Right Mid
            % Az: 0   El: 90
            DSgd_arDesiredStates(1,5,3) = 1;
            % Az: 180 El: 0
            DSgd_arDesiredStates(5,3,3) = 1;
            % Az: 180 El: 45
            DSgd_arDesiredStates(5,4,3) = 1;
            % Az: 180 El: -45
            DSgd_arDesiredStates(5,2,3) = 1;
            % Az: 180 El: -90
            DSgd_arDesiredStates(5,1,3) = 1;
            
        % Top
            % Az: 0 El: -90
            DSgd_arDesiredStates(1,1,4) = 1;
            % Az: 0 El: -45
            DSgd_arDesiredStates(1,2,4) = 1;
            % Az: 180 El: -45
            DSgd_arDesiredStates(5,2,4) = 1;
                        
        % Centre-Left Bottom    
            % Az: 0   El: 45
            DSgd_arDesiredStates(1,4,5) = 1;
            % Az: 0   El: 0
            DSgd_arDesiredStates(1,3,5) = 1;
            % Az: 180 El: 45
            DSgd_arDesiredStates(5,4,5) = 1;
            % Az: 180 El: 0
            DSgd_arDesiredStates(5,3,5) = 1;

        % Centre-Right Bottom
            % Az: 0   El: 45
            DSgd_arDesiredStates(1,4,6) = 1;
            % Az: 0   El: 0
            DSgd_arDesiredStates(1,3,6) = 1;
            % Az: 180   El: 45
            DSgd_arDesiredStates(5,4,6) = 1;
            % Az: 180 El: 0
            DSgd_arDesiredStates(5,3,6) = 1;
            
        % Left Bottom
            % Az: 0   El: 45
            DSgd_arDesiredStates(1,4,7) = 1;
            % Az: 0   El: 0
            DSgd_arDesiredStates(1,3,7) = 1;

        % Right Bottom    
            % Az: 180   El: 45
            DSgd_arDesiredStates(5,4,8) = 1;
            % Az: 180 El: 0
            DSgd_arDesiredStates(5,3,8) = 1;
            
%   Equilateral Triangle in the Y-Z plane with 9 Agents 3-D
    elseif sGlobalPattern == 'TriaXZ_9'
        
        % Supoosed in the same plane (no X coordinate)
        % Initialize Desired States as a tensor of 4 matrixes
        DSgd_arDesiredStates = zeros(8,5,9);
        
        % Central Mid
            % Az: 0   El: 90
            DSgd_arDesiredStates(1,5,1) = 1;
            % Az: 0   El: 0
            DSgd_arDesiredStates(1,3,1) = 1;
            % Az: 0   El: -45
            DSgd_arDesiredStates(1,2,1) = 1;
            % Az: 180 El: 0
            DSgd_arDesiredStates(5,3,1) = 1;
            % Az: 180 El: -45
            DSgd_arDesiredStates(5,2,1) = 1;
            % Az: 0 El: -90
            DSgd_arDesiredStates(1,1,1) = 1;
            
        % Left Mid
            % Az: 0   El: 45
            DSgd_arDesiredStates(1,4,2) = 1;
            % Az: 0   El: 0
            DSgd_arDesiredStates(1,3,2) = 1;
            % Az: 0   El: -45
            DSgd_arDesiredStates(1,2,2) = 1;
            % Az: 180 El: -45
            DSgd_arDesiredStates(5,2,2) = 1;
            % Az: 0 El: -90
            DSgd_arDesiredStates(1,1,2) = 1;
            
        % Right Mid
            % Az: 0   El: -45
            DSgd_arDesiredStates(1,2,3) = 1;
            % Az: 180 El: 45
            DSgd_arDesiredStates(5,4,3) = 1;
            % Az: 180 El: 0
            DSgd_arDesiredStates(5,3,3) = 1;
            % Az: 180 El: -45
            DSgd_arDesiredStates(5,2,3) = 1;
            % Az: 0 El: -90
            DSgd_arDesiredStates(1,1,3) = 1;
            
        % Top
            % Az: 0 El: -90
            DSgd_arDesiredStates(1,1,4) = 1;
            % Az: 0 El: -45
            DSgd_arDesiredStates(1,2,4) = 1;
            % Az: 180 El: -45
            DSgd_arDesiredStates(5,2,4) = 1;
            
        % Centre Bottom
            % Az: 0   El: 90
            DSgd_arDesiredStates(1,5,5) = 1;
            % Az: 0   El: 45
            DSgd_arDesiredStates(1,4,5) = 1;
            % Az: 0   El: 0
            DSgd_arDesiredStates(1,3,5) = 1;
            % Az: 180 El: 45
            DSgd_arDesiredStates(5,4,5) = 1;
            % Az: 180 El: 0
            DSgd_arDesiredStates(5,3,5) = 1;  
            
        % Centre-Left Bottom    
            % Az: 0   El: 90
            DSgd_arDesiredStates(1,5,6) = 1;
            % Az: 0   El: 45
            DSgd_arDesiredStates(1,4,6) = 1;
            % Az: 0   El: 0
            DSgd_arDesiredStates(1,3,6) = 1;
            % Az: 180 El: 0
            DSgd_arDesiredStates(5,3,6) = 1;

        % Centre-Right Bottom    
            % Az: 0   El: 90
            DSgd_arDesiredStates(1,5,7) = 1;
            % Az: 0   El: 0
            DSgd_arDesiredStates(1,3,7) = 1;
            % Az: 180   El: 45
            DSgd_arDesiredStates(5,4,7) = 1;
            % Az: 180 El: 0
            DSgd_arDesiredStates(5,3,7) = 1;
            
        % Left Bottom
            % Az: 0   El: 45
            DSgd_arDesiredStates(1,4,8) = 1;
            % Az: 0   El: 0
            DSgd_arDesiredStates(1,3,8) = 1;

        % Right Bottom    
            % Az: 180   El: 45
            DSgd_arDesiredStates(5,4,9) = 1;
            % Az: 180 El: 0
            DSgd_arDesiredStates(5,3,9) = 1;
            
    elseif sGlobalPattern == 'TriaXZ10'
        
        % Supoosed in the same plane (no X coordinate)
        % Initialize Desired States as a tensor of 4 matrixes
        DSgd_arDesiredStates = zeros(8,5,4);
        
        % Central Bottom Bottom
            % Az: 0   El: 0
            DSgd_arDesiredStates(1,3,1) = 1;
            % Az: 0   El: 90
            DSgd_arDesiredStates(1,5,1) = 1;
            % Az: 180 El: 0
            DSgd_arDesiredStates(5,3,1) = 1;
            % Az: 0   El: 45
            DSgd_arDesiredStates(1,4,1) = 1;
            % Az: 180 El: 45
            DSgd_arDesiredStates(5,4,1) = 1;
            
        % Central-Left Bottom 
            % Az: 0    El: 0
            DSgd_arDesiredStates(1,3,2) = 1;
            % Az: 0    El: 45
            DSgd_arDesiredStates(1,4,2) = 1;
            % Az: 0    El: 90
            DSgd_arDesiredStates(1,5,2) = 1;
            % Az: 180  El: 0
            DSgd_arDesiredStates(5,3,2) = 1;
            
        % Central-Right Bottom
            % Az: 0    El: 0
            DSgd_arDesiredStates(1,3,3) = 1;
            % Az: 180    El: 45
            DSgd_arDesiredStates(5,4,3) = 1;
            % Az: 0    El: 90
            DSgd_arDesiredStates(1,5,3) = 1;
            % Az: 180  El: 0
            DSgd_arDesiredStates(5,3,3) = 1;
            
        % Left Bottom
            % Az: 0    El: 0
            DSgd_arDesiredStates(1,3,4) = 1;
            % Az: 0    El: 45
            DSgd_arDesiredStates(1,4,4) = 1;
            
        % Right Bottom
            % Az: 180  El: 0
            DSgd_arDesiredStates(5,3,4) = 1;
            % Az: 180  El: 45
            DSgd_arDesiredStates(5,4,4) = 1;
            
        % Central Mid
            % Az: 0    El: 0
            DSgd_arDesiredStates(1,3,5) = 1;
            % Az: 0    El: 90
            DSgd_arDesiredStates(1,5,5) = 1;
            % Az: 180  El: 0
            DSgd_arDesiredStates(5,3,5) = 1;
            % Az: 180  El: -90
            DSgd_arDesiredStates(5,1,5) = 1;
            % Az: 180  El: -45
            DSgd_arDesiredStates(5,2,5) = 1;
            % Az: 0    El: -45
            DSgd_arDesiredStates(1,2,5) = 1;
            
        % Left Mid
            % Az: 0    El: 0
            DSgd_arDesiredStates(1,3,6) = 1;
            % Az: 0    El: 45
            DSgd_arDesiredStates(1,4,6) = 1;
            % Az: 180  El: -90
            DSgd_arDesiredStates(5,1,6) = 1;
            % Az: 180  El: -45
            DSgd_arDesiredStates(5,2,6) = 1;
            % Az: 0    El: -45
            DSgd_arDesiredStates(1,2,6) = 1;

        % Right Mid
            % Az: 180  El: 0
            DSgd_arDesiredStates(5,3,7) = 1;
            % Az: 180  El: 45
            DSgd_arDesiredStates(5,4,7) = 1;
            % Az: 180  El: -45
            DSgd_arDesiredStates(5,2,7) = 1;
            % Az: 180  El: -90
            DSgd_arDesiredStates(5,1,7) = 1;
            % Az: 0    El: -45
            DSgd_arDesiredStates(1,2,7) = 1; 
            
        % Top
            % Az: 0    El: -90
            DSgd_arDesiredStates(1,1,4) = 1;
            % Az: 0    El: -45
            DSgd_arDesiredStates(1,2,4) = 1;
            % Az: 180  El:-45
            DSgd_arDesiredStates(5,2,4) = 1;
        

    elseif sGlobalPattern == 'LineInfi'
        % Supoosed in the same plane (no X coordinate)
        % Initialize Desired States 2-D
        DSgd_arDesiredStates = zeros(1,8,3);
        
        % Left End
            % Az: 0 El: 0
            DSgd_arDesiredStates(1,1,1) = 1;
            
        % Right End
            % Az: 180 El: 0
            DSgd_arDesiredStates(1,5,2) = 1;  
        
        % Midle Element
            % Az: 0 El: 0
            DSgd_arDesiredStates(1,1,3) = 1;
            
            %Az: 180 El: 0
            DSgd_arDesiredStates(1,5,3) = 1;
            
    % Triangle 3        
    elseif sGlobalPattern == 'TriVXZ_3'
        
        % Supoosed in the same plane (no X coordinate)
        % Initialize Desired States as a tensor of 4 matrixes
        DSgd_arDesiredStates = zeros(8,5,3);
        
        %Bottom 
            %Az : 180 El : 45
            DSgd_arDesiredStates(5,4,1) = 1;
       
        %Middle
            %Az : 0   El : -45
            DSgd_arDesiredStates(1,2,2) = 1;
            %Az : 0   El :  45
            DSgd_arDesiredStates(1,4,2) = 1;
         
        % Top
            %Az : 180 El : -45
            DSgd_arDesiredStates(5,2,3) = 1;
            
    elseif sGlobalPattern == 'ATVXZ__3'
        
        % Supoosed in the same plane (no X coordinate)
        % Initialize Desired States as a tensor of 4 matrixes
       DSgd_arDesiredStates = zeros(8,5,3);

        %Left 
            %Az : 0 El : -45
            DSgd_arDesiredStates(1,2,1) = 1;
       
        %Center
            %Az : 0   El : 45
            DSgd_arDesiredStates(5,4,2) = 1;
            %Az : 0   El :  0
            DSgd_arDesiredStates(1,3,2) = 1;
         
        % Right
            %Az : 180 El : 0
            DSgd_arDesiredStates(5,3,3) = 1;

            
    % Hexagon with center element non origin centered
    elseif sGlobalPattern == 'HEXACE_7'
        
        DSgd_arDesiredStates = zeros(1,6,7);
        
        % Center
            %Az : 0
            DSgd_arDesiredStates(1,1,1) = 1;
            %Az : 60 
            DSgd_arDesiredStates(1,2,1) = 1;
            %Az : 120
            DSgd_arDesiredStates(1,3,1) = 1;
            %Az : 180
            DSgd_arDesiredStates(1,4,1) = 1;
            %Az : 220
            DSgd_arDesiredStates(1,5,1) = 1; 
            %Az : 280
            DSgd_arDesiredStates(1,6,1) = 1;
            
        % Mid Right
            %Az : 120
            DSgd_arDesiredStates(1,3,2) = 1;
            %Az : 180
            DSgd_arDesiredStates(1,4,2) = 1;
            %Az : 220
            DSgd_arDesiredStates(1,5,2) = 1;
            
        % Top Right
            %Az : 180
            DSgd_arDesiredStates(1,4,3) = 1;
            %Az : 220
            DSgd_arDesiredStates(1,5,3) = 1;
            %Az : 280
            DSgd_arDesiredStates(1,6,3) = 1;

       % Top Left
            %Az :   0
            DSgd_arDesiredStates(1,1,4) = 1;
            %Az : 220
            DSgd_arDesiredStates(1,5,4) = 1;
            %Az : 280
            DSgd_arDesiredStates(1,6,4) = 1;

       % Mid Left
            %Az :   0
            DSgd_arDesiredStates(1,1,5) = 1;
            %Az :  60
            DSgd_arDesiredStates(1,2,5) = 1;
            %Az : 280
            DSgd_arDesiredStates(1,6,5) = 1;
            
       % Bottom Left
            %Az :   0
            DSgd_arDesiredStates(1,1,6) = 1;
            %Az :  60
            DSgd_arDesiredStates(1,2,6) = 1;
            %Az : 120
            DSgd_arDesiredStates(1,3,6) = 1;
            
       % Bottom Right
            %Az :  60
            DSgd_arDesiredStates(1,2,7) = 1;
            %Az : 120
            DSgd_arDesiredStates(1,3,7) = 1;
            %Az : 180
            DSgd_arDesiredStates(1,4,7) = 1;
            
    elseif sGlobalPattern == 'HEXTRI_3'
        
        DSgd_arDesiredStates = zeros(1,6,3);
        
        % Center
            %Az : 60 
            DSgd_arDesiredStates(1,2,1) = 1;
            %Az : 120
            DSgd_arDesiredStates(1,3,1) = 1;
            
        % Top Right
            %Az : 180
            DSgd_arDesiredStates(1,4,3) = 1;
            %Az : 220
            DSgd_arDesiredStates(1,5,3) = 1;

       % Top Left
            %Az :   0
            DSgd_arDesiredStates(1,1,4) = 1;
            %Az : 280
            DSgd_arDesiredStates(1,6,4) = 1;
            
    elseif sGlobalPattern == 'SHEXNC_6'
        
        DSgd_arDesiredStates = zeros(1,3,6);
        
        % Mid Right
            DSgd_arDesiredStates(1,:,1) = [3 -4 5];
            
        % Top Right
            DSgd_arDesiredStates(1,:,2) = [4 -5 6];

       % Top Left
            DSgd_arDesiredStates(1,:,3) = [1 5 -6];

       % Mid Left
            DSgd_arDesiredStates(1,:,4) = [-1 2  6];
            
       % Bottom Left
            DSgd_arDesiredStates(1,:,5) = [1 -2  3];

       % Bottom Right
            DSgd_arDesiredStates(1,:,6) = [2 -3  4];
            
    elseif sGlobalPattern == 'SSQUAR_4'
        
        DSgd_arDesiredStates = zeros(1,2,4);
        
        % Top Right
            DSgd_arDesiredStates(1,:,1) = [5 7];

       % Top Left
            DSgd_arDesiredStates(1,:,2) = [1 7];
            
       % Bottom Left
            DSgd_arDesiredStates(1,:,3) = [1 3];

       % Bottom Right
            DSgd_arDesiredStates(1,:,4) = [3 5];
        
    end
    
end