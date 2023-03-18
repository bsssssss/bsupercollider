(

SynthDef(\bs_sine, {
	| out, gate=0, sustain=1, freq=440, speed=1, begin=0, end=1, pan, accelerate, offset,
	pitchEnv=0, pitchEnvSpeed=1, pitchModCurve=(-12) |

	var pitchMod,
	    sig,
		osc,
		gainEnv,
		gain,
		line,
		dur;

	dur  = sustain * (end - begin)/speed;

	line     = Line.ar    (begin, end, dur, doneAction: Done.freeSelf);
	gainEnv  = Env.new    (levels: [0, 1, 0.77, 0], times: [0.01, 0.88, 0.1], curve:[-5, -3, 5]);
	gain     = IEnvGen.ar (gainEnv,line);

	pitchMod = EnvGen.ar (Env.new (
		levels: [0, 1, 0],
		times:  [0, 0.1 * (1 / pitchEnvSpeed), 0],
		curve:  [1, pitchModCurve, -5]))
		* pitchEnv;

	freq     = max (0, (freq + (pitchMod * 200)) * (1+ (accelerate * line)));
	freq     = freq.clip(0, 20000);

	osc = SinOsc.ar(
		freq:  freq,
		phase: 2pi
	);
	osc = LeakDC.ar(osc);

	OffsetOut.ar(out,DirtPan.ar(osc, ~dirt.numChannels, pan, gain))

}).add;

);
