% jRCaMP intensity of before and after stimulation
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
img.FrameBefore = 250;
img.FrameAfter = 255;
img.fps = 1;
clims = [0 2500];
clims_res = [0 2];
% nRoi = 1;

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
filename=NAME1(1:length(NAME1)-4);
%% Image Before
figure('Position',[50 100 scrsz(3)*3/10 scrsz(4)*5/10])
imagesc(img.raw_img{img.FrameBefore,1}, clims);
axis('image','off')
colorbar
savefig([filename '_img_before'])
%% Image After
figure('Position',[50 100 scrsz(3)*3/10 scrsz(4)*5/10])
imagesc( img.raw_img{img.FrameAfter,1}, clims);
axis('image','off')
colorbar
savefig([filename '_img_after'])
%% Making Response
img.delta = img.raw_img{img.FrameAfter,1} -  img.raw_img{img.FrameBefore,1} ;
img.res = img.delta ./ img.raw_img{img.FrameBefore,1};

%% Image Response
figure('Position',[50 100 scrsz(3)*3/10 scrsz(4)*5/10])
imagesc(img.res, clims_res);
axis('image','off')
colorbar
savefig([filename '_img_res'])
