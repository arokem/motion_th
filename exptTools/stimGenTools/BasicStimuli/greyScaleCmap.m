function cmap = greyScaleCmap(display)%cmap = greyScaleCmap(display)[lowCol,highCol]=getFreeColors(display);cmap = zeros(display.numColors,3);cmap = insertReservedCols(display,cmap);f = linspace(0,255,highCol-lowCol+1)';cmap(lowCol+1:highCol+1,1)= f;cmap(lowCol+1:highCol+1,2)= f;cmap(lowCol+1:highCol+1,3)= f;