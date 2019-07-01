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
% Synopsis: This function checks if a given local state is within the    
%           desired states. There are two types of desired states. Fixed 
%           and with rule. Fixed desired states are defined through the
%           local variable DSgd_arDesiredStates and form a fixed pattern.
%           Those defined by rules are evaluated in this function. In both 
%           cases the function returns the flag lStatus = true if the local
%           state is a desired state        
%
% Inputs    arLocalState    : Array with the local state.
%
%           sGlobalPattern  : Caracter String. Desired global shape of
%                             the swarm.
%      
% Outputs   arDesiredStates : Array of Real. Desired States (in
%                             spherical coordinates. (Radius, Azimuth,
%                             Elevation).
%
%--------------------------------------------------------------------------

function lStatus = CheckState( arLocalState, sGlobalPattern)

    % Describe global variables used in this function
    global DSgd_arDesiredStates SSlo_lUseExtremeScale

    % Initialize Status Flag
    lStatus = false;
    lFixed  = false;
    
    % Identify if the patter is fixed or rule based
    if ( all(sGlobalPattern == 'TriaXZ_4') || all(sGlobalPattern ==     ...
            'TriaYZ_4')||all(sGlobalPattern == 'TriaXZ_9') ||           ...
            all(sGlobalPattern == 'LineInfi') || all(sGlobalPattern ==  ...
            'TriVXZ_3' ) || all(sGlobalPattern == 'ATVXZ__3') || all(   ...
            sGlobalPattern == 'HEXTRI_3') || all(sGlobalPattern ==      ...
            'HEXACE_7') || all(sGlobalPattern == 'TriaYZ_9') )
        
        lFixed = true;
    end
    
    % Fixed Pattern Shapes
    if lFixed && ~SSlo_lUseExtremeScale
        
       for iLoop = 1:size(DSgd_arDesiredStates,3)
                      
            lStatus = all ( all( DSgd_arDesiredStates(:,:,iLoop) ==     ...
               arLocalState ) );

            % If one desired state matches with the local state set the
            % output to true and break
            if lStatus 
                break
            end
            
       end
       
    % Seeding Fixed Pattern
    elseif ~lFixed && SSlo_lUseExtremeScale
        
        for iLoop = 1:size(DSgd_arDesiredStates,3)

            % Check only the necessary elements to generate the state
            % Read the different rows (in 3-D states)
            for iLoop1 = 1:size( DSgd_arDesiredStates(:,:,iLoop),1 )
                
                % Read the different columns
                for iLoop2 = 1:size( DSgd_arDesiredStates(:,:,iLoop),2 )

                    % Analyze the gaps
                    if DSgd_arDesiredStates(iLoop1,iLoop2,iLoop) < 0

                        lStatus(iLoop2) = 0 == arLocalState( abs(       ...
                            DSgd_arDesiredStates(iLoop1,iLoop2,iLoop) ) );

                    % Analyze the filled   
                    else

                        lStatus(iLoop2) = 1 == arLocalState( abs(       ...
                            DSgd_arDesiredStates(iLoop1,iLoop2,iLoop) ) );

                    end

                end
            end
            
            % Evaluate the full status
            lStatus = all(lStatus);
            
            % If one desired state matches with the local state set the
            % output to true and break
            if lStatus 
                break
            end 
            
        end
       
    % Rule Based Patterns
    elseif ~lFixed && ~SSlo_lUseExtremeScale

      % Two neighbours patterns
      if sGlobalPattern == 'TwoMates'
        
        % This mode referes to all states where there are two agents as
        % neighbours.
        if sum(sum(arLocalState))  == 2 || sum(sum(arLocalState)) == 1
            
            lStatus = true;
            
        end
           
      elseif sGlobalPattern == '333Mates'
          
          
        % This mode referes to all states where there are two agents as
        % neighbours.
        if sum(sum(arLocalState))  == 3
            
            lStatus = true;
            
        end
          
      elseif sGlobalPattern == '444Mates'
          
          
        % This mode referes to all states where there are two agents as
        % neighbours.
        if sum(sum(arLocalState))  == 4
            
            lStatus = true;
            
        end
        
      else
          
          error('Pattern not Identified')
          
      end
             
    end
        
end