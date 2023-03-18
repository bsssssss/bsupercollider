
(
(1..SuperDirt.maxSampleNumChannels).do { |numChannels|

	SynthDef("global_comp" ++ numChannels, {
		|dryBus, effectBus,
		comp=0, compPre=1, compThreshold=0.5,
		compAttack=0.002, compRelease=0.5,
		compRatio=4, compUp = 1, compMakeup=1|

		var in, signal, compress;

		in = In.ar(dryBus, ~dirt.numChannels);
		ReplaceOut.ar(dryBus, in * (1 - comp));

		compress = CompanderD.ar (
			in * compPre,
			compThreshold,
			(1/compUp),
			(1/compRatio),
			compAttack,
			compRelease
		) * compMakeup;

		signal = compress.tanh;

		DirtPause.ar(effectBus, graceTime:4);
		XOut.ar(dryBus, comp, signal);
		// Out.ar(dryBus, signal*comp)
	}, [\ir, \ir]).add;

	~dryBussesComp = [];
	~dirt.orbits.do { |x|
		~dryBussesComp = ~dryBussesComp ++ x.dryBus
	};

	SynthDef("global_sidechain" ++ numChannels, {
		|dryBus, effectBus, sidechainFrom=(-1), sidechain=1, scMakeup=1,
		scThreshold=0.02, scUp=1, scRatio=10, scAttack=0.002, scRelease=0.4|

		var in, signal, control, controlbus;

		in = In.ar(dryBus, ~dirt.numChannels);
		controlbus = InFeedback.ar(Select.kr(sidechainFrom-1,~dryBussesComp),2);
		controlbus = EnvFollow.ar(controlbus);
		// controlbus = InFeedback.ar(~dirt.orbits[0].dryBus,2);
		// controlbus = InBus.ar(~dirt.orbits[0].dryBus, 2);
		// control = In.ar(controlbus, ~dirt.numChannels);
		// control = In.ar(controlbus, 2).sum;

		// In.ar(~dirt.orbits.collect { |x| x.dryBus }, ~dirt.numChannels).sum;

		// InBus.ar(~dirt.orbits { |x| x.dryBus }, ~dirt.numChannels);

		// InBus.ar(~dirt.orbits[1].dryBus, 2);

		ReplaceOut.ar(dryBus, in * (1 - sidechain));

		signal = Compander.ar (
			in,
			controlbus*1,
			scThreshold,
			(1/scUp),
			(1/scRatio),
			scAttack,
			scRelease
		)* scMakeup;

		DirtPause.ar(effectBus, graceTime:4);
		XOut.ar(dryBus, sidechain, signal);
	}, [\ir, \ir]).add;
};
);
