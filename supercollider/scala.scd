(
~dirt.orbits.do{ |x|

    x.set(\freq, #{
		// var freq      = ~freq;
		var degree    = ~note ? ~n;
        var oct       = ~octave;
		var scalaPath = "/Users/bss/Documents/scala/scl/" ++ ~scala ++ ".scl";
		var tname     = if(~scala.isNil, {~scala ='et12'}, {~scala = Scala.open(scalaPath)} );

		Event.default.use{
			~degree = degree;
			// ~scale  = if(~scala.isNil, {~scale}, Scale.chromatic(tname).semitones );
			~scale  = Scale.chromatic(Tuning.new(\et12).semitones);
			~octave = oct;
			~freq.value
		}
	})
});