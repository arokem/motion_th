%function d=d_prime(ht,ms,cr,fa)
%Calculates d' for arrays containing the number of hits(ht), misses(ms),
%correct rejections(cr) and false alarms(fa)
%The formula used is: d'=Z(prop. hits)-Z(prop. false alarms), where Z is the Z score
%associated with the proportion of hits/false alarms relative to the number
%of trials in which there was or wasn't a stimulus. When no misses were
%recorded prop. hits= (#hits-0.5)/#hits and when no false
%alarms were recorded prop. false alarms = 0.5/#correct rejections, per
%definition.
%%NOTE: THERE IS A FUNCTION CALLED dPrime that does something very
%%similar!
%
%021407 ASR wrote it

function d=d_prime(ht,ms,fa,cr)

if ms
    htprop=ht./(ht+ms);
else
    htprop=(ht-0.5)./(ht);
end

if fa
    faprop=fa./(fa+cr);

else
    faprop=0.5./(cr);
end

Zfa=norminv(faprop);
Zht=norminv(htprop);

d=Zht-Zfa;
