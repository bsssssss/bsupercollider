(
SynthDef("rings", {
	|out, gate=0, sustain=1, freq=440, speed=1, begin=0, end=1, cps, pan, accelerate, offset|

	var snd;

	var struct = \structure.kr(0.5);
	var bright = \brightness.kr(0.5);
	var damp   = \damping.kr(0.5);
	var pos    = \position.kr(0.5);

	var dur = sustain*(end-begin);
	var line = Line.ar(begin, end, dur, doneAction: Done.freeSelf);

	var pitchEnv = TiltEnv.ar(
		\pitch_env_tilt.kr(0).clip(0,1),
		\pitch_env_hold.kr(0).clip(0,1),
		\pitch_env_curve.kr(-4),
		0.11 / \pitch_env_speed.kr(1)
	);

	freq   = max(0, (freq) * (1 + (accelerate * line)));
	freq   = (freq.cpsmidi + (SinOsc.ar(freq: \vibrato_rate.kr(8) * cps) * \vibrato_depth.kr(0)) + (pitchEnv * \pitch_env.kr(0))).midicps;

	snd = MiRings.ar(
		//in:             trig,
		trig:           1,
		pit:            freq.cpsmidi,
		struct:         struct,
		bright:         bright,
		damp:           damp,
		pos:            pos,
		model:          \model.kr(0).fold(0, 5),
		poly:           1,
		intern_exciter: 0,
		easteregg:      \easter_egg.kr(0)
	);

	snd = snd.tanh;
	snd = snd * (-6.dbamp);

	//DetectSilence.ar(snd, doneAction: Done.freeSelf);


	snd = Mix.ar (DirtPan.ar (snd, ~dirt.numChannels, -1) * \odd.kr(1)
		          + (DirtPan.ar (snd, ~dirt.numChannels,  1) * \even.kr(0)));
	Out.ar(out, DirtPan.ar(snd, ~dirt.numChannels, pan, 1));
}).add;
);
