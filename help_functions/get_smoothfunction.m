%Take matrix (r,f or t) and calculate smoothing functions for Maximum in r
%and f or t
%A smoothfunction is used to get rid of sharp edges that cuase problems in
%fourier transform e.g. FFT(smoothfct*stepfct) as well as noise
function [r_smoothfct,f_smoothfct]=get_smoothfunction(mesh,E,type)
%find max
[maxf,imaxf]=max(max(abs(E).^2,[],1),[],2);
[maxr,imaxr]=max(max(abs(E).^2,[],2),[],1);
%index for values below threshold in r and f
rbound=find(abs(E(:,imaxf).^2)<maxr/exp(4),1);
fbound=find(abs(E(imaxr,:).^2)>maxf/exp(4),1);

halfwidthR=mesh.dr*abs(rbound)+(mesh.rmin-mesh.dr);
% halfwidthF=mesh.df*abs(mesh.fbound-fbound);
LRbounds=find_bounds(E);
halfwidthF=mesh.df.*(LRbounds(1,3)-LRbounds(1,1));


if isempty(rbound)
    halfwidthR=inf;
end
if isempty(fbound)
    halfwidthF=0;
end
%calculate the smoothing function
switch type
    case 'supergaussian'
    r_smoothfct=calc_supergaussian(mesh.r,halfwidthR.*3.5,10,0);
    r_smoothfct=handle_NaNInf(r_smoothfct');
    f_smoothfct=handle_NaNInf(calc_supergaussian(mesh.f,halfwidthF,10,mesh.df*(LRbounds(1,2)-mesh.indexfmid)));
end

end