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
    
%sftest=ones(Nfft);
    
%%Détermination du nombre de zero pour le zero-padding
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

%%Boucle de N itération pour approcher la DSP

for j=1:N
    i=0;
    %%Génération de l'itération
    
    %fct=sigma*randn(1,n);
    fct=cos(f0/fech*ones(1,n));
    
    %%Boucle de fenêtrage
    while i*dec+Nfft < n
        selec=zeros(1,n);
        selec(i*dec+1:i*dec+Nfft)=ones(1,Nfft);

        s=fct.*selec;
        %%Convolution par la fenêtre+ zero padding
        sf=[conv2(s,fen) zeros(1,l)];
        
        %%fft
        tf=fftshift(fft(sf));
        
        %Calcul DSE
        DSE=abs(tf).^2;
        DSPm=DSPm+DSE;
        i=i+1;
    end
end

%%Moyennage des DSE

DSP=DSPm/(i*N);

%figure,

if (x==1)
    absi=linspace(fmin,fmax,length(DSP));
    plot(absi,DSP)
    title('Periodogramme par la méthode de Welch');
    xlabel('Fréquence (Hz)')
    ylabel('Puissance')
    %%Calcul de la puissance par la méthode des trapèze.
    nd=length(DSP);
    A=0;
    for i=1:nd-1
        A=A+(DSP(i)+DSP(i+1))*(1/fech)/2;
    end
    A=round(A);
    %disp(["La puissance estimé par la méthode des trapèze est" A "W"]);
elseif x==0
    imagesc(-f0,1,log(DSPm))
    title('Spectrogramme');
    xlabel('Fréquence (Hz)')
    ylabel('Puissance')
end
end