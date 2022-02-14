function y = pitchGenerate2(pitch, Amplitude, X, Fs,Ttot)

Ts=1/Fs;
t=[0:Ts:Ttot];

y = Amplitude .* sin((2.*pi.*t.*pitch)*X); 
y = y(:);
end

