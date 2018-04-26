
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
// ML estimation setup
// parameter name, initial value, boundaries_low, ..._up;
 rho, 0, -0.99, 0.999;  // use this for unconstrained max likelihood
// rho, .98, .975, .999 ;  // use this for long run risk model
// sig_x, .0004,.0001,.05 ; // use this for the long run risk model
 sig_x, .0005, .00000000001, .01;  // use this for unconstrained max likelihood
sig_u, .007,.001, .1;
mu_y, .014, .0001, .04;

end;

varobs y;
estimation(datafile=data_consRicardoypg,first_obs=1,nobs=227,mh_replic=0,mode_compute=4,mode_check);