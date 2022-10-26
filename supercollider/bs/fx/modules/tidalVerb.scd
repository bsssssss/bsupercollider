(

var numChannels = ~dirt.numChannels;

  SynthDef(\tidalVerb, {

		|dryBus, effectBus, preDelay=1, revTime=10, lpf=4500, mix=0.5,amp=1|

		var dry,wet,temp,sig;

		dry  = In.ar(dryBus, 2);
		temp = In.ar(dryBus, 2);
		wet=0;
		temp=DelayN.ar(temp, 0.2, preDelay);

		32.do {temp=AllpassN.ar(temp, 0.05, {Rand(0.001,0.05)}!2,revTime);
			temp=LPF.ar(temp,lpf);
			wet=wet+temp;
		};

		sig=XFade2.ar(dry,wet,mix*2-1,amp);

		Out.ar(effectBus, sig);
	}).add;

)


