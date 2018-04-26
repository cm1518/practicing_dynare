// Estimates the Hansen Sargent and Tallarini model by maximum likelihood.

var s c h k i d dhat dbar mus muc muh gamma R;
varexo e_dhat e_dbar;

parameters lambda deltah deltak mud b bet phi1 phi2 cdbar alpha1 alpha2 cdhat;
bet=0.9971;
deltah=0.682;
lambda=2.443;
alpha1=0.813;
alpha2=0.189;
phi1=0.998;
phi2=0.704;
mud=13.710;
cdhat=0.155;
cdbar=0.108;
b=32;
deltak=0.975;

model(linear);
R=deltak+gamma;
R*bet=1;
s=(1+lambda)*c-lambda*h(-1);
h=deltah*h(-1)+(1-deltah)*c;
k=deltak*k(-1)+i;
c+i=gamma*k(-1)+d;
mus=b-s;
muc=(1+lambda)*mus+(1-deltah)*muh;
muh=bet*(deltah*muh(+1)-lambda*mus(+1));
muc=bet*R*muc(+1);
d=mud+dbar+dhat;
dbar=(phi1+phi2)*dbar(-1) - phi1*phi2*dbar(-2) + cdbar*e_dbar;
dhat=(alpha1+alpha2)*dhat(-1) - alpha1*alpha2*dhat(-2) + cdhat*e_dhat;
end;

shocks;
var e_dhat;
stderr 1;
var e_dbar;
stderr 1;
end;

// stoch_simul(irf=0, periods=500);
// save dataHST c i;

estimated_params;
bet, .91, .9, .99999;
deltah, 0.4, 0.1, 0.8;
lambda, 2, 0.1, 50;
alpha1, 0.8, 0.6, 0.99999;
alpha2, 0.2, 0.01, 0.5;
phi1, 0.8, 0.6, 0.99999;
phi2, 0.5, 0.3, 0.9;
mud, 10, 1, 50;
cdhat, 0.1, 0.05, 0.2;
cdbar, 0.1, 0.05, 0.2;

end;

varobs c i;
estimation(datafile=dataHST,first_obs=1,nobs=500,mode_compute=4,mode_check);

