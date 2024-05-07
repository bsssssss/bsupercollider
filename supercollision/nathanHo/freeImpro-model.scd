


// Run before booting server.
Server.default.options.blockSize = 1;

(
SynthDef(\easel, {
        var snd, numInputs, numOutputs;
        numInputs = 12;
        numOutputs = 7;
        snd = LocalIn.ar(numOutputs);
        // Matrix-vector multiplication using multichannel expansion.
        snd = snd * ({ { LFNoise2.kr(0.5).round } ! numInputs } ! numOutputs);
        snd = snd.sum;
        // If additional modules are added, remember to update numInputs and numOutputs.
        // numInputs should equal the maximum i in snd[i], plus one.
        // numOutputs should equal the number of entries in the snd array.
        snd = [
                // Oscillator that reaches LFO range
                SinOsc.ar(snd[0].linexp(-1, 1, 0.1, 8000)),
                // Oscillator in audio range only
                SinOsc.ar(snd[1].linexp(-1, 1, 100, 8000)),
                // Wavefolder with controllable gain
                (snd[2] * snd[3].linexp(-1, 1, 1, 10)).fold2,
                // Two filters with controllable cutoff and resonance
                MoogFF.ar(snd[4], snd[5].linexp(-1, 1, 10, 8000), snd[6].linlin(-1, 1, 0, 4)) * 3.dbamp,
                MoogFF.ar(snd[7], snd[8].linexp(-1, 1, 10, 8000), snd[9].linlin(-1, 1, 0, 4)) * 3.dbamp,
                // Metallic reverb (spring reverb in the Easel)
                FreeVerb.ar(snd[10], mix: 1),
                // Five-step sequencer
                Demand.ar(Impulse.ar(snd[11].linexp(-1, 1, 0.1, 1000)), 0, Dseq([-0.1, 0.5, -0.9, 0.3, -0.4], inf))
        ];
        if(snd.size != numOutputs) {
                Error("Please ensure numOutputs matches number of modules").throw;
        };
        snd = Sanitize.ar(snd);
        LocalOut.ar(snd);
        // Grab output from one of the filters. Try changing the index here, or even using snd.sum.
        snd = Limiter.ar(LeakDC.ar(snd[3]));
        snd = Pan2.ar(snd, 0);
        Out.ar(\out.kr(0), snd);
}).add;
)

Synth(\easel);
