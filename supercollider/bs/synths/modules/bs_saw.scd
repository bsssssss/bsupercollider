(
SynthDef(\bs_saw, {
	|out, gate=0, sustain=1, freq=440, speed=1, begin=0, end=1, cps, pan, accelerate, offset|

	var snd;
	var dur  = sustain * (end - begin);
	var line = Line.ar(begin, end, dur, doneAction: Done.freeSelf);
	var pitchEnv = TiltEnv.ar(
		\pitch_env_tilt.kr(0).clip(0,1),
		\pitch_env_hold.kr(0).clip(0,1),
		\pitch_env_curve.kr(-4),
		0.11 / \pitch_env_speed.kr(1)
	);

	freq   = max(0, (freq) * (1 + (accelerate * line)));
	freq   = (freq.cpsmidi + (SinOsc.ar(freq: \vibrato_rate.kr(8) * cps) * \vibrato_depth.kr(0)) + (pitchEnv * \pitch_env.kr(0))).midicps;

	snd = Saw.ar(
		freq: freq
	);
	snd = LeakDC.ar(snd);


	Out.ar(out,DirtPan.ar(snd, ~dirt.numChannels, pan, 1))
}).add
);
