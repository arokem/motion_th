%motion_th_test.m
%Psycho-physical code to measure motion discrimination thresholds around 8
%orientations, 50 trials for each direction (in ordered blocks).
%The size of the difference is calculated using Pelli's QUEST algorithm.
%031507 ASR made it
%102709 Made this the 'test' version - for pre- and post-learning testing 

if ~isfield(params, 'id')
    params.id = input('Enter subject id: ', 's');
end

fix.size = params.fixationSize; %Is this needed?
fix.type = params.type;
[display]=getScannerDisplay(params.scanner);

setBkColor(display.windowPtr,display.reservedColor,'black');

params.dotVelocity=params.dotVelocity/display.frameRate;

outer = angle2pix(display, params.size(2));
% [x,y] is a mesh grid in visual angle coordinates
xx = linspace(-(params.size(2) + params.RingWidth/2), (params.size(2) + params.RingWidth/2), (outer * 2));
[x,y] = meshgrid(xx);

%make mask here
r = sqrt(x.^2 + y.^2);
circmask = (r < params.size(2)) & (r > params.size(1));

for location = 1:2
    a_small{location} = zeros(length(xx),length(xx))+1;
    angmask = zeros(length(xx),length(xx));
    angmask(1:round(length(xx)/2) , (round(length(xx)/2):length(xx))) = 1;
    %angmask = angmask .* imrotate(angmask,45, 'crop');
    angmask = imrotate(angmask, (-90 * (location - 1)), 'crop') + imrotate(angmask, ((-90 * (location - 1)) -180), 'crop');
    % %     angmask = angmask'; %hack to make this compatible with the assumptions of move_dots
    mask = circmask .* angmask;
    a_small{location} = a_small{location} .* mask;
end

%No spokes and rings?
%image_Rings = makeRings_mas(display,params);
image_Spokes = makeSpokes_OSX(display,params);
image_sta_small = zeros(size(image_Spokes)); % ceil((image_Rings)/2); % + image_Spokes)/2); %insures all values are 0 or 1


%Make fixation:

fixImage = chooseFixationType(fix.type, fix.size, display); %Function in ArielUtils

[fixx fixy]= meshgrid([1:length(fixImage)],[1:length(fixImage)]);
id = (1:prod(size(fixImage)))';
fixCenter = round([size(x,1),size(y,1)]/2);
fixBottom = [floor(fixCenter(2)-length(fixImage)/2)-1, ceil(fixCenter(1)-length(fixImage)/2)];
image_sta_small(size(x,1)*(fixx(id)+fixBottom(1)) + fixy(id)+fixBottom(2)) = fixImage(id);


for loccounter = 1:2
    b_small{loccounter} = zeros(size(a_small{1}));
    btmp = find((1:2) ~= loccounter);
    b_small{loccounter} = b_small{loccounter} + a_small{btmp};
    b_small{loccounter} = ceil(b_small{loccounter}/2); %insures all values are 0 or 1
end


%the display is larger than the image created in the existing code, so it
%has to be fit into the size of the whole screen:

image_sta=zeros(display.numPixels(1),display.numPixels(2)); %initialize
ind_width1=display.numPixels(1)/2-length(image_sta_small)/2;
ind_width2=display.numPixels(1)/2+length(image_sta_small)/2-1;
ind_height1=display.numPixels(2)/2-length(image_sta_small)/2;
ind_height2=display.numPixels(2)/2+length(image_sta_small)/2-1;
image_sta(ind_width1:ind_width2, ind_height1:ind_height2)=image_sta_small;

for location = 1:2
    a{location} = zeros(display.numPixels(1),display.numPixels(2));
    a{location}(ind_width1:ind_width2, ind_height1:ind_height2) =a_small{location};
    b{location} = zeros(display.numPixels(1),display.numPixels(2));
    b{location}(ind_width1:ind_width2, ind_height1:ind_height2) = b_small{location};
end

%Transform into x,y coordinates:

image_sta_xy=zeros(2,length(find(image_sta>=1)));
k=1;

for x=1:display.numPixels(1)
    for y=1:display.numPixels(2)
        if image_sta(x,y)>0
            image_sta_xy(:,k)=[x y];
            k=k+1;
        end
    end
end

pThreshold=0.70;
beta=3.5;delta=0.01;gamma=0.5;
tGuess=log10(params.QuestTGuess/params.maxTheta);
tGuessSd= params.QuestTGuessSd;


for sesscounter = 1:params.numberScans

    q=QuestCreate(tGuess,tGuessSd,pThreshold,beta,delta,gamma);
    q.normalizePdf=1; %This is important for some reason. '

    scanHistory = doScan_motion_th(display, image_sta_xy, a, b, params,sesscounter,q);

    if sesscounter == 1
        newsession = 1;
    else
        newsession = 0;
    end

    UpdateResults_OSX('motion_th',params,scanHistory,newsession);


end

Screen('CloseAll')
Priority(0);
ShowCursor;