(
s.reboot { // server options are only updated on reboot
	// configure the sound server: here you could add hardware specific options
	// see http://doc.sccode.org/Classes/ServerOptions.html

  // scnvim
  if (\SCNvim.asClass.notNil) {
      Server.default.doWhenBooted {
          \SCNvim.asClass.updateStatusLine(1, \SCNvim.asClass.port);
      }
  };
	//s.options.outDevice_("local-device"); s.options.numOutputBusChannels = 2;
	//s.options.outDevice_("External Headphones"); s.options.numOutputBusChannels = 2;
  s.options.device_("BH+MBP");
	// s.options.inDevice_("AudioBox 1818 VSL"); s.options.numOutputBusChannels = 18;
  //s.options.outDevice_("BlackHole 64ch"); s.options.numOutputBusChannels = 16;
	//s.options.outDevice_("MacBook Pro Speakers"); s.options.numOutputBusChannels = 2;


	s.options.hardwareBufferSize   = 128;
	// s.options.numInputBusChannels  = 0;
	s.options.numBuffers           = 1024 * 256; // increase this if you need to load more samples
	s.options.memSize              = 8192 * 16; // increase this if you get "alloc failed" messages
	s.options.numWireBufs          = 2048; // increase this if you get "exceeded number of interconnect buffers" messages
	s.options.maxNodes             = 1024 * 32; // increase this if you are getting drop outs and the message "too many nodes"
	// boot the server and start SuperDirt
	s.waitForBoot {

		~dirt.stop; // stop any old ones, avoid duplicate dirt (if it is nil, this won't do anything)
		~dirt = SuperDirt(2, s); // two output channels, increase if you want to pan across more channels
		~looper = TidalLooper(~dirt);

		// ~dirt.loadSoundFiles;   // load samples (path containing a wildcard can be passed in)
		// for example: ~dirt.loadSoundFiles("/Users/myUserName/Dirt/samples/*");
    
		~dirt.doNotReadYet = true;
    ~drumMachinesDir = Quarks.all.detect({ |x| x.name == "tidal-drum-machines" }).localPath;
    ~dirt.loadSoundFiles(~drumMachinesDir +/+ "machines" +/+ "*" +/+ "*", namingFunction: { |x| x.basename.replace("-","")});
		//~dirt.loadSoundFiles("/Users/bss/Documents/samples/tidal-samples/autodafe/*");
		//~dirt.loadSoundFiles("/Users/bss/Documents/samples/tidal-samples/jbk/*");
		//~dirt.loadSoundFiles("/Users/bss/Documents/samples/tidal-samples/mars/*");
		//~dirt.loadSoundFiles("/Users/bss/Documents/samples/tidal-samples/legowelt/*");
		//~dirt.loadSoundFiles("/Users/bss/Documents/samples/tidal-samples/ukg/*");
		//~dirt.loadSoundFiles("/Users/bss/Documents/samples/zooms/bino/to_amb");
		//~dirt.loadSoundFiles("/Volumes/T7 Shield/sons/zoom/stereos");
		//~dirt.loadSoundFiles("/Volumes/T7 Shield/sons/zoom/stereos2");
		//~dirt.loadSoundFiles("/Volumes/T7 Shield/sons/zoom/stereos3");
		//~dirt.loadSoundFiles("/Volumes/T7 Shield/sons/zoom/stereos4");
		//~dirt.loadSoundFiles("/Volumes/T7 Shield/sons/zoom/stereos5");
		//~dirt.loadSoundFiles("/Volumes/T7 Shield/sons/egms");
		~dirt.loadSoundFiles("/Users/bss/Documents/samples/tidal-samples/jbk/*");
		~dirt.loadSoundFiles("/Users/bss/Documents/samples/tidal-samples/rvbreaks/*");
		~dirt.loadSoundFiles("/Volumes/T7 Shield/sons/samples/jungle/junglebreaks");
		~dirt.loadSoundFiles("/Volumes/T7 Shield/sons/samples/jungle/junglebreaks2");
		~dirt.loadSoundFiles("/Volumes/T7 Shield/sons/samples/jungle/junglebreaks3");
		~dirt.loadSoundFiles("/Volumes/T7 Shield/sons/samples/tidal-samples/legowelt/*");
		~dirt.loadSoundFiles("/Volumes/T7 Shield/sons/samples/tidal-samples/jbk/*");

		load(PathName.new(thisProcess.nowExecutingPath).parentPath ++ "/tidal-banks.scd");
		// s.sync; // optionally: wait for samples to be read

		// MIDI SETUPS :
		MIDIClient.init(verbose: false); /* <---- enable this !!! */

		load(PathName.new(thisProcess.nowExecutingPath).parentPath ++
			"/tidal-midi.scd");
		// load(PathName.new(thisProcess.nowExecutingPath).parentPath ++ "/tidal-midi-audiobox.scd");
		// load(PathName.new(thisProcess.nowExecutingPath).parentPath ++ "/tidal-midi-audiobox&m8u.scd");
		// load(PathName.new(thisProcess.nowExecutingPath).parentPath ++ "/tidal-midi-m8u.scd");

		// SYNTHS & FX

		load(PathName.new(thisProcess.nowExecutingPath).parentPath ++ "/bs/synths/config.scd");
		load(PathName.new(thisProcess.nowExecutingPath).parentPath ++ "/bs/fx/bs_fx.scd");
		load(PathName.new(thisProcess.nowExecutingPath).parentPath ++ "/dirt-modules-order.scd");
		load(PathName.new(thisProcess.nowExecutingPath).parentPath ++ "/dirt_compressor.scd");
		// load(PathName.new(thisProcess.nowExecutingPath).parentPath ++ "/scala.scd");

		//~dirt.start(57120, [0, 2, 4, 6, 8, 10, 12, 14]); // 8 stereos out
		~dirt.start(57120, 0 ! 12); // 12 stereos mixdown

		SuperDirt.default = ~dirt; // make this instance available in sclang (optional)

		// optional, needed for convenient access from sclang:
		(
			~d1 = ~dirt.orbits[0]; ~d2  = ~dirt.orbits[1]; ~d3  = ~dirt.orbits[2];  ~d4  = ~dirt.orbits[3];
			~d5 = ~dirt.orbits[4]; ~d6  = ~dirt.orbits[5]; ~d7  = ~dirt.orbits[6];  ~d8  = ~dirt.orbits[7];
			~d9 = ~dirt.orbits[8]; ~d10 = ~dirt.orbits[9]; ~d11 = ~dirt.orbits[10]; ~d12 = ~dirt.orbits[11];
		);
	};

	s.latency = 0.3; // increase this if you get "late" messages
};
);
