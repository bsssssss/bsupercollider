(

SynthDef(\bs_sinefm, {

	|out, sustain=1, freq=440, speed=1, begin=0, end=1, pan, accelerate, offset|

	var dur, sig, line, gainEnv, gain, osc1, osc2, pitchMod;

	dur     = sustain*(end-begin);
    line    = Line.ar(begin, end, dur, doneAction: Done.freeSelf);
	gainEnv = Env.new([0,1,0], [0.01,0.99], [0, 80]);
    gain    = IEnvGen.ar(gainEnv, line);

	pitchMod = EnvGen.ar (Env.new (
		levels: [0, 1, 0],
		times:  [0, 0.1 * (1 / \pitchEnvSpeed.kr(1)), 0],
		curve:  [1, \pitchModCurve.kr(-4), -5]))
	* \pitchEnv.kr(0);

	freq   = max(0, (freq) * (1 + (accelerate * line)));
	freq   = (freq.cpsmidi + pitchMod).midicps;

	osc2    = SinOsc.ar(freq*\fmRatio.kr(1) , 2pi);
	osc1    = SinOsc.ar(freq , osc2*\fmAmount.kr(0));

	sig = osc1;
	sig = LeakDC.ar(sig);

	ReplaceOut.ar(out, DirtPan.ar (sig, ~dirt.numChannels, pan, gain))
}).add

);
