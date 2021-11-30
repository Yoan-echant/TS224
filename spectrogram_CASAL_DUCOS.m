clear ;
close all;
clc;

%% Display

%recovery of the signal to be analysed

addpath(genpath('.'));
[file,path]=uigetfile('*mat','rt');
signal=load(fullfile(path,file));
Fs=signal.Fs;
ecg=signal.ecg;


% tests of our functions

figure
subplot(2,2,1)
spectro(ecg,hamming(Fs*8),256,512,Fs);
title('Spectrogram of a normal patient')

load  data/ecg_AF.mat
subplot(2,2,2)
spectro(ecg,hamming(Fs*8),256,512,Fs);
title('Spectrogram of a sick patient (AF)')

load  data/ecg_VF.mat
subplot(2,2,3)
spectro(ecg,hamming(Fs*8),256,512,Fs);
title('Spectrogram of a sick patient (VF)')

load  data/ecg_PVC.mat
subplot(2,2,4)
spectro(ecg,hamming(Fs*8),256,512,Fs);
title('Spectrogram of a sick patient (PVC)')


%% Fonctions


function [X, f, t] = stft(x,w,d,N_fft,Fs)
% This function computes the stft for m = [0, d, 2d, 3d...]
% This function outputs are:
% -> X, which is a matrix of n_fft lines and M columns
% M is the number of elements of m
% X(i,j) is the value of the spectrogram for time t(i) and frequency f(j)
% -> f, is a column vector of the frequencies (in Hz)
% -> t, is a row vector containing the times of the beginning of the windows

L = length(x);
N = length(w);
M = floor ( L / d);
X = zeros ( N , M);
t=zeros(1,N);

if L < M*d + N
    
    x = [ x zeros( 1 , M*d + N - L) ];
    
end


k=1;
for i = 1 : M
    
    X ( : , i ) = x( k : k + N - 1 ) .*w';
    k=k+d;
    
end

X = fft(X,N_fft,1);

nu = 0 : 1/N : (N-1)/N;
f = nu .* Fs;
end




function [Sx, f, t] = spectro(x,w,d,N_fft,Fs)
% This function computes the spectrogram for m = [0, d, 2d, 3d...]
% This function outputs are:
% -> Sx, which is a matrix of n_fft lines and
% M (number of elements of m) columns
% Sx(i,j) is the value of the spectrogram for time t(i) and frequency f(j)
% -> f, is a column vector of the frequencies (in Hz)
% -> t, is a row vector containing the times of the beginning of the windows

[X, f, t] = stft(x,w,d,N_fft,Fs) ;

N = length(w);

Sx = 1/N * abs(X) .^2 ;
imagesc(log(Sx));

end



