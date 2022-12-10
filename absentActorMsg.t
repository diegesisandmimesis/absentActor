#charset "us-ascii"
#include <adv3.h>
#include <en_us.h>

// Action messages for memories.  Called by the objVisible precondition
// above.
modify playerActionMessages
	// Trying to remember something currently visible
	absentActorCanSee = '{You/he} {do}n\'t have to remember, {you/he}
		can see {it/him dobj}. '

	// Trying to do something to an actor who we don't know yet and
	// who isn't here
	absentActorNoMemoryActor(obj) {
		gMessageParams(obj);
		return('{You/he} {do}n\'t know anyone named {you/him obj}.');
	}

	// Same as above, only for an object.
	absentActorNoMemoryObject(obj) {
		gMessageParams(obj);
		if(gActor.hasSeen(obj)) {
			return('{You/he} remember{s} seeing {that/him dobj},
				but you don\'t remember more than that.');
		} else {
			return('{You/he} {do}n\'t have any memories of
				{that/him dobj}.');
		}
	}

	absentActorNoMemoryRoom(obj) {
		return('{You/he} don\'t remember ever having been there.');
	}

	// Trying to do something to an actor we know but who isn't here.
	absentActorHaveMemory(obj) {
		gMessageParams(obj);
		return('{That/he obj} {is}n\'t here. ');
	}
	absentActorHaveMemoryObject(obj) {
		return('{That/he dobj} {is dobj}n\'t here. ');
	}
	absentActorHaveMemoryRoom(obj) {
		return('That\'s somewhere else. ');
	}
	absentActorMemoryActor(obj, mem) {
		return('The last place {you/he} remember seeing {it/him dobj} is
			<<mem.locationName()>>, <<mem.ageEstimate()>>. ');
	}
	absentActorMemoryObject(obj, mem) {
		return('The last place {you/he} remember seeing {it/him dobj} is
			<<mem.locationName()>>, <<mem.ageEstimate()>>. ');
	}
	absentActorMemoryRoom(obj, mem) {
		return('{You/he} remember being there,
			<<mem.ageEstimate()>>. ');
	}
/*
	absentActorHaveMemory(obj) {
		local i;

		gMessageParams(obj);
		i = mem.getAge();
		return('{That/he obj} {is}n\'t here.  The last place {you/he}
			remember seeing {it/him obj} is
			<<mem.location.roomName>>, <<toString(i)>>
			turn<<if (i != 1)>>s<<end>> ago. ');
	}
	absentActorHaveMemoryObject(obj, mem) {
		return('{That/he dobj} {is dobj}n\'t here.  The last place
			{you/he} remember seeing {it/him dobj} is
			<<mem.locationName()>>, <<mem.ageEstimate()>>. ');
	}
	absentActorMemoryRoom(obj, mem) {
		return('{You/he} remember being there,
			<<mem.ageEstimate()>>. ');
	}
*/
;


