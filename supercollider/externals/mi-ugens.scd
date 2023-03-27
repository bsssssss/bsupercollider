// https://github.com/v7b1/mi-UGens

// installer classes d'abord!!


(
SynthDef(\braids, {

	|
	out=0, freq=440, sustain=1, pan=0, begin=0, end=1, speed=1, accelerate=0, cps=0.5,
	envMode=1,
	model=0,
	timbre=0.5, timbrePlat=0, timbreTilt=1, timbreCurve=1, timbreMirror=0, timbreEnv=0,
	timbreLfoRate=1, timbreLfo=0, timbreLfoShape=1,
	color =0.5, colorPlat=0, colorTilt=1, colorCurve=1, colorMirror=0, colorEnv=0,
	colorLfoRate =1, colorLfo =0, colorLfoShape=1,
	vibratoRate=8, vibratoDepth=0,
	pitchEnv=0, pitchEnvSpeed=1, pitchEnvCurve=(-12)
	|

	var sig, pitchMod;

	var envLength = sustain*(end-begin)/speed;
	var line      = Line.ar(begin, end, envLength, doneAction: Done.freeSelf);

	var env       = Env([0, 1, 1, 0], [0.002,0.97,0.03], \sin);
	var volume    = IEnvGen.ar(env, line);

	var tp = timbrePlat.clip(0, 1);
	var tc = timbreTilt.clip(0, 1);
	var triseAndFall = 1 - tp;
	var tattack = tc * triseAndFall;
	var trelease = (1 - tc) * triseAndFall;
	var thold = tp;
	var tenv = 	EnvGen.ar(Env.new(
			levels: [timbreMirror, 1-timbreMirror, 1-timbreMirror, timbreMirror],
			times:  [tattack, thold, trelease],
			curve:  [timbreCurve,0,timbreCurve*(-1)]
		),  timeScale: sustain);

	var cp = colorPlat.clip(0, 1);
	var cc = colorTilt.clip(0, 1);
	var criseAndFall = 1 - cp;
	var cattack = cc * criseAndFall;
	var crelease = (1 - cc) * criseAndFall;
	var chold = cp;
	var cenv = 	EnvGen.ar(Env.new(
			levels: [colorMirror, 1-colorMirror, 1-colorMirror, colorMirror],
			times:  [cattack, chold, crelease],
			curve:  [colorCurve,0,colorCurve*(-1)]
		),  timeScale: sustain);

	var timbreLfoMod = Select.kr (timbreLfoShape, [
		SinOsc.ar  (freq: cps*timbreLfoRate, add: 0),
		LFTri.ar   (freq: cps*timbreLfoRate, add: 0),
		LFSaw.ar   (freq: cps*timbreLfoRate, add: 1)/2,
		LFPulse.ar (freq: cps*timbreLfoRate, add: 0),
	]);

	var colorLfoMod = Select.kr (colorLfoShape, [
		SinOsc.ar  (freq: cps*colorLfoRate, add: 0),
		LFTri.ar   (freq: cps*colorLfoRate, add: 0),
		LFSaw.ar   (freq: cps*colorLfoRate, add: 1)/2,
		LFPulse.ar (freq: cps*colorLfoRate, add: 0),
	]);

	pitchMod = EnvGen.ar (Env.new (
		levels: [0, 1, 0],
		times:  [0, 0.1 * (1 / pitchEnvSpeed), 0],
		curve:  [1, pitchEnvCurve, -5]))
		* pitchEnv;

	freq   = max(0, (freq+(pitchMod * 100)) * (1 + (accelerate * line)));
	freq   = freq + (SinOsc.ar(freq: vibratoRate * cps) * vibratoDepth);
	freq   = freq.cpsmidi;

	timbre = (timbreLfoMod*timbreLfo) + (tenv * timbreEnv) + (timbre);
	timbre = timbre.clip(0, 1);

	color  = (colorLfoMod*colorLfo) + (cenv * colorEnv) + color;
	color  = color.clip(0, 1);

	sig = MiBraids.ar (
		pitch:  freq,
		timbre: timbre,
		color:  color,
		model:  model.clip(0, 47),
		resamp: 0
	);
	sig = sig*volume;

	Out.ar(out, DirtPan.ar(sig * 0.4, ~dirt.numChannels, pan, 1));
}).add;
);


(
  SynthDef(\plaits, {

	|
	out=0, freq=440, sustain=1, pan=0, begin=0, end=1, speed=1, accelerate=0, cps=0.5,
	envMode=1,
	model=0,
	timbre=0.5, timbrePlat=0, timbreTilt=1, timbreCurve=1, timbreMirror=0, timbreEnv=0,
	timbreLfoRate=1, timbreLfo=0, timbreLfoShape=1,
	harm=0.5, harmPlat=0, harmTilt=1, harmCurve=1, harmMirror=0, harmEnv=0,
	harmLfoRate=1, harmLfo=0, harmLfoShape=1,
	morph=0.5, morphPlat=0, morphTilt=1, morphCurve=1, morphMirror=0, morphEnv=0,
	morphLfoRate=1, morphLfo=0, morphLfoShape=1,
	level=1, lpgdecay=0, lpgcolour=0,
	main=1,
	aux=0,
	pitchEnv=0, pitchEnvSpeed=1, pitchEnvCurve=(-12),
	vibratoRate=8, vibratoDepth=0,
	trig=0
	|

    var osc;
	var sig;
	var pitchMod;

    var envLength = sustain*(end-begin)/speed;
    var line      = Line.ar(begin, end, envLength, doneAction: Done.freeSelf);
	var env       = Env([0, 1, 1, 0], [0.002,0.97,0.03], \sin);
	var volume    = IEnvGen.ar(env, line);

	var tp = timbrePlat.clip(0, 1);
	var tc = timbreTilt.clip(0, 1);
	var triseAndFall = 1 - tp;
	var tattack = tc * triseAndFall;
	var trelease = (1 - tc) * triseAndFall;
	var thold = tp;
	var tenv = 	EnvGen.ar(Env.new(
			levels: [timbreMirror, 1-timbreMirror, 1-timbreMirror, timbreMirror],
			times:  [tattack, thold, trelease],
			curve:  [timbreCurve,0,timbreCurve*(-1)]
		),  timeScale: sustain);

	var timbreLfoMod = Select.kr (timbreLfoShape, [
		SinOsc.ar  (freq: cps*timbreLfoRate, add: 0),
		LFTri.ar   (freq: cps*timbreLfoRate, add: 0),
		LFSaw.ar   (freq: cps*timbreLfoRate, add: 1)/2,
		LFPulse.ar (freq: cps*timbreLfoRate, add: 0),
	]);

	var hp = harmPlat.clip(0, 1);
	var hc = harmTilt.clip(0, 1);
	var hriseAndFall = 1 - hp;
	var hattack = hc * hriseAndFall;
	var hrelease = (1 - hc) * hriseAndFall;
	var hhold = hp;
	var henv = 	EnvGen.ar(Env.new(
			levels: [harmMirror, 1-harmMirror, 1-harmMirror, harmMirror],
			times:  [hattack, hhold, hrelease],
			curve:  [harmCurve,0,harmCurve*(-1)]
		),  timeScale: sustain);

	var harmLfoMod = Select.kr (harmLfoShape, [
		SinOsc.ar  (freq: cps*harmLfoRate, add: 0),
		LFTri.ar   (freq: cps*harmLfoRate, add: 0),
		LFSaw.ar   (freq: cps*harmLfoRate, add: 1)/2,
		LFPulse.ar (freq: cps*harmLfoRate, add: 0),
	]);

	var mp = morphPlat.clip(0, 1);
	var mc = morphTilt.clip(0, 1);
	var mriseAndFall = 1 - mp;
	var mattack = mc * mriseAndFall;
	var mrelease = (1 - mc) * mriseAndFall;
	var mhold = mp;
	var menv = 	EnvGen.ar(Env.new(
			levels: [morphMirror, 1-morphMirror, 1-morphMirror, morphMirror],
			times:  [mattack, mhold, mrelease],
			curve:  [morphCurve,0,morphCurve*(-1)]
		),  timeScale: sustain);

	var morphLfoMod = Select.kr (morphLfoShape, [
		SinOsc.ar  (freq: cps*morphLfoRate, add: 0),
		LFTri.ar   (freq: cps*morphLfoRate, add: 0),
		LFSaw.ar   (freq: cps*morphLfoRate, add: 1)/2,
		LFPulse.ar (freq: cps*morphLfoRate, add: 0),
	]);

	timbre = (timbreLfoMod*timbreLfo) + (tenv * timbreEnv) + (timbre);
	timbre = timbre.clip(0, 1);

	harm = (harmLfoMod*harmLfo) + (henv * harmEnv) + (harm);
	harm = harm.clip(0, 1);

	morph = (morphLfoMod*morphLfo) + (menv * morphEnv) + (morph);
	morph = morph.clip(0, 1);

	pitchMod = EnvGen.ar (Env.new (
		levels: [0, 1, 0],
		times:  [0, 0.1 * (1 / pitchEnvSpeed), 0],
		curve:  [1, pitchEnvCurve, -5]))
		* pitchEnv;

	freq = max(0, (freq + pitchMod) * (1 + (accelerate * line.fold(0, 1))));
	freq = freq + (SinOsc.ar(freq: vibratoRate * cps) * vibratoDepth);

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

	osc = osc * volume;

	sig = Mix.ar (DirtPan.ar (osc, ~dirt.numChannels, -1) * main
		       + (DirtPan.ar (osc, ~dirt.numChannels,  1) * aux));

    Out.ar(out, DirtPan.ar(sig * 0.4, ~dirt.numChannels, pan, 1));
  }).add;
);



(
SynthDef("rings_synth" ,{

	|
	out, freq=440, speed=1, begin=0, end=1, sustain=1, pan=0.5,
	main=1,aux=0,
	ringsfreq=440, ringsstruct=0.5,ringsbright=0.33,ringsdamp=0.33,ringspos=0.33,
	ringsmodel=0,ringspoly=0,ringsbypass=0,
	ringsinternal=0,ringseasteregg=0
	|

	var envLength = sustain*(end-begin);
	var line      = Line.ar(begin, end, envLength, doneAction: Done.freeSelf);
	var env       = Env([0, 1, 1, 0], [0.000,0.992,0.008], \sin);
	var volume    = IEnvGen.ar(env, line);
	var signal, osc, trig, tr;

	trig = Trig.ar(line, 0.01) * 1;
	tr = (WhiteNoise.ar * trig)*1;

	osc = MiRings.ar(
		in:             0,
		trig:           0,
		pit:            freq.cpsmidi,
		struct:         ringsstruct,
		bright:         ringsbright,
		damp:           ringsdamp,
		pos:            ringspos,
		model:          ringsmodel,
		poly:           ringspoly,
		intern_exciter: 1,
		easteregg:      ringseasteregg
	);
	osc = osc*volume;
	osc = osc*0.4;

	signal = Mix.ar (DirtPan.ar (osc, ~dirt.numChannels, -1) * main
		          + (DirtPan.ar (osc, ~dirt.numChannels,  1) * aux));
	Out.ar(out, DirtPan.ar(signal, ~dirt.numChannels, pan, 1));
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
~dirt.addModule('rings_fx', { |dirtEvent|
	dirtEvent.sendSynth('rings_fx' ++ ~dirt.numChannels,
		[
			fx_ringstrig:      ~fx_ringstrig,
			fx_ringsfreq:      ~fx_ringsfreq ?? 0,
			fx_ringsnote:      ~fx_ringsnote ?? 0,
			fx_ringsstruct:    ~fx_ringsstruct ?? 0.5,
			fx_ringsbright:    ~fx_ringsbright ?? 0.5,
			fx_ringsdamp:      ~fx_ringsdamp ?? 0.5,
			fx_ringspos:       ~fx_ringspos ?? 0.5,
			fx_ringsmodel:     ~fx_ringsmodel,
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

(1..SuperDirt.maxSampleNumChannels).do { |numChannels|

	SynthDef("global_mi_verb" ++ numChannels, {
		|dryBus, effectBus,
		verbwet=0, verbtime=0, verbdamp=0, verbhp=0, verbfreeze=0, verbdiff=0.625, verbgain=0, verbsend=1|

		var in, signal, rvb;
		in = In.ar(dryBus, ~dirt.numChannels);
		in = in * verbsend;
		ReplaceOut.ar(dryBus, in * (1 - verbwet));

		verbtime = Lag.kr(verbtime, 0.2);
		verbdamp = Lag.kr(verbdamp, 0.2);
		verbhp   = Lag.kr(verbhp, 0.2);
		verbdiff = Lag.kr(verbdiff, 0.2);
		verbgain = Lag.kr(verbgain, 0.2);


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
