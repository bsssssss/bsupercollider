(
~midi_m8_1 = MIDIOut.newByName("ESI M8U eX", "Port 1");
~midi_m8_2 = MIDIOut.newByName("ESI M8U eX", "Port 2");
~midi_m8_3 = MIDIOut.newByName("ESI M8U eX", "Port 3");

~midi_audiobox  = MIDIOut.newByName("AudioBox 1818 VSL", "AudioBox 1818 VSL");

~midi_internal1 = MIDIOut.newByName("IAC", "fromSupercollider");
//
~dirt.soundLibrary.addMIDI(\brain,   ~midi_m8_1);
~dirt.soundLibrary.addMIDI(\coast,   ~midi_m8_2);
~dirt.soundLibrary.addMIDI(\volca,   ~midi_m8_3);
~dirt.soundLibrary.addMIDI(\midiOut, ~midi_audiobox);
~dirt.soundLibrary.addMIDI(\midi,    ~midi_internal1);

"Send midi to : ".postln;
"brain   -> m8 port 1".postln;
"coast   -> m8 port 2".postln;
"volca   -> m8 port 3".postln;
"midiOut -> audiobox".postln;
"midi    -> internal".postln;
"".postln;
)