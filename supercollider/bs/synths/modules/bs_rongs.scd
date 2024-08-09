(
SynthDef.new(\bs_rongs, {

	|out=0, freq=440, sustain=1, pan=0, begin=0, end=1, speed=1, accelerate=0, cps=0.5|

	var snd;
	var trig = Trig.kr(1, dur: sustain);
	var modeNum=2;
	var cosFreq=0.25;

	var envLength = sustain*(end-begin);
	var line      = Line.ar(begin, end, envLength, doneAction: Done.freeSelf);

	freq = max(0, (freq) * (1 + (accelerate * line)));
	freq = freq;

	snd = Rongs.ar(
		trigger:    trig,
		sustain:    trig*0,
		f0:         freq,
		structure:  structure,
		brightness: brightness,
		damping:    damping,
		accent:     accent,
		stretch:    harmonicStretch,
		position:   position,
		loss:       loss,
		modeNum:    modeNum,
		cosFreq:    cosFreq
	);

	/*DetectSilence.ar(in: sig, amp: 0.0001, time: 0.1, doneAction: 2);*/

	Out.ar(out, DirtPan.ar(snd, ~dirt.numChannels, pan, volume));
}).add;
);
