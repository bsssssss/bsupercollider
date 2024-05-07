//////////////////////////////////////////////////////////

(
~makeNotes = {
	|root = 0, nNotes=3|
	var scale = [0,2,4,5,7,9,11];
	var notes;

	scale = scale + root;
	notes = scale.scramble.keep(nNotes);
};
)
~makeNotes.(0, 4);



5.dup(4);
rrand(1,100).dup(4); // gauche a droite = repete le choix

{ rrand(1,100) }.dup(4); //repete la fonction
{ rrand(1,100) } ! 4; // pareil



(
x = [0,2,4,5,7,9,11];

//retourne la collection modifiee, alors que "do" retourne quelquchose fait avec la collection
	|item|
	// item.postln;
	item + rrand(0,3);
});
)

//////////////////////////////////////////////////////////




//server commands
s.boot;

(
s.reboot {
	s.options.hardwareBufferSize = 128;
	s.options.numWireBufs = 2048*8;
};
)

s.quit;


(
x = {
	PinkNoise.ar * (-12).dbamp;
}.play;
)

(
x = {
	LFTri.ar(
		freq: 60
	) * (-12).dbamp;
}.play;
)
//.plot .scope

s.meter;

(
x = {
    var mod, snd, lfoFreqMod;

	lfoFreqMod = LFNoise1.kr([5,3,6]).exprange(0.01,1);
	mod        = LFTri.ar(freq: lfoFreqMod) * 10;

	snd    = SinOsc.ar(freq: [1000,1111] + mod);
	snd    = snd*(-30.dbamp);

	snd = Splay.ar(snd);
}.play;
)



(
x = {
    var mod, snd, lfoFreqMod, ampMod, voices;

	voices = 10;

	lfoFreqMod = LFNoise1.kr(
		freq: {exprand(10, 5)} ! voices
	);

	ampMod = SinOsc.kr(
		freq: {exprand(0.1, 1)} ! voices
	);


	mod = LFTri.ar(
		freq: lfoFreqMod.exprange(0.01,1)
	) * ampMod.range(10,0);


	snd = SinOsc.ar(
		freq: {exprand(3060,20000)} ! voices + mod
	);

	snd = snd * ampMod.range(-70,0).dbamp;
	snd = snd * (-18.dbamp);

	snd = Splay.ar(snd);
	// snd = snd.sum.dup(2);
};
)

x.play;





(
x = {
	var osc1, osc2,
	    compare,
	    amp, snd, out;

	osc1 = VarSaw.ar(
		freq:  2,
		width: 1
	);

	osc2 = VarSaw.ar(
		freq:  XLine.kr(1, 8, 2),
		width: 0
	);

	compare = osc1 >= osc2;

	out = [osc1, osc2, compare];
}.plot(2)
)



(
x = {
	var snd;

	snd = VarSaw.ar(
		freq:  \freq.kr(120).lag(1) + ({exprand(1,300)} ! 10),
		width: \width.kr(0.5)
	);
	snd = snd * \amp.kr(-20.dbamp); // <--- named controls prend des expressions !!

	snd = Splay.ar(snd);
}.play
)

x.set(\freq, 220, \width, 0.97, \amp, -30.dbamp);

x.release(1);


/////////////////////////////////////////////////////////////////



(
x = Env.new(
	levels: [0,1,0],
	times:  [0.1,1],
	curve: [-4,-8]
).plot;
)

(
x = {
	var snd, env;

	env = EnvGen.ar(
		Env.new(
			levels: [0,1,0],
			times:  [0.1,1],
			curve: [9,-4],
		),
		timeScale:  0.4,
		doneAction: Done.freeSelf
	);

	snd = VarSaw.ar(
		freq:  \freq.kr(120).lag(1) + ({exprand(1,10)} ! 30) + ({exprand(1,1000)} ! 2),
		width: \width.kr(0.5)
	);

	snd = snd * env;
	snd = snd * \amp.kr(-20.dbamp); // <--- named controls prend des expressions !!

	snd = Splay.ar(snd);
}.play
)






(
x = {
	var snd, env;

	env = Env.new(
		levels: [0,1,0],
		times: [0.04, 1],
		curve: [4,-4]
	).ar(gate: \trig.tr(1), doneAction: Done.freeSelf); // Retrig

	snd = VarSaw.ar(
		freq:  \freq.kr(120).lag(1) + ({exprand(1,10)} ! 30) + ({exprand(1,1000)} ! 2),
		width: \width.kr(0.5)
	);

	snd = snd * env;
	snd = snd * \amp.kr(-20.dbamp); // <--- named controls prend des expressions !!

	snd = Splay.ar(snd);
}.play
)

x.set(\trig, 1);




// gated ADSR
(
x = {
	var snd, env;

	env = Env.new(
		levels: [0,1,0.2,0],
		times: [0.04, 1, 1],
		curve: [4,-4],
		releaseNode: 2
	).ar(gate: \gate.kr(1), doneAction: Done.freeSelf);

	snd = VarSaw.ar(
		freq:  \freq.kr(200),
		width: \width.kr(0.5)
	);

	snd = snd * env;
	snd = snd * \amp.kr(-20.dbamp); // <--- named controls prend des expressions !!

	snd = Splay.ar(snd);
}.play
)

x.set(\gate, 0);



(
SynthDef.new(\bibu, {
	var snd;

	snd = VarSaw.ar(
		freq: 400,
		width: 0.8
	);
	snd = snd * -24.dbamp;

	Out.ar(\out.kr(0), snd); // JAMAIS d'array ici pour pas fucker les expansions multichannel
}).add;
)

x = Synth(\bibu);
x.free;
