
(

// var numChannels = ~dirt.numChannels;

(1..SuperDirt.maxSampleNumChannels).do { |numChannels|

	SynthDef("global_comp" ++ numChannels, {
		|dryBus, effectBus, gate=1,
		comp=0, compThreshold=0.5,
		compAttack=0.002, compRelease=0.5,
		compRatio=4, compUp = 1, compMakeup=1|

		var in, signal, compress;

		in = In.ar(dryBus, ~dirt.numChannels);
		ReplaceOut.ar(dryBus, in * (1 - comp));

		compress = CompanderD.ar (
			in,
			compThreshold,
			(1/(compUp+0.00001)),
			(1/(compRatio+0.00001)),
			compAttack,
			compRelease
		) * compMakeup;

		signal = compress.tanh;
		signal = signal * EnvGen.kr(Env.asr, gate, doneAction:2);

		DirtPause.ar(signal, graceTime:4);
		// XOut.ar(dryBus, comp, signal);
		Out.ar(dryBus, signal*comp)
	}, [\ir, \ir]).add;

	~dryBussesComp = [];
	~dirt.orbits.do { |x|
		~dryBussesComp = ~dryBussesComp ++ x.dryBus
	};

	SynthDef("global_sidechain" ++ numChannels, {
		|dryBus, effectBus, gate=1,
		sidechainFrom=(-1), sidechain=1, scMakeup=1,
		scThreshold=0.03, scUp=1, scRatio=10, scAttack=0.002, scRelease=0.4|

		var in, signal, control, controlbus;

		in = In.ar(dryBus, ~dirt.numChannels);
		controlbus = InFeedback.ar(Select.kr(sidechainFrom-1,~dryBussesComp),2);
		controlbus = EnvFollow.ar(controlbus);

		ReplaceOut.ar(dryBus, in * (1 - sidechain));

		signal = Compander.ar (
			in,
			controlbus*1,
			scThreshold,
			(1/(scUp+0.00001)),
			(1/(scRatio+0.00001)),
			scAttack,
			scRelease
		)* scMakeup;

		signal = signal * EnvGen.kr(Env.asr, gate, doneAction:2);

		DirtPause.ar(signal, graceTime:4);
		// XOut.ar(dryBus, sidechain, signal);
		Out.ar(dryBus, signal*sidechain)
	}, [\ir, \ir]).add;
};
// s.freeAll
)
