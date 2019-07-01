%--------------------------AE-AE5810 Space Thesis--------------------------
%
%
% Function            : OMpp_PreProcesPFSM
% Programing Language : MatLab R2018a 
% Project             : MSc. Thesis
% Copyright           : Andrés Ripoll Sánchez
% Year                : 2019
%
%--------------------------------------------------------------------------
%
% Synopsis : This
%
%--------------------------------------------------------------------------

function OMpp_PreProcessPFSM

    % Load Global Variables
    global SSis_arLoadedPFSM
    
    % Generate a vector with the total probability of the actions 
    arProbab = sum(SSis_arLoadedPFSM,2);
    % Find the indexes of those rows with probability over 1
        % Normalize Probability for rows over 1
        arRow = arProbab > 1;

        SSis_arLoadedPFSM(arRow,:) = SSis_arLoadedPFSM(arRow,:) ./      ...
            sum(SSis_arLoadedPFSM(arRow,:),2);
        
        % Generate the Probability for No Move
        SSis_arLoadedPFSM = [SSis_arLoadedPFSM zeros( size(             ...
            SSis_arLoadedPFSM, 1), 1 ) ];
        % Find those Rows with propability bellow 1
        arRow = arProbab  < 1;
        SSis_arLoadedPFSM(arRow,end) = 1 - sum(SSis_arLoadedPFSM(arRow, ...
            :),2);
        
end