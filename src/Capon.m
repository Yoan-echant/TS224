padding=1;
F=3000;
P=zeros(1,F-1);
fech=1000;
for f=2:F
    fmin=f-1;
    fmax=f+1;
    P(f-1)=Estimation_Puissance(fech,fmin,fmax,1,padding);
end

plot(2:F,P)