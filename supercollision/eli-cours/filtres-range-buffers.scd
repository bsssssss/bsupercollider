
//////////////
//Ranges////
/////////
(
var num, steps;
steps = 32;
num = Array.fill(steps, {
	|i|
	var step;
	step = i + 1;
	// step.postln;
});

[
	num,
	num.linexp  (1,steps,1,steps),
	num.explin  (1,steps,1,steps),
	num.lincurve(1,steps,1,steps,10),
].plot;
)



// dronpets
(
{
	var snd, mod1, mod2, mod3, freq, voices;

	voices = 10;

	mod1 = LFNoise2.kr(0.1 ! voices);
	mod2 = LFNoise2.kr(0.3 ! voices);
	mod3 = LFNoise2.kr(0.666 ! voices);

	freq = 600 + ( ({rrand(-1, 1) * 7} ! voices) * mod3.max(0.1) );
	freq = freq * ([0,3,5,-12]).postln.midiratio;

	snd = SinOsc.ar(freq);
	snd = snd.lincurve(-1,1,-1,1, mod1.range(-20,20)) ; // waveshaping !!
	// snd.scope();
	snd = snd * mod2.range(0,-20).dbamp;
	snd = snd * -24.dbamp;
	snd = Splay.ar(snd);
	// 0;
}.play
)



(
s.reboot{
	s.options.hardwareBufferSize = 128;
};
)


s.freeAll;

/////////////
//Buffers///
//////////

(
b = Buffer.read(
	s, // server
	"/Users/bss/Documents/samples/tidal-samples/legowelt/legsy35/Synth-ArtVoice6chord.wav",
);
)

b.play;
b.query;
b.numChannels; // etc.. language side

BufDur.kr // server side

thisProcess.nowExecutingPath; // juste une string

PathName(thisProcess.nowExecutingPath); // objet donc..
PathName(thisProcess.nowExecutingPath).parentPath ++ "truc.txet"; // eh oui

s.options.numBuffers;

(
{
	var snd, rate;

	rate = 1;
	snd = PlayBuf.ar(
		numChannels: 1,
		bufnum: b,
		rate: rate * BufRateScale.kr(b), //samplerate correspondance
		doneAction: Done.freeSelf
	);
	snd = snd * -3.dbamp;
	snd = Splay.ar(snd);
}.play;
)

b;

Buffer.freeAll;




































