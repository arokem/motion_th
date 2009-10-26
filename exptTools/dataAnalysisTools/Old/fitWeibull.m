function [L,p]=fitWeibull(v,results)%[L,p]=fitWeibull(v,results)%%Returns L, the likelihood of observing the psychometric%data in x and y, given parameter values v for the Weibull function. %%'x' holds the stimulus intensities used in the staircase.% The first column of y holds the number of correct responses% for each stimulus strenght in x.  The second column holds % the number of incorrect responses.% v = [u,s] where u is the stimulus intensity that will give % 79.37% correct performance.  (.7939 = (1/2)^(1/3), which is % the expected percent correct for a three down, one up staircase.)% s controls the slope of the psychometric function.%Written by G. Boynton in the summer of 96.goodVals = finite(results.response);p=Weibull(v,results.intensity(goodVals));p=(p'*0.99)+.005;L=-log(1-p)*(1-results.response(goodVals))-log(p)*results.response(goodVals);