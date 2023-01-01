
(

(1..SuperDirt.maxSampleNumChannels).do { |numChannels|

	SynthDef("global_jpverb" ++ numChannels, {

		| dryBus, effectBus, jverbWet=0.4,
		jverbTime=2, jverbDamp=0.2, jverbSize=1, jverbEarly=0.707,
		jverbModDepth=0.1, jverbModFreq=1.33,
		jverbLow=1, jverbMid=1, jverbHigh=1, jverbLo=200, jverbHi=2000, jverbGain=1|

		var signalDry = In.ar(dryBus, ~dirt.numChannels);
		var signalWet = JPverb.ar(
			signalDry*jverbGain,
			t60: jverbTime,
			damp: jverbDamp,
			size: jverbSize,
			earlyDiff: jverbEarly,
			modDepth: jverbModDepth,
			modFreq: jverbModFreq,
			low: jverbLow,
			mid: jverbMid,
			high: jverbHigh,
			lowcut: jverbLo,
			highcut: jverbHi
		);
		var signal = signalWet;

		// DetectSilence.ar(signal, doneAction:2);
		DirtPause.ar(effectBus, graceTime:4);

		Out.ar(effectBus, signal);


	}, [\ir, \ir]).add;

};
);