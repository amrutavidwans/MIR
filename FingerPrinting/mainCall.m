clear all;
close all;
clc;

addpath('/Users/Rithesh/Documents/MIR/Projects/FingerPrinting_Supplies/DanEllisCodes/');

[audio,oldSampleFreq] = audioread('/Users/Rithesh/Documents/MIR/Projects/FingerPrinting_Supplies/DanEllisCodes/audio/Christina Perri - A Thousand Years.wav');
%[oldAudio,oldSampleFreq] = audioread('/Users/Amruta/Documents/MS GTCMT/Sem1/Computational Music Analysis/Christina Perri - A Thousand Years.wav');

% possible downsampling goes here
% downSampleFactor =2;     
% audio = downsample(audio,downSampleFactor);
% sampleFreq = sampleFreq/downSampleFactor;
sampleFreq = 8000; %not giving importance to High Frequency Content
audio = resample(audio,sampleFreq,oldSampleFreq);

windowSize = 0.064; noverlap = 0.5;
timeDistance = 5; pitchDistance = 5;
nfft=512;
prcntPks  = 2/100;

[specMat,yFreq,xTime] = mySpectrogram(audio,sampleFreq,windowSize,noverlap);
% save('specMat.mat','specMat');
[peakLocation] = findSalientPeaks(specMat,pitchDistance,prcntPks,sampleFreq);
%plotSalientPeaks(peakLocation,xTime,yFreq,specMat);
%
%elimCriteria = 20;
%reducedPkLoc=reduceDensity(peakLocation,yFreq,elimCriteria);
%figure
%plotSalientPeaks(reducedPkLoc,xTime,yFreq,specMat);

%% 
load('maxes1.mat');
load('theirSpec.mat');
[L,maxes]  = getLandMarks( specMat );  %>> note that that our specMat has different magnitude from his! 

[landy,~,~,maxy] = find_landmarks(audio,sampleFreq,5);

%%
H = getHashStruct( 5, L );
Hy = landmark2hash( L, 5 );


%%
global hashTable hashCount

hashTable = zeros( 20, 2^20); % maximum 20 entries per hash
hashCount = zeros( 1,  2^20); % 2^20 cause our hash is a 20 bit structure

%%
storeHashes( H );