// This program replicates figure 11.3.1 from chapter 11 of RMT2 by Ljungqvist and Sargent
// This is a commented version of the program given in the handout.

// Note: y_ records the simulated endogenous variables in alphabetical order
// ys0_ records the initial steady state
// ys_ records the terminal steady state
// We check that these line up at the end points
// Note: y_ has ys0_ in first column, ys_ in last column, explaining why it is 102 long; 
// The sample of size 100 is in between.

// Warning:  we align c, k, and the taxes to exploit the dynare syntax. See comments below. 
// So k in the program corresponds to k_{t+1} and the same timing holds for the taxes.

//Declares the endogenous variables;
var c k;
//declares the exogenous variables // investment tax credit, consumption tax, capital tax, government spending
varexo taui tauc tauk g; 

parameters bet gam del alpha A;

bet=.95;  // discount factor
gam=2;    // CRRA parameter
del=.2;  //  depreciation rate
alpha=.33; //  capital's share
A=1;    // productivity

// Alignment convention:
// g tauc taui tauk are now columns of ex_. Because of a bad design decision
// the date of ex_(1,:) doesn't necessarily match the date in y_. Whether they match depends
// on the number of lag periods in endogenous versus exogenous variables.
// In this example they match because tauc(-1) and taui(-1) enter the model.

// These decisions and the timing conventions mean that 
// y_(:,1) records the initial steady state, while y_(:,102) records the terminal steady state values.
// For j > 2, y_(:,j) records [c(j-1) .. k(j-1) ..   G(j-1)]  where k(j-1) means 
// end of period capital in period j-1, which equals k(j) in chapter 11 notation.
// Note that the jump in G occurs in y_(;,11), which confirms this timing.  
// the jump occurs now in ex_(11,1)

model;
// equation 11.3.8.a
k=A*k(-1)^alpha+(1-del)*k(-1)-c-g;
// equation 11.3.8e + 11.3.8.g
c^(-gam)= bet*(c(+1)^(-gam))*((1+tauc(-1))/(1+tauc))*((1-taui)*(1-del)/(1-taui(-1))+
 ((1-tauk)/(1-taui(-1)))*alpha*A*k(-1)^(alpha-1));
end;

initval;
k=1.5;
c=0.6;
g = 0.2;
tauc = 0;
taui = 0;
tauk = 0;
end;
steady; // put this in if you want to start from the initial steady state, comment it out to start from the indicated values

endval; // The following values determine the new steady state after the shocks.
k=1.5;
c=0.4;
g =.4;
tauc =0;
taui =0;
tauk =0;
end;

steady; // We use steady again and the enval provided are initial guesses for dynare to compute the ss.

//  The following lines produce a g sequence with a once and for all jump in g
shocks;
// we use shocks to undo that for the first 9 periods and leave g at
// it's initial value of 0

var g;
periods 1:9;
values 0.2;
end;


// now solve the model
simul(periods=100);

// Note: y_ records the simulated endogenous variables in alphabetical order
// ys0_ records the initial steady state
// ys_ records the terminal steady state
// check that these line up at the end points
y_(:,1) -ys0_(:)
y_(:,102) - ys_(:)

// Compute the initial steady state for consumption to later do the plots.
co=ys0_(var_index('c'));
ko = ys0_(var_index('k'));
// g is in ex_(:,1) since it is stored in alphabetical order
go = ex_(1,1)

// The following equation compute the other endogenous variables use in the plots below
// Since they are function of capital and consumption, so we can compute them from the solved
// model above.

// These equations were taken from page 333 of RMT2
rbig0=1/bet;
rbig=y_(var_index('c'),2:101).^(-gam)./(bet*y_(var_index('c'),3:102).^(-gam));
rq0=alpha*A*ko^(alpha-1);
rq=alpha*A*y_(var_index('k'),1:100).^(alpha-1);
wq0=A*ko^alpha-ko*alpha*A*ko^(alpha-1);
wq=A*y_(var_index('k'),1:100).^alpha-y_(var_index('k'),1:100).*alpha*A.*y_(var_index('k'),1:100).^(alpha-1);
sq0=(1-ex_(1,4))*A*alpha*ko^(alpha-1)+(1-del);
sq=(1-ex_(1:100,4)')*A*alpha.*y_(var_index('k'),1:100).^(alpha-1)+(1-del);

//Now we plot the responses of the endogenous variables to the shock.

figure
subplot(2,3,1)
plot([ko*ones(100,1)  y_(var_index('k'),1:100)' ]) // note the timing: we lag capital to correct for syntax
title('k')
subplot(2,3,2)
plot([co*ones(100,1)  y_(var_index('c'),2:101)' ])
title('c')
subplot(2,3,3)
plot([rbig0*ones(100,1) rbig' ])
title('R')
subplot(2,3,4)
plot([wq0*ones(100,1) wq' ])
title('w/q')
subplot(2,3,5)
plot([sq0*ones(100,1) sq' ])
title('s/q')
subplot(2,3,6)
plot([rq0*ones(100,1) rq' ])
title('r/q')
