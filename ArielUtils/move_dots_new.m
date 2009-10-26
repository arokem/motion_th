%This function moves dots for a given number of frames (fram) within a
%defined area (a - a vector of 0's and 1's representing the whole screen.
%0 is outside of the defined area and 1 is within that area) of the window
%(given as win_id. The dots will have a certain density given by dens in
%pixels per dot) and a certain size (siz, in pixels). They move in a
%certain direction (dir, in degrees clockwise relative to up) in a certain
%coherence (coh - from 0 to 1, denoting the proportion of coherently moving dots)
%Also, optionally, in another area of the screen, b, there is incoherent
%dot motion.
%how_many_frames - how many frame changes before a dot 'jumps' to a
%location in the area not immediatley adjacent to where it was before
%NEW AND IMPROVED!
%If there is a stimulus with 100% coherence, the life-time of the dots is
%still limited. ASR 8/18/06
%9/6/06 ASR: commented out time-consuming while loops that are supposed to
%make sure that dots don't overlap
%9/5/07 ASR: added parameter "contrast" to the params, such that dots can
%be less than 100% contrast. Added to the call to drawdots the rgb values
%as determined by the if structure at the very beginning of the function


function move_dots_new(window, fram, a, b, dens, vel, coh, siz, dir, how_many_frames, display, params, image_sta)

white = WhiteIndex(window);

if isfield(params,'contrast')
    
    color=colorFromContrast(params.contrast,display);

else

    color=white;

end


[a_ind_x a_ind_y]=find(a==1);%vectors with the x- and y-indices of the locations in a that can include dots

[b_ind_x b_ind_y]=find(b==1);%another area on screen that has a DRD, but no coherent dots

num_of_dots_a=floor(sum(sum(a))/dens);
num_of_dots_b=floor(sum(sum(b))/dens);

%In order to put out random dots on the screen, generate random locations
%from the possible locations:

gen_rand=zeros(1,num_of_dots_a);
gen_rand(1)=ceil(rand*length(a_ind_x));

%Each dot has to have a different location:
for i=2:num_of_dots_a
    gen_rand(i)=ceil(rand*length(a_ind_x));
    % while find(gen_rand(1:i-1)==gen_rand(i))
    %     gen_rand(i)=ceil(rand*length(a_ind_x));
    % end
end

%The xy locations can then be extracted into a 2Xnum_of_dots long vector
%which holds the x and y coordinates for each dot.

dot_loc_a=[a_ind_x(gen_rand(1:num_of_dots_a)) a_ind_y(gen_rand(1:num_of_dots_a))];

gen_rand=zeros(1,num_of_dots_b);
gen_rand(1)=ceil(rand*length(a_ind_x));

%Each dot has to have a different location:
for i=2:num_of_dots_b
    gen_rand(i)=ceil(rand*length(b_ind_x));

    %while find(gen_rand(1:i-1)==gen_rand(i))
    %    gen_rand(i)=ceil(rand*length(b_ind_x));
    %end
end

dot_loc_b=[b_ind_x(gen_rand(1:num_of_dots_b)) b_ind_y(gen_rand(1:num_of_dots_b))];

white = WhiteIndex(window);
%Put the first set of dots up on the screen:
Screen('DrawDots', window,[dot_loc_a' dot_loc_b'],siz,color,[],1)
%Usage of DrawDots: Screen('DrawDots', windowPtr, xy [,size] [,color] [,center] [,dot_type]);
Screen('Flip', window);

%In each new frame a certain proportion of the dots moves together
%coherently. We can choose every nth dot (where n is 1/coh) to move
%coherently


if coh>0
    mod_factor=ceil(1/coh);
else
    mod_factor=num_of_dots_a;
end

% Calculate the distance in pixels in the x and in the y direction to move
% the coherently moving dots in each framechange

dy=round(-1*vel*cos((dir)*(2*pi/360)));
dx=round(vel*sin((dir)*(2*pi/360)));

% Loop over all the frames:
for f=1:fram
    % First determine the new location of the coherently moving dots
    for k=1:length(dot_loc_a)
        % Each frame we want to choose a different set of dots to move
        % coherently. This way we cycle across different sets:


        if mod(k+f,mod_factor)==0
            dot_loc_a(k,1)=dot_loc_a(k,1)+dx;
            dot_loc_a(k,2)=dot_loc_a(k,2)+dy;
        end
        %If the dot happens to fall off the area assigned, give it another
        %location within the assigned area:

        if(a(dot_loc_a(k,1),dot_loc_a(k,2))==0)
            get_rand=ceil(rand*length(a_ind_x));
            dot_loc_a(k,:)=[a_ind_x(get_rand) a_ind_y(ceil(get_rand))];
        end

        %% In the special case of coherence = 100% we need to force dots to
        %% have a short life time (otherwise they would live forever...):
        if (mod_factor==1 && rand<(1/(how_many_frames)))
            get_rand=ceil(rand*length(a_ind_x));
            dot_loc_a(k,:)=[a_ind_x(get_rand) a_ind_y(ceil(get_rand))];
        end
    end

    %Now determine new random locations for the rest of the dots

    for m=1:length(dot_loc_a)

        %This chooses the non-coherently moving dots:

        if mod(m+f,mod_factor)~=0

            %Do we want the other dots to move incoherently or jump to
            %another location alltogether? Now they move incoherently:

            ran_angle=rand*360;
            dy_ran=vel*cos((ran_angle)*(2*pi/360));
            dx_ran=vel*sin((ran_angle)*(2*pi/360));
            dot_loc_a(m,1)=dot_loc_a(m,1)+round(dx_ran);
            dot_loc_a(m,2)=dot_loc_a(m,2)+round(dy_ran);

            % In two cases, the dot has to be reassigned a position:
            % if it has moved in its trajectory for a while (how long? That can
            % be tweaked by changing the proportion rand is compared to) and the
            % other is if it goes outside of the area.

            if(rand<(1/(how_many_frames)) || a(dot_loc_a(m,1),dot_loc_a(m,2))==0)
                get_rand=ceil(rand*length(a_ind_x));
                dot_loc_a(m,:)=[a_ind_x(get_rand) a_ind_y(ceil(get_rand))];
            end
        end
    end

    %In area b all dots are incoherently moving

    for m=1:length(dot_loc_b)
        ran_angle=rand*360;
        dy_ran=vel*cos((ran_angle)*(2*pi/360));
        dx_ran=vel*sin((ran_angle)*(2*pi/360));
        dot_loc_b(m,1)=dot_loc_b(m,1)+round(dx_ran);
        dot_loc_b(m,2)=dot_loc_b(m,2)+round(dy_ran);

        %Again - dots outside the area or whos lifetime is up need to be reassigned

        if(rand<(1/(how_many_frames)) || b(dot_loc_b(m,1),dot_loc_b(m,2))==0)
            get_rand=ceil(rand*length(b_ind_x));
            dot_loc_b(m,:)=[b_ind_x(get_rand) b_ind_y(ceil(get_rand))];
        end

    end


    % After all dots have a location - draw the dots on the screen:
    % USAGE: Screen('DrawDots', windowPtr, xy [,size] [,color] [,center] [,dot_type]);
    Screen('DrawDots', window,[dot_loc_a' dot_loc_b'], siz, color ,[],1);
    Screen('DrawDots', window, image_sta, siz,white,[],1)
    Screen('Flip', window);
end

%erase dots
Screen('DrawDots', window,image_sta, siz,white,[],1)
Screen('Flip', window);