(
~dirt.orbits.do{ |x|
    x.set(\freq, #{
        var degree = ~note;
        var oct = ~octave;
		var name = ~scl ?? 'et12';
		var path = format("/home/bss/Documents/scala/scl/%.scl", name);
		var tname = Scala.new(path).scale;
        Event.default.use {
            ~degree = degree;
            ~octave = oct;
            ~scale = tname;
            ~freq.value
        }
    })};
)
