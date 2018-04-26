var x y;
varexo e_x e_u; 

parameters  rho sig_x sig_u mu_y; 

rho = .98;
mu_y=.015;
sig_x=0.00025;
sig_u=.0078;

model(linear);
x=rho*x(-1) + sig_x*e_x;
y=mu_y + x(-1) + sig_u*e_u;
end;

initval;
x=0;
y=mu_y;
end;

steady;

shocks;
var e_x;
stderr 1;
var e_u;
stderr 1;
end;

estimated_params;

rho, beta_pdf, .98, .01;
mu_y, uniform_pdf, .005, .0025;
sig_u, inv_gamma_pdf, .003, inf;
sig_x, inv_gamma_pdf, .003, inf;
// The syntax for to input the priors is the following:
// variable name, prior distribution, parameters of distribution.

end;

varobs y;
estimation(datafile=data_consRicardoypg,first_obs=1,nobs=227,mh_replic=5000,mh_nblocks=1,mh_jscale=1);