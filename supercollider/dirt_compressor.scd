// emulation of master compressor from original Dirt
// requires Fb1 from miSCellaeous for single-sample feedback
// https://github.com/dkmayer/miSCellaneous_lib
(
Ndef(\dirtComp, { |amount=0.3, speed=50|
    var in, max, env;
    in = In.ar(0, ~dirt.numChannels);

    max = Select.ar(ArrayMax.ar(in.abs)[1], in);
    env = Fb1({ |in, out|
        var env, prod;
        env = out[1];
        env = env + (speed / SampleRate.ir);
        prod = (in[0] * env).abs;
        Select.kr(prod > 1, [env, env/prod]);
    }, max, leakDC: false);

    ReplaceOut.ar(0, in * amount.linlin(0, 1, 1, env * 0.2));
}).play(
    group: RootNode(Server.default),
    addAction: \addToTail
);
)
