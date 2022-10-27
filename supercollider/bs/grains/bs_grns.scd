
(

// var mod = LFNoise1.ar(0.5, 0.0001);



SynthDef(\bs_grn, {
	| out, sustain=1, freq=264, speed=1, begin=0, end=1, pan, accelerate, offset, grainIndex=0,
	grainSize=0, grainSizeRatio=1, grainRate=1, grainPitch=0, grainFreq=0, grainFreqRatio=1,
	grainPos=0.0, grainPosModAmp=0, grainPosModRate=0, grainFreqModRate=1, grainFreqModAmp=0,
	grainPosRand=0, grainPitchRand=0, grainPhase=1, grainFreqModPhase=0, cps = 0.5|

	var
	lineGrain,
	line,
	gainEnv,
	gain,
	sig,
	dur,
	b,
	trig,
	sample,
	index,
	trigLine,
	bdur,
	grainPoss,
	posMax;
	index = 1;

	// b  = SoundFile.collectIntoBuffers("/home/bss/Samples/autodafe/Keio_Checkmate/*", s);
	// b = b[index];
	b = Buffer.readChannel(s, "/media/bss/mais?/sonsse/Gems/tremblez/hrsh.wav", channels: [0]);
	"buffer loaded".postln;

	dur = sustain*(end-begin);

	line     = Line.ar    (begin, end, dur, doneAction:2);


	gainEnv  = Env.new    (
		levels: [0, 1, 0.8, 0],
		times: [0.01, 0.98, 0.01],
		curve:[-5, -3, 5]);

	gain = IEnvGen.ar (gainEnv,line);


/*
	b.postln;*/


	// b[grainIndex].bufnum.postln;

	grainFreq = ((cps)*grainFreqRatio) + (SinOsc.ar(
		freq: (1/dur) * grainFreqModRate,
		mul: grainFreqModAmp,
		phase: grainFreqModPhase
	) + grainFreq).abs.clip(0,22050);




	grainPoss = SinOsc.ar(
		freq: (cps) * grainPosModRate,
		mul: grainPosModAmp
	);
	// grainPos = grainPos.fold(0,1);

	grainPoss = grainPoss + Line.ar(LFDNoise1.ar(0.02, 1), LFDNoise1.ar(0.02, 1), 10000)*grainPosRand;



	trig = Impulse.ar(grainFreq);

	// grainPos = grainPos + Latch.ar(WhiteNoise.ar(grainPosRand), trig);

	grainRate = 2.pow(((freq.cpsmidi - 60) + grainPitch/12)) * grainRate;
	grainRate = grainRate + Latch.ar(WhiteNoise.ar(grainPitchRand), trig);
	grainSize = (1/grainFreq)*grainSizeRatio+grainSize;


	posMax = (grainSize/BufDur.kr(b));

	lineGrain = Line.ar(begin, 0.95, BufDur.kr(b)*(1/speed), grainPhase);


	grainPos = lineGrain + grainPoss + grainPos;
	grainPos = grainPos.clip(0,1);

	// bdur = BufDur.kr(b);

	// trigLine = Trig.ar(line, 0.01);
	// lineGrain = Phasor.ar(trigLine, 1/44100, 0, 1);

	sig = GrainBuf.ar (
		numChannels: 1,
		trigger:     trig,
		dur:         grainSize,
		sndbuf:      b,
		rate:        grainRate,
		pos:         grainPos,
		interp:      2,
		maxGrains:   512,
		pan:         0,
		envbufnum:   -1,
		mul:         1,
		add:         0
	);

	ReplaceOut.ar(out, DirtPan.ar(sig, ~dirt.numChannels, pan, gain));
}).add;

);






(

// var mod = LFNoise1.ar(0.5, 0.0001);



SynthDef(\bs_grn2, {
	| bufnum, out, sustain=1, freq=264, speed=1, begin=0, end=1, pan, accelerate, offset, grainIndex=0,
	grainSize=0, grainSizeRatio=1, grainRate=1, grainPitch=0, grainFreq=0, grainFreqRatio=1,
	grainPos=0.0, grainPosModAmp=0, grainPosModRate=0, grainFreqModRate=1, grainFreqModAmp=0,
	grainPosRand=0, grainPitchRand=0, grainPhase=1, grainFreqModPhase=0, cps = 0.5|

	var
	lineGrain,
	line,
	gainEnv,
	gain,
	sig,
	dur,
	b,
	trig,
	sample,
	index,
	trigLine,
	bdur,
	grainPoss,
	posMax;
	index = 1;

	// b  = SoundFile.collectIntoBuffers("/media/bss/mais?/sonsse/Gems/texturythmes/*", s);
	// b = b[index];
	b = Buffer.readChannel(s, "/media/bss/mais?/sonsse/Gems/SILOC/redio.wav", channels: [0]);
	// b = bufnum;
	"buffer loaded".postln;

	dur = sustain*(end-begin);

	line     = Line.ar    (begin, end, dur, doneAction:2);


	gainEnv  = Env.new    (
		levels: [0, 1, 0.8, 0],
		times: [0.01, 0.98, 0.01],
		curve:[-5, -3, 5]);

	gain = IEnvGen.ar (gainEnv,line);


/*
	b.postln;*/


	// b[grainIndex].bufnum.postln;

	grainFreq = ((cps)*grainFreqRatio) + (SinOsc.ar(
		freq: (1/dur) * grainFreqModRate,
		mul: grainFreqModAmp,
		phase: grainFreqModPhase
	) + grainFreq).abs.clip(0,22050);

	grainFreq = max(0, (grainFreq) * speed * (1 + (accelerate * line)));


	grainPoss = SinOsc.ar(
		freq: (cps) * grainPosModRate,
		mul: grainPosModAmp
	);
	// grainPos = grainPos.fold(0,1);

	grainPoss = grainPoss + Line.ar(LFDNoise1.ar(0.02, 1), LFDNoise1.ar(0.02, 1), 10000)*grainPosRand;



	trig = Impulse.ar(grainFreq);

	// grainPos = grainPos + Latch.ar(WhiteNoise.ar(grainPosRand), trig);

	grainRate = 2.pow(((freq.cpsmidi - 60) + grainPitch/12)) * grainRate;
	grainRate = grainRate + Latch.ar(WhiteNoise.ar(grainPitchRand), trig);
	grainSize = (1/grainFreq)*grainSizeRatio+grainSize;


	posMax = (grainSize/BufDur.kr(b));

	lineGrain = Line.ar(begin, 0.95, BufDur.kr(b)*(1/speed), grainPhase);


	grainPos = lineGrain + grainPoss + grainPos;
	grainPos = grainPos.clip(0,1);

	// bdur = BufDur.kr(b);

	// trigLine = Trig.ar(line, 0.01);
	// lineGrain = Phasor.ar(trigLine, 1/44100, 0, 1);

	sig = GrainBuf.ar (
		numChannels: 1,
		trigger:     trig,
		dur:         grainSize,
		sndbuf:      b,
		rate:        grainRate,
		pos:         grainPos,
		interp:      2,
		maxGrains:   512,
		pan:         0,
		envbufnum:   -1,
		mul:         1,
		add:         0
	);

	ReplaceOut.ar(out, DirtPan.ar(sig, ~dirt.numChannels, pan, gain));
}).add;

);








(

SynthDef(\bs_grn3, {

    | out, sustain=1, freq=264, speed=1, begin=0, end=1, pan, accelerate, offset,
	grainFreq=33.33, grainPos=0, overlap=2, grainRate=1, grainPitch=0, grainPosRate=1, grainSizeRatio=1|

	var line, b, dur, phasor, sig, trig, bufFrames, grainTrig, phasorTrig;

	b          = Buffer.readChannel (s, "/media/bss/mais?/sonsse/Gems/SILOC/159 dbb.wav", channels: [0]);
	bufFrames  = BufFrames.ir(b.bufnum);


	dur        = sustain * (end - begin);
	line       = Line.ar (1, 0, dur * (1 / speed), doneAction: 2);
	phasorTrig = Trig.ar (line);

	grainTrig  = Impulse.ar(grainFreq);
	grainRate  = 2.pow(((freq.cpsmidi - 60) + grainPitch/12)) * grainRate;


	phasor = Phasor.ar (
		phasorTrig,
		rate: grainPosRate * BufRateScale.kr(b.bufnum),
		start: 0.0,
		end: bufFrames
	);

	sig = GrainBuf.ar(
		numChannels: 2,
		trigger: grainTrig,
		dur: grainFreq.reciprocal * grainSizeRatio,
		sndbuf: b.bufnum,
		rate: grainRate,
		pos: (phasor / bufFrames) + grainPos
	);

	ReplaceOut.ar(out, DirtPan.ar(sig, ~dirt.numChannels, pan));
}).add;

);
































