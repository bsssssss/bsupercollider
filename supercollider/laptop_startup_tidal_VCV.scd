    // server options are only updated on reboot
	// configure the sound server: here you could add hardware specific options
	// see http://doc.sccode.org/Classes/ServerOptions.html
	s.options.numBuffers = 1024 * 256; // increase this if you need to load more samples
	s.options.memSize = 8192 * 32; // increase this if you get "alloc failed" messages
	s.options.numWireBufs = 64; // increase this if you get "exceeded number of interconnect buffers" messages
	s.options.maxNodes = 1024*32; // increase this if you are getting drop outs and the message "too many nodes"
	s.options.numOutputBusChannels = 16; // set this to your hardware output channel size, if necessary
	s.options.numInputBusChannels = 2; // set this to your hardware output channel size, if necessary
    s.options.maxLogins = 8; // optional, required to enable feedforward VU meter
	"SC_JACK_DEFAULT_OUTPUTS".setenv(
		"VCV Rack:inport 0,VCV Rack:inport 1,VCV Rack:inport 2,VCV Rack:inport 3,VCV Rack:inport 4,VCV Rack:inport 5,VCV Rack:inport 6,VCV Rack:inport 7,VCV Rack:inport 8,VCV Rack:inport 9,VCV Rack:inport 10,VCV Rack:inport 11,VCV Rack:inport 12,VCV Rack:inport 13,VCV Rack:inport 14,VCV Rack:inport 15,"
		);

	// boot the server and start SuperDirt
	s.waitForBoot {
		~dirt = SuperDirt(2, s); // two output channels, increase if you want to pan across more channels
		// ~looper = TidalLooper(~dirt);
		// load("/home/bss/.local/share/SuperCollider/synthdefs/mi-ugens.scd");
		// load("/home/bss/.local/share/SuperCollider/synthdefs/bs_synths.scd");
		// load("/home/bss/.local/share/SuperCollider/synthdefs/bs_fx.scd");
		// load("/home/bss/.local/share/SuperCollider/synthdefs/bs_grns.scd");
		// load("/home/max/git/bsupercollider/supercollider/externals/mi-ugens.scd");
		// load("/home/max/git/bsupercollider/supercollider/bs/synths/config.scd");
		// load("/home/max/git/bsupercollider/supercollider/bs/fx/bs_fx.scd");
		// ~dirt.doNotReadYet = true; //lazy sample loading
        load(PathName.new(thisProcess.nowExecutingPath).parentPath ++ "/bs/synths/config.scd");
		load(PathName.new(thisProcess.nowExecutingPath).parentPath ++ "/bs/fx/config.scd");
		load(PathName.new(thisProcess.nowExecutingPath).parentPath ++ "/bs/grains/bs_grns.scd");
		load(PathName.new(thisProcess.nowExecutingPath).parentPath ++ "/bs/cv/config.scd");
		load(PathName.new(thisProcess.nowExecutingPath).parentPath ++ "/externals/mi-ugens.scd");
		// load(PathName.new(thisProcess.nowExecutingPath).parentPath ++ "/bs/fx/modules/tidalVerb.scd");
		~dirt.doNotReadYet = false;
		// ~dirt.loadSoundFiles;   // load samples (path containing a wildcard can be passed in)
		// ~dirt.loadSoundFiles("/media/max/T7 Shield/sons/cloud-samples/tidal-samples/autodafe/*");
		~dirt.loadSoundFiles("/media/max/T7 Shield/sons/cloud-samples/tidal-samples/breaks/*");
		// ~dirt.loadSoundFiles("/media/max/T7 Shield/sons/cloud-samples/tidal-samples/fieldrec/*");
		~dirt.loadSoundFiles("/media/max/T7 Shield/sons/cloud-samples/tidal-samples/gemscut/*");
		// ~dirt.loadSoundFiles("/media/max/T7 Shield/sons/cloud-samples/tidal-samples/goldbaby/*");
		~dirt.loadSoundFiles("/media/max/T7 Shield/sons/cloud-samples/tidal-samples/jungle/*");
		~dirt.loadSoundFiles("/media/max/T7 Shield/sons/cloud-samples/tidal-samples/trs/*");
		~dirt.loadSoundFiles("/media/max/T7 Shield/sons/cloud-samples/tidal-samples/legowelt/*");
		~dirt.loadSoundFiles("/media/max/T7 Shield/sons/cloud-samples/tidal-samples/pers/*");
		~dirt.loadSoundFiles("/media/max/T7 Shield/sons/cloud-samples/tidal-samples/rvbreaks/*");
		// ~dirt.loadSoundFiles("~/git/kindohm/expedition/samples/*");
		// ~dirt.loadSoundFiles("/media/max/T7 Shield/sons/samples/internat/*");
		// ~dirt.loadSoundFiles("~/Music/vsco/*");
		// ~dirt.loadSoundFiles("~/Music/breakcore is not a good way to get laid/*");
		// for example: ~dirt.loadSoundFiles("/Users/myUserName/Dirt/samples/*");

		// s.sync; // optionally: wait for samples to be read
		// ~dirt.start(57120, 0 ! 12);   // start listening on port 57120, create two busses each sending audio to channel 0
		
		// listen osc messages from all addr
		~dirt.start(57120, [0, 2, 4, 6, 8, 10, 12, 14], NetAddr("0.0.0.0"));   // start listening on port 57120, create two busses each sending audio to channel 0

        // optional, enable feedforward vu meter
        ~dirt.startSendRMS;

		// ~tidalcv = TidalCV(~dirt, -1, 9, 0.05, 0.025);

		// optional, needed for convenient access from sclang:
		(
			~d1  = ~dirt.orbits[0]; ~d2  = ~dirt.orbits[1];  ~d3  = ~dirt.orbits[2];
			~d4  = ~dirt.orbits[3]; ~d5  = ~dirt.orbits[4];  ~d6  = ~dirt.orbits[5];
			~d7  = ~dirt.orbits[6]; ~d8  = ~dirt.orbits[7];  ~d9  = ~dirt.orbits[8];
			~d10 = ~dirt.orbits[9]; ~d11 = ~dirt.orbits[10]; ~d12 = ~dirt.orbits[11];
		);

		MIDIClient.init;
		~midiOut = MIDIOut.newByName("Midi Through", "Midi Through Port-0"); // substitute your own device here

		~dirt.soundLibrary.addMIDI(\midi, ~midiOut);
		        // define global effects for mutable instruments effects
        ~dirt.orbits.do { |x|
            // var clouds = GlobalDirtEffect(\global_mi_clouds, [\cloudspitch, \cloudspos, \cloudssize, \cloudsdens, \cloudstex, \cloudswet, \cloudsgain, \cloudsspread, \cloudsrvb, \cloudsfb, \cloudsfreeze, \cloudsmode, \cloudslofi]);
            var verb = GlobalDirtEffect(\global_mi_verb, [\verbwet, \verbtime, \verbdamp, \verbhp, \verbfreeze, \verbdiff, \verbgain]);
			var jpverb = GlobalDirtEffect(\global_jpverb, [\jverbTime, \jverbDamp, \jverbSize, \jverbEarly, \jverbModDepth, \jverbModFreq, \jverbLow, \jverbMid, \jverbHigh, \jverbLo, \jverbHi, \jverbGain]);
            x.globalEffects = x.globalEffects
            //   .addFirst(clouds)
              .addFirst(verb)
			  .addFirst(jpverb); 
            x.initNodeTree;    
        };                     
        // end define global effects for mutable instruments effects
	};

	s.latency = 0.2; // increase this if you get "late" messages
	~midiOut.latency = 0.01;