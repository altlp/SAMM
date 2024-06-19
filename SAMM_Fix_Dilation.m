% Date:10/8/2021
% This code was writen by Mengdi Sun,
% Email:mdsun829@hotmail.com
% completed and corrected by Zhonggui Sun
% Email:altlp@hotmail.com

% This algorithm is described in details in 
%
% "An Adaptive Mathematical Morphology with Serial Operators"

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  InputI: input image
%  InputI0: original image
%  t: threshold pameter
%  se: size of structuring element
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [Output] = SAMM_Fix_Dilation(InputI,InputI0,t,se)
% Size of the image
[m,n] = size(InputI);

% Memory for the output
Output = zeros(m,n);

% Replicate the boundaries of the input image
InputI_Padarray = int8(padarray(InputI,[se se],'symmetric'));    %the initial image I
InputI0_Padarray = int8(padarray(InputI0,[se se],'symmetric'));    %the initial image I

for i=se+1:m+se
    waitbar(i/(m+se));
    for j=se+1:n+se
        
        d=int8((1-t)*255);
        W1 = int8(InputI_Padarray(i-se:i+se,j-se:j+se));
        W0 = int8(InputI0_Padarray(i-se:i+se,j-se:j+se));
        W2 = max(W1(W0 >= (InputI0_Padarray(i,j)-d )& W0 <= (InputI0_Padarray(i,j)+d) ));
                
        Output(i-se,j-se) = W2;
                
    end
end

Output=uint8(Output);