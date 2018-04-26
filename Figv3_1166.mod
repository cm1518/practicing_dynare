
%----------------------------------------------------------------
% Experiment  : One time increase in g at t=10
%----------------------------------------------------------------

// This program replicates figure 11.6.6 from chapter 11 of RMT3 by Ljungqvist and Sargent


// This program computes the yield curves and prices for the fiscal policy experiment of a permenanent increase in g at date 10.


// Dynare records the endogenous variables with the following convention. Say N is the number of simulations(sample)
//Index 1 : Initial values (steady sate)
//Index 2 to N+1 : N simulated values
//Index N+2 : Temnial Value (Steady State)
// Warning:  we align c, k, and the taxes to exploit the dynare syntax. In Dynare the timing of the variable reflects the date 
//when the variable is decided. For instance the capital stock for time 't' is decided in time 't-1'(end of period). So a statement like 
// k(t+1) = i(t) + (1-del)*k(t) would translate to " k(t) = i(t) +(1-del)*k(t-1)" in the code. 

%----------------------------------------------------------------
% 1. Defining variables
%----------------------------------------------------------------

//Declares the endogenous variables consumption ('c') capital stock (k);
var c k;
//declares the exogenous variables //  consumption tax ('tauc'), capital tax('tauk'), government spending('g')
varexo tauc tauk g; 

parameters bet gam del alpha A;


%----------------------------------------------------------------
% 2. Calibration and alignment convention
%----------------------------------------------------------------

bet=.95;  // discount factor
gam=2;    // CRRA parameter  
del=.2;  //  depreciation rate
alpha=.33; //  capital's share
A=1;    // productivity

// Alignment convention:
// g tauc taui tauk are now columns of ex_. Because of a bad design decision
// the date of ex_(1,:) doesn't necessarily match the date in endogenous variables. Whether they match depends
// on the number of lag periods in endogenous versus exogenous variables.

// These decisions and the timing conventions mean that 
// k(1) records the initial steady state, while k(102) records the terminal steady state values.
// For j > 1, k(j) records the variables for j-1th smimulation where the capital stock decision 
//taken in j-1 th simulation i.e stock at the begining of period j.
// The variable ex_ also follows a different timing convention i.e ex_(j,:) records the value of exogenous variables in the j th simualtion. 
//The jump in the government policy is reflected in ex_(11,1) for instance.

%----------------------------------------------------------------
% 3. Model
%----------------------------------------------------------------

model;
// equation 11.3.8.a
k=A*k(-1)^alpha+(1-del)*k(-1)-c-g;
// equation 11.3.8e + 11.3.8.g
c^(-gam)= bet*(c(+1)^(-gam))*((1+tauc)/(1+tauc(+1)))*((1-del) + (1-tauk(+1))*alpha*A*k^(alpha-1));
end;

%----------------------------------------------------------------
% 4. Computation
%----------------------------------------------------------------

initval;
k=1.5;
c=0.6;
g = .2;
tauc = 0;
tauk = 0;
end;
steady; // put this in if you want to start from the initial steady state, comment it out to start from the indicated values

endval; // The following values determine the new steady state after the shocks.
k=1.5;
c=0.6;
g =.2;
tauc =.0;
tauk =.0;
end;

steady; // We use steady again and the enval provided are initial guesses for dynare to compute the ss.

//  The following lines produce a g sequence with a pulse at t=10
// we use shocks to undo that for the 10th  period and leave g at
// it's initial value of 0
// Note :  period j referes to the value in the jth simulation and j=0 refers to the the initial value.

shocks;
var g;
periods 11;
values .4;
end;


// now solve the model
simul(periods=100);

// Compute the initial steady state for consumption to later do the plots.
c0=c(1);
k0 = k(1);
// g is in ex_(:,1) since it is stored in alphabetical order
g0 = ex_(1,1);


%----------------------------------------------------------------
% 5. Graphs and plots for other endogenous variables
%----------------------------------------------------------------

// The following equation compute the other endogenous variables use in the plots below
// Since they are function of capital and consumption, so we can compute them from the solved
// model above.

// These equations were taken from page 371 of RMT3
rbig0=1/bet;
rbig=c(2:101).^(-gam)./(bet*c(3:102).^(-gam));
nq0=alpha*A*k0^(alpha-1);
nq=alpha*A*k(1:100).^(alpha-1);
wq0=A*k0^alpha-k0*alpha*A*k0^(alpha-1);
wq=A*k(1:100).^alpha-k(1:100).*alpha*A.*k(1:100).^(alpha-1);


//Now we plot the responses of the endogenous variables to the shock.
//Let N be the periods to plot
N=40;

x=0:N-1;
figure(1)

// subplot for capital 'k'
subplot(2,3,1)
plot(x,[k0*ones(N,1)],'--k', x,k(1:N),'k','LineWidth',1.5) // note the timing: we lag capital to correct for syntax
title('k','Fontsize',12)
set(gca,'Fontsize',12)

// subplot for consumption 'c'
subplot(2,3,2)
plot(x,[c0*ones(N,1)],'--k', x,c(2:N+1),'k','LineWidth',1.5)
title('c','Fontsize',12)
set(gca,'Fontsize',12)

// subplot for cost of capital 'R_bar'
subplot(2,3,3)
plot(x,[rbig0*ones(N,1)],'--k', x,rbig(1:N),'k','LineWidth',1.5)
title('$\overline{R}$','interpreter', 'latex','Fontsize',12)
set(gca,'Fontsize',12)


// subplot for rental rate 'eta'
subplot(2,3,4)
plot(x,[nq0*ones(N,1)],'--k', x,nq(1:N),'k','LineWidth',1.5)
title('\eta','Fontsize',12)
set(gca,'Fontsize',12)

// subplot for the experiment proposed
subplot(2,3,5)
plot(x,[g0*ones(N,1)],'--k', x,ex_(1:N,1),'k','LineWidth',1.5)
axis([-inf inf -.1 .5])
set(gca,'Fontsize',12)
title('g','Fontsize',12)

print -depsc fig_g1.eps
