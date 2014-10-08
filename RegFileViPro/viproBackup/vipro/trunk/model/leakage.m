function [E_leakage] = leakage()

I_offn = 2.1e-9;
I_offp = 1.5e-9;
VDD = 1.0;
Tclk = 5e-9;

E_leakage = VDD*Tclk*(2*I_offn + I_offp);

end
