(
var loadAndReplace = { |path, charToReplace, depth|
	var pattern = path;
	(depth-1).do { pattern = pattern +/+ "*" };
	pattern = pattern +/+ "*";
	~dirt.loadSoundFiles(pattern, namingFunction: { |x| x.basename.replace(charToReplace, "") });
};

// tidal-drum-machines :
loadAndReplace.("/Users/bss/Documents/git/samples/tidal-drum-machines/machines", "-", 2);

//undo
loadAndReplace.("/Users/bss/Documents/samples/tidal-samples/undo", "_", 1);

// jaga
loadAndReplace.("/Users/bss/Documents/samples/percussions/", "_", 1);

// bs-banks :
loadAndReplace.("/Users/bss/Documents/samples/tidal-samples/bs", "_", 2);
loadAndReplace.("/Users/bss/Documents/samples/tidal-samples/bog-drums", "_", 1);
)
