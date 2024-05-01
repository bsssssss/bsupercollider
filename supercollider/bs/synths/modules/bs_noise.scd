(

SynthDef(\bs_noise, {
	|out, sustain=1, freq=440, speed=1, begin=0, end=1, pan, accelerate, offset|

	var snd, dur, line;

	dur = sustain;
	line = Line.kr(0, 1, dur, doneAction: Done.freeSelf);

	snd = WhiteNoise.ar * (-6.dbamp);

	Out.ar (out, DirtPan.ar (snd, ~dirt.numChannels, pan))
}).add;

);