% Metrics with MCA for Iowa

%Base_Case with average area of an HRU
CornP = 4.27 ; BioP = 60; SoyP = 9.79; A = 615;

%Yield - IA - normal distribution for all feedstock
Corn_IA = csvread('C:\Users\skeerthi\Documents\Journal Paper 2/Corn_yield_IA.csv');
mu = mean(Corn_IA);
sigma = std(Corn_IA);
Ydistcorn = makedist('normal','mu',mu,'sigma',sigma);
Ycorn = random(Ydistcorn,10000,1);
Soy_IA = csvread('C:\Users\skeerthi\Documents\Journal Paper 2/Soy_yield_IA.csv');
mu = mean(Soy_IA);
sigma = std(Soy_IA);
Ydistsoy = makedist('normal','mu',mu,'sigma',sigma);
Ysoy = random(Ydistsoy,10000,1);
Swch_IA = csvread('C:\Users\skeerthi\Documents\Journal Paper 2/Swch_yield_IA.csv');
mu = mean(Swch_IA);
sigma = std(Swch_IA);
Ydistswch = makedist('normal','mu',mu,'sigma',sigma);
Yswch = random(Ydistswch,10000,1);
Mis_IA = csvread('C:\Users\skeerthi\Documents\Journal Paper 2/Mis_yield_IA.csv');
mu = mean(Mis_IA);
sigma = std(Mis_IA);
Ydistmisc = makedist('normal','mu',mu,'sigma',sigma);
Ymisc = random(Ydistmisc,10000,1);
C1_IA = csvread('C:\Users\skeerthi\Documents\Journal Paper 2/C1_yield_IA.csv');
mu = mean(C1_IA);
sigma = std(C1_IA);
Ydistc1 = makedist('normal','mu',mu,'sigma',sigma);
YC1 = random(Ydistc1,10000,1);
S1_IA = csvread('C:\Users\skeerthi\Documents\Journal Paper 2/S1_yield_IA.csv');
mu = mean(S1_IA);
sigma = std(S1_IA);
Ydists1 = makedist('normal','mu',mu,'sigma',sigma);
YS1 = random(Ydists1,10000,1);

%calculation of farm safety net numbers
ARC_IAC = 586.2 ; %$/acre for 86% of ARC benchmark revenue for corn
ARC_IAS = 460.53 ; %$/acre for 86% of ARC benchmark revenue for soybean
Prem_C = 11.17 ; %$/acre for 85% coverage levels 
Prem_S = 9.16 ; %$/acre for 85% coverage levels
AHP_C = mean(Corn_IA);
AHP_S = mean(Soy_IA);

% Corn Soy for OC costs and to calculate metrics 
for i = 1: 10000
CSCost(i) = ((347.65 + 0.05*Ycorn(i)*0.89/56)+  (218.52 + 0.05*Ysoy(i)*0.89/60))*A*2.47/2 + (Prem_C + Prem_S)*A*2.47/2;%including Insurance premiums
CSFCost(i)= ((275.20 + 0.06*Ycorn(i)*0.89/56 + 347.65 + 0.05*Ycorn(i)*0.89/56)+ (276.20 + 0.11*Ysoy(i)*0.89/60 + 218.52))*A*2.47/2 + (Prem_C + Prem_S)*A*2.47/2;
CSRev(i)= (CornP*Ycorn(i)*0.89/56 + SoyP*Ysoy(i)*0.89/60)*A*2.47/2;
CSProfit(i)= CSRev(i) - CSCost(i); % this has to be calculated before insurance for OC for switchgrass and miscanthus
OC(i) = CSProfit(i)/(A); %also returns over unit area without fixed costs
OC1(i) = CSFProfit(i)/A; % returns over unit area with fixed and variable costs
%additional revenue from ARC for corn and soybean
CornRev = CornP*Ycorn(i)*0.89/56;
SoyRev = SoyP*Ysoy(i)*0.89/60;
if CornRev < ARC_IAC
    ARC_IACP = (ARC_IAC - Ycorn(i)*CornP*0.89/56)*0.85*A*2.47 ;
    if ARC_IACP > 58.62*A*2.47
        ARC_IACP = 58.62*A*2.47;
    end
elseif CornRev >= ARC_IAC
    ARC_IACP = 0;
end
if SoyRev < ARC_IAS
    ARC_IASP = (ARC_IAS - Ysoy(i)*SoyP*0.89/60)*0.85*A*2.47 ;
    if ARC_IASP > 46.05*A*2.47
        ARC_IASP = 46.05*A*2.47;
    end
elseif SoyRev >= ARC_IAS
    ARC_IASP = 0;
end
% additional revenue from YP insurance for corn and soybean
if Ycorn(i)< AHP_C
    YP_RC = 0.85*(AHP_C*0.89/56 - Ycorn(i)*0.89/56)*CornP*A*2.47 ;
else
    YP_RC = 0;
end
if Ysoy(i)< AHP_S
    YP_RS = 0.85*(AHP_S*0.89/60 - Ysoy(i)*0.89/60)*SoyP*A*2.47 ;
else
    YP_RS = 0;
end
CSRev(i)= CSRev(i) + (ARC_IACP + ARC_IASP + YP_RC + YP_RS)/2;
CSProfit(i) = CSRev(i) - CSCost(i);
CSobj1(i) = CSProfit(i)/A;
CSFProfit(i)= CSRev(i) - CSFCost(i);
CSgal(i) = (2.84*Ycorn(i)*0.89/56*A*2.47/2);
CSobj3(i)= CSgal(i)/CSRev(i);
CSobj4(i) = CSRev(i)/A;
CSobj5(i) = (CSgal(i)*84858)/A;
%%% Corn Stover 
StovCost(i) = A*2.47*((347.65 + 0.05*YC1(i)*0.89/56)+  (218.52 + 0.05*YS1(i)*0.89/60))/2+ (11.04 +8.04/1000*YC1(i)*0.52)*A/2;
StovFCost(i) = ((275.20 + 0.06*YC1(i)*0.89/56 + 347.65 + 0.05*YC1(i)*0.89/56)/2 + (276.20 + 0.11*YS1(i)*0.89/60 + 218.52))*A*2.47/2 + (11.04 +8.04/1000*YC1(i)*0.52)*A/2;
StovRev(i) = (YC1(i)*0.892/56*CornP + YS1(i)*0.892/60*SoyP)*A*2.47/2 + YC1(i)*0.52*BioP/2000*A;
%additional revenue from ARC for corn and soybean
if CornP*YC1(i)*0.89/56 < ARC_IAC
    ARC_IACP = (ARC_IAC - YC1(i)*CornP*0.89/56)*0.85*A*2.47 ;
    if ARC_IACP > 58.62*A*2.47
        ARC_IACP = 58.62*A*2.47;
    end
elseif CornP*YC1(i)*0.89/56 >= ARC_IAC
    ARC_IACP = 0;
end
if SoyP*YS1(i)*0.89/60 < ARC_IAS
    ARC_IASP = (ARC_IAS - YS1(i)*SoyP*0.89/60)*0.85*A*2.47 ;
    if ARC_IASP > 45.03*A*2.47
        ARC_IASP = 45.03*A*2.47;
    end
elseif SoyP*YS1(i)*0.89/60 >= ARC_IAS
    ARC_IASP = 0;
end
% additional revenue from YP insurance for corn and soybean
if YC1(i)< AHP_C
    YP_RC = 0.85*(AHP_C*0.89/56 - YC1(i)*0.89/56)*CornP*A*2.47 ;
else
    YP_RC = 0;
end
if YS1(i)< AHP_S
    YP_RS = 0.85*(AHP_S*0.89/60 - YS1(i)*0.89/60)*SoyP*A*2.47 ;
else
    YP_RS = 0;
end
StovCost(i) = StovCost(i)+ (Prem_C + Prem_S)*A*2.47/2;
StovRev(i)= StovRev(i) + (ARC_IACP + ARC_IASP + YP_RC + YP_RS)/2;
StovProfit(i) = StovRev(i) - StovCost(i);
StovFProfit(i)= StovRev(i) - StovFCost(i);
Stovobj1(i)= StovProfit(i)/A;
Stovobj2(i)= StovFProfit(i)/A;
StovGgal(i) = (2.84*YC1(i)*0.892/56*A*2.47)/2;
Stovgal(i) = (YC1(i)*0.52/1000*A*79/2);
Stovobj3(i)= (StovGgal(i) + Stovgal(i))/StovRev(i);
Stovobj4(i) = StovRev(i)/A;
Stovobj5(i) = ((StovGgal(i)*0.4+Stovgal(i))*84858)/A;
end

%Switchgrass costs

%Establishment Costs - Triangular Distribution
Est = [138.94,133.34,146.62,123.48,151.05,113.13,270.8,139.55,150.6, 617.40,270.8];
lower = min(Est);
mpv = median(Est);
upper = max(Est);
Estd2=makedist('triangular','a',lower,'b',mpv,'c',upper);
r = random(Estd2,10000,1);

% Maintenance Costs - Non-Yield (1-2)- MNY1, and MNY3 Triangular
% distribution
MNY1 = [224.86,183.72,351.88,248.25,139.64,197.70,129.42,346.27,148.6];
MNY3 = [87.32,52.59,111.99,114.87,35.96,159.53,66.1,244.34,355.13];
lower = min(MNY1);
mpv = median(MNY1);
upper = max(MNY1);
MNY1dist=makedist('triangular','a',lower,'b',mpv,'c',upper);
MNY1 = random(MNY1dist,10000,1);
lower = min(MNY3);
mpv = median(MNY3);
upper = max(MNY3);
MNY3dist=makedist('triangular','a',lower,'b',mpv,'c',upper);
MNY3 = random(MNY3dist,10000,1);

%Harvest Non-yield HY1, HY3 - Triangular Distribution
HY1 = [0,0,0,70.51,67.67,39.27,23.1,35];
HY3 = [0,0,39.64,67.67,17.65,39.27,46.21,23.1,46.21,35,35];
lower = min(HY1);
mpv = median(HY1);
upper = max(HY1);
HY1dist=makedist('triangular','a',lower,'b',mpv,'c',upper);
HY1 = random(HY1dist,10000,1);
lower = min(HY3);
mpv = median(HY3);
upper = max(HY3);
HY3dist=makedist('triangular','a',lower,'b',mpv,'c',upper);
HY3 = random(HY3dist,10000,1);

% Harvest - yield dependent - Triangular distribution
H1 = [0.0313,0.0374,0.047,0.028,0.029,0.003,0.018,0.03,0.026];
lower = min(H1);
mpv = median(H1);
upper = max(H1);
H1dist=makedist('triangular','a',lower,'b',mpv,'c',upper);
H1 = random(H1dist,10000,1);
%Storage - Yield dependent 
S1 = [0.004,0.004,0.003,0.013,0.004,0.008];
lower = min(S1);
mpv = median(S1);
upper = max(S1);
S1dist=makedist('triangular','a',lower,'b',mpv,'c',upper);
S1 = random(S1dist,10000,1);

%Lifetime - Triangular
L = [11,11,10,12,10,10,10,10,10,10];
lower = min(L);
mpv = median(L);
upper = max(L);
Ldist=makedist('triangular','a',lower,'b',mpv,'c',upper);
L = random(Ldist,10000,1);

%discount rate - Triangular
d = [8,4,10,6,6,5,4,4,5,7];
lower = min(d);
mpv = median(d);
upper = max(d);
ddist=makedist('triangular','a',lower,'b',mpv,'c',upper);
d = random(ddist,10000,1);
% To ensure that lifetime and discount rates are integers
for i = 1:10000
    L(i) = round(L(i));
    d(i) = round(d(i))/100;
end

%Actual simulation
for i = 1:10000
AnnualizedSwchCostIA(i) = (r(i)+ MNY1(i)*(1+d(i))^0.667 + HY1(i)+ H1(i)*Yswch(i)*1000/2 + S1(i)*Yswch(i)*1000/2)/ L(i)+ (MNY3(i)*(1+d(i))^0.667 + HY3(i)+ Yswch(i)*1000*(H1(i)+S1(i)))*(L(i)-1)/L(i);
% assumed for optimization 
AssumedSWCHIA(i) = 292.79 + 31.92*Yswch(i);
%Establishment Costs
if r(i)<= 2470
    AnnualizedSwchCostIA(i)= AnnualizedSwchCostIA(i)-(r(i)/2)/L(i);
else
    AnnualizedSwchCostIA(i) = AnnualizedSwchCostIA(i) - 1235/L(i);
end
% To cover loss of revenue during establishment - for upto 5 years (2 years
% establishment period for Miscanthus)
AnnualizedSwchCostIA(i)= AnnualizedSwchCostIA(i)-(Yswch(i)*BioP*(0.5))/(L(i));
% % to cover harvest and storage costs for two years
if Yswch(i)< 20
AnnualizedSwchCostIA(i)= AnnualizedSwchCostIA(i)- (Yswch(i)*2/L(i));
else
AnnualizedSwchCostIA(i)= AnnualizedSwchCostIA(i)- (20*2/L(i));  
end
SwchRev(i)= Yswch(i)*BioP*A;
SwchProfit(i)= Yswch(i)*BioP*A - AnnualizedSwchCostIA(i)*A - OC(i)*A ;
if OC1(i)< 0
    SwchFProfit(i) = Yswch(i)*BioP*A - AnnualizedSwchCostIA(i)*A - 105*2.47*A - 235*2.47*A ; % enrollment in CRP
else
SwchFProfit(i) = Yswch(i)*BioP*A - AnnualizedSwchCostIA(i)*A - OC1(i)*A ;
end
SwchProfit1(i)= Yswch(i)*BioP*A - AssumedSWCHIA(i)*A ;
Swchobj1(i)= SwchProfit(i)/A;
Swchobj1a(i)= (SwchProfit(i)+ CSProfit(i))/A;
Swchobj1b(i)= (SwchProfit1(i))/A;
Swchobj2(i)= SwchFProfit(i)/A;
Swchobj2a(i)= (SwchProfit(i)+ CSFProfit(i))/A;
Swchgal(i) = 79*Yswch(i)*A;
Swchobj3(i)= Swchgal(i)/SwchRev(i);
Swchobj4(i) = SwchRev(i)/A;
Swchobj5(i) = (Swchgal(i)*84858)/A;
end

%%%Miscanthus
%Establishment Costs - Triangular Distribution - Miscanthus
Est = [2802.17,440.06,500,3097,1874.730,3750,556.4];
lower = min(Est);
mpv = median(Est);
upper = max(Est);
Estd2=makedist('triangular','a',lower,'b',mpv,'c',upper);
r = random(Estd2,10000,1);

% Maintenance Costs - Non-Yield (1-2)- MNY1, and MNY3 Triangular
% distribution Miscan
MNY1 = [610.17,186.58,222.24,782.175,64.3];
MNY3 = [87.32,53.73,111.16,175.247,64.3];
lower = min(MNY1);
mpv = median(MNY1);
upper = max(MNY1);
MNY1dist=makedist('triangular','a',lower,'b',mpv,'c',upper);
MNY1 = random(MNY1dist,10000,1);
lower = min(MNY3);
mpv = median(MNY3);
upper = max(MNY3);
MNY3dist=makedist('triangular','a',lower,'b',mpv,'c',upper);
MNY3 = random(MNY3dist,10000,1);

%Harvest Non-yield HY1, HY3 - Triangular Distribution Miscanthus
HY1 = [0,40.52,46.2,65.455,35];
HY3 = [40.52,46.2,65.455,36];
lower = min(HY1);
mpv = median(HY1);
upper = max(HY1);
HY1dist=makedist('triangular','a',lower,'b',mpv,'c',upper);
HY1 = random(HY1dist,10000,1);
lower = min(HY3);
mpv = median(HY3);
upper = max(HY3);
HY3dist=makedist('triangular','a',lower,'b',mpv,'c',upper);
HY3 = random(HY3dist,10000,1);

% Harvest - yield dependent - Triangular distribution Miscanthus 
H1 = [0.0404,0.056,0.005,0.019,0.026];
lower = min(H1);
mpv = median(H1);
upper = max(H1);
H1dist=makedist('triangular','a',lower,'b',mpv,'c',upper);
H1 = random(H1dist,10000,1);
%Storage - Yield dependent 
S1 = [0.008,0.006,0.005,0.0065];
lower = min(S1);
mpv = median(S1);
upper = max(S1);
S1dist=makedist('triangular','a',lower,'b',mpv,'c',upper);
S1 = random(S1dist,10000,1);

%Lifetime - Triangular Misc
L = [15,20,10,15,15,20,15,10];
lower = min(L);
mpv = median(L);
upper = max(L);
Ldist=makedist('triangular','a',lower,'b',mpv,'c',upper);
L = random(Ldist,10000,1);

%discount rate - Triangular Misc
d = [6,4,5,4,4,5,4,7];
lower = min(d);
mpv = median(d);
upper = max(d);
ddist=makedist('triangular','a',lower,'b',mpv,'c',upper);
d = random(ddist,10000,1);
% To ensure that lifetime and discount rates are integers
for i = 1:10000
    L(i) = round(L(i));
    d(i) = round(d(i))/100;
end

%Actual simulation Misc
for i = 1:10000
AnnualizedMiscCostIA(i) = (r(i)+ MNY1(i)*(1+d(i))^(0.667)+ HY1(i)+ H1(i)* Ymisc(i)*1000/2 + S1(i)*Ymisc(i)*1000/2)/ L(i) + ((L(i)-2)*MNY3(i)*(1+d(i))^(0.667)+ ...
   + HY3(i)*(L(i)-2)+ H1(i)*Ymisc(i)*1000*(L(i)-2)+ S1(i)*Ymisc(i)*1000*(L(i)-2))/L(i);
%Establishment Costs
if r(i)<= 2470
    AnnualizedMiscCostIA(i)= AnnualizedMiscCostIA(i)-(r(i)/2)/L(i);
else
    AnnualizedMiscCostIA(i) = AnnualizedMiscCostIA(i) - 1235/L(i);
end
% To cover loss of revenue during establishment - for upto 5 years (2 years
% establishment period for Miscanthus)
AnnualizedMiscCostIA(i)= AnnualizedMiscCostIA(i)-(Ymisc(i)*BioP*(1.5))/(L(i));
% % to cover harvest and storage costs for two years
if Ymisc(i)< 20
AnnualizedMiscCostIA(i)= AnnualizedMiscCostIA(i)- (Ymisc(i)*2/L(i));
else
AnnualizedMiscCostIA(i)= AnnualizedMiscCostIA(i)- (20*2/L(i));  
end
% assumed for optimization 
AssumedMISCIA(i) = 915.24+8.75*Ymisc(i);
MiscRev(i)= Ymisc(i)*BioP*A;
MiscProfit(i)= Ymisc(i)*BioP*A - AnnualizedMiscCostIA(i)*A - OC(i)*A ;
if OC1(i)< 0
    MiscFProfit(i) = Ymisc(i)*BioP*A - AnnualizedMiscCostIA(i)*A - 105*2.47*A - 235*2.47*A ;
else
MiscFProfit(i) = Ymisc(i)*BioP*A - AnnualizedMiscCostIA(i)*A - OC1(i)*A ;
end
MiscProfit1(i)= Ymisc(i)*BioP*A - AssumedMISCIA(i)*A ;
Miscobj1(i)= MiscProfit(i)/A;
Miscobj1a(i)= (MiscProfit(i)+ CSProfit(i))/A;
Miscobj1b(i)= (MiscProfit1(i))/A;
Miscobj2(i)= MiscFProfit(i)/A;
if CSFProfit(i)< 0
  Miscobj2a(i)= (MiscProfit(i)+ 230)/A ;
else
 Miscobj2a(i)= (MiscProfit(i)+ CSFProfit(i))/A;
end

Miscgal(i) = 79*Ymisc(i)*A;
Miscobj3(i)= Miscgal(i)/MiscRev(i);
Miscobj4(i) = MiscRev(i)/A;
Miscobj5(i) = (Miscgal(i)*84858)/A;
end

%%Pdfs for each metric
% Objective 1 : DOE - returns over VC
%CS
% mu = mean(OC);
% sigma = std(OC);
mu = mean(CSobj1);
sigma = std(CSobj1);
CSobj1_IA = makedist('normal','mu',mu,'sigma',sigma);
%Stover
mu = mean(Stovobj1);
sigma = std(Stovobj1);
Stovobj1_IA = makedist('normal','mu',mu,'sigma',sigma);
%Switchgrass
mu = mean(Swchobj1);
sigma = std(Swchobj1);
Swchobj1_IA = makedist('normal','mu',mu,'sigma',sigma);
%Miscanthus
mu = mean(Miscobj1);
sigma = std(Miscobj1);
Miscobj1_IA = makedist('normal','mu',mu,'sigma',sigma);
figure(1);
x = -400: 0.5 : 1500;
y = pdf(CSobj1_IA,x);
y1 = pdf(Stovobj1_IA,x);
y2 = pdf(Swchobj1_IA,x);
y3 = pdf(Miscobj1_IA,x);
plot(x,y,'b',x,y1,'--r',x,y2,'--g',x,y3,'c');
legend('CS','Stover','Swch','Misc');
xlabel('$/ha');
ylabel('Probability Distribution')
title('Returns over variable costs');

%without OC
%Switchgrass
mu = mean(Swchobj1a);
sigma = std(Swchobj1a);
Swchobj1a_IA = makedist('normal','mu',mu,'sigma',sigma);
%Miscanthus
mu = mean(Miscobj1a);
sigma = std(Miscobj1a);
Miscobj1a_IA = makedist('normal','mu',mu,'sigma',sigma);
figure(2);
x = -300: 0.5 : 1000;
y = pdf(CSobj1_IA,x);
y1 = pdf(Stovobj1_IA,x);
y2 = pdf(Swchobj1a_IA,x);
y3 = pdf(Miscobj1a_IA,x);
plot(x,y,'b',x,y1,'--r',x,y2,'--g',x,y3,'c');
legend('CS','Stover','Swch','Misc');
xlabel('$/ha');
ylabel('Probability Distribution')
title('Returns over variable costs without an opportunity cost');
% 
% % with only yield variability, no OC
mu = mean(Swchobj1b);
sigma = std(Swchobj1b);
Swchobj1b_IA = makedist('normal','mu',mu,'sigma',sigma);
%Miscanthus
mu = mean(Miscobj1b);
sigma = std(Miscobj1b);
Miscobj1b_IA = makedist('normal','mu',mu,'sigma',sigma);
figure(3);
x = -300: 0.5 : 1000;
y = pdf(CSobj1_IA,x);
y1 = pdf(Stovobj1_IA,x);
y2 = pdf(Swchobj1b_IA,x);
y3 = pdf(Miscobj1b_IA,x);
plot(x,y,'b',x,y1,'--r',x,y2,'--g',x,y3,'c');
legend('CS','Stover','Swch','Misc');
xlabel('$/ha');
ylabel('Probability Distribution');
title('Returns over variable costs without an opportunity cost (only yield variability)');

%USDA - Objective 2 : Maximize ethanol production
mu1 = mean(CSobj5);
sigma1 = std(CSobj5);
CSobj5_IA = makedist('normal','mu',mu1,'sigma',sigma1);
%Stover
mu2 = mean(Stovobj5);
sigma2 = std(Stovobj5);
Stovobj5_IA = makedist('normal','mu',mu2,'sigma',sigma2);
%Switchgrass
mu3 = mean(Swchobj5);
sigma3 = std(Swchobj5);
Swchobj5_IA = makedist('normal','mu',mu3,'sigma',sigma3);
%Miscanthus
mu4 = mean(Miscobj5);
sigma4 = std(Miscobj5);
Miscobj5_IA = makedist('normal','mu',mu4,'sigma',sigma4);
figure(4);
x = 10^7:10^6:3*10^8;
y = pdf(CSobj5_IA,x);
y1 = pdf(Stovobj5_IA,x);
y2 = pdf(Swchobj5_IA,x);
y3 = pdf(Miscobj5_IA,x);
plot(x,y,'b',x,y1,'--r',x,y2,'--g',x,y3,'c');
legend('CS','Stover','Swch','Misc');
xlabel('kJ/ha');
ylabel('Probability Distribution')
title('Energy produced per hectare');

%EPA - Cost of procurement/gal 
mu1 = mean(CSobj3);
sigma1 = std(CSobj3);
CSobj3_IA = makedist('normal','mu',mu1,'sigma',sigma1);
%Stover
mu2 = mean(Stovobj3);
sigma2 = std(Stovobj3);
Stovobj3_IA = makedist('normal','mu',mu2,'sigma',sigma2);
%Switchgrass
mu3 = mean(Swchobj3);
sigma3 = std(Swchobj3);
Swchobj3_IA = makedist('normal','mu',mu3,'sigma',sigma3);
%Miscanthus
mu4 = mean(Miscobj3);
sigma4 = std(Miscobj3);
Miscobj3_IA = makedist('normal','mu',mu4,'sigma',sigma4);
figure(5);
x = 0:0.05:3;
y = pdf(CSobj3_IA,x);
y1 = pdf(Stovobj3_IA,x);
y2 = pdf(Swchobj3_IA,x);
y3 = pdf(Miscobj3_IA,x);
plot(x,y,'b',x,y1,'--r',x,y2,'y',x,y3,'--k');
legend('CS','Stover','Swch','Misc');
xlabel('gal/$');
ylabel('Probability Distribution')
title('Ethanol procured per dollar spent');

%DOE - Returns over Total cost
mu = mean(OC1);
sigma = std(OC1);
CSobj2_IA = makedist('normal','mu',mu,'sigma',sigma);
%Stover
mu = mean(Stovobj2);
sigma = std(Stovobj2);
Stovobj2_IA = makedist('normal','mu',mu,'sigma',sigma);
%Switchgrass
mu = mean(Swchobj2);
sigma = std(Swchobj2);
Swchobj2_IA = makedist('normal','mu',mu,'sigma',sigma);
%Miscanthus
mu = mean(Miscobj2);
sigma = std(Miscobj2);
Miscobj2_IA = makedist('normal','mu',mu,'sigma',sigma);
figure(6);
x = -1500: 0.5 : 1200;
y = pdf(CSobj2_IA,x);
y1 = pdf(Stovobj2_IA,x);
y2 = pdf(Swchobj2_IA,x);
y3 = pdf(Miscobj2_IA,x);
plot(x,y,'b',x,y1,'--r',x,y2,'--g',x,y3,'c');
legend('CS','Stover','Swch','Misc');
xlabel('$/ha');
ylabel('Probability Distribution')
title('Returns over total costs');

%without OC
%Switchgrass
mu = mean(Swchobj2a);
sigma = std(Swchobj2a);
Swchobj2a_IA = makedist('normal','mu',mu,'sigma',sigma);
%Miscanthus
mu = mean(Miscobj2a);
sigma = std(Miscobj2a);
Miscobj2a_IA = makedist('normal','mu',mu,'sigma',sigma);
figure(7);
x = -500: 0.5 : 1000;
y = pdf(CSobj1_IA,x);
y1 = pdf(Stovobj1_IA,x);
y2 = pdf(Swchobj2a_IA,x);
y3 = pdf(Miscobj2a_IA,x);
plot(x,y,'b',x,y1,'--r',x,y2,'--g',x,y3,'c');
legend('CS','Stover','Swch','Misc');
xlabel('$/ha');
ylabel('Probability Distribution')
title('Returns over total costs without an opportunity cost');