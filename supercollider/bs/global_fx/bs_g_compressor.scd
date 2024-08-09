// ~dirt.orbits.do { |x| x.globalEffects.postln }

(
var numChannels = ~dirt.numChannels;
// (1..SuperDirt.maxSampleNumChannels).do { |numChannels|
	SynthDef("dirt_compressor", {
		|dryBus, effectBus, gate=1|
		var amplitude, attack, release, treshold, slope;
		var inArray, snd;

		treshold = \g_comp_trh.kr(-18);
		slope    = \g_comp_slp.kr(1/4);
		attack   = \g_comp_att.kr(0.05);
		release  = \g_comp_rel.kr(0.3);



		snd = In.ar(dryBus, numChannels);

	// snd = if(snd.isArray) {snd} {[snd]};

		amplitude = (Amplitude.ar(snd, attack, release) / snd.size.sqrt).max(-100.dbamp).ampdb;
		amplitude = ((amplitude - treshold).max(0) * (slope-1)).lag(attack).dbamp;

		snd = snd*amplitude;


		DirtPause.ar(snd, 4);
		ReplaceOut.ar(effectBus, snd);

	}, [\ir, \ir]).add;
)

(
~dirt.orbits.do {|x|
	x.globalEffects = x.globalEffects
	    .addFirst(GlobalDirtEffect(\dirt_compressor, [\g_comp_trh, \g_comp_slp, \g_comp_att, \g_comp_rel]));
	x.initNodeTree;
}
)

~dirt.orbits.do { |x| x.globalEffects.postln; " ----------".postln; }
