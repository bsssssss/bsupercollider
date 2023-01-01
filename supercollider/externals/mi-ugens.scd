// https://github.com/v7b1/mi-UGens

// installer classes d'abord!!

(
SynthDef(\braids2, {

	| out=0, freq=440, sustain=1, pan=0, begin=0, end=1, speed=1, accelerate=0, cps=0.5,
	envMode=0,
	model=0,
	timbre=0.5, timbreFrom=0, timbreTo=0, timbreSpeed=1, timbreCurve=0,
	timbreLfoRate=1, timbreLfoAmp=0, timbreLfoShape=1,
	color =0.5, colorFrom=0, colorTo=0, colorSpeed=1, colorCurve=0,
	colorLfoRate =1, colorLfoAmp =0, colorLfoShape=1,
	vibratoRate=8, vibratoDepth=0|

	var sig;

	var envLength = sustain*(end-begin)/speed;
	var line      = Line.ar(begin, end, envLength, doneAction: Done.freeSelf);
	// var env       = Env.asr;
	var env       = Env([0, 1, 0, 0], [0.01,0.986,0.008], [5,-5,5]);
	var env2      = Env([0, 1, 1, 0], [0.008,0.986,0.008]);
	var volume    = Select.kr(envMode, [IEnvGen.ar(env, line), IEnvGen.ar(env2, line)]);

	Env([0, 1, 0, 0], [0.01,0.986,0.008], [5,-5,5]).plot;

	var timbreLength = sustain*(end-begin)/timbreSpeed;
	var timbreLine   = Line.ar(begin, end, timbreLength);
	var timbreEnv    = Env.new(
		levels: [0, timbreFrom, timbreTo],
		times:  [0, 1, 0],
		curve:  [0, timbreCurve, 0]
	);
	var timbreLfo = Select.kr (timbreLfoShape, [
		SinOsc.ar  (freq: cps*timbreLfoRate, add: 1)/2,
		LFTri.ar   (freq: cps*timbreLfoRate, add: 1)/2,
		LFSaw.ar   (freq: cps*timbreLfoRate, add: 1)/2,
		LFPulse.ar (freq: cps*timbreLfoRate, add: 0),
	]);

	var colorLength = sustain*(end-begin)/colorSpeed;
	var colorLine   = Line.ar(begin, end, colorLength);
	var colorEnv    = Env.new(
		levels: [0, colorFrom, colorTo],
		times:  [0, 1, 0],
		curve:  [0, colorCurve, 0]
	);
	var colorLfo = Select.kr (colorLfoShape, [
		SinOsc.ar  (freq: cps*colorLfoRate, add: 1)/2,
		LFTri.ar   (freq: cps*colorLfoRate, add: 1)/2,
		LFSaw.ar   (freq: cps*colorLfoRate, add: 1)/2,
		LFPulse.ar (freq: cps*colorLfoRate, add: 0),
	]);

	freq   = max(0, (freq) * (1 + (accelerate * line)));
	freq   = freq + (SinOsc.ar(freq: vibratoRate * cps) * vibratoDepth);
	freq   = freq.cpsmidi;

	timbre = IEnvGen.ar(timbreEnv, timbreLine)+timbre;
	timbre = timbre + (timbreLfo*timbreLfoAmp);
	timbre = timbre.clip(0, 1);

	color  = IEnvGen.ar(colorEnv, colorLine)+color;
	color  = color + (colorLfo*colorLfoAmp);
	color  = color.clip(0, 1);

	sig = MiBraids.ar (
		pitch:  freq,
		timbre: timbre,
		color:  color,
		model:  model
	);
	Out.ar(out, DirtPan.ar(sig * 0.33, ~dirt.numChannels, pan, volume));
}).add;
);



(
  SynthDef(\plaits2, {

	|out=0, freq=440, sustain=1, pan=0, begin=0, end=1, speed=1, accelerate=0, cps=0.5,
	envMode=0,
	model=0,
	timbre=0.5, timbreFrom=0, timbreTo=0, timbreSpeed=1, timbreCurve=1, timbreLfoRate=1, timbreLfoAmp=0,
	timbreLfoShape=1,
	harm=0.5, harmFrom=0, harmTo=0, harmSpeed=1, harmCurve=1, harmLfoRate=1, harmLfoAmp=0,
	harmLfoShape=1,
	morph=0.5, morphFrom=0, morphTo=0, morphSpeed=1, morphCurve=1, morphLfoRate=1, morphLfoAmp=0,
	morphLfoShape=1,
	level=1, lpgdecay=0, lpgcolour=0,
	main=1,
	aux=0,
	pitchModAmp=0, pitchModRate=1, pitchModCurve=(-5),
	trig=0|

    var osc;
	var sig;
	var pitchMod;

    var envLength = sustain*(end-begin)/speed;
    var line      = Line.ar(begin, end, envLength, doneAction: Done.freeSelf);
	var env 	  = Env.asr;
	var env2      = Env([0, 1, 1, 0], [0.01,0.98,0.01]);
	var volume    = Select.kr(envMode, [IEnvGen.ar(env, line), IEnvGen.ar(env2, line)]);

	var timbreLength = sustain*(end-begin)/timbreSpeed;
	var timbreLine   = Line.ar(begin, end, timbreLength);
	var timbreEnv    = Env.new(
		levels: [0, timbreFrom, timbreTo],
		times:  [0, 1, 0],
		curve:  [0, timbreCurve, 0]
	);
	var timbreLfo = Select.kr (timbreLfoShape, [
		SinOsc.ar  (freq: cps*timbreLfoRate, add: 1)/2,
		LFTri.ar   (freq: cps*timbreLfoRate, add: 1)/2,
		LFSaw.ar   (freq: cps*timbreLfoRate, add: 1)/2,
		LFPulse.ar (freq: cps*timbreLfoRate, add: 0),
	]);

	var harmLength = sustain*(end-begin)/harmSpeed;
	var harmLine   = Line.ar(begin, end, harmLength);
	var harmEnv    = Env.new(
		levels: [0, harmFrom, harmTo],
		times:  [0, 1, 0],
		curve:  [0, harmCurve, 0]
	);
	var harmLfo = Select.kr (harmLfoShape, [
		SinOsc.ar  (freq: cps*harmLfoRate, add: 1)/2,
		LFTri.ar   (freq: cps*harmLfoRate, add: 1)/2,
		LFSaw.ar   (freq: cps*harmLfoRate, add: 1)/2,
		LFPulse.ar (freq: cps*harmLfoRate, add: 0),
	]);

	var morphLength = sustain*(end-begin)/morphSpeed;
	var morphLine   = Line.ar(begin, end, morphLength);
	var morphEnv    = Env.new(
		levels: [0, morphFrom, morphTo],
		times:  [0, 1, 0],
		curve:  [0, morphCurve, 0]
	);
	var morphLfo = Select.kr (morphLfoShape, [
		SinOsc.ar  (freq: cps*morphLfoRate, add: 1)/2,
		LFTri.ar   (freq: cps*morphLfoRate, add: 1)/2,
		LFSaw.ar   (freq: cps*morphLfoRate, add: 1)/2,
		LFPulse.ar (freq: cps*morphLfoRate, add: 0),
	]);

	timbre = IEnvGen.ar(timbreEnv, timbreLine)+timbre;
	timbre = timbre + (timbreLfo*timbreLfoAmp);
	timbre = timbre.clip(0, 1);

	harm = IEnvGen.ar(harmEnv, harmLine)+harm;
	harm = harm + (harmLfo*harmLfoAmp);
	harm = harm.clip(0, 1);

	morph = IEnvGen.ar(morphEnv, morphLine)+morph;
	morph = morph + (morphLfo*morphLfoAmp);
	morph = morph.clip(0, 1);

	pitchMod = EnvGen.ar (Env.new (
		levels: [0, freq, 0],
		times:  [0, 0.1 * (1 / pitchModRate), 0],
		curve:  [1, pitchModCurve, -5])) * pitchModAmp;

	freq = max(0, (freq + pitchMod) * (1 + (accelerate * line.fold(0, 1))));

	osc = MiPlaits.ar(
		// trigger:    trigg,
		pitch:      freq.cpsmidi,
		timbre:     timbre,
		harm:       harm,
		engine:     model,
		morph:      morph,
		level:      level,
		decay:      lpgdecay,
		lpg_colour: lpgcolour,
    );

	sig = Mix.ar (DirtPan.ar (osc, ~dirt.numChannels, -1) * main
		       + (DirtPan.ar (osc, ~dirt.numChannels,  1) * aux));

    Out.ar(out, DirtPan.ar(sig * volume, ~dirt.numChannels, pan, volume*0.3));
  }).add;
);



(

SynthDef(\braids, {

	|out=0, freq=440, sustain=1, pan=0, begin=0, end=1, speed=1, accelerate=0, cps=0.5,
	timbre=0.5, color=0.5, model=0, pitchEnv=0, pitchEnvSpeed=1, pitchLfoRate=1, pitchLfoPhase=0, pitchLfoAmp=0,  colorEnv=0, colorSpeed=1, colorLfoRate=1, colorLfoAmp=0, colorLfoPhase=0, timbreLfoRate=1, timbreLfoAmp=0, timbreLfoPhase=0, timbreEnv=0, timbreSpeed=1, envMode=0|

	var envLength       = sustain*(end-begin)/speed;
	var line            = Line.ar(begin, end, envLength, doneAction: Done.freeSelf);
	var env             = Env.asr;
	var env2            = Env([0, 1, 1, 0], [0.01,0.98,0.01]);
	var volume          = IEnvGen.ar(env2, line);

	var pitchEnvLength  = sustain*(end-begin)/pitchEnvSpeed;
	var pitchLine       = Line.ar(begin, end, pitchEnvLength);
	var pitchEnvv       = Env.asr;
	var pitchMod        = IEnvGen.ar(pitchEnvv, pitchLine);
	var pitchLfo        = SinOsc.ar(cps * pitchLfoRate, pitchLfoPhase);

	var colorEnvLength  = sustain*(end-begin)/colorSpeed;
	var colorLine       = Line.ar(begin, end, colorEnvLength);
	var colorEnvv       = Env.asr;
	var colorMod        = IEnvGen.ar(colorEnvv, colorLine);
	var colorLfo        = SinOsc.ar(cps * colorLfoRate, colorLfoPhase).abs;

	var timbreEnvLength = sustain*(end-begin)/timbreSpeed;
	var timbreLine      = Line.ar(begin, end, timbreEnvLength);
	var timbreEnvv      = Env.asr;
	var timbreMod       = IEnvGen.ar(timbreEnvv, timbreLine);
	var timbreLfo       = SinOsc.ar(cps * timbreLfoRate, timbreLfoPhase);

	var sig;

	pitchLfo  = pitchLfo * pitchLfoAmp;
	colorLfo  = colorLfo * colorLfoAmp;
	timbreLfo = timbreLfo * timbreLfoAmp;

	pitchMod  = (pitchMod * freq) * pitchEnv;
	pitchMod  = pitchMod + pitchLfo;

	freq      = max(0, (freq + pitchMod) * (1 + (accelerate * line)));
	freq      = freq.clip(0.0, SampleRate.ir/2);

	timbre    = timbre + (timbreMod * timbreEnv);
	timbre    = timbre + timbreLfo;
	timbre    = timbre.clip(0,1);

	color     = color + (colorMod * colorEnv);
	color     = color + colorLfo;
	color     = color.clip(0,1);

	sig = MiBraids.ar (
		pitch:  freq.cpsmidi,
		timbre: timbre,
		color:  color,
		model:  model
	);

	Out.ar(out, DirtPan.ar(sig*0.33, ~dirt.numChannels, pan, volume));
}).add;

);



(
  SynthDef(\omi, {|out=0,freq=440,sustain=1,pan=0,begin=0,end=1,speed=1,accelerate=0|
    var envLength = sustain*(end-begin)/speed;
    var line = Line.ar(begin, end, envLength, doneAction: Done.freeSelf);
    var env = Env.asr;
    var volume = IEnvGen.ar(env, line);
    var sig;

    freq = max(0, freq * speed * (1 + (accelerate * line)));
    sig = MiOmi.ar(pit: freq.cpsmidi);

    Out.ar(out, DirtPan.ar(sig * volume, ~dirt.numChannels, pan));
  }).add;
);





(
  SynthDef(\plaits_trig, {

	|out=0, freq=440, sustain=1, pan=0, begin=0, end=1, speed=1, accelerate=0,
	timbre=0.5, engine=0, harm=0.5, morph=0.5,
	level=1, lpgdecay=0, lpgcolour=0,
	main=1, aux=0, trig=0,
	pitchModAmp=0, pitchModRate=1, pitchModCurve=(-5)|

    var envLength = sustain*(end-begin)/speed;
    var line      = Line.ar(begin, end, envLength, doneAction: Done.freeSelf);
	var env 	  = Env.new    (
		levels: [0, 1, 0.77, 0],
		times: [0.02, 0.9, 0.02],
		curve:[-5, -3, 5]);
    var volume    = IEnvGen.ar(env, line);
    var osc;
	var sig;
	var pitchMod;
	var trigg;

	pitchMod = EnvGen.ar (Env.new (levels: [0, freq, 0], times: [0, 0.1 * (1 / pitchModRate), 0], curve: [1, pitchModCurve, -5])) * pitchModAmp;
	freq     = max(0, (freq + pitchMod) * speed * (1 + (accelerate * line)));

	// trigg    = Trig.ar (1-line, 0.01);

	osc = MiPlaits.ar(
		// trigger:    trigg,
		pitch:      freq.cpsmidi,
		timbre:     timbre,
		harm:       harm,
		engine:     engine,
		morph:      morph,
		level:      level,
		decay:      lpgdecay,
		lpg_colour: lpgcolour,
    );

	sig = Mix.ar (DirtPan.ar(osc, ~dirt.numChannels, -1) * main + (DirtPan.ar (osc, ~dirt.numChannels, 1) * aux));

    Out.ar(out, DirtPan.ar(sig * volume, ~dirt.numChannels, pan));

  }).add;
);





(
  SynthDef(\plaits, {

	|out=0, freq=440, sustain=1, pan=0, begin=0, end=1, speed=1, accelerate=0,
	timbre=0.5, timbreMod=0, engine=0, harm=0.5, morph=0.5,
	level=1, lpgdecay=0, lpgcolour=0,
	main=1, mainMod=0, aux=0, auxMod=0, pitchModAmp=0, pitchModRate=1, pitchModCurve=(-5), trig=0, harmMod=0, morphMod=0|

    var envLength = sustain*(end-begin)/speed;
    var line      = Line.ar(begin, end, envLength, doneAction: Done.freeSelf);
	var env 	  = Env.asr;
    var volume    = IEnvGen.ar(env, line);
    var osc;
	var sig;
	var pitchMod;
	var trigg;




	pitchMod = EnvGen.ar (Env.new (levels: [0, freq, 0], times: [0, 0.1 * (1 / pitchModRate), 0], curve: [1, pitchModCurve, -5])) * pitchModAmp;
	freq     = max(0, (freq + pitchMod) * (1 + (accelerate * line.fold(0, 1))));

	timbre   = timbre +((timbreMod * line)) * speed;
	timbre   = timbre.fold(0, 1);
	harm     = harm +((harmMod * line)) * speed;
	harm     = harm.fold(0, 1);
	morph    = morph +((morphMod * line)) * speed;
	morph    = morph.fold(0, 1);
	main     = main +((mainMod * line)) * speed;
	aux      = aux +((auxMod * line)) * speed;

	trigg    = Trig.ar (1-line, 0.01);


	osc = MiPlaits.ar(
		// trigger:    trigg,
		pitch:      freq.cpsmidi,
		timbre:     timbre,
		harm:       harm,
		engine:     engine,
		morph:      morph,
		level:      level,
		decay:      lpgdecay,
		lpg_colour: lpgcolour,
    );

	sig = Mix.ar (DirtPan.ar (osc, ~dirt.numChannels, -1) * main
		       + (DirtPan.ar (osc, ~dirt.numChannels,  1) * aux));

    Out.ar(out, DirtPan.ar(sig * volume, ~dirt.numChannels, pan, volume*0.4));
  }).add;
);




(
  SynthDef(\tides, {|out=0,freq=440,sustain=1,pan=0,begin=0,end=1,speed=1,accelerate=0,tidesshape=0.5,slope=0.5,tidessmooth=0.5,shift=0.5,mode=2|

	var envLength = sustain*(end-begin)/speed;
    var line = Line.ar(begin, end, envLength, doneAction: Done.freeSelf);
    var env = Env.asr;
    var volume = IEnvGen.ar(env, line);
    var sig;

    freq = max(0, freq * speed * (1 + (accelerate * line)));
    sig = MiTides.ar(
      freq:   freq,
      shape:  tidesshape,
      slope:  slope,
      smooth: tidessmooth,
      shift:  shift,
      output_mode: mode,
      ramp_mode: 1,
      rate: 1
    );

    Out.ar(out, DirtPan.ar(sig * volume, ~dirt.numChannels, pan));
  }).add;
);





(
~dirt.addModule('elements', { |dirtEvent|
	dirtEvent.sendSynth('elements' ++ ~dirt.numChannels,
		[
      elementspitch: ~elementspitch,
      elementsstrength: ~elementsstrength,
      elementscontour: ~elementscontour,
      elementsbowlevel: ~elementsbowlevel,
      elementsblowlevel: ~elementsblowlevel,
      elementsstrikelevel: ~elementsstrikelevel,
      elementsflow: ~elementsflow,
      elementsmallet: ~elementsmallet,
      elementsbowtimb: ~elementsbowtimb,
      elementsblowtimb: ~elementsblowtimb,
      elementsstriketimb: ~elementsstriketimb,
      elementsgeom: ~elementsgeom,
      elementsbright: ~elementsbright,
      elementsdamp: ~elementsdamp,
      elementspos: ~elementspos,
      elementsspace: ~elementsspace,
      elementsmodel: ~elementsmodel,
      elementseasteregg: ~elementseasteregg,
			out: ~out
		]
	)
}, {~elementsstrength.notNil});
);

(
  SynthDef("elements" ++ ~dirt.numChannels, {

	|out,freq=440,sustain=1,pan=0,begin=0,end=1,speed=1,accelerate=0,
     elementspitch=48, elementsstrength=0.5, elementscontour=0.2, elementsbowlevel=0,elementsblowlevel=0, elementsstrikelevel=0,
     elementsflow=0.5, elementsmallet=0.5, elementsbowtimb=0.5, elementsblowtimb=0.5,
     elementsstriketimb=0.5, elementsgeom=0.25, elementsbright=0.5, elementsdamp=0.7, elementspos=0.2, elementsspace=0.3, elementsmodel=0,
     elementseasteregg=0|

    var signal = In.ar(out, ~dirt.numChannels);

    ReplaceOut.ar(out, MiElements.ar(
      blow_in: signal,
      strike_in: signal,
      gate: 1,
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





(
~dirt.addModule('rings', { |dirtEvent|
	dirtEvent.sendSynth('rings' ++ ~dirt.numChannels,
		[
			ringstrig:      ~ringstrig,
			ringsfreq:      ~ringsfreq,
			ringsstruct:    ~ringsstruct,
			ringsbright:    ~ringsbright,
			ringsdamp:      ~ringsdamp,
			ringspos:       ~ringspos,
			ringsmodel:     ~ringsmodel,
			ringspoly:      ~ringspoly,
			ringsinternal:  ~ringsinternal,
			ringseasteregg: ~ringseasteregg,
			ringsMix:       ~ringsMix,
			ringsPre:       ~ringsPre,
			speed:          ~speed,
			begin:          ~begin,
			end:            ~end,
			sustain:        ~sustain,
			out:            ~out
		]
	)
}, {~ringsbright.notNil});
);

(
SynthDef("rings" ++ ~dirt.numChannels, {

	|out,
	ringsfreq=440, freq=440, ringsstruct=0,ringsbright=0,ringsdamp=0.5,ringspos=0,ringsmodel=0,ringspoly=0,ringsinternal=0,ringseasteregg=0,ringsbypass=0, ringsPre=1, ringsMix=1, speed=1, begin=0, end=1, sustain|

	/*var envLength = sustain*(end-begin);
    var line      = Line.ar(begin, end, envLength, doneAction: Done.freeSelf);*/
	var signalDry = In.ar(out, ~dirt.numChannels);
	var signal;
	// var env       = Env.new    (levels: [0, 1, 0.77, 0], times: [0.0098, 0.6, 0.2], curve:[-5, -3, 5]);
	// var volume    = IEnvGen.ar(env, line);

	signalDry = signalDry * ringsPre;

	signal = MiRings.ar(
    in:             signalDry,
    trig:           ringsinternal,
    pit:            ringsfreq.cpsmidi,
    struct:         ringsstruct,
    bright:         ringsbright,
    damp:           ringsdamp,
    pos:            ringspos,
    model:          ringsmodel,
    poly:           ringspoly,
    intern_exciter: ringsinternal,
    easteregg:      ringseasteregg
  );

	signal = (signal*ringsMix)+(signalDry*(1-ringsMix));
	// signal = signal*volume;

  ReplaceOut.ar(out, signal)
}).add;

);





(
~dirt.addModule('ripples', { |dirtEvent|
	dirtEvent.sendSynth('ripples' ++ ~dirt.numChannels,
		[
			ripplescf: ~ripplescf,
			ripplesreson: ~ripplesreson,
			ripplesdrive: ~ripplesdrive,
			out: ~out
		]
	)
}, {~ripplescf.notNil});
);

(
SynthDef("ripples" ++ ~dirt.numChannels, { |out, ripplescf=0, ripplesreson=0, ripplesdrive=1|
	var signal = In.ar(out, ~dirt.numChannels);
	signal = MiRipples.ar(
    signal,
    cf: ripplescf,
    reson: ripplesreson,
    drive: ripplesdrive,
  );
  ReplaceOut.ar(out, signal)
}).add;

);





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
			out: ~out
		]
	)
}, {~warpsalgo.notNil});
);

(
SynthDef("warps" ++ ~dirt.numChannels, { |out, warpsalgo=0, warpstimb=0, warpsosc=1, warpsfreq=440, warpsvgain=1, warpseasteregg=0|
	var signal = In.ar(out, ~dirt.numChannels);

	signal = MiWarps.ar(
		carrier: signal,
		modulator: signal,
		algo: warpsalgo,
		lev1: 1,
		lev2: 1,
		timb: warpstimb,
		osc: warpsosc,
		freq: warpsfreq,
		vgain: warpsvgain,
		easteregg: warpseasteregg
  );

  ReplaceOut.ar(out, signal)
}).add;

);


(

(1..SuperDirt.maxSampleNumChannels).do { |numChannels|

	SynthDef("global_mi_verb" ++ numChannels, { |dryBus, effectBus, verbwet=0, verbtime=0, verbdamp=0, verbhp=0, verbfreeze=0, verbdiff=0.625, verbgain=0, verbsend=1|
		var signal = In.ar(dryBus, ~dirt.numChannels);

		Out.ar(effectBus, MiVerb.ar(
			signal,
			verbtime,
			verbwet,
			verbdamp,
			verbhp,
			verbfreeze,
			verbdiff
		) * verbgain);

		// DetectSilence.ar(effectBus, doneAction:2);
		DirtPause.ar(effectBus, graceTime:4);

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
