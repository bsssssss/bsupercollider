(
{
	var freq, freqs, nPartials, n, snd;

	// snd = 0;
	nPartials = 100;
	n = (1..nPartials);

	freq = 129.2 * 1;

	freqs = freq * n;
	// freqs.postln;
	// freqs = freqs * ((n*n) * 1e-4).sqrt;
	// freqs.postln;

	snd = freqs.collect({ |f, i|
		// i = i/1;
		SinOsc.ar(f) * (-30.dbamp / 1.1.pow(i));
	});

	snd = snd.sum;
	snd = snd.tanh;
	snd = Splay.ar(snd);
	snd = LeakDC.ar(snd);
	// snd = snd ! 2;

}.play;
)





(
var freq, freqs, nPartials, n, snd;

nPartials = 8;
n = (1..nPartials);

freq = 200;
freqs = freq * n;

((1-log2([1,2] * 1).sin.abs)** 5).postln;

freqs.collect({
	|f, i|
});

)

s.boot;


((1-log2([1,3] * 1).sin.abs)** 5)

((1-log2([1,3] * 1).sin.abs).pow(5))

2.pow(4);