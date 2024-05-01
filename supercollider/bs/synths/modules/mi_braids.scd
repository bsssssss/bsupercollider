(
SynthDef(\braids, {
	| out=0, freq=440, sustain=1, pan=0, begin=0, end=1, speed=1, accelerate=0, cps=0.5|

	var dur = sustain*(end-begin);
	var line   = Line.ar(begin, end, dur, doneAction: Done.freeSelf);

	var timbre_eg = TiltEnv.ar(\timbre_env_tilt.kr(0).clip(0,1), \timbre_env_hold.kr(0).clip(0,1), \timbre_env_curve.kr(-4),
		dur / \timbre_env_speed.kr(1) );

	var color_eg  = TiltEnv.ar(\color_env_tilt.kr(0).clip(0,1),  \color_env_hold.kr(0).clip(0,1),  \color_env_curve.kr(-4),
		dur / \color_env_speed.kr(1) );

	var pitch_eg  = TiltEnv.ar(\pitch_env_tilt.kr(0).clip(0,1),  \pitch_env_hold.kr(0).clip(0,1),  \pitch_env_curve.kr(-4),
		0.11 / \pitch_env_speed.kr(1));

	var snd, timbre, color;

	freq = max(0, (freq) * (1 + (accelerate * line)));
	freq = freq.cpsmidi + (SinOsc.ar(freq: \vibrato_rate.kr(8) * cps) * \vibrato_depth.kr(0)) + (pitch_eg * \pitch_env.kr(0));

	timbre = (timbre_eg * \timbre_env.kr(0)) + \timbre.kr(0.5);
	color  = (color_eg  * \color_env.kr(0))  + \color.kr(0.5);

	snd = MiBraids.ar (
		pitch:  freq,
		timbre: timbre.clip(0, 1),
		color:  color.clip(0, 1),
		model:  \model.kr(0).fold(0, 47),
		resamp: 0
	);
	snd = snd * (-6.dbamp);

	Out.ar(out, DirtPan.ar(snd, ~dirt.numChannels, pan, 1));
}).add;
);