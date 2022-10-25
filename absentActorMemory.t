#charset "us-ascii"
#include <adv3.h>
#include <en_us.h>

// An object class to hold all the things we want to remember.
class AbsentActorMemory: object
	location = nil			// location remembered object was in
	turn = nil			// turn remembered object was last seen

	ages = static [
		3 -> 'recently',
		10 -> 'fairly recently',
		20 -> 'a while ago',
		40 -> 'a long time ago',
		80 -> 'a very long time ago'
	]
	ageOldest = 'a very, very long time ago'

	// Get the number of turns since this memory was set.  
	// KLUDGE ALERT:  If the turn isn't set for this memory, we use
	// zero.  The assumption here is that that's a corner case (the
	// turn gets set by default) and we rather have a bogus return
	// value than an error.
	getAge() {
		return(libGlobal.totalTurns - (self.turn ? self.turn : 0));
		
	}

	// The age as a string of the form '1 turn'/'n turns'.
	ageInTurns() {
		local i;

		i = getAge();
		
		return('<<toString(i)>> turn<<if(i != 1)>>s<<end>>');
	}

	ageEstimate() {
		local i, r;

		i = getAge();
		r = nil;
		ages.forEachAssoc(function(k, v) {
			if(r) return;
			if(i <= k)
				r = v;
		});
		if(!r) r = ageOldest;

		return(r);
	}

	locationName() {
		if(!location) return('nowhere');
		return(location.roomName);
	}

	update(loc?, tn?) {
		location = loc;
		turn = (tn ? tn : libGlobal.totalTurns);
	}

	// Arguments to the constructor are the location the remembered
	// object was in, and the turn number it was seen on.
	construct(loc?, tn?) {
		location = loc;
		// If an explicit turn number isn't passed as an arg, use
		// the current turn.
		turn = (tn ? tn : libGlobal.totalTurns);
	}
;
