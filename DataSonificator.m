load('datasono.mat')
ngen = size(dataSortReproAv);

% find genes that with the expression level higher/lower than at the
% reproductive stage.
% for prepubertal
indPrepubUP = find(dataSortPrepubAv > dataSortReproAv + num*dataSortReproSEM);
indPrepubDOWN =  find(dataSortPrepubAv < dataSortReproAv - num*dataSortReproSEM);
% for menopausal
indMenopUP = find(dataSortMenopAv > dataSortReproAv + num*dataSortReproSEM);
indMenopDOWN =  find(dataSortMenopAv < dataSortReproAv - num*dataSortReproSEM);

%% music for Prepub

Fs = 8192; % sampling frequency
% note frexuency in Hz for a chromatic scale
pitchvalue = [262, 277, 294, 311, 330,  349, 370, 392, 415, 440, 466, 494, 523];
pitchdiff = diff(pitchvalue);
% notes names for a chromatic scale
pitchname =  {'C' 'C#' 'D' 'D#' 'E' 'F' 'F#' 'G' 'G#' 'A' 'A#' 'B', 'C2'};
% melody for "twinkle twinkle little star"
melody = {'C' 'C' 'G' 'G' 'A' 'A' 'G' ...
          'F' 'F' 'E' 'E' 'D' 'D' 'C' ...
          'G' 'G' 'F' 'F' 'E' 'E' 'D'....
          'G' 'G' 'F' 'F' 'E' 'E' 'D'...
          'C' 'C' 'G' 'G' 'A' 'A' 'G' ...
          'F' 'F' 'E' 'E' 'D' 'D' 'C' ...
          'G' 'G' 'F' 'F' 'E' 'E' 'D'};
      % rythm, 2 - twice longer than 1 (
rhytm =   [1 1 1 1 1 1 2 1 1 1 1 1 1 2 1 1 1 1 1 1 2 1 1 1 1 1 1 2 ...
           1 1 1 1 1 1 2 1 1 1 1 1 1 2 1 1 1 1 1 1 2]/2;
       % find notes indices rom the chromatic scale
for k1 = 1:length(melody)
    idx = strcmp(melody(k1), pitchname);
    melodyidx(k1) = find(idx);
end    
%% melody for Repro
melodynote = [];
for k1 = 1:length(melodyidx)
    freqRepPrepMenop(k1,1) = pitchvalue(melodyidx(k1));
    melodynote = [melodynote; pitchGenerate2(pitchvalue(melodyidx(k1)), Amplitude, X,Fs,rhytm(k1))];

    melodynote = [melodynote;zeros(75,1)]; % short pause
end
 soundsc(melodynote, Fs)%  play
 % normalise between -1 and 1
melodynote = -1 + 2.*(melodynote - min(melodynote))./(max(melodynote) - min(melodynote));
% save normalise
audiowrite('TwinkleTwinkle.wav', melodynote, Fs);
%% melody for prepubertal
melodynotePrepub = [];
for k1 = 1:ngen%length(melodyidx)
     freqRepPrepMenop(k1,2) = pitchvalue(melodyidx(k1));
    if ismember(k1,indPrepubUP) % execute if expression higher than in repro
        freqshift = dataSortReproAv(k1)/dataSortPrepubAv(k1);
        freqPrepub(k1) = pitchvalue(melodyidx(k1)) + freqshift*pitchdiff(melodyidx(k1));
        melodynotePrepub = [melodynotePrepub; pitchGenerate2(freqPrepub(k1), ...
            Amplitude, X,Fs,rhytm(k1))];
    elseif ismember(k1,indPrepubDOWN) % execute if expression lower than in repro
        freqshift = dataSortPrepubAv(k1)/dataSortReproAv(k1);
        freqPrepub(k1) = pitchvalue(melodyidx(k1)) - freqshift*pitchdiff(melodyidx(k1));
        melodynotePrepub = [melodynotePrepub; pitchGenerate2(freqPrepub(k1), ...
            Amplitude, X,Fs,rhytm(k1))];
    else % execute if no significant change in expression compared to repro
        melodynotePrepub = [melodynotePrepub; pitchGenerate2(pitchvalue(melodyidx(k1)), ...
            Amplitude, X,Fs,rhytm(k1))];
    end
     freqRepPrepMenop(k1,2) = freqPrepub(k1);
    melodynotePrepub = [melodynotePrepub;zeros(75,1)]; % short pause
end
soundsc(melodynotePrepub, Fs) % play melody
% rescale
melodynotePrepub = -1 + 2.*(melodynotePrepub - min(melodynotePrepub))./(max(melodynotePrepub) - min(melodynotePrepub));
%save
audiowrite('TwinkleTwinkle_Prepub.wav', melodynotePrepub, Fs);
%% melody Menop
melodynoteMenop = [];
for k1 = 1:ngen%length(melodyidx)
    freqRepPrepMenop(k1,3) = pitchvalue(melodyidx(k1));
    if ismember(k1,indMenopUP) % execute if expression higher than in repro
        freqshift = dataSortReproAv(k1)/dataSortMenopAv(k1);
        freqMenop(k1) = pitchvalue(melodyidx(k1)) + freqshift*pitchdiff(melodyidx(k1));
        melodynoteMenop = [melodynoteMenop; pitchGenerate2(freqMenop(k1), ...
            Amplitude, X,Fs,rhytm(k1))];
    elseif ismember(k1,indMenopDOWN) % execute if expression lower than in repro
        freqshift = dataSortMenopAv(k1)/dataSortReproAv(k1);
        freqMenop(k1) = pitchvalue(melodyidx(k1)) - freqshift*pitchdiff(melodyidx(k1));
        melodynoteMenop = [melodynoteMenop; pitchGenerate2(freqMenop(k1), ...
            Amplitude, X,Fs,rhytm(k1))];
    else % if no change in expression level
        melodynoteMenop = [melodynoteMenop; pitchGenerate2(pitchvalue(melodyidx(k1)), ...
            Amplitude, X,Fs,rhytm(k1))];
    end
    freqRepPrepMenop(k1,3) = freqMenop(k1);
    melodynoteMenop = [melodynoteMenop;zeros(75,1)]; % short pause
end
soundsc(melodynoteMenop, Fs) % play melody
% rescale
melodynoteMenop = -1 + 2.*(melodynoteMenop - min(melodynoteMenop))./(max(melodynoteMenop) - min(melodynoteMenop));
%save
audiowrite('TwinkleTwinkle_Menop.wav', melodynotePrepub, Fs);