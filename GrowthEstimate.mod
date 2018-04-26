
var c k lab z;
varexo e;

parameters bet del alp rho the tau s;

bet     = 0.987;
the     = 0.357;
del     = 0.012;
alp     = 0.4;
tau     = 2;
rho     = 0.95;
s       = 0.007;

model; 
    (c^the*(1-lab)^(1-the))^(1-tau)/c=bet*((c(+1)^the*(1-lab(+1))^(1-the))^(1-tau)/c(+1))*(1+alp*exp(z(+1))*k^(alp-1)*lab(+1)^(1-alp)-del);
    c=the/(1-the)*(1-alp)*exp(z)*k(-1)^alp*lab^(-alp)*(1-lab);
    k=exp(z)*k(-1)^alp*lab^(1-alp)-c+(1-del)*k(-1);
    z=rho*z(-1)+s*e;
end;

initval;
k   = 1;
c   = 1;
lab = 0.3;
z   = 0;
e   = 0;
end;

shocks;
var e;
stderr 1;
end;

estimated_params;
stderr e, inv_gamma_pdf, 0.95,30;
rho, beta_pdf,0.93,0.02;
the, normal_pdf,0.3,0.05;
tau, normal_pdf,2.1,0.3;
end;

varobs c;

estimation(datafile=simudata,mh_replic=1000,mh_jscale=0.9,nodiagnostic);
