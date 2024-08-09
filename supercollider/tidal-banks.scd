//
// (
// //tidal-drum-machines
// ~dirt.loadSoundFiles("/Users/bss/Documents/git/tidal-drum-machines/machines" +/+ "*" +/+ "*", namingFunction: { |x| x.basename.replace("-","")});
// //bs-banks
// ~dirt.loadSoundFiles("/Users/bss/Documents/git/bsssssss/strudel-samples" +/+ "*" +/+ "*", namingFunction: { |x| x.basename.replace("_","")});
// ~dirt.loadSoundFiles("/Users/bss/Documents/samples/tidal-samples/undo" +/+ "*", namingFunction: { |x| x.basename.replace("_","")});
// )

(
var loadAndReplace = { |path, charToReplace, depth|
	var pattern = path;
	(depth-1).do { pattern = pattern +/+ "*" };
	pattern = pattern +/+ "*";
	~dirt.loadSoundFiles(pattern, namingFunction: { |x| x.basename.replace(charToReplace, "") });
};
// tidal-drum-machines :
loadAndReplace.("/Users/bss/Documents/git/samples/tidal-drum-machines/machines", "-", 2);

// bs-banks :
loadAndReplace.("/Users/bss/Documents/samples/tidal-samples/undo", "_", 1);
// loadAndReplace.("/Users/bss/Documents/samples/tidal-samples/bs/bs-drums", "_", 1);
// loadAndReplace.("/Users/bss/Documents/samples/tidal-samples/bs/bs-breaks", "_", 1);
loadAndReplace.("/Users/bss/Documents/samples/tidal-samples/bs", "_", 2);
)
