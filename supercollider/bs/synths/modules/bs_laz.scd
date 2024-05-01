// additive synth
(
(
SynthDef(\bs_laz, {

	|out=0, freq=440, sustain=1, pan=0, begin=0, end=1, speed=1, accelerate=0, cps=0.5|

	var snd, line, dur,
		numPartials, n, freqs,
		comb_f1,
		pitchMod;

	numPartials = 256;
	n = (1..numPartials);

	dur  = sustain*(end-begin);
	line = Line.kr(begin, end, dur, doneAction: Done.freeSelf);

	freq  = max(1e-4, freq * (1 + (accelerate * line)));
	freq  = freq.cpsmidi + (SinOsc.kr(freq: \vibratoRate.kr(6) * cps) * \vibratoDepth.kr(0));
	freq  = freq.midicps;

	freqs = freq * n;
	// freqs = freqs * (1+ (n*n * 0.001)).sqrt;
	snd   = SinOsc.ar(freqs);

	// freq tilt
	snd = snd * (log2(n) * \laz_ftilt.kr(-3)).dbamp;

	// comb
	comb_f1 = \laz_combf1.kr(1);
	snd     = snd * ((1-log2(n * comb_f1).sin.abs)** 5);

	// snd = snd[0,2..].sum + ([-1,1] * snd[1,3..].sum);
	snd = snd.sum;
	snd = snd * (-5.dbamp);
	snd = snd.tanh;

	snd = LeakDC.ar(snd);
	snd = Limiter.ar(snd);
	Out.ar(out, DirtPan.ar(snd, ~dirt.numChannels, pan));
}).add;
);

(
SynthDef(\bs_laz2, {
	|out=0, freq=440, sustain=1, pan=0, begin=0, end=1, speed=1, accelerate=0, cps=0.5|

	var snd, line, dur,
        numPartials,
	    ratios, inharmonics, comb_f1,
	    mod1
	;
	var sampleDur  = SampleDur.ir;
	var limit      = (SampleRate.ir * 0.5) * 0.2;

	dur  = sustain*(end-begin);
	line = Line.kr(begin, end, dur, doneAction: Done.freeSelf);

	mod1 = TiltEnv.ar(\mod1_tilt.kr(0), \mod1_hold.kr(0), \mod1_curve.kr(0), dur) * \mod1_amp.kr(1);


	freq  = max(1e-4, freq * (1 + (accelerate * line)));
	freq  = freq.cpsmidi + (SinOsc.kr(freq: \vibrato_rate.kr(6) * cps) * \vibrato_depth.kr(0));
	freq  = freq.midicps;



	numPartials = 50;
	ratios = (1..numPartials);
	inharmonics = \inharmonics.kr(0);
	inharmonics = inharmonics + (mod1 * \inharmonics_mod1.kr(0));

	snd = ratios.collect{ |ratio|
		var localFreq, localPhase, taper, stretchRatio, tilt, localSnd;


		stretchRatio = ratio * (1+ (inharmonics * ratio)).sqrt;
		localFreq    = (freq * stretchRatio);

		taper = 1 / (1 + exp (localFreq - limit));
		tilt = (log2(ratio) * -3).dbamp;

		// localPhase = Phasor.ar(0, localFreq * sampleDur);
		// localSnd = sin(localPhase * 2pi);

		localSnd = SinOsc.ar(localFreq);

		localSnd = localSnd * tilt * taper;
		LeakDC.ar(localSnd) ;
	};

	comb_f1 = \laz_combf1.kr(1);
	comb_f1 = comb_f1 + (mod1 * \laz_combf1_mod1.kr(0));
	snd     = snd * ((1-log2(ratios * comb_f1).sin.abs)** 5);

	snd = snd.sum;
	snd = LeakDC.ar(snd);
	// snd.freqscope;

	snd = snd * -6.dbamp;

	Out.ar(out, DirtPan.ar(snd, ~dirt.numChannels, pan));
}).add;
)

)