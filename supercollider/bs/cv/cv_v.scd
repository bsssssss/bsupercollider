(

(
SynthDef(\cv_v__, {
	|out, cvOut = 0, freq = 440, portamento = 0, n|
	var v = (n/10).clip(-10,10);
	var sig = K2A.ar(v);
	OffsetOut.ar(cvOut, sig);
}).add
);

// define a unique name for each Ndef
Ndef(\cv_v_).source = \cv_v__;
Ndef(\cv_v_).play(0);


// add to dirt library, give it a name that you will use in tidal
(
~dirt.soundLibrary.addSynth(\cv_v, (play: {
	var latency    = (~latency ? 0);
	var n          = ~n;
	var cvOut      = ~cvOut;
	var portamento = ~portamento;

	Ndef(\cv_v_).wakeUp;

	// schedule the cycles, prevents delayed signals
	thisThread.clock.sched(latency - 0.025, {
		Ndef(\cv_v_).set(\portamento, portamento);
		Ndef(\cv_v_).set(\cvOut, cvOut);
		Ndef(\cv_v_).set(\n, n);
	});
})
))

)
