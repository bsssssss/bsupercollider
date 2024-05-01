
(
~dirt.addModule('lpf2', { |dirtEvent|
	dirtEvent.sendSynth('lpf2' ++ ~numChannels,
		[
			sustain:     ~sustain,
			out:         ~out,
			lp2_pre:     ~lp2_pre   ?? 0.4,
			lp2_f:       ~lp2_f,
			lp2_q:       ~lp2_q,
			lp2_mix:     ~lp2_mix   ?? 1,
			lp2_fEnv:    ~lp2_fEnv,
			lp2_fTilt:   ~lp2_fTilt,
			lp2_fPlat:   ~lp2_fPlat,
			lp2_fCurve:  ~lp2_fCurve ?? (-4),
		]
	)
}, {~lp2_f.notNil});
);
(
SynthDef("lpf2" ++ ~dirt.numChannels, {
	|out, in, sustain = 1, speed = 1|
	var signalDry, signal, freq, res, pre, mix, fenv;

	var envV = (\lp2_fEnv.kr(0)).linexp(0, 1, 0.1, 20000);

	freq = \lp2_f.kr(1000);
	res  = \lp2_q.kr(0);
	pre  = \lp2_pre.kr(1);
	mix  = \lp2_mix.kr(1);

	fenv = TiltEnv.ar(\lp2_fPlat.kr(0), \lp2_fTilt.kr(0), \lp2_fCurve.kr(4), sustain);
	fenv = (fenv * envV);
	freq = freq + fenv;
	freq = freq.max(20, SampleRate.ir/2);

	signalDry = In.ar(out, ~dirt.numChannels);
	signal    = DFM1.ar(
		in:        signalDry,
		freq:      freq,
		res:       res,
		inputgain: pre,
		type:      0
	);
	signal = (signal * mix) + (signalDry * (1 - mix));
  ReplaceOut.ar(out, signal)
}).add;
);


0.5.


(
~dirt.addModule('hpf2', { |dirtEvent|
	dirtEvent.sendSynth('hpf2' ++ ~numChannels,
		[
			sustain:     ~sustain,
			out:         ~out,
			hp2_pre:     ~hp2_pre   ?? 1,
			hp2_f:       ~hp2_f,
			hp2_q:       ~hp2_q,
			hp2_mix:     ~hp2_mix   ?? 1,
			hp2_fEnv:    ~hp2_fEnv,
			hp2_fTilt:   ~hp2_fTilt,
			hp2_fPlat:   ~hp2_fPlat,
			hp2_fCurve:  ~hp2_fCurve ?? (-4),
		]
	)
}, {~hp2_f.notNil});
);
(
SynthDef("hpf2" ++ ~dirt.numChannels, {
	|out, in, sustain = 1, speed = 1|
	var signalDry, signal, freq, res, pre, mix, fenv;

	freq = \hp2_f.kr(1000);
	res  = \hp2_q.kr(0);
	pre  = \hp2_pre.kr(1);
	mix  = \hp2_mix.kr(1);

	fenv = TiltEnv.ar(\hp2_fPlat.kr(0), \hp2_fTilt.kr(0), \hp2_fCurve.kr(4), sustain);
	freq = freq + (fenv * \hp2_fEnv.kr(0));
	freq = freq.max(20, SampleRate.ir/2);

	signalDry = In.ar(out, ~dirt.numChannels);
	signal    = DFM1.ar(
		in:        signalDry,
		freq:      freq,
		res:       res,
		inputgain: pre,
		type:      1
	);
	signal = (signal * mix) + (signalDry * (1 - mix));
  ReplaceOut.ar(out, signal)
}).add;
);



(
~dirt.addModule('brf', { |dirtEvent|
	dirtEvent.sendSynth('brf' ++ ~numChannels,
		[
			sustain:    ~sustain,
			out:        ~out,
			br_pre:     ~br_pre    ?? 0.4,
			br_f:       ~br_f,
			br_q:       ~br_q      ?? 1,
			br_mix:     ~br_mix    ?? 1,
			br_fEnv:    ~br_fEnv,
			br_fTilt:   ~br_fTilt,
			br_fPlat:   ~br_fPlat,
			br_fCurve:  ~br_fCurve ?? (-4),
		]
	)
}, {~br_f.notNil});
);
(
SynthDef("brf" ++ ~dirt.numChannels, {
	|out, in, sustain = 1, speed = 1|
	var signalDry, signal, freq, res, pre, mix, fenv, curve;

	freq = \br_f.kr(1000);
	res  = \br_q.kr(0);
	pre  = \br_pre.kr(1);
	mix  = \br_mix.kr(1);

	curve = \br_fCurve.kr(4);
	fenv = TiltEnv.ar(\br_fPlat.kr(0), \br_fTilt.kr(0), curve, sustain);
	freq = freq + (fenv * \br_fEnv.kr(0));
	freq = freq.max(20, SampleRate.ir/2);

	signalDry = In.ar(out, ~dirt.numChannels);
	signal    = BBandStop.ar(
		in:        signalDry,
		freq:      freq,
		bw:        res
	);
	signal = (signal * mix) + (signalDry * (1 - mix));
  ReplaceOut.ar(out, signal)
}).add;
);



(
~dirt.addModule('bp2', { |dirtEvent|
	dirtEvent.sendSynth('bp2' ++ ~numChannels,
		[
			sustain:     ~sustain,
			out:         ~out,
			bp2_pre:     ~bp2_pre    ?? 0.4,
			bp2_f:       ~bp2_f,
			bp2_q:       ~bp2_q      ?? 0,
			bp2_mix:     ~bp2_mix    ?? 1,
			bp2_fEnv:    ~bp2_fEnv,
			bp2_fTilt:   ~bp2_fTilt,
			bp2_fPlat:   ~bp2_fPlat,
			bp2_fCurve:  ~bp2_fCurve ?? (-4),
			bp2_sat:     ~bp2_sat    ?? 0.9
		]
	)
}, {~bp2_f.notNil});
);
(
SynthDef("bp2" ++ ~dirt.numChannels, {
	|out, in, sustain = 1, speed = 1|
	var signalDry, signal, freq, res, pre, mix, fenv, curve;

	freq = \bp2_f.kr(1000);
	res  = \bp2_q.kr(0);
	pre  = \bp2_pre.kr(1);
	mix  = \bp2_mix.kr(1);

	curve = \bp2_fCurve.kr(4);
	fenv  = TiltEnv.ar(\bp2_fPlat.kr(0), \bp2_fTilt.kr(0), curve, sustain);
	freq  = freq + (fenv * \bp2_fEnv.kr(0));
	freq  = freq.max(20, SampleRate.ir/2);

	signalDry = In.ar(out, ~dirt.numChannels);
	signal    = BMoog.ar(
		in:   signalDry,
		freq: freq,
		q:    res,
		mode: 3,
		saturation: \bp2_sat.kr(0.9)
	);
	signal = signal.tanh;
	signal = (signal * mix) + (signalDry * (1 - mix));

  ReplaceOut.ar(out, signal)
}).add;
);



(
~dirt.addModule('combf', { |dirtEvent|
	dirtEvent.sendSynth('combf' ++ ~numChannels,
		[
			sustain:   ~sustain,
			out:       ~out,
			combf_mix: ~combf_mix ?? 0.5,
			combf_fb:  ~combf_fb  ?? 0.001,
			combf:     ~combf
		]
	)
}, {~combf.notNil});
);
(
SynthDef("combf" ++ ~dirt.numChannels, {
	|out, in, sustain = 1, speed = 1|
	var signalDry, signal, freq, mix;

	freq = \combf.kr(500).clip(0, SampleRate.ir/2);
	mix  = \combf_mix.kr(1);

	signalDry = In.ar(out, ~dirt.numChannels);
	signal    = CombL.ar(signalDry, 1, (1/freq), \combf_fb.kr(0.01));
	signal    = (signal * mix) + (signalDry * (1 - mix));

  ReplaceOut.ar(out, signal)
}).add;
);



(
~dirt.addModule('mu', { |dirtEvent|
	dirtEvent.sendSynth('mu' ++ ~dirt.numChannels,
		[ mu: ~mu, out: ~out ]
	)
}, {~mu.notNil});
);
(
  SynthDef("mu" ++ ~dirt.numChannels, {|out,mu=0|
    var signal = In.ar(out, ~dirt.numChannels);
    ReplaceOut.ar(out, MiMu.ar(signal, mu));
  }).add;
);
