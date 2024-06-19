clear;
close all;

% picindex={'Dowels.tif','Rice.png','Toyobjects.png','Checkerboard.png','Plane.png','Boat.png','Cameraman.png','Lena.png','House.png','Peppers.png'};
picindex={'House.png'};
% picindex={'Lena.png','House.png','Toyobjects.png','Checkerboard.png'};

for i=1:length(picindex)   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    fprintf('the %d th picture\n',i);
    str=['f:\SAMM\picture\',picindex{i}];
    ima=imread(str);
    ima=imresize(ima,[256 256]);
    %     ima=imresize(ima,0.5);
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
            str=['f:\results\idempotence\',picindex{i},'_GS',num2str(gausigma),'.png'];
            imwrite(uint8(rima),str);
            %             rima=double(rima);
            %             ima=double(ima);
            InputI = uint8(rima);
            InputI0 = uint8(rima);
            
            SSIM_rima = ssim(uint8(ima),uint8(InputI))
            PSNR_rima = psnr(uint8(ima),uint8(InputI))
            
            MSE43=[];
            MSE42=[];
            MSE33=[];
            MSE34=[];
            
            %% SAMM Dynamic
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            for t1=0.5:0.2:0.9
                t2=0;
                vse1=3;
                vse2=1;
                
                %% opening
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                erosion11 = SAMM_Dynamic_Erosion(InputI0,t1,vse1);
                erosion12 = SAMM_Dynamic_Erosion(erosion11,t2,vse2);
                opening12 = SAMM_Dynamic_Dilation(erosion12,t2,vse2);
                opening11 = SAMM_Dynamic_Dilation(opening12,t1,vse1);
                aaa=opening11;
                error=double(opening11)-double(aaa);
                %                 error=opening11-aaa;
                dy_op_mse=mse(error);
                
                %%%%%%%%%%%%%%%%%%%%%
                for flag=1:300
                    
                    %                     figure,imshow(opening11);
                    str=['f:\results\idempotence\','dynamicopening',picindex{i},num2str(flag),'.png'];
                    imwrite(uint8(opening11),str);
                    InputI=opening11;
                    erosion11 = SAMM_Dynamic_Erosion(InputI,t1,vse1);
                    erosion12 = SAMM_Dynamic_Erosion(erosion11,t2,vse2);
                    opening12 = SAMM_Dynamic_Dilation(erosion12,t2,vse2);
                    opening11 = SAMM_Dynamic_Dilation(opening12,t1,vse1);
                    error=double(opening11)-double(aaa);
                    %                     error=opening11-aaa;
                    dy_op_mse=mse(error);
                    
                    MSE43=[MSE43;dy_op_mse];                  
                   
                end
                
                %%%%%%%%%%%%%%%%%%%
                save('MSE43DATA','MSE43');
                
                %% closing
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                dilation11 = SAMM_Dynamic_Dilation(InputI0,t2,vse2);
                dilation12 = SAMM_Dynamic_Dilation(dilation11,t1,vse1);
                closing12 = SAMM_Dynamic_Erosion(dilation12,t1,vse1);
                closing11 = SAMM_Dynamic_Erosion(closing12,t2,vse2);
                aaa=closing11;
                error=double(closing11)-double(aaa);
                %                 error=closing11-aaa;
                dy_cl_mse=mse(error);
                %%%%%%%%%%%%%%%%%%%%%
                for flag=1:300
                    
                    %                     figure,imshow(closing11);
                    str=['f:\results\idempotence\','dynamicclosing',picindex{i},num2str(flag),'.png'];
                    imwrite(uint8(closing11),str);
                    InputI=closing11;
                    dilation11 = SAMM_Dynamic_Dilation(InputI,t2,vse2);
                    dilation12 = SAMM_Dynamic_Dilation(dilation11,t1,vse1);
                    closing12 = SAMM_Dynamic_Erosion(dilation12,t1,vse1);
                    closing11 = SAMM_Dynamic_Erosion(closing12,t2,vse2);
                    error=double(closing11)-double(aaa);
                    %                     error=closing11-aaa;
                    dy_cl_mse=mse(error);
                    
                    MSE42=[MSE42;dy_cl_mse];
                    %                     DYCLPSNR=psnr(closing11,aaa);
                    %                     MSE9=[MSE9;DYCLPSNR];
                end
                %                 MSE=MSE1
                %%%%%%%%%%%%%%%%%%%
                save('MSE42DATA','MSE42');
                
            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
          
            %% SAMM Fix
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            for t1=0.5:0.2:0.9
                t2=0;
                vse1=2;
                vse2=1;
                
                %% oepning
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                erosion11 = SAMM_Fix_Erosion(InputI,InputI0,t1,vse1);
                erosion12 = SAMM_Fix_Erosion(erosion11,InputI0,t2,vse2);
                opening12 = SAMM_Fix_Dilation(erosion12,InputI0,t2,vse2);
                opening11 = SAMM_Fix_Dilation(erosion11,InputI0,t1,vse1);
                aaa=opening11;
                error1=double(opening11)-double(aaa);
                fi_op_mse=mse(error1);
                MSE33=[MSE33;fi_op_mse];
                
                %%%%%%%%%%%%%%%%%%%%%
                for flag=1:299
                    
                    %                     figure,imshow(opening11);
                    str=['f:\results\idempotence\','fixopening',num2str(flag),'.png'];
                    imwrite(uint8(opening11),str);
                    InputI=opening11;
                    erosion11 = SAMM_Fix_Erosion(InputI,InputI0,t1,vse1);
                    erosion12 = SAMM_Fix_Erosion(erosion11,InputI0,t2,vse2);
                    opening12 = SAMM_Fix_Dilation(erosion12,InputI0,t2,vse2);
                    opening11 = SAMM_Fix_Dilation(erosion11,InputI0,t1,vse1);
                    error=double(opening11)-double(aaa);
                    fi_op_mse=mse(error);
                    
                    
                    MSE33=[MSE33;fi_op_mse];
                end
                %%%%%%%%%%%%%%%%%%%
                save('MSE33DATA','MSE33');
                %% closing
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                dilation11 = SAMM_Fix_Dilation(InputI,InputI0,t2,vse2);
                dilation12 = SAMM_Fix_Dilation(dilation11,InputI0,t1,vse1);
                closing12 = SAMM_Fix_Erosion(dilation12,InputI0,t1,vse1);
                closing11 = SAMM_Fix_Erosion(closing12,InputI0,t2,vse2);
                aaa=closing11;
                error=double(closing11)-double(aaa);
                fi_cl_mse=mse(error);
                MSE34=[MSE34;fi_cl_mse];
                %%%%%%%%%%%%%%%%%%%%%
                for flag=1:299
                    
                    %                     figure,imshow(closing11);
                    str=['f:\results\idempotence\','fixclosing',num2str(flag),'.png'];
                    imwrite(uint8(closing11),str);
                    InputI=closing11;
                    dilation11 = SAMM_Fix_Dilation(InputI,InputI0,t2,vse2);
                    dilation12 = SAMM_Fix_Dilation(dilation11,InputI0,t1,vse1);
                    closing12 = SAMM_Fix_Erosion(dilation12,InputI0,t1,vse1);
                    closing11 = SAMM_Fix_Erosion(closing12,InputI0,t2,vse2);
                    error=double(closing11)-double(aaa);
                    fi_cl_mse=mse(error);
                    
                    MSE34=[MSE34;fi_cl_mse];
                end
                %%%%%%%%%%%%%%%%%%%
                save('MSE34DATA','MSE34');
                
            end
        end
    end
end
