(

SynthDef(\bs_formant, {
	| out, gate=0, sustain=1, freq=440, speed=1, begin=0, end=1, pan, accelerate, offset|

	var snd, line, dur, freq2ratio, freq2, phase;

	dur  = sustain * (end - begin);
	line = Line.ar(begin, end, dur, doneAction: Done.freeSelf);

	freq  = freq.clip(0, SampleRate.ir/2);

	freq2ratio = \freq2ratio.kr(1);
	freq2 = freq * freq2ratio;

	phase = \phase.kr(0);


	snd = NeoFormant.ar(
		formantfreq: freq2,
		carrierfreq: freq,
		phaseshift:  phase
	);
	snd = LeakDC.ar(snd);

	Out.ar(out,DirtPan.ar(snd, ~dirt.numChannels, pan, 1))

}).add;

);