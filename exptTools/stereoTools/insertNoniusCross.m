function [left,right] = insertNoniusCross(left,right,radius,twoColors)%[left,right] = insertNoniusCross(left,right,radius,twoColors)% inserts nonius lines into disparity images along with a% binocular fixation cross% radius: half-size of image (true size is [2*radius+1,2*radius+1], default=9% twoColors gives color of background and lines (default [0 1])% DJFif ~exist('radius')  radius=7;endif radius < 6 error('radius argument must be at least 6.'); endwidth=2*radius+1;if ~exist('twoColors')  twoColors=[0 1];end%get image sizes, and center locationsm = size(left,1);n = size(left,2);mdiv2=round(m/2);ndiv2=round(n/2);%insert black box in center:%black box alonebox = twoColors(1)*ones(2*radius+1,2*radius+1);box(radius:radius+2,radius+1)=twoColors(2)*ones(3,1);box(radius+1,radius:radius+2)=twoColors(2)*ones(1,3);leftBox=box;leftBox(radius-5:radius-2,radius+1)=twoColors(2)*ones(4,1);leftBox(radius+1,radius-5:radius-2)=twoColors(2)*ones(1,4);leftBox(1,:)=twoColors(2)*ones(1,width);leftBox(width,:)=twoColors(2)*ones(1,width);leftBox(:,1)=twoColors(2)*ones(width,1);leftBox(:,width)=twoColors(2)*ones(width,1);rightBox=fliplr(flipud(leftBox));%insert nonious linesfor frameNum = 1:size(left,3)	left(mdiv2-radius:mdiv2+radius,ndiv2-radius:ndiv2+radius,frameNum)=leftBox;	right(mdiv2-radius:mdiv2+radius,ndiv2-radius:ndiv2+radius,frameNum)=rightBox;end