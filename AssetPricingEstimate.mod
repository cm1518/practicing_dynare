var  dc, dd, v_c, v_d, x;
varexo e_c, e_x, e_d;

parameters DELTA THETA PSI MU_C MU_D RHO_X LAMBDA_DX;

DELTA=.99;
PSI=1.5;
THETA=(1-7.5)/(1-1/PSI); 
MU_C=0.0015;
MU_D=0.0015;
RHO_X=.979;
LAMBDA_DX=3;


model;
v_c       = DELTA^THETA * exp((-THETA/PSI)*dc(+1) + (THETA-1)*log((1+v_c(+1))*exp(dc(+1))/v_c) ) * (1+v_c(+1))*exp(dc(+1));
v_d       = DELTA^THETA * exp((-THETA/PSI)*dc(+1) + (THETA-1)*log((1+v_c(+1))*exp(dc(+1))/v_c) ) * (1+v_d(+1))*exp(dd(+1));
dc        = MU_C  + x(-1) + e_c;
dd        = MU_D + LAMBDA_DX*x(-1) + e_d;
x         = RHO_X * x(-1) + e_x;
end;

initval;
v_c=15;
v_d=15;
dc=MU_C;
dd=MU_D;
x=0;
e_c=0;
e_x=0;
e_d=0;
end;

shocks;
var e_d; stderr .001;
var e_c; stderr .001;
var e_x; stderr .001;
end;

steady;

estimated_params;
DELTA, beta_pdf, 0.98,.005;
THETA,normal_pdf,-19.5, 0.0025; 
PSI,normal_pdf,1.6, 0.1; 
MU_C,normal_pdf,0.001, 0.001; 
MU_D,normal_pdf,0.001, 0.001; 
RHO_X,normal_pdf,.98, 0.005; 
LAMBDA_DX,normal_pdf,3, 0.05; 
stderr e_d,inv_gamma_pdf,.0025, 30; 
stderr e_x,inv_gamma_pdf,.0003, 30; 
stderr e_c,inv_gamma_pdf,.01, 30; 
end;


varobs v_d dd dc;

estimation(datafile=simudata,mh_replic=1000,mh_jscale=.4,nodiagnostic);