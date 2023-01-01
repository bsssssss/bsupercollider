
(
~dirt.addModule('lockhart', { |dirtEvent|
	dirtEvent.sendSynth('lockhart' ++ ~dirt.numChannels,
		[
			out:         ~out,
			lockhartPre: ~lockhartPre,
			lockhartMix: ~lockhartMix
		]
	)
}, {~lockhartMix.notNil});
);

(

SynthDef("lockhart" ++ ~dirt.numChannels, {

	|out,
	lockhartPre=1, lockhartMix=1|

	var signalDry,
		signal;

	signalDry = In.ar(out, ~dirt.numChannels);
	signal    = LockhartWavefolder.ar(signalDry*lockhartPre, 4);
	signal    = (signal*lockhartMix)+(signalDry*(1-lockhartMix));

  ReplaceOut.ar(out, signal)
}).add;

);


(
~dirt.addModule('phasormodal', { |dirtEvent|
	dirtEvent.sendSynth('phasormodal' ++ ~dirt.numChannels,
		[
			out:              ~out,
			phasormodalMix:   ~phasormodalMix,
			phasormodalPre:   ~phasormodalPre,
			phasormodalDecay: ~phasormodalDecay,
			phasormodalFreq:  ~phasormodalFreq,
			phasormodalDamp:  ~phasormodalDamp,
			phasormodalPhase: ~phasormodalPhase
		]
	)
}, {~phasormodalMix.notNil});
);

(

SynthDef("phasormodal" ++ ~dirt.numChannels, {

	|out,
	phasormodalMix=1, phasormodalPre=1, phasormodalFreq=100, phasormodalDecay=0.25, phasormodalDamp=1, phasormodalPhase=0|

	var signalDry,
		signal;

	signalDry = In.ar(out, ~dirt.numChannels);
	signal    = PhasorModal.ar(
		input: signalDry*phasormodalPre,
		freq:  phasormodalFreq*(SinOsc.ar(0.2)*1000),
		decay: phasormodalDecay,
		damp:  phasormodalDamp,
		phase: phasormodalPhase
	);
	signal    = (signal*phasormodalMix)+(signalDry*(1-phasormodalMix));

  ReplaceOut.ar(out, signal)
}).add;

);

(
~dirt.addModule('dcompressor', { |dirtEvent|
	dirtEvent.sendSynth('dcompressor' ++ ~dirt.numChannels,
		[
			out:           ~out,
			compRatio:     ~compRatio,
			compThreshold: ~compThreshold,
			compAttack:    ~compAttack,
			compRelease:   ~compRelease,
			compMakeup:    ~compMakeup,
			compPre:       ~compPre,
			compMix:       ~compMix
		]
	)
}, {~compRatio.notNil or: {~compThreshold.notNil} or:{~compAttack.notNil} or:{~compRelease.notNil} or:{~compMakeup.notNil} or:{~compPre.notNil}});
);

(

SynthDef("dcompressor" ++ ~dirt.numChannels, {

	|out, in,
	compPre=1, compRatio=8, compThreshold=0, compAttack=0.01, compRelease=100.1, compMakeup=0.5, compMix=1|

	var signalDry,
		signal;

	signalDry = In.ar(out, ~dirt.numChannels);
	signal    = DCompressor.ar(
		input: signalDry*compPre,
		ratio: compRatio,
		threshold: compThreshold,
		attack: compAttack,
		release: compRelease,
		makeup: compMakeup
	);
	signal    = (signal*compMix)+(signalDry*(1-compMix));

  ReplaceOut.ar(out, signal)
}).add;

);

(
~dirt.addModule('K35', { |dirtEvent|
	dirtEvent.sendSynth('K35' ++ ~numChannels,
		[
			out: ~out,
			k35Pre: ~k35Pre,
			k35Freq: ~k35Freq,
			k35Res: ~k35Res,
			k35Drive: ~k35Drive,
			k35Type: ~k35type,
			k35Mix: ~k35Mix
		]
	)
}, {~k35Freq.notNil});
);

(

SynthDef("K35" ++ ~dirt.numChannels, {

	|out, in,
	k35Pre=1.0, k35Freq=3000.0, k35Res=0.1, k35Drive=0.0, k35Type=1, k35Mix=0|

	var signalDry,
		signal;
	// k35Freq=2300;
	signalDry = In.ar(out, ~dirt.numChannels);
	signal    = VAKorg35.ar(
		input: signalDry*k35Pre,
		freq: k35Freq,
		res: k35Res,
		overdrive: k35Drive,
		type: k35Type
	);
	signal    = (signal*k35Mix)+(signalDry*(1-k35Mix));

  ReplaceOut.ar(out, signal)
}).add;

);