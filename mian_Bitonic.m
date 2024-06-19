clear;
close all;

picindex={'Toyobjects.png','Checkerboard.png','Plane.png','Boat.png','Cameraman.png','Lena.png','House.png','Peppers.png'};

for i=1:length(picindex)   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    fprintf('the %d th picture\n',i);
    str=['f:\SAMM\picture\',picindex{i}];
    ima=imread(str);
    if length(size(ima))>2
        ima=rgb2gray(ima);
    end
    
    ima=double(ima);
    %         for imp=[0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5]
    for imp=0
        for gausigma=[5 10 15 20 25 30 35 50 75 100]
            
            rand('state',0);
            gima=ima+gausigma*randn(size(ima));%mixed noise
            rima = imnoise(uint8(gima),'salt & pepper',imp);   %%%%%%%%%%%%%%%%%%%%%%%%%  'salt & pepper noise'
            %             str=['f:\results\',picindex{i},'_GS',num2str(gausigma),'_bitonic.png'];
            %             imwrite(uint8(rima),str);
            %             rima=double(rima);
            %             ima=double(ima);
            InputI = uint8(rima);
            
            %             SSIM_rima = ssim(uint8(ima),uint8(InputI))
            %             PSNR_rima = psnr(uint8(ima),uint8(InputI))
            
            %% SAMM
            for t1=1-0.005*gausigma
                t2=0;
                vse1=2;
                vse2=2;
                
                erosion1 = SAMM_Dynamic_Erosion(InputI,t1,vse1);
                erosion2 = SAMM_Dynamic_Erosion(erosion1,t2,vse2);
                
                opening2 = SAMM_Dynamic_Dilation(erosion2,t2,vse2);
                opening1 = SAMM_Dynamic_Dilation(opening2,t1,vse1);
                
                dilation1 = SAMM_Dynamic_Dilation(InputI,t1,vse1);
                dilation2 = SAMM_Dynamic_Dilation(dilation1,t2,vse2);
                
                closing1 = SAMM_Dynamic_Erosion(dilation2,t2,vse2);
                closing2 = SAMM_Dynamic_Erosion(closing1,t1,vse1);
                
                erroropening = double(InputI) - double(opening1);
                errorclosing = double(closing2) - double(InputI);
                smoothedopening = abs(imgaussfilt(erroropening,2))+0.1;
                smoothedclosing = abs(imgaussfilt(errorclosing,2))+0.1;
                
                ssmoothedopening = smoothedclosing ./(smoothedclosing+smoothedopening);
                ssmoothedclosing = smoothedopening ./(smoothedclosing+smoothedopening);
                
                reconstruction = ((smoothedclosing.*double(opening1))./(smoothedclosing+smoothedopening))+((smoothedopening.*double(closing2))./(smoothedclosing+smoothedopening));
                figure,imshow(uint8(reconstruction));title('reconstruction');
                
                SSIM_reconstruction = ssim(uint8(ima),uint8(reconstruction))
                PSNR_reconstruction = psnr(uint8(ima),uint8(reconstruction))
                
            end
        end
    end
end