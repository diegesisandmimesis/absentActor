#charset "us-ascii"
#include <adv3.h>
#include <en_us.h>

// Action messages for memories.  Called by the objVisible precondition
// above.
modify playerActionMessages
	// Trying to do something to an actor who we don't know yet and
	// who isn't here
	absentActorNoMemory(obj) {
		gMessageParams(obj);
		return('{You/he} {do}n\'t know anyone named {you/him obj}.');
	}

	// Same as above, only for an object.
	absentActorNoMemoryObject(obj) {
		gMessageParams(obj);
		return('{You/he} {do}n\'t know remember {you/him obj}.');
	}

	// Trying to do something to an actor we know but who isn't here.
	absentActorMemory(obj, mem) {
		local i;
		gMessageParams(obj);
		i = mem.getAge();
		return('{That/he obj} {is}n\'t here.  The last place {you/he}
			remember seeing {it/him obj} is
			<<mem.location.roomName>>, <<toString(i)>>
			turn<<if (i != 1)>>s<<end>> ago. ');
	}
	absentActorMemoryObject(obj, mem) {
		gMessageParams(obj);
		return('{That/he dobj} {is dobj}n\'t here.  The last place
			{you/he} remember seeing {it/him dobj} is
			<<mem.locationName()>>, <<mem.ageEstimate()>>. ');
	}
;


