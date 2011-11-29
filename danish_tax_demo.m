income_monthly = linspace(2000,120000,30);
[ic, tax] = danish_tax(income_monthly);
[ic_d, tax_d] = danish_tax(income_monthly,'beskaef_fradrag',0.042, 'lone_interest', 5000);

subplot(211)
plot(income_monthly,ic/12, 'o', ...
    income_monthly,ic_d/12 ,'o')
xlabel('income before tax (monthly)')
ylabel('income after tax (monthly)')
legend('No duduction','Paid interest 5000kr monthly')
grid on
subplot(212)
plot(income_monthly,tax, 'x', ...
    income_monthly,tax_d, 'x')
xlabel('income before tax (monthly)')
ylabel('tax of total income')
legend('No duduction','Paid interest 5000kr monthly')
grid on
