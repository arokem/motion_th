function screen_grab(window)

im = Screen('GetImage', window);
ax = axes('position',[[0,0],[1,1]]);
imagesc(im)
axis off
chdir('movie_figs')
this_dir = dir;
% compensate for the first few items in the dir:
saveas(ax,strcat(['figure_',num2str(length(this_dir)+1-3),'.png']))
chdir('..')