(

SynthDef(\bs_trig, {
    | out, sustain=1, freq=440, speed=1, begin=0, end=1, pan, accelerate, offset|

	var sig,
		gain,
		dur,
		line;

	dur = sustain * (end - begin);

	line    = Line.ar  (1, 0, dur*(1/speed), doneAction:2);
	sig     = Trig.ar  (line, 0.001*(1/speed));

	OffsetOut.ar(out, DirtPan.ar(sig, ~dirt.numChannels, pan))

}).add;

);