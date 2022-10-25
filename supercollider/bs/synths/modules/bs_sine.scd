(

SynthDef(\bs_sine, {
	| out, gate=0, sustain=1, freq=440, speed=1, begin=0, end=1, pan, accelerate, offset, pitchEnv=0, pitchEnvSpeed=1, pitchModCurve=(-12) |

	var pitchMod,
	    sig,
		osc,
		gainEnv,
		gain,
		line,
		dur;

	dur  = sustain * (end - begin);

	line     = Line.ar    (begin, end, dur, doneAction:2);
	gainEnv  = Env.new    (levels: [0, 1, 0.77, 0], times: [0.008, 0.8, 0.1], curve:[-5, -3, 5]);
	gain     = IEnvGen.ar (gainEnv,line);

	freq     = max (0, freq * (1+ (accelerate * line)));
	freq     = freq.clip(0, 20000);
	pitchMod = EnvGen.ar (Env.new (levels: [0, 1, 0], times: [0, 0.1 * (1 / pitchEnvSpeed), 0], curve: [1, pitchModCurve, -5])) * pitchEnv;

	osc = SinOsc.ar(
		freq:  freq+(pitchMod*freq),
		phase: 2pi
	);
	osc = LeakDC.ar(osc);

	OffsetOut.ar(out,DirtPan.ar(osc, ~dirt.numChannels, pan, gain))

}).add;

);
