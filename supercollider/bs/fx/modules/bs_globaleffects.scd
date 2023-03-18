(

~dirt.orbits.do { |x|
            // var clouds = GlobalDirtEffect(\global_mi_clouds, [\cloudspitch, \cloudspos, \cloudssize, \cloudsdens, \cloudstex, \cloudswet, \cloudsgain, \cloudsspread, \cloudsrvb, \cloudsfb, \cloudsfreeze, \cloudsmode, \cloudslofi]);
	var mi_verb = GlobalDirtEffect(\global_mi_verb, [
		\verbwet, \verbtime, \verbdamp, \verbhp, \verbfreeze, \verbdiff, \verbgain
	]);

	var jpverb = GlobalDirtEffect(\global_jpverb, [
		\jverbTime, \jverbDamp, \jverbSize, \jverbEarly, \jverbModDepth, \jverbModFreq,
		\jverbLow, \jverbMid, \jverbHigh, \jverbLo, \jverbHi, \jverbGain
	]);

	var comp = GlobalDirtEffect(\global_comp, [
		\comp, \compThreshold, \compRatio, \compAttack, \compRelease, \compMakeup, \compPre, \compUp
	]);

	var sidechain = GlobalDirtEffect(\global_sidechain, [
		\sidechain, \sidechainFrom, \scThreshold, \scRatio, \scAttack, \scRelease, \scMakeup, \scPre, \scUp
	]);

	// var length = ~dirt.orbits[0].globalEffects.size;

	// ~dirt.orbits[0].globalEffects.size;

	x.globalEffects = x.globalEffects
	.insert(2,comp)
	.insert(3,mi_verb)
	.insert(4,jpverb)
	.insert(1,sidechain);
	// .addFirst(comp);
	// .addFirst(jpverb)
	// .addFirst(mi_verb);
	x.initNodeTree;
};

)
// s.freeAll;
