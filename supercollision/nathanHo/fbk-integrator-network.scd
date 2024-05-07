
Server.default.options.blockSize = 1;

s.boot;

(
{
    var snd, n;
    n = 8;
    snd = Impulse.ar(0);
    snd = snd + LocalIn.ar(n);
    snd = Integrator.ar(snd, 0.99);
    snd = snd * ({ { Rand(-1, 1) * 1000 } ! n } ! n);
    snd = snd.sum;
    snd = LeakDC.ar(snd);
    snd = snd.clip2;
    LocalOut.ar(snd);
    Splay.ar(snd) * 0.3;
}.play(fadeTime: 0);
)


({ { rrand(-1.0, 1) * 1000 } ! 2 } ! 2)
