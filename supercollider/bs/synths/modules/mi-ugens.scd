// https://github.com/v7b1/mi-UGens











(
~dirt.addModule('elements', { |dirtEvent|
	dirtEvent.sendSynth('elements' ++ ~dirt.numChannels,
		[
			elementspitch:       ~elementspitch,
			elementsstrength:    ~elementsstrength,
			elementscontour:     ~elementscontour,
			elementsbowlevel:    ~elementsbowlevel,
			elementsblowlevel:   ~elementsblowlevel,
			elementsstrikelevel: ~elementsstrikelevel,
			elementsflow:        ~elementsflow,
			elementsmallet:      ~elementsmallet,
			elementsbowtimb:     ~elementsbowtimb,
			elementsblowtimb:    ~elementsblowtimb,
			elementsstriketimb:  ~elementsstriketimb,
			elementsgeom:        ~elementsgeom,
			elementsbright:      ~elementsbright,
			elementsdamp:        ~elementsdamp,
			elementspos:         ~elementspos,
			elementsspace:       ~elementsspace,
			elementsmodel:       ~elementsmodel,
			elementseasteregg:   ~elementseasteregg,
			out: ~out
		]
	)
}, {~elementsstrength.notNil});
);

(
  SynthDef("elements" ++ ~dirt.numChannels, {

	|
	out,freq=440,sustain=1,pan=0,begin=0,end=1,speed=1,accelerate=0,
	elementspitch=48, elementsstrength=0.5, elementscontour=0.2, elementsbowlevel=0,elementsblowlevel=0, elementsstrikelevel=0,
	elementsflow=0.5, elementsmallet=0.5, elementsbowtimb=0.5, elementsblowtimb=0.5,
	elementsstriketimb=0.5, elementsgeom=0.25, elementsbright=0.5, elementsdamp=0.7, elementspos=0.2, elementsspace=0.3, elementsmodel=0,
	elementseasteregg=0
	|

    var signal = In.ar(out, ~dirt.numChannels);

    ReplaceOut.ar(out, MiElements.ar(
      blow_in: signal,
      strike_in: signal,
      gate: 0,
      pit: elementspitch,
      strength: elementsstrength,
      contour: elementscontour,
      bow_level: elementsbowlevel,
      blow_level: elementsblowlevel,
      strike_level: elementsstrikelevel,
      flow: elementsflow,
      mallet: elementsmallet,
      bow_timb: elementsbowtimb,
      blow_timb: elementsblowtimb,
      strike_timb: elementsstriketimb,
      geom: elementsgeom,
      bright: elementsbright,
      damp: elementsdamp,
      pos: elementspos,
      space: elementsspace,
      model: elementsmodel,
      easteregg: elementseasteregg
    ));
  }).add;
);










(
~dirt.addModule('rings_fx', { |dirtEvent|
	dirtEvent.sendSynth('rings_fx' ++ ~dirt.numChannels,
		[
			fx_ringstrig:      ~fx_ringstrig,
			fx_ringsfreq:      ~fx_ringsfreq ?? 0,
			fx_ringsnote:      ~fx_ringsnote ?? ~note,
			fx_ringsstruct:    ~fx_ringsstruct ?? 0.5,
			fx_ringsbright:    ~fx_ringsbright ?? 0.5,
			fx_ringsdamp:      ~fx_ringsdamp ?? 0.2,
			fx_ringspos:       ~fx_ringspos ?? 0.5,
			fx_ringsmodel:     ~fx_ringsmodel ?? 1,
			fx_ringspoly:      ~fx_ringspoly ?? 1,
			fx_ringsinternal:  ~fx_ringsinternal,
			fx_ringseasteregg: ~fx_ringseasteregg,
			fx_ringsMix:       ~fx_ringsMix,
			fx_ringsPre:       ~fx_ringsPre ?? 1,
			speed:             ~speed,
			begin:             ~begin,
			end:               ~end,
			sustain:           ~sustain,
			out:               ~out
		]
	)
}, {~fx_ringsMix.notNil});
);

(
SynthDef("rings_fx" ++ ~dirt.numChannels, {

	|
	out, freq=440,	speed=1, begin=0, end=1, sustain, fx_ringsnote = 60,
	fx_ringsfreq=440, fx_ringsstruct=0.5,fx_ringsbright=0.5,fx_ringsdamp=0.5,fx_ringspos=0.5,
	fx_ringsmodel=0,fx_ringspoly=0,fx_ringsinternal=0,fx_ringseasteregg=0,
	fx_ringsbypass=0,
	fx_ringsPre=1, fx_ringsMix=1
	|

	/*var envLength = sustain*(end-begin);
    var line      = Line.ar(begin, end, envLength, doneAction: Done.freeSelf);*/
	var signalDry = In.ar(out, ~dirt.numChannels);
	var signal, pitch, f2p;
	// var env       = Env.new    (levels: [0, 1, 0.77, 0], times: [0.0098, 0.6, 0.2], curve:[-5, -3, 5]);
	// var volume    = IEnvGen.ar(env, line);

	signalDry = signalDry * fx_ringsPre;
	fx_ringsmodel = fx_ringsmodel.clip(0,5);


	pitch = fx_ringsnote + 60;
	// pitch = fx_ringsnote + ;

	signal = MiRings.ar(
    in:             signalDry,
    trig:           fx_ringsinternal,
    pit:            pitch,
    struct:         fx_ringsstruct,
    bright:         fx_ringsbright,
    damp:           fx_ringsdamp,
    pos:            fx_ringspos,
    model:          fx_ringsmodel,
    poly:           fx_ringspoly,
    intern_exciter: fx_ringsinternal,
    easteregg:      fx_ringseasteregg
  );

	signal = signal *1.2;
	signal = (signal*fx_ringsMix)+(signalDry*(1-fx_ringsMix));
	// signal = signal*volume;

  ReplaceOut.ar(out, signal)
}).add;

);





// (
// ~dirt.addModule('ripples', { |dirtEvent|
// 	dirtEvent.sendSynth('ripples' ++ ~dirt.numChannels,
// 		[
// 			ripplescf: ~ripplescf,
// 			ripplesreson: ~ripplesreson,
// 			ripplesdrive: ~ripplesdrive,
// 			out: ~out
// 		]
// 	)
// }, {~ripplescf.notNil});
// );
//
// (
// SynthDef("ripples" ++ ~dirt.numChannels, { |out, ripplescf=0, ripplesreson=0, ripplesdrive=1|
// 	var signal = In.ar(out, ~dirt.numChannels);
// 	signal = MiRipples.ar(
// 		signal,
// 		cf: ripplescf,
// 		reson: ripplesreson,
// 		drive: ripplesdrive,
// 	);
// 	ReplaceOut.ar(out, signal)
// }).add;
//
// );
//






(

(1..SuperDirt.maxSampleNumChannels).do { |numChannels|

	SynthDef("global_mi_verb" ++ numChannels, {
		|dryBus, effectBus,
		verbwet=0, verbtime=0, verbdamp=0, verbhp=0, verbfreeze=0, verbdiff=0.625, verbgain=0, verbsend=1|

		var in, signal, rvb;


		// verbtime = Lag.kr(verbtime, 0.2);
		// verbdamp = Lag.kr(verbdamp, 0.2);
		// verbhp   = Lag.kr(verbhp, 0.2);
		// verbdiff = Lag.kr(verbdiff, 0.2);
		// verbgain = Lag.kr(verbgain, 0.2);
		// verbsend = Lag.kr(verbsend, 0.2);

		in = In.ar(dryBus, ~dirt.numChannels);
		in = in * (-6.dbamp);
		in = in.tanh;
		ReplaceOut.ar(dryBus, in * (1 - verbwet));

		rvb = MiVerb.ar(
			in,
			verbtime,
			1,
			verbdamp,
			verbhp,
			verbfreeze,
			verbdiff
		) * verbgain;

		DirtPause.ar(rvb, graceTime:4);
		Out.ar(effectBus, rvb*verbwet);
		// DetectSilence.ar(effectBus, doneAction:2);

	}, [\ir, \ir]).add;




  SynthDef("global_mi_clouds" ++ numChannels, { |dryBus, effectBus, cloudspitch=0, cloudspos=0, cloudssize=0, cloudsdens=0, cloudstex=0, cloudswet=0, cloudsgain=0, cloudsspread=0, cloudsrvb=0, cloudsfb=0, cloudsfreeze=0, cloudsmode=0, cloudslofi=0|
    var signal = In.ar(dryBus, ~dirt.numChannels);
    Out.ar(effectBus, MiClouds.ar(
      inputArray: signal,
      pit: cloudspitch,
      pos: cloudspos,
      size: cloudssize,
      dens: cloudsdens,
      tex: cloudstex,
      drywet: cloudswet,
      in_gain: cloudsgain,
      spread: cloudsspread,
      rvb: cloudsrvb,
      fb: cloudsfb,
      freeze: cloudsfreeze,
      mode: cloudsmode,
      lofi: cloudslofi
    ));
  }, [\ir, \ir]).add;
};

);
