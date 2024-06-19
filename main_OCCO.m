clear;
close all;

picindex={'Toyobjects.png','Checkerboard.png','Plane.png','Boat.png','Cameraman.png','Lena.png','House.png','Peppers.png'};

for i=1:length(picindex)   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    fprintf('the %d th picture\n',i);
    str=['e:\SAMM\picture\',picindex{i}];
    ima=imread(str);
    if length(size(ima))>2
        ima=rgb2gray(ima);
    end
    
    %     ima=double(ima);
    %     for imp=[0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5]
    for imp=0
        for gausigma=10:10:50
            
            rand('state',0);
            gima=double(ima)+gausigma*randn(size(double(ima)));%mixed noise
            rima = imnoise(uint8(gima),'salt & pepper',imp);   %%%%%%%%%%%%%%%%%%%%%%%%%  'salt & pepper noise'
            %             str=['f:\results\',picindex{i},'_GS',num2str(gausigma),'_occo.png'];
            %             imwrite(uint8(rima),str);
            %             rima=double(rima);
            %             ima=double(ima);
            InputI = uint8(rima);
            
            %             SSIM_rima = ssim(uint8(ima),uint8(InputI))
            %             PSNR_rima = psnr(uint8(ima),uint8(InputI))
            
            %% SAMM
            for t1=1-0.002*gausigma
                t2=0;
                vse1=2;
                vse2=2;
                
                erosion11 = SAMM_Dynamic_Erosion(InputI,t1,vse1);
                erosion12 = SAMM_Dynamic_Erosion(erosion11,t2,vse2);
                
                opening12 = SAMM_Dynamic_Dilation(erosion12,t2,vse2);
                opening11 = SAMM_Dynamic_Dilation(opening12,t1,vse1);
                
                dilation12 = SAMM_Dynamic_Dilation(opening11,t2,vse2);
                dilation11 = SAMM_Dynamic_Dilation(dilation12,t1,vse1);
                
                reconstruction11 = SAMM_Dynamic_Erosion(dilation11,t1,vse1);
                reconstruction12 = SAMM_Dynamic_Erosion(reconstruction11,t2,vse2);
                
                
                dilation21 = SAMM_Dynamic_Dilation(InputI,t1,vse1);
                dilation22 = SAMM_Dynamic_Dilation(dilation21,t2,vse2);
                
                closing22 = SAMM_Dynamic_Erosion(dilation22,t2,vse2);
                closing21 = SAMM_Dynamic_Erosion(closing22,t1,vse1);
                
                erosion22 = SAMM_Dynamic_Erosion(closing21,t2,vse2);
                erosion21 = SAMM_Dynamic_Erosion(erosion22,t1,vse1);
                
                reconstruction21 = SAMM_Dynamic_Dilation(erosion21,t1,vse1);
                reconstruction22 = SAMM_Dynamic_Dilation(reconstruction21,t2,vse2);
                
                
                reconstruction = (double(reconstruction12)+double(reconstruction22))/2;
                figure,imshow(uint8(reconstruction));title('reconstruction');
                
                SSIM_reconstruction = ssim(uint8(ima),uint8(reconstruction))
                PSNR_reconstruction = psnr(uint8(ima),uint8(reconstruction))
                
            end
        end
    end
end
