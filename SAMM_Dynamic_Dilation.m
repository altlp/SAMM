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
%  c: threshold pameter
%  se: size of structuring element
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [Output] = SAMM_Dynamic_Dilation(InputI,t,se)
% Size of the image
[m,n] = size(InputI);

% Memory for the output
Output = zeros(m,n);

% Replicate the boundaries of the input image
InputI_Padarray = padarray(InputI,[se se],'symmetric');    %the initial image I

for i=se+1:m+se
    waitbar(i/(m+se));
    for j=se+1:n+se
        
        d=(1-t)*255;
        W1 = InputI_Padarray(i-se:i+se,j-se:j+se);
        W2 = max(W1( W1 >= (InputI_Padarray(i,j)-d )& W1 <= (InputI_Padarray(i,j)+d) ));
        
        Output(i-se,j-se) = W2;
        
    end
end

Output=uint8(Output);











