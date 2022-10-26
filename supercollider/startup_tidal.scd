    // server options are only updated on reboot
	// configure the sound server: here you could add hardware specific options
	// see http://doc.sccode.org/Classes/ServerOptions.html
	s.options.numBuffers = 1024 * 256; // increase this if you need to load more samples
	s.options.memSize = 8192 * 32; // increase this if you get "alloc failed" messages
	s.options.numWireBufs = 64; // increase this if you get "exceeded number of interconnect buffers" messages
	s.options.maxNodes = 1024*32; // increase this if you are getting drop outs and the message "too many nodes"
	s.options.numOutputBusChannels = 2; // set this to your hardware output channel size, if necessary
	s.options.numInputBusChannels = 2; // set this to your hardware output channel size, if necessary
    s.options.maxLogins = 8; // optional, required to enable feedforward VU meter
	"SC_JACK_DEFAULT_OUTPUTS".setenv("system:playback_7,system:playback_8");

	// boot the server and start SuperDirt
	s.waitForBoot {
		~dirt = SuperDirt(2, s); // two output channels, increase if you want to pan across more channels
		// ~looper = TidalLooper(~dirt);
		// load("/home/bss/.local/share/SuperCollider/synthdefs/mi-ugens.scd");
		// load("/home/bss/.local/share/SuperCollider/synthdefs/bs_synths.scd");
		// load("/home/bss/.local/share/SuperCollider/synthdefs/bs_fx.scd");
		// load("/home/bss/.local/share/SuperCollider/synthdefs/bs_grns.scd");
        load(PathName.new(thisProcess.nowExecutingPath).parentPath ++ "/bs/synths/config.scd");
		load(PathName.new(thisProcess.nowExecutingPath).parentPath ++ "/externals/mi-ugens.scd");
		load(PathName.new(thisProcess.nowExecutingPath).parentPath ++ "/bs/fx/bs_fx.scd");
		load(PathName.new(thisProcess.nowExecutingPath).parentPath ++ "/bs/grains/bs_grns.scd");
		~dirt.doNotReadYet = true; //lazy sample loading
		~dirt.loadSoundFiles;   // load samples (path containing a wildcard can be passed in)
		~dirt.loadSoundFiles("~/MEGA/tidal-samples/autodafe/*");
		~dirt.loadSoundFiles("~/MEGA/tidal-samples/breaks/*");
		~dirt.loadSoundFiles("~/MEGA/tidal-samples/fieldrec/*");
		~dirt.loadSoundFiles("~/MEGA/tidal-samples/gemscut/*");
		~dirt.loadSoundFiles("~/MEGA/tidal-samples/goldbaby/*");
		~dirt.loadSoundFiles("~/MEGA/tidal-samples/jungle/*");
		~dirt.loadSoundFiles("~/MEGA/tidal-samples/legowelt/*");
		~dirt.loadSoundFiles("~/MEGA/tidal-samples/pers/*");
		~dirt.loadSoundFiles("~/MEGA/tidal-samples/trs/*");
		// for example: ~dirt.loadSoundFiles("/Users/myUserName/Dirt/samples/*");

		// s.sync; // optionally: wait for samples to be read
		// ~dirt.start(57120, 0 ! 12);   // start listening on port 57120, create two busses each sending audio to channel 0
		
		// listen osc messages from all addr
		~dirt.start(57120, 0 ! 12, NetAddr("0.0.0.0"));   // start listening on port 57120, create two busses each sending audio to channel 0

        // optional, enable feedforward vu meter
        ~dirt.startSendRMS;


		// optional, needed for convenient access from sclang:
		(
			~d1  = ~dirt.orbits[0]; ~d2  = ~dirt.orbits[1];  ~d3  = ~dirt.orbits[2];
			~d4  = ~dirt.orbits[3]; ~d5  = ~dirt.orbits[4];  ~d6  = ~dirt.orbits[5];
			~d7  = ~dirt.orbits[6]; ~d8  = ~dirt.orbits[7];  ~d9  = ~dirt.orbits[8];
			~d10 = ~dirt.orbits[9]; ~d11 = ~dirt.orbits[10]; ~d12 = ~dirt.orbits[11];
		);

		        // define global effects for mutable instruments effects
     /*   ~dirt.orbits.do { |x|
            var clouds = GlobalDirtEffect(\global_mi_clouds, [\cloudspitch, \cloudspos, \cloudssize, \cloudsdens, \cloudstex, \cloudswet, \cloudsgain, \cloudsspread, \cloudsrvb, \cloudsfb, \cloudsfreeze, \cloudsmode, \cloudslofi]);
			// var verb = GlobalDirtEffect(\global_mi_verb, [\verbwet, \verbtime, \verbdamp, \verbhp, \verbfreeze, \verbdiff, \verbgain]);
            x.globalEffects = x.globalEffects
			.addFirst(clouds);
			// .addFirst(verb);
            x.initNodeTree;
        };*/
        // end define global effects for mutable instruments effects


	};

	s.latency = 0.05; // increase this if you get "late" messages