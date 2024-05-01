(
SynthDef(\tides, {
    |out=0, freq=440, sustain=1, pan=0, begin=0, end=1, speed=1, accelerate=0|

    var snd;
    var dur  = sustain * (end - begin);
    var line = Line.ar(begin, end, dur, doneAction: Done.freeSelf);

    var pitchEnv = TiltEnv.ar(
        \pitch_env_tilt.kr(0).clip(0,1),
        \pitch_env_hold.kr(0).clip(0,1),
        \pitch_env_curve.kr(-4),
        0.11 / \pitch_env_speed.kr(1)
    );

    freq   = max(0, (freq) * (1 + (accelerate * line)));
    freq   = (freq.cpsmidi + (SinOsc.ar(freq: \vibrato_rate.kr(8) * cps) * \vibrato_depth.kr(0)) + (pitchEnv * \pitch_env.kr(0))).midicps;

      snd = MiTides.ar(
        freq:   freq,
        shape:  tidesshape,
        slope:  slope,
        smooth: tidessmooth,
        shift:  shift,
        output_mode: mode,
        ramp_mode: 1,
        rate: 1
      );
    snd = snd * (-6.dbamp);

      Out.ar(out, DirtPan.ar(snd, ~dirt.numChannels, pan));
    }).add;
  );