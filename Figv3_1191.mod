%----------------------------------------------------------------
% Experiment  : Unforseen increase in g at t=0
%----------------------------------------------------------------


// This program replicates figure 11.9.1 from chapter 11 of RMT3 by Ljungqvist and Sargent

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
var c k n;
//declares the exogenous variables //  consumption tax ('tauc'), capital tax('tauk'), government spending('g')
varexo tauc tauk taun g; 

parameters bet gam del alpha A B;

%----------------------------------------------------------------
% 2. Calibration and alignment convention
%----------------------------------------------------------------

bet=.95;  // discount factor
gam=1;    // CRRA parameter 
del=.2;  //  depreciation rate
alpha=.33; //  capital's share
A=1;    // productivity
B=3; // coeffecient on leisure




// Alignment convention:
// g tauc tauk taun are now columns of ex_. Because of a bad design decision
// the date of ex_(1,:) doesn't necessarily match the date in endogenous variables. Whether they match depends
// on the number of lag periods in endogenous versus exogenous variables.

// These decisions and the timing conventions mean that 
// k(1) records the initial steady state, while k(102) records the terminal steady state values.
// For j > 1, k(j) records the variables for j-1th smimulation where the capital stock decision 
//taken in j-1 th simulation i.e stock at the begining of period j.
// The variable ex_ also follows a different timing convention i.e ex_(j,:) records the value of exogenous variables in the j th simualtion. 
//The jump in the government policy is reflected in ex_(10,1) for instance.

%----------------------------------------------------------------
% 3. Model
%----------------------------------------------------------------

model;


//Feasibility
k=A*k(-1)^alpha*n^(1-alpha)+(1-del)*k(-1)-c-g;

//Euler equation
c^(-gam)= bet*(c(+1)^(-gam))*((1+tauc)/(1+tauc(+1)))*((1-del) + (1-tauk(+1))*alpha*A*k^(alpha-1)*n(+1)^(1-alpha));

//Consumption leisure choice
B/c^(-gam)=(1-taun)*((1-alpha)*A*k(-1)^(alpha)*n^(-alpha))*(1+tauc)^-1;

end;

%----------------------------------------------------------------
% 4. Computation
%----------------------------------------------------------------

initval;
k=1.5;
c=0.6;
g = .2;
n=1.02;
tauc = 0;
tauk = 0;
taun=0;
end;
steady; // put this in if you want to start from the initial steady state, comment it out to start from the indicated values

endval; // The following values determine the new steady state after the shocks.
k=1.5;
c=0.6;
g =.4;
n=1.02;
tauc =0;
tauk =0;
taun=0;
end;

steady; // We use steady again and the enval provided are initial guesses for dynare to compute the ss.


// now solve the model
simul(periods=100);

// Compute the initial steady state for consumption to later do the plots.
c0=c(1);
k0 = k(1);
n0=n(1);
// g is in ex_(:,1) since it is stored in alphabetical order
g0 = .2;


%----------------------------------------------------------------
% 5. Graphs and plots for other endogenous variables
%----------------------------------------------------------------

//Let N be the periods to plot
N=40;

// The following equation compute the other endogenous variables use in the plots below
// Since they are function of capital and consumption, so we can compute them from the solved
// model above.
// These equations were taken from page 371 of RMT3
rbig0=1/bet;
rbig=c(2:101).^(-gam)./(bet*c(3:102).^(-gam));
nq0=alpha*A*k0^(alpha-1)*n0^(1-alpha);
nq=alpha*A*k(1:100).^(alpha-1).*(n(2:101).^(1-alpha));
wq0=A*(1-alpha)*k0^(alpha)*n0^(-alpha);
wq=(1-alpha)*A*k(1:100).^alpha.*(n(2:101).^(-alpha));


//Now we plot the responses of the endogenous variables to the shock.
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

// subplot for consumption 'n'
subplot(2,3,3)
plot(x,[n0*ones(N,1)],'--k', x,n(2:N+1),'k','LineWidth',1.5)
title('n','Fontsize',12)
set(gca,'Fontsize',12)

// subplot for cost of capital 'R_bar'
subplot(2,3,4)
plot(x,[rbig0*ones(N,1)],'--k', x,rbig(1:N),'k','LineWidth',1.5)
title('$\overline{R}$','interpreter', 'latex','Fontsize',12)
set(gca,'Fontsize',12)


// subplot for wage rate 'w'
subplot(2,3,5)
plot(x,[wq0*ones(N,1)],'--k', x,wq(1:N),'k','LineWidth',1.5)
title('w','Fontsize',12)
set(gca,'Fontsize',12)

// subplot for the experiment proposed
subplot(2,3,6)
plot(x,[g0*ones(N,1)],'--k', x,ex_(1:N,1),'k','LineWidth',1.5)
title('g','Fontsize',12)
axis([0 40 -.1 .5])
set(gca,'Fontsize',12)

print -depsc fig_gnu.eps
