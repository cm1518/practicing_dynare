// Estimates the hall model using maximum likelihood.  See hall1_estimateBayes.mod for Bayesian method

periods 5000;

var c k mu_c  b d in;
varexo e_d e_b; 

parameters R rho rho_b mu_b mu_d; 
R=1.05;
rho=0.9;
mu_b=30;
mu_d=5;
rho_b = 0.5;

model(linear);

 c+k = R*k(-1) + d;
 mu_c = b - c;
 mu_c=mu_c(+1);
 d= rho*d(-1)+ mu_d*(1-rho) + e_d;
 b=(1-rho_b)*mu_b+rho_b*b(-1)+e_b;
in = k - k(-1);
 end;
// Michel says that in a stationary linear model, this junk is irrelevant.
// But with a unit root, there exists no steady state.  Use the following trick.
// Supply ONE solution corresponding to the initial k that you named.  (Michel is a gneius!!  Or so he thinks -- let's see
// if this works.)

initval;
d=mu_d;
k=100;
c = (R-1)*k +d;
mu_c=mu_b-c;
b=mu_b;
end;

shocks;
var e_d;
stderr 0.05;
var e_b;
stderr 0.05;
end;

estimated_params;
// ML estimation setup
// parameter name, initial value, boundaries_low, ..._up;
// now we use the optimum results from csminwel for starting up Marco's
rho, -0.0159, -0.9, 0.9;
R, 1.0074, 0, 1.5;
end;

varobs c in;
// declare the unit root variables for diffuse filter
unit_root_vars k;
estimation(datafile=data_hall,first_obs=101,nobs=200,mh_replic=0,mode_compute=4,mode_check);
// Note: there is a problem when you try to use method 5.  Tom, Jan 13, 2006