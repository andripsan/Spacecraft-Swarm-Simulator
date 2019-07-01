%--------------------------AE-AE5810 Space Thesis--------------------------
%
%
% Function            : Plotting
% Programing Language : MatLab R2018a 
% Project             : MSc. Thesis
% Copyright           : Andrés Ripoll Sánchez
% Year                : 2019
%
%--------------------------------------------------------------------------
%
% Synopsis : This script contains all the high level instructions for real
%            time plotting
%
%--------------------------------------------------------------------------

% Load Global Variables
global SSlo_lRealTime SSlo_lRealTimeLocal SSmp_lEnd SSis_iNumAgents     ...
    SSmp_arError SSis_arRefOrbit SSmp_arResults SSis_oRealTimePlotter   ...
    SSis_oRealTimeLocalPlotter SSlo_arStateTolerance

% Create the Plotter Objects Needed
if SSlo_lRealTime
    
    cla
    SSis_oRealTimePlotter.RealTimePlottingAbs(SSis_arAgents,            ...
        SSis_arRefOrbit)
    
end

if SSlo_lRealTimeLocal
    
    cla
    SSis_oRealTimeLocalPlotter.RealTimePlottingRel(SSis_arAgents)    
    
end

% If the Simulation is done, plot final results
if SSmp_lEnd
    
    for iLoop = 1:SSis_iNumAgents
     disp('Total DeltaV of Agent ' + string(iLoop) + ' : ' +           ...
         string( SSis_arAgents(iLoop).Thruster.rDeltaV ) + 'm/s' );
    end
    
    % Plot Final Orbits
    figure(3)
    grid on 
    hold on 
    % Create the Central Body (Moon)
%         [x, y, z] = sphere;
%         surf(x * 1738.1, y * 1738.1, z * 1738.1);
%         pt_cslegend(1,:) = 'Moon           ';
        
    % Create Reference Orbit
        plot3(SSis_arRefOrbit(:,1)/1000, SSis_arRefOrbit(:,2)/1000,     ...
            SSis_arRefOrbit(:,3)/1000,'b')
        pt_csLegend(1,:) = 'Reference Orbit';
        
    % Create Orbits    
    for iLoop = 1:SSis_iNumAgents
        
        plot3( SSis_arRefOrbit(1:size(SSmp_arResults,1)-1,1)/1000 +     ...
            SSmp_arResults(2:size(SSmp_arResults,1),2,iLoop)/1000,      ...
            SSis_arRefOrbit(1:size(SSmp_arResults,1)-1,2)/1000 +        ...
            SSmp_arResults(2:size(SSmp_arResults,1),3,iLoop)/1000,      ...
            SSis_arRefOrbit(1:size(SSmp_arResults,1)-1,3)/1000 +        ...
            SSmp_arResults(2:size(SSmp_arResults,1),4,iLoop)/1000, 'k')
    
        hold on
        pt_csLegend(iLoop + 1,:) = 'Agent ' + string(iLoop) + '        ';
        
    end
    legend(pt_csLegend);
    xlabel('Radial(m)')
    ylabel('Along Track(m)')
    zlabel('Cross Track(m)')
    title('Orbits') 
    view(45,45)
    hold off

    % Plot Error Rates    
    for iLoop=1:SSis_iNumAgents
        
            figure(iLoop+4)
            hold on 
            grid on
            plot(SSmp_arError(:,1,iLoop),'b')
            plot(SSmp_arError(:,2,iLoop),'g')
            plot(SSmp_arError(:,3,iLoop),'r')
            legend('ErrorX','ErrorY','ErrorZ')
            ylabel('Error (m)')
            xlabel('Time Step')
            title('Agent ' + string(iLoop) + ' Relative Error')
            hold off
            
    end
    
end