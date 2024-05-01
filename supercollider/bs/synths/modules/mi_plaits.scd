(
  SynthDef(\plaits, {

	|out=0, freq=440, sustain=1, pan=0, begin=0, end=1, speed=1, accelerate=0, cps=0.5|

    var snd, timbre, harm, morph;

    var dur  = sustain*(end-begin);
    var line = Line.kr(begin, end, dur, doneAction: Done.freeSelf);

	var timbreEnv = TiltEnv.ar(
		\timbre_env_tilt.kr(0).clip(0,1),
		\timbre_env_hold.kr(0).clip(0,1),
		\timbre_env_curve.kr(-4),
		dur / \timbre_env_speed.kr(1)
	);
	var harmEnv = TiltEnv.ar(
		\harm_env_tilt.kr(0).clip(0,1),
		\harm_env_hold.kr(0).clip(0,1),
		\harm_env_curve.kr(-4),
		dur / \harm_env_speed.kr(1)
	);
	var morphEnv = TiltEnv.ar(
		\morph_env_tilt.kr(0).clip(0,1),
		\morph_env_hold.kr(0).clip(0,1),
		\morph_env_curve.kr(-4),
		dur / \morph_env_speed.kr(1)
	);


	var timbreLfoRate = \timbre_lfo_rate.kr(2.5);
	var timbreLfo = SelectX.kr (\timbre_lfo_shape.kr(0);, [
		LFSaw.kr   (freq: cps * timbreLfoRate, add: 1)/2,
		LFTri.kr   (freq: cps * timbreLfoRate, add: 0),
		SinOsc.kr  (freq: cps * timbreLfoRate, add: 0),
		LFPulse.kr (freq: cps * timbreLfoRate, add: 0),
	]) * \timbre_lfo_amp.kr(0);

	var harmLfoRate = \harm_lfo_rate.kr(2.5);
	var harmLfo = Select.kr (\harm_lfo_shape.kr(0), [
		LFSaw.kr   (freq: cps * harmLfoRate, add: 1)/2,
		LFTri.kr   (freq: cps * harmLfoRate, add: 0),
		SinOsc.kr  (freq: cps * harmLfoRate, add: 0),
		LFPulse.kr (freq: cps * harmLfoRate, add: 0),
	])* \harm_lfo_amp.kr(0);

	var morphLfoRate = \morph_lfo_rate.kr(2.5);
	var morphLfo = Select.kr (\morph_lfo_shape.kr(0), [
		LFSaw.kr   (freq: cps * morphLfoRate, add: 1)/2,
		LFTri.kr   (freq: cps * morphLfoRate, add: 0),
		SinOsc.kr  (freq: cps * morphLfoRate, add: 0),
		LFPulse.kr (freq: cps * morphLfoRate, add: 0),
	])* \morph_lfo_amp.kr(0);

	var pitchEnv = TiltEnv.ar(
		\pitch_env_tilt.kr(0).clip(0,1),
		\pitch_env_hold.kr(0).clip(0,1),
		\pitch_env_curve.kr(-4),
		0.11 / \pitch_env_speed.kr(1)
	);


	freq   = max(0, (freq) * (1 + (accelerate * line)));
	freq   = freq.cpsmidi + (SinOsc.ar(freq: \vibrato_rate.kr(8) * cps) * \vibrato_depth.kr(0)) + (pitchEnv * \pitch_env.kr(0));

	timbre = timbreLfo + (timbreEnv * \timbre_env.kr(0)) + \timbre.kr(0.5);
	timbre = timbre.clip(0, 1);

	harm   = harmLfo + (harmEnv * \harm_env.kr(0)) + \harm.kr(0.5);
	harm   = harm.clip(0, 1);

	morph  = morphLfo + (morphEnv * \morph_env.kr(0)) + \morph.kr(0.5);
	morph  = morph.clip(0, 1);

	snd = MiPlaits.ar(
		pitch:      freq,
		timbre:     timbre,
		harm:       harm,
		engine:     \model.kr(0).fold(0, 15),
		morph:      morph
    );

	snd = snd * (-6.dbamp);

	snd = Mix.ar (DirtPan.ar (snd, ~dirt.numChannels, -1) * \main.kr(1)
		       + (DirtPan.ar (snd, ~dirt.numChannels,  1) * \aux.kr(0)));

    Out.ar(out, DirtPan.ar(snd, ~dirt.numChannels, pan, 1));
  }).add;
);