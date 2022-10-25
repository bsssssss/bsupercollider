(

SynthDef(\bs_formant, {

	|out, sustain=1, freq=440, speed=1, begin=0, end=1, pan, accelerate, offset,
	formantCarrierFreq=0, formantShift=0.5, formantCarrierRatio=1, pitchEnv=0|

	var sig, dur, line, gainEnv, gain;
	var mod = SinOsc.ar(3)*SinOsc.ar(1).cubed* 0.5;

	var pitchEnvLength  = sustain*(end-begin)/speed;
    var pitchLine       = Line.ar(begin, end, pitchEnvLength);
    var pitchEnvv       = Env.asr;
    var pitchMod        = IEnvGen.ar(pitchEnvv, pitchLine);

	dur  = sustain * (end - begin)/speed;
	line     = Line.ar    (begin, end, dur, doneAction:2);

	pitchMod = (pitchMod * freq) * pitchEnv;
	freq   = max(0, (freq + pitchMod) * (1 + (accelerate * line)));

	gainEnv  = Env.new    (levels: [0, 1, 0.77, 0], times: [0.05, 0.79, 0.01], curve:[0, -3, 5]);
	gain     = IEnvGen.ar (gainEnv,line);

	sig    = NeoFormant.ar(
		freq,
		(freq * formantCarrierRatio)+ formantCarrierFreq,
		mod.unipolar
	);


  ReplaceOut.ar(out, DirtPan.ar (sig, ~dirt.numChannels, pan, gain))
}).add;

);