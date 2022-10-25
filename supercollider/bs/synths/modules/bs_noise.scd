(

SynthDef(\bs_noise, {
	|out, sustain=1, freq=440, speed=1, begin=0, end=1, pan, accelerate, offset,
	fall=1, rise=0, fallRate=1, riseRate=1, fallCurve=(-5), riseCurve=5, curve=5|

	var sigFall,
		sigRise,
		sig,
		ampEnv,
		lineFall,
		lineRise,
		dur,
		envFall,
		envRise;

	dur = sustain * (end - begin);

	lineFall = Line.ar  (begin, end, dur*(1/fallRate), doneAction:2);
	lineRise = Line.ar  (begin, end, dur*(1/riseRate), doneAction:2);

	envFall = IEnvGen.ar (Env.new(
		levels: [0,1,0],
		times:[0.008, 1, 0],
		curve:[0, (fallCurve), 0]),
	lineFall
	);

	envRise = IEnvGen.ar (Env.new(
		levels: [0,0,1],
		times:[0, 1, 0],
		curve:[0, riseCurve, 0]),
	lineRise
	);

	sigFall = PinkNoise.ar(envFall * fall);
	sigRise = PinkNoise.ar(envRise * rise);
	sig     = Mix.new([sigFall, sigRise]);

	OffsetOut.ar (out, DirtPan.ar (sig, ~dirt.numChannels, pan))
}).add;

);