(
SynthDef.new(\bs_rongs, {

	|out=0, freq=440, sustain=1, pan=0, begin=0, end=1, speed=1, accelerate=0, cps=0.5,
	envMode = 0,
	structure=0.5, brightness=0.5, damping=0.75, accent=0.9, harmonicStretch=0.5, position=0.15, loss=0.15|

	var sig;

	var trig = Trig.kr(1, dur: sustain);
	var modeNum=2,
		cosFreq=0.025;

	var envLength = sustain*(end-begin)/speed;
	var line      = Line.ar(begin, end, envLength, doneAction: Done.freeSelf);
	// var env       = Env.asr;
	var env       = Env([0, 1, 0, 0], [0.01,0.986,0.008], [5,-5,5]);
	var env2      = Env([0, 1, 1, 0], [0.008,0.986,0.008]);
	var volume    = Select.kr(envMode, [IEnvGen.ar(env, line), IEnvGen.ar(env2, line)]);

	// freq = max(0, (freq) * (1 + (accelerate * line)));

	sig = Rongs.ar(
		trigger:trig,
		sustain:trig,
		f0:freq,
		structure:structure,
		brightness:brightness,
		damping:damping,
		accent:accent,
		stretch:harmonicStretch,
		position:position,
		loss:loss,
		modeNum:modeNum,
		cosFreq:cosFreq
	);

	/*DetectSilence.ar(in: sig, amp: 0.0001, time: 0.1, doneAction: 2);*/

	Out.ar(out, DirtPan.ar(sig * 0.33, ~dirt.numChannels, pan, volume));
}).add;
);