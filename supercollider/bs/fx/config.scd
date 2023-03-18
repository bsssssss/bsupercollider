// load("/home/max/git/bsupercollider/supercollider/bs/fx/modules/jpverb.scd");
// load("/home/max/git/bsupercollider/supercollider/bs/fx/modules/bs_fx.scd");

load(PathName.new(thisProcess.nowExecutingPath).parentPath ++ "/modules/jpverb.scd");
load(PathName.new(thisProcess.nowExecutingPath).parentPath ++ "/modules/bs_fx.scd");
load(PathName.new(thisProcess.nowExecutingPath).parentPath ++ "/modules/global_comp.scd");
