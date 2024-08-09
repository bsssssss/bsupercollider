(
~midi_internal1 = MIDIOut.newByName("IAC", "fromSupercollider");

~dirt.soundLibrary.addMIDI(\midi, ~midi_internal1);
~midi_internal1.latency = 0.025;

"".postln;
"Send midi to : ".postln;
"midi -> internal".postln;
"".postln;
)