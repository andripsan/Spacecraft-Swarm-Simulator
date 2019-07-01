%--------------------------AE-AE5810 Space Thesis--------------------------
%
%
% Function            : Classify State
% Programing Language : MatLab R2018a 
% Project             : MSc. Thesis
% Copyright           : Andrés Ripoll Sánchez
% Year                : 2019
%
%--------------------------------------------------------------------------
%
% Synopsis : This function classifies a given state (2-D in the current
%            version) to a subset of 255 IDs. Refer to Mario Coppola for
%            understanding the state definition.
%
% Inputs  :   arState  :  State to be classified.
%
% Outputs :   iStateID : State ID (corresponding colum in PFSM)
%
%--------------------------------------------------------------------------


function iStateID = OMcs_ClassifyState(arState)

  % Load Global Variables Used
  global SSlo_csMovShape
  
  % X-Z plane 8 elements Cube
  if all(SSlo_csMovShape == 'Cube')
           
      iStateID = arState(1,1) * 8 + arState(1,2) * 16 + arState(1,3) *  ...
          32 + arState(1,4) * 64 + arState(1,5) * 128 + arState(5,2) *  ...
          4 + arState(5,3) * 2 + arState(5,4) + arState(5,1) * 8 +   ...
          arState(5,5) * 128;
      
      if all([arState(5,5) arState(1,5)]) && all([arState(5,1) arState( ...
              1,1)])
          
          error('DOUBLE Definition of a Position')
          
      end
      

      if iStateID > 255
          error('Failed State. Problem in double definition of State')
      end
      
  % Y-Z plane 8 elements    
  elseif all(SSlo_csMovShape == 'Squa')
      
      iStateID =arState(1) * 32 + arState(2) * 64 + arState(3) * 128 +  ...
          arState(4) + arState(5) * 2 + arState(6) * 4 + arState(7) * 8 ...
          + arState(8) * 16;

      if iStateID > 255
          error('Failed State. Problem in double definition of State')
      end
      
  end

end