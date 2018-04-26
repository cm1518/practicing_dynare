// this program estimates the model in
// "The Demand for Money during Hyperinflations under Rational Expectations: I" by T. Sargent, IER 1977 using Bayesian techniques
// variables are defined as follows:
// x=p_t-p_{t-1}, p being the log of the price level
// mu=m_t-m_{t-1}, m being the log of money supply
// note that in contrast to the paper eta and epsilon have variance 1 (they are multiplied by the standard deviations)



var x mu a1 a2;
varexo epsilon eta;
parameters alpha lambda sig_eta sig_epsilon;
lambda=.5921;
alpha=-2.344;
sig_eta=.001;
sig_epsilon=.001;

model;
x=x(-1)-lambda*a1(-1)+(1/(lambda+alpha*(1-lambda)))*sig_epsilon*epsilon-(1/(lambda+alpha*(1-lambda)))*sig_eta*eta;
mu=(1-lambda)*x(-1)+lambda*mu(-1)-lambda*a2(-1)+(1+alpha*(1-lambda))/(lambda+alpha*(1-lambda))*sig_epsilon*epsilon-(1-lambda)/(lambda+alpha*(1-lambda))*sig_eta*eta;
a1=(1/(lambda+alpha*(1-lambda)))*sig_epsilon*epsilon-(1/(lambda+alpha*(1-lambda)))*sig_eta*eta;
a2=(1+alpha*(1-lambda))/(lambda+alpha*(1-lambda))*sig_epsilon*epsilon-(1-lambda)/(lambda+alpha*(1-lambda))*sig_eta*eta;
end;

steady;

shocks;

var eta;
stderr 1;
var epsilon;
stderr 1;
end;



estimated_params;
// Bayesian setup
lambda, uniform_pdf,   0.68, .5;  
alpha, uniform_pdf, -5, 2;
sig_eta, uniform_pdf, .5, 0.25;
sig_epsilon, uniform_pdf, .5, 0.25;
end;


varobs mu x;
unit_root_vars x;
estimation(datafile=cagan_data,first_obs=1,nobs=34,mh_replic=25000,mh_nblocks=1,mh_jscale=1,mode_compute=4);
