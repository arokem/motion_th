% Compare two gun steps at center for R G B  and Wload rcenter;load gcenter;load bcenter;figure;plot(rcenter(:,1), rcenter(:,2),'r-', ...     gcenter(:,1), gcenter(:,2), 'g-', ...     bcenter(:,1), bcenter(:,2), 'b');% compare spectrum across different locations.% red gunload rcenter;load rtop;load rbottom;load rright;load rleft;figure;plot(rcenter(:,1), rcenter(:,2),'r-', ...     rtop(:,1),    rtop(:,2),    'g-', ...     rbottom(:,1), rbottom(:,2), 'b', ...     rright(:,1), rright(:,2), 'y', ...     rleft(:,1), rleft(:,2), 'w');% green gunload gcenter;load gtop;load gbottom;load gright;load gleft;figure;plot(gcenter(:,1), gcenter(:,2),'r-', ...     gtop(:,1),    gtop(:,2),    'g-', ...     gbottom(:,1), gbottom(:,2), 'b', ...     gright(:,1), gright(:,2), 'y', ...     gleft(:,1), gleft(:,2), 'w');% blue gunload bcenter;load btop;load bbottom;load bright;load bleft;figure;plot(bcenter(:,1), bcenter(:,2),'r-', ...     btop(:,1),    btop(:,2),    'g-', ...     bbottom(:,1), bbottom(:,2), 'b', ...     bright(:,1), bright(:,2), 'y', ...     bleft(:,1), bleft(:,2), 'w');