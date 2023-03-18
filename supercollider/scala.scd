(
~dirt.orbits.do{ |x|
    x.set(\freq, #{
        var degree = ~note;
        var oct = ~octave;
		var name = ~scl ?? 'et12';
		var path = format("/home/max/Documents/scala/scl/%.scl", name).asString;
		// path.postln;
		var tname = Scala.open(path).scale;
        Event.default.use {
            ~degree = degree;
            ~octave = oct;
            ~scale = tname;
            ~freq.value
        }
    }
    )
};
)
