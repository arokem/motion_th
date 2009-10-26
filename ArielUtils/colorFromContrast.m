function color=colorFromContrast(c,display)

gamma=display.gammaTable/max(max(display.gammaTable)); 

color=gamma(ceil(c.*length(gamma)),:)*255; 

