function [ic tax]= danish_tax(income_monthly,varargin)

% initialization
% http://www.skat.dk/SKAT.aspx?oId=133800
% http://worktrotter.dk/images/taxes2011.jpg
% http://en.wikipedia.org/wiki/Taxation_in_Denmark

conf = struct(...,
    'beskaef_fradrag', 0 ,...
    'lone_interest' , 0 ...
    );

conf = getargs(conf, varargin); 

tax_Gross = 8 / 100;
tax_Municipal = 24 / 100; % 0.23 - 0.28
tax_Health = 8 / 100;
tax_BaseState = 3.64 / 100;
tax_TopState = 15 / 100;

% deduction, fradrag
beskaef_fradrag = conf.beskaef_fradrag;
Max_beskaef_fradrag = 13600;

% interest deduction
Max_lone_interest = 50000;
lone_interest = conf.lone_interest*12;
if lone_interest > Max_lone_interest
    lone_interest = Max_lone_interest;
end
Base_level = 42900 + lone_interest;
Top_level = 389900;

% calculation
ic_year = income_monthly * 12;

ic = ic_year;
ic_pure = ic * (1-tax_Gross); %
ic = ic_pure;

for ii = 1:length(ic)
    if ic_pure(ii) > Base_level
        tax_coef = ic_pure(ii) - Base_level;
        ic(ii) = ic(ii) - tax_coef.*tax_BaseState; %
        
        if tax_coef*(beskaef_fradrag) < Max_beskaef_fradrag
            tax_coef_2 = tax_coef*(1-beskaef_fradrag);
        else
            tax_coef_2 = tax_coef - Max_beskaef_fradrag;
        end
        ic(ii) = ic(ii) - tax_coef_2.*tax_Municipal; %
        ic(ii) = ic(ii) - tax_coef_2.*tax_Health; %
        

        if ic_pure(ii) > Top_level
            tax_coef = ic_pure(ii) - Top_level;
            ic(ii) = ic(ii) - tax_coef.*tax_TopState; %
        end
    end
end

tax = 1 - ic ./ ic_year;