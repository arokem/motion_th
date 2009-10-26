%function [Fix fixx fixy]=chooseFixationType(ty,si,display)
%
%Outputs the fixation stimulus as a NxN Matrix where N is the size of the
%required size of the fixation stimulus in pixels. The matrix is binary,
%where 1 will be drawn and a 0 will not.
%
%%<ty> is the type, to be chosen from the following:
%'rectangle' - makes a hollow square (with a whole in the middle 1/4 of
%the size of the fixation on each side
%'hexagon' - makes a filled hexagon as close to equilateral as
%possible (TODO: calculate that this is indeed the case always)
%'diamond' - makes an equilateral filled diamond
%'square'- makes a filled square
%'circle' - makes a filled equilateral circle ;)
%'ring' - makes a ring (hollow circle)
%'square' - makes a filled square
%%<si> is the size of the fixation in degrees of visual angle
%%<dsiplay> is a display struct, containing the distance from the screen,
%the screen resolution and the display size 
%
%3/1/2007 ASR made it

%TODO: A lot of 'for' loops in here - this could probably be changed into a more intelligent use of   


function Fix = chooseFixationType(ty,si,display)

%Calculate size in pixels: 
s = round(angle2pix(display,si)/2)*2;
%Calculate the size of the margin for some of the hollow stimuli:
margin = max(floor(angle2pix(display,si/4)),1);

[fixx,fixy]  =meshgrid([1:s],[1:s]);

Fix = ones(s);

switch ty

    case 'rectangle'
        Fix([margin+1:size(fixx,1)-margin],[margin+1:size(fixx,2)-margin]) = ...
            0*ones(size(fixx)-margin*2);

    case 'hexagon'
        for kindex=1:s
            for jindex=1:s
                if sum(abs([kindex jindex]-[s/2+0.5 s/2+0.5]))>floor(2/3*s)
                    Fix(kindex,jindex)=0;
                end
            end
        end

    case 'diamond'

        for kindex=1:s
            for jindex=1:s
                if sum(abs([kindex jindex]-[s/2+0.5 s/2+0.5]))>floor(1/2*s)
                    Fix(kindex,jindex)=0;
                end
            end
        end
        
    case 'circle'

        for kindex=1:s
            for jindex=1:s
                if sum(([kindex jindex]-[s/2+0.5 s/2+0.5]).^2)>floor(3*s)
                    Fix(kindex,jindex)=0;
                end
            end
        end

        
    case 'ring'

        for kindex=1:s
            for jindex=1:s
                if sum(([kindex jindex]-[s/2+0.5 s/2+0.5]).^2)>floor(3*s) | sum(([kindex jindex]-[s/2+0.5 s/2+0.5]).^2)<floor(s)
                    Fix(kindex,jindex)=0;
                end
            end
        end

    case 'square'
        %DO NOTHING
        
    otherwise
        disp('WARNING: Fixation type is not properly defined - defaulting to filled square');

        
end


