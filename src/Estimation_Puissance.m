function A=Estimation_Puissance(fech,fmin,fmax,x,padding)


N=10;
n=2*fech;
sigma=1;
nbit=100;
fen=[zeros(1,fmin) ones(1,(fmax-fmin)+1)];
s=sigma*randn(1,n);
sftest=conv2(s,fen);
f0=3*fech/2;


%%Méthode de Welch

Nfft=floor(n/10); %%Largeur de la fenêtre
dec=floor(n/20);  %%décalage entre le début de deux fenêtre
    
sftest=ones(Nfft);
    
%%Zero-padding
if (padding==1)
    nsf=length(sftest);
    i=nsf;
    c=1;
    while (i/2>1)
        i=i/2;
        c=c+1;
    end
    l=(2^c)-nsf;
else
    l=0;
end

DSPm=0;

for j=1:N
    i=0;
    %fct=sigma*randn(1,n);
    fct=cos(f0/fech*ones(1,n));    
    while i*dec+Nfft < n
        selec=zeros(1,n);
        selec(i*dec+1:i*dec+Nfft)=ones(1,Nfft);

        s=fct.*selec;
        %sf=[s zeros(1,l)];
        sf=[conv2(s,fen) zeros(1,l)];

        tf=fftshift(fft(sf));

        DSP=abs(tf).^2;
        DSPm=DSPm+DSP;
        i=i+1;
    end
end
DSPm=DSPm/(i*N);

%figure,

if (x==1)
    absi=linspace(fmin,fmax,length(DSPm));
    %plot(absi,DSPm)
    title('Periodogramme par la méthode de Welch');
    xlabel('Fréquence (Hz)')
    ylabel('Puissance')
    %%Calcul de la puissance par la méthode des trapèze.
    nd=length(DSPm);
    A=0;
    for i=1:nd-1
        A=A+(DSPm(i)+DSPm(i+1))*(1/fech)/2;
    end
    A=round(A);
    %disp(["La puissance estimé par la méthode des trapèze est" A "W"]);
elseif x==0
    %imagesc(-f0,1,log(DSPm))
    title('Spectrogramme');
    xlabel('Fréquence (Hz)')
    ylabel('Puissance')
end
end