clear;
close all;

picindex = {'Lena.png','House.png'};

for i=1:length(picindex)   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    fprintf('the %d th picture\n',i);
    str=['f:\SAMM\picture\',picindex{i}];
    ima=imread(str);
    if length(size(ima))>2
        ima=rgb2gray(ima);
    end
    
    %     ima=double(ima);
    %         for imp=[0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5]
    for imp=0
        %             for gausigma=[10 20 30 40 50]
        for gausigma=0
            
            rand('state',0);
            gima=double(ima)+gausigma*randn(size(double(ima)));%mixed noise
            rima = imnoise(uint8(gima),'salt & pepper',imp);   %%%%%%%%%%%%%%%%%%%%%%%%%  'salt & pepper noise'
            str=['f:\results\edge\',picindex{i},'_GS',num2str(gausigma),'_edge.png'];
            imwrite(uint8(rima),str);
            %             rima=double(rima);
            %             ima=double(ima);
            InputI = uint8(rima);
            InputI0 = uint8(rima);
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %% SAMM edge detection
            
            for t1=0.95
                t2=0;
                vse1=2;
                vse2=1;
                
                erosion1 = SAMM_Dynamic_Dilation(InputI,t1,vse1);
                erosion2 = SAMM_Dynamic_Dilation(erosion1,t2,vse2);
                
                dilation1 = SAMM_Dynamic_Dilation(InputI,t1,vse1);
                dilation2 = SAMM_Dynamic_Dilation(dilation1,t2,vse2);
                
                edge = dilation2-erosion2;
                thresh=graythresh(edge);
                edge = imbinarize(edge,thresh);
                figure,imshow(edge);
                
                str2=['f:\results\edge\',picindex{i},'oursdynamic','_edge.png'];
                imwrite(edge,str2);
                
            end
        end
    end
end