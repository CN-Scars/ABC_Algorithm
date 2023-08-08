function [K,Bsi] = Axui_FeedbackGain(EmuD1,EmuD2)

a1 = 1; a2 = 2; a3 = 3;

A = [2 1 1;
     1 1 0;
     0 1 2];

B = [1 2;
     3 1;
     1 1];

Emu = [0,     1,     0;
       EmuD1, EmuD2, 1];
   
b1 = [B(1:3,1)];
b2 = [B(1:3,2)];
M = [b1 A*b1 b2];
Mi = inv(M);
H = Emu*Mi;

h1 = [H(1,1:3)];
h2 = [H(2,1:3)];
Bs = [h1*A*B;h2*B];
Bsi = inv(Bs);

piA1 = A^2+(a1+a2)*A+(a1*a2)*eye(3); 
piA2 = A+a3*eye(3);
As1 = h1*piA1;
As2 = h2*piA2;
As = [As1;As2];

K = Bsi*As;
