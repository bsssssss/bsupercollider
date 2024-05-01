(
SynthDef(\bs_sine, {
	|out, gate=0, sustain=1, freq=440, speed=1, begin=0, end=1, cps, pan, accelerate, offset|

	var snd;
	var	dur  = sustain * (end - begin);
	var line = Line.ar(begin, end, dur, doneAction: Done.freeSelf);

	var pitch_EG = TiltEnv.ar(\pitch_env_tilt.kr(0),\pitch_env_hold.kr(0),\pitch_env_curve.kr(-4),
		0.11 / \pitch_env_speed.kr(1) ) * \pitch_env.kr(0);
	var pitch_LFO = SinOsc.ar(freq: \vibrato_rate.kr(8) * cps) * \vibrato_depth.kr(0);

	freq = max(0, freq * (1 + (accelerate * line)));
	freq = (freq.cpsmidi + pitch_LFO + pitch_EG).midicps;

































	snd = SinOsc.ar(
		freq:  freq,
		phase: 0
	);
	snd = LeakDC.ar(snd);

	Out.ar(out,DirtPan.ar(snd, ~dirt.numChannels, pan, 1))

}).add;
)
