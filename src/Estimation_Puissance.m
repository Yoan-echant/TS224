function Estimation_Puissance(fech,fmin,fmax,x,padding)


fech=round(fech);
fmin=round(fmin);
fmax=round(fmax);

x=round(x);
n=100;
sigma=1;
nbit=100;
fen=zeros(1,fmax);
fen(1,fmin:fmax)=ones(1,fmax-fmin+1);
s=sigma*randn(1,n);
sftest=conv2(s,fen);
%prompt= 'tapez 0 pour un spectre de puissance, 1 pour un periodigramme: ';
%x=input(prompt);
%%Spectre de puissance
disp('hey')
disp(padding)
if x ==1
    %%Zero-padding
    if (padding==1)
        nsf=length(sftest);
        i=nsf;
        c=1;
        while (i/2>1)
            i=i/2;
            c=c+1;
        end
        l=0;
        while ((nsf+l)/(2^c)~=1)
            l=l+1;
        end
    else
    l=0;    
    end
    DSPm=0;

    for i=0:nbit
        s=sigma*randn(1,n);

        sf=[conv2(s,fen) zeros(1,l)];

        tf=fftshift(fft(sf));

        DSP=abs(tf).^2/nbit;
        DSPm=DSPm+DSP;
    end

    figure;
    plot(DSPm)
    title('Periodogramme par la méthode de Welch');
    xlabel('Fréquence (Hz)')
    ylabel('Puissance')
    
    %%Calcul de la puissance par la méthode des trapèze.
    nd=length(DSPm);
    A=0;
    for i=1:nd-1
        A=A+(DSPm(i)+DSPm(i+1))*(1/fech)/2;
    end
    disp(["La puissance estimé par la méthode des rectangle est" A "W"]);


%{
elseif x==2
    %%Specte de puissance:
    Nfft=floor(n/10);
    dec=floor(n/20);
    
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
        l=0;
        while ((nsf+l)/(2^c)~=1)
            l=l+1;
        end
    end
    
    DSPm=0;
    i=0;
    while i*dec+Nfft < n
        selec=zeros(1,n);
        selec(i*dec+1:i*dec+Nfft)=ones(1,Nfft);
        
        s=sigma*randn(1,n).*selec;

        sf=[conv2(s,fen) zeros(1,l)];

        tf=fftshift(fft(sf));

        DSP=abs(tf).^2;
        DSPm=DSPm+DSP;
        i=i+1;
    end
    DSPm=DSPm/i;
    figure;
    plot(DSPm)
    title('Estimation de la puissance');
    xlabel('Fréquence (Hz)')
    ylabel('Puissance')
%} 
elseif x==0
    figure,
    spectrogram(sigma*randn(1,n))
    title('Spectre de puissance')
    
else
    disp("La valeur entrée n'est pas valide") 
end
end