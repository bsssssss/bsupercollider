

(
~warpsbusses = ~dirt.orbits.collect { |x| x.dryBus };


SynthDef("warps" ++ ~dirt.numChannels, {
	| out, pan=0.5,
	warpsalgo=1, warpstimb=0, warpsfreq=1000,
	warpsosc=1, warpsvgain=1, warpseasteregg=0,
	warpsmodorbit=1, warpsmod=1, warpssum=0 |

	var signal = In.ar(out, ~dirt.numChannels);
	var modbus = Select.kr(warpsmodorbit, ~warpsbusses);
	var mod    = In.ar(modbus, ~dirt.numChannels).sum;

	signal = MiWarps.ar(
		carrier: signal,
		modulator: mod,
		algo: warpsalgo,
		lev1: 1,
		lev2: 1,
		timb: warpstimb,
		osc: warpsosc,
		freq: warpsfreq,
		vgain: warpsvgain,
		easteregg: warpseasteregg
	);
	signal = Mix.ar (DirtPan.ar (signal, ~dirt.numChannels, -1) * 1
		          + (DirtPan.ar (signal, ~dirt.numChannels,  1) * 1));



	ReplaceOut.ar(out,signal)
}).add;




(
~dirt.addModule('warps', { |dirtEvent|
	dirtEvent.sendSynth('warps' ++ ~dirt.numChannels,
		[
			warpsalgo: ~warpsalgo,
			warpstimb: ~warpstimb,
			warpsosc: ~warpsosc,
			warpsfreq: ~warpsfreq,
			warpsvgain: ~warpsvgain,
			warpseasteregg: ~warpseasteregg,
			warpsmodorbit: ~warpsmodorbit,
			warpsmod: ~warpsmod,
			warpssum: ~warpssum,
			out: ~out
			// pan: ~pan ?? 0
		]
	)
}, {~warpsosc.notNil});
);
)

