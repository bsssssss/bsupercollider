(

SynthDef(\bs_sinefm, {

	|out, sustain=1, freq=440, speed=1, begin=0, end=1, pan, accelerate, offset,
	fmAmount=0, fmRatio=1|

	var dur, sig, line, gainEnv, gain, osc1, osc2;

	dur     = sustain*(end-begin)/speed;
    line    = Line.ar(begin, end, dur, doneAction: Done.freeSelf);
	gainEnv = Env.new([0,1,0], [0.01,0.99], [0, 80]);
    gain    = IEnvGen.ar(gainEnv, line);

	freq   = max(0, (freq) * (1 + (accelerate * line)));

	osc2    = SinOsc.ar(freq*fmRatio, 2pi);
	osc1    = SinOsc.ar(freq , osc2*fmAmount);

	sig = osc1;
	sig = LeakDC.ar(sig);

	ReplaceOut.ar(out, DirtPan.ar (sig, ~dirt.numChannels, pan, gain))
}).add

);
