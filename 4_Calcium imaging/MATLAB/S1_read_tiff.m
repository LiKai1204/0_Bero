% RCaMP Analyzer 
% 180214 by S. Baba 
% Roi���l�p�`�Ŏw�肵����A���̗̈撆�̋P�x�̍������300pixel��ΏۂɁA
% ���ς�dF/F0���Z�o���ăO���t�ɕ`�悷��B
% F0�͐F���ƎˑO��5F�̕��ϒl���Ƃ�B���ŏ���1farame�͊܂߂Ȃ� �F���Ǝ˒��O��5frame�@191226 modified by A. Tsumadori
% 200305 modified by Tsumadori Roi color, Roi text color, Font Size(fig.3),
% x���\���͈�(BL�Ǝ�6�b�O��� fig.3),Blue light ON������Box�������쐬���̑��ׂ��Ȍv�Z��@���C��
% 201221 save����Ńf�[�^�ʂ��傫������ꍇ�ɕۑ��ł��Ȃ��Ȃ�s����C���@
% 201225�@F0�v�Z�������ƎˑO5�b�ԂɏC��
% F0�̒�`���u���ƎˑO50frame�̂����������ق�����5frame���o���Ă��̒����l�v�ɕύX�@220117 by Tsukasa
% Roi���l�p�`�Ŏw�肵����A���̗̈撆�̋P�x�̍������200pixel��ΏۂɁA�@220610 by Tsukasa
%% Default setting -----------------------------------------------------------------
close all% Figure��S�ĕ���
clear% ���[�N�X�y�[�X�̕ϐ��ꗗ���폜
set(0,'defaultAxesFontSize',10);
set(0,'defaultAxesFontName','Arial');
set(0,'defaultTextFontSize',10);
set(0,'defaultTextFontName','Arial');
scrsz = get(groot,'ScreenSize');
%% Loading ---------------------------------------------------------
% ���h�����O�̃t���[��,fps(img.fps,�P�ʂ�Hz),�ώ@����Roi�̐����w�肷��
img.Frame0 = 250;
img.fps = 1;
nRoi = 7;

% img.raw{:,1}�Ƀt���[�����̎B�e�f�[�^���i�[�����
% Fnum�ɑ��t���[�������i�[�����
NAME1=uigetfile('*.tif');        
bI = bfopen([pwd,'\',NAME1]);        
img.Fnum = length(bI{1,1});
for i = 1:img.Fnum
    img.raw_img{i,1}=double(bI{1,1}{i,1});
end
clear bI
Timescale=(1-img.Frame0)*(1/img.fps):(1/img.fps):(img.Fnum-img.Frame0)*(1/img.fps);
%% Making projection -----------------------------------------------
% img.raw{:,1}�Ɠ����L�����o�X�T�C�Y��img.proj�����
% ���f�[�^��z-project(Ave)���v�Z���ĕۑ�����
img.proj = zeros(size(img.raw_img{1,1}));
        for i = 1:img.Fnum
            img.proj = img.proj + img.raw_img{i,1};
        end
img.proj=img.proj./img.Fnum;

%% Getting ratio ---------------------------------------------------        
% Roi�̐F�̐ݒ� (Max15�F)�A�o�b�N�O���E���h�p�ɍŌ��roi�̐F�̓O���[�ɂȂ�B  
colorRoi =[     1         0         0;
                0         1         0;
                0         0         1;
                1         1         0;
                1         0         1;
                0         1         1;
                0    0.4470    0.7410;               
           0.8500    0.3250    0.0980;
           0.9290    0.6940    0.1250;
           0.4940    0.1840    0.5560;
           0.4660    0.6740    0.1880;
           0.3010    0.7450    0.9330;
           0.6350    0.0780    0.1840;
              0.5       0.5       0.5];         
colorRoi(nRoi,:)=0.75;

% ��������̈���}�E�X�őI����Roi�f�[�^�Ƃ���img.roi(nRoi).region�Ɋi�[
figure; imagesc(img.proj);  axis('image','off');
img.roi = struct;
for iRoi=1:nRoi
    img.roi(iRoi).region = round(getrect);
     hold on
     rectangle('position',img.roi(iRoi).region,'edgecolor',colorRoi(iRoi,:));
end

 for iRoi = 1:nRoi
% Roi�f�[�^����ARoi���W��(Regionx,Regiony)���쐬
% Roi���W������Roi�̈�ɂP�C��Roi�̈��0���i�[�����s��f�[�^�APreRoi�}�X�N���쐬����
    Regionx=img.roi(iRoi).region(1):(img.roi(iRoi).region(1)+img.roi(iRoi).region(3));
    Regiony=img.roi(iRoi).region(2):(img.roi(iRoi).region(2)+img.roi(iRoi).region(4));
    Roi=zeros(size(img.proj));  
    Roi(Regiony,Regionx) = 1;  
     
    if iRoi == nRoi
    % (if:�o�b�N�O���E���h�p�̃X�N���v�g�A�I��������̂܂�Roi�Ƃ��A1pixel�̕��ϋP�x�l��F_temp�ֈꎞ�ۑ�)   
        roisize_total = sum(Roi(:));
       for i = 1:img.Fnum
           img.roi(iRoi).map=img.raw_img{i,1}.*Roi;
           F_temp(i) = sum(sum(img.roi(iRoi).map))/roisize_total;
       end  
       
    else
    %(else: �V�O�i���p�̃X�N���v�g�B�̈撆���200pixel�̋P�x�l�𒊏o���ĕ��ω�����)    
    %�e�t���[���őI��̈�𕂂�����ɂ��A�x�N�g���f�[�^�ɒ�������~���ɕ��בւ��A���200�𕽋ω����AF_temp�ֈꎞ�ۑ��B
       for ind = 1:img.Fnum
           vec_temp=img.raw_img{ind,1}.*Roi;
           vec_temp=vec_temp(:);
           vec_temp=sort(vec_temp,'descend');  
           F_temp(ind,1) = sum(vec_temp(1:200))/200   ;
       end
        vec_temp1=img.raw_img{1,1}.*Roi;
       vec_temp1=vec_temp1(:);
       vec_temp1=sort(vec_temp1,'descend'); 
       vec(iRoi,:)=  vec_temp1(1:2000);  
    end   
% F0�̒�`���u���ƎˑO50frame�̂����������ق�����5frame���o���Ă��̒����l�v�ɕ�
    Fs=sort(F_temp((img.Frame0-49):img.Frame0));   %����ύX
    F0=median(Fs(1:5)) ;
    img.roi(iRoi).raw(:,1) = F_temp;
    img.roi(iRoi).raw(1,2)=F0; 
 end
 filename=NAME1(1:length(NAME1)-4)
clear Mx Mxs MxInd MxY MxX F_temp F0 PreRegionx PreRegiony regionx regiony Roi PreRoiFs

%% Figure 0: intensity per pixels
figure('Position',[500 100 scrsz(3)*6/10 scrsz(4)*5/10])
for iRoi = 1:nRoi-1
    plot(vec(iRoi,:),'LineWidth',1.5,'color',colorRoi(iRoi,:))
    hold on   
end
ylim([0 4000])
% ylim([0 max(img.roi(1).raw(:,1))])
set(gca,'YTick',0:500:4000)
set(gca,'TickDir','out','Ticklength',[0.02 0])% Others
set(gca,'Color','none')
box off
savefig([filename '_pix']);

%% Figure 1: Whole image and ROIs
figure('Position',[50 100 scrsz(3)*3/10 scrsz(4)*5/10])
imagesc(img.proj);
axis('image','off')
for iRoi = 1:nRoi
    hold on
    rectangle('position',img.roi(iRoi).region,'LineWidth',1,'edgecolor',colorRoi(iRoi,:));
    text(img.roi(iRoi).region(1)+3,img.roi(iRoi).region(2)+7,[num2str(iRoi)],'color','w','FontSize',12)
end
title(NAME1,'interpreter','none');
savefig([filename '_img']);

%% Figure 2:Raw Ca2+ dynamics of each ROI
figure('Position',[500 100 scrsz(3)*4/10 scrsz(4)*5/10])
for iRoi = 1:nRoi
    Time = Timescale;
    plot(Time,img.roi(iRoi).raw(:,1),'LineWidth',1.5,'color',colorRoi(iRoi,:))
    hold on   
end
xlim([-250 max(Time)])% ���͈̔�
ylim([0 4000])
set(gca,'XTick',-250:50:250)% ���̖ڐ���Ԋu
set(gca,'YTick',00:500:4000)
xlabel('Time(sec)')% �����x��
ylabel('Intensity')
title(NAME1,'interpreter','none');% �^�C�g��
set(gca,'TickDir','out','Ticklength',[0.03 0])% Others
set(gca,'Color','none')
box off
axis square
savefig([filename '_raw']);

%% Figure 3:��FF0 Ca2+ dynamics of each ROI
figure('Position',[800 100 scrsz(3)*4/10 scrsz(4)*5/10])
bs=sort(img.roi(nRoi).raw((img.Frame0-49):img.Frame0,1));
b0=median(bs(1:5));   
back_incre = (img.roi(nRoi).raw(:,1)-b0);
for iRoi = 1:nRoi-1
    Time=Timescale;    
    F0=img.roi(iRoi).raw(1,2) ;     
    img.roi(iRoi).sub_back=(img.roi(iRoi).raw(:,1)-F0-back_incre)/F0; %signnal�ʂ�ratio�Ȃ̂ɑ΂�back_incre�͋��x�Ȃ̂ŁA���ꂪ�������Ȃ�悤F0�Ŋ���
    plot(Time,img.roi(iRoi).sub_back*100,'LineWidth',1.5,'color',colorRoi(iRoi,:));
    hold on
end

    

patch([0 2.5 2.5 0],[-300 -300 500 500], 'b','FaceAlpha',.2,'EdgeColor','none')
xlim([-50 50])% ���͈̔�
ylim([-20 200])
set(gca,'XTick',-50:10:50,'FontSize',18)% ���̖ڐ���Ԋu
set(gca,'YTick',-20:20:200,'FontSize',14)
xlabel('Time(sec)','FontSize',14)% �����x��
ylabel('\DeltaF/F_{0} (%)','FontSize',14)
title(NAME1,'interpreter','none');% �^�C�g��
set(gca,'TickDir','out','Ticklength',[0.03 0])% Others
set(gca,'Color','none')
box off
axis square

savefig([filename '_cal']);

clear  b0 back_incre colorRoi F0 i ind iRoi NAME1  Regionx Regiony roisize_total scrsz Time Timescale vec_temp bs
%% Saving
 img.raw_img =[];
%  NAME1=uigetfile('*.tif');  
%  filename=NAME1(1:length(NAME1)-4);
 pathname='D:\Tsuksa Data\bero\ABLK\Ca imaging\MATLAB\ABLK file\Part-I'
 save(fullfile(pathname, filename));
 



 %save -v7.3 ([filename '.mat']);
%save([filename '2']);


