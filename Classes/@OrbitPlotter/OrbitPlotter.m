%--------------------------AE-AE5810 Space Thesis--------------------------
%
%
% Function            : Plotter
% Programing Language : MatLab R2018a 
% Project             : MSc. Thesis
% Copyright           : Andrés Ripoll Sánchez
% Year                : 2019
%
%--------------------------------------------------------------------------
%
% Synopsis : This script contains all the plotting functions used to
% graphically represent the swarm
%
%--------------------------------------------------------------------------

classdef OrbitPlotter < handle
    
    % On-Line Plotting Related
    properties (Access = public)
        
        % Array with the colors to choose from
        colors = ['r','b','k','m','y','g','c'];
        % Flag to indicate that this is the first time the code is ran
        lFirst
        % Figure Object where the on-line plot is plotted
        oOnLineFigure
        % Array of plot objects with the different data of the curves.
        aoPlot
        % Array of logical indicating which agents have already been
        % initialized and only a refresh is needed
        alSkip
        
    end
    
    % Real Time Plotting Related
    properties (Access = public)
        
        % Figure
        oFigure
        % Figure Name
        csName
        % Positioning
        csPosition
        % Axis
        Axis
        % Curves (Orbits) (Save to plot in real time the whole orbits)
        arFullOrbits
        
    end
    
methods
    
    function obj = OrbitPlotter(csPlotterType)
        %-------------------------- Description ---------------------------
        % Synopsis: This is the class creator of the OrbitPlotter Object
        %
        % Inputs    : csPlotterType : Character String with 3 characters
        %                             defining the type of plotter.
        %
        % Outputs
        %
        %---------------------------- Function ----------------------------

        global SSis_iNumAgents SSlo_rMaxTime  SSlo_rTimeStep
        
        if csPlotterType == 'Abs'
            
            obj.InitializeRealTime('Real Time',[0 0 500 375],           ...
                [-5000000 5000000 -5000000 5000000 -100 100],[45 45]);
            
            % Initialize Full Orbits
            obj.arFullOrbits = zeros( SSlo_rMaxTime/SSlo_rTimeStep, 3, SSis_iNumAgents);
            
        elseif csPlotterType == 'Rel'
            
            obj.InitializeRealTime( 'Real Time Local',[0 428 500 375],  ...
                [-3000 3000 -3000  3000 -3000 3000],[90 0]);
                %[-2000 2000 -2000  2000 -2000 2000],[90 0]);
                %[-40 40 -40  40 -40 40]
                %[-20 20 -20 20 -20 20],[0 0]);
        end
        
    end
    
    function InitializeRealTime(thisOrbitPlotter,csName, aiPosition,    ...
            aiAxis,arView)
    
        %-------------------------- Description ---------------------------
        % Synopsis: This function initializes the plotter for Real Time
        %
        % Inputs    : csName     : Name of the Plotter Object
        %             aiPosition : Position in the Screen of the Figure
        %             aiAxis     : Axis of the Figure
        %             arView     : Position of the View of the Axis.
        %
        % Outputs
        %
        %---------------------------- Function ----------------------------
                       
        % Create the Corresponding Figure
        thisOrbitPlotter.oFigure = figure('Name',csName,'Position',      ...
            aiPosition, 'Visible',0,'Resize',0);
        axis(aiAxis)
        view(arView(1),arView(2))
        ylabel('Along-Track (m)')
        zlabel('Cross-Track (m)')
        
    end     
        
    function RealTimePlottingAbs(thisOrbitPlotter, aoAgents, arRefOrb)
    
        %-------------------------- Description ---------------------------
        % Synopsis: This function plots in Real Time the Agents in Absolute
        %           Axis
        %
        % Inputs
        %
        %       aoAgents : 1-D array of objects with the agents
        %                  information on it.
        %
        %       arRefOrb : Reference Orbit propagated with the same times 
        %                  step (1x3 array).
        %
        % Outputs
        %
        %---------------------------- Function ----------------------------
        
                % Load Used Global Variables
        global SSlo_csPattern SSis_iNumAgents SSlo_arStateTolerance     ...
            SSmp_rTime SSlo_rTimeStep
        
        % Load Figure
        thisOrbitPlotter.oFigure.Visible = 1;
        grid on
        hold on
        
        % Load Iterator
        iIterator = SSmp_rTime/SSlo_rTimeStep;
        
        for iLoop = 1:SSis_iNumAgents
          
          % Select the Color  
          if aoAgents(iLoop).CheckLocalState(SSlo_csPattern)

              color = 'g';

          elseif ~aoAgents(iLoop).lActive

              color = 'b';

          else              

              color = 'k';

          end
          
          % Save in Orbits the Inertial Positions
          thisOrbitPlotter.arFullOrbits(iIterator,1:3,iLoop) =          ...
              aoAgents(iLoop).Position' + arRefOrb(iIterator,:);
          
          % Plot Agents
            scatter3(aoAgents(iLoop).Position(1) +                      ...
                arRefOrb(iIterator,1), aoAgents(iLoop).Position(2) +   ...
                arRefOrb(iIterator,2), aoAgents(iLoop).Position(3) +   ...
                arRefOrb(iIterator,3), 20 * SSlo_arStateTolerance(1),  ...
                'Marker','o','MarkerEdgeColor',color)
                       
            hold on
            
           % Plot Targets
            scatter3(aoAgents(iLoop).arTarget(1) +                      ...
                arRefOrb(iIterator,1), aoAgents(iLoop).arTarget(2) +   ...
                arRefOrb(iIterator,2), aoAgents(iLoop).arTarget(3) +   ...
                arRefOrb(iIterator,3), 100 * SSlo_arStateTolerance(1), ...
                'Marker','o','MarkerEdgeColor',color)

          hold on
                    
          % Plot Full Orbit
          plot3( thisOrbitPlotter.arFullOrbits(1:iIterator,1,iLoop), ...
              thisOrbitPlotter.arFullOrbits(1:iIterator,2,iLoop),       ...
              thisOrbitPlotter.arFullOrbits(1:iIterator,3,iLoop),color)
          hold on
          
        end
        
        % Plot the Reference Orbit
        plot3( arRefOrb(1:iIterator,1), arRefOrb(1:iIterator,2),        ...
            arRefOrb(1:iIterator,3),'b')
        
        hold off
        pause(0.0001)
        
    end
    
    function RealTimePlottingRel(thisOrbitPlotter, aoAgents)
        
        %-------------------------- Description ---------------------------
        % Synopsis: This function plots in Real Time the Agents
        %
        % Inputs
        %
        %       aoAgents : 1-D array of objects with the agents
        %                  information on it.
        %
        % Outputs
        %
        %---------------------------- Function ----------------------------
        
        % Load Used Global Variables
        global SSlo_csPattern SSis_iNumAgents SSis_lDebug               ...
            SSlo_arStateTolerance
        
        % Load Figure
        thisOrbitPlotter.oFigure.Visible = 1;
        grid on
        hold on
        
        for iLoop = 1:SSis_iNumAgents
          
          % Select the Color  
          if aoAgents(iLoop).CheckLocalState(SSlo_csPattern)

              color = 'g';

          elseif ~aoAgents(iLoop).lActive

              color = 'r';

          else              

              color = 'k';

          end
          
          % Plot Agents
%          scatter3(aoAgents(iLoop).Position(1), aoAgents(iLoop).        ...
%              Position(2), aoAgents(iLoop).Position(3), 20 *            ...
%              SSlo_arStateTolerance(1), 'Marker','o', 'MarkerEdgeColor',...
%              color)
         scatter3(aoAgents(iLoop).Position(1), aoAgents(iLoop).        ...
             Position(2), aoAgents(iLoop).Position(3),20, 'Marker','o',   ...
             'MarkerEdgeColor', color)


          % Plot Targets
%           scatter3(aoAgents(iLoop).arTarget(1), aoAgents(iLoop).        ...
%               arTarget(2), aoAgents(iLoop).arTarget(3),100 *            ...
%               SSlo_arStateTolerance(1) , 'Marker','o', 'MarkerEdgeColor'...
%               ,color)

          scatter3(aoAgents(iLoop).arTarget(1), aoAgents(iLoop).        ...
              arTarget(2), aoAgents(iLoop).arTarget(3),100, 'Marker','o',   ...
              'MarkerEdgeColor', color)

          hold on
          
       end
          
       hold off
       pause(0.0001)
        
    end

end

% Private Class Methods
methods(Access = private)
    
    function InitializePlot(thisOrbitPlotter)

        %-------------------------- Description ---------------------------
        % Synopsis: This function initializes the figure and all general
        %           purpose variables and functions
        %
        % Inputs
        %
        % Outputs
        %
        %---------------------------- Function ----------------------------
        
        % Initialize Figure
        thisOrbitPlotter.oOnLineFigure =  figure(1);
        % Set the hold to on to ensure that all plots are made in the same
        % figure
        hold on
        
    end
    
    function iIdx = selectcolor(thisOrbitPlotter,iInteger)
        
        %-------------------------- Description ---------------------------
        % Synopsis: This function selects the color of the plot given an
        %           integer.
        %
        % Inputs
        %
        %       iInteger : integer assigned to the variable to be plotted.
        %
        %
        % Outputs
        %
        %       iIdx     : integer corresponding to one of the colors 
        %                  saved in the property colors.
        %
        %---------------------------- Function ----------------------------
        
        if mod(iInteger,7) == 0
            
            iIdx = 7;
            
        elseif mod(iInteger,6) == 0
            
            iIdx = 6;
 
        elseif mod(iInteger,5) == 0

            iIdx = 5;
            
        elseif mod(iInteger,4) == 0
            
            iIdx = 4;
            
        elseif mod(iInteger,3) == 0
            
            iIdx = 3;
            
        elseif mod(iInteger,2) == 0
            
            iIdx = 2;
            
        elseif mod(iInteger,1) == 0
            
            iIdx = 1;
            
        end        
        
    end

end

end