function y = mmax(x);%y = mmax(x)%    returns maximum value of matrix x - ACROSS ALL DIMENSIONS.%    SEE ALSO mmin%10/21/97 gmb  Wrote it.%note the tricky recursion!y = max(x);if max(size(y)) ~= 1	y = mmax(y);end