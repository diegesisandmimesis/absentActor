#charset "us-ascii"
//
// absentActor.t
//
//	A simple library that allows actors to automagically remember
//	when and where they saw other actors.
//
//	Changes the default behavior of actions on a non-visible actor from:
//
//		>X ALICE
//		You see no alice here.
//
//	...to...
//
//		>X ALICE
//		You don't know anyone named Alice.
//
//	...or...
//
//		>X ALICE
//		She isn't here.  The last place you remember seeing her is
//		Alice's Room, 2 turns ago.
//
#include <adv3.h>
#include <en_us.h>

// Module ID for the library
absentActorModuleID: ModuleID {
	name = 'absentActor Library'
	byline = 'jbg'
	version = '1.0'
	listingOrder = 99
}


// Modifications to the base Actor class.
// We modify Actor because we need to touch noteSeenBy(), which is called
// by the thing being seen, not the thing doing the seeing.
modify Actor
	// Called when this actor (self) is seen by the actor passed as the
	// first arg.  Part of basic adv3 behavior we're glomming onto.
	noteSeenBy(actor, prop) {
		inherited(actor, prop);
		// Tell "seeing" actor that they've seen us, the "seen" actor
		actor.setAbsentActorMemory(self);
	}

	// Define stub memory methods on all actors.  We do this because
	// we decide whether or not to remember based on if the "seeing"
	// actor is an AbsentActor instance.  But the call is made from
	// within the "seen" actor's noteSeenBy().  To avoid a bunch of
	// conditionals here, we just add a stub method so we can just
	// always call setAbsentActorMemory() regardless.
	getAbsentActorMemory(actor) { return(nil); }
	setAbsentActorMemory(actor) { return(nil); }
;

/*
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
*/

// Class for Actors that remember things.
// Actors who need to remember the times and locations should include this
// class in their definition.
class AbsentActor: Actor
	// absentActorMemory will be the LookupTable that holds our memories.
	absentActorMemory = nil

	// Called by actors when acting, on all the stuff in their location.
	// We add Actors to avoid the "You see no alice here." situation.
	getExtraScopeItems(actor) {
		local l;

		l = inherited(actor);
		if(actor != self)
			return(l);

		l = _getExtraScopeItemsActors(l);

		return(l);
	}
	_getExtraScopeItemsActors(lst) {
		forEachInstance(Actor, function(o) {
			if(knowsAbout(o) || hasSeen(o) || o.isProperName)
				lst += o;
		});
		return(lst);
	}

	// Return the memory of the passed obj, if we have one.
	getAbsentActorMemory(obj) {
		if(absentActorMemory == nil) return(nil);
		return(absentActorMemory[obj]);
	}
	// Remember the passed thing.
	setAbsentActorMemory(obj) {
		// Create the LookupTable for our memories if it doesn't
		// already exist.
		if(absentActorMemory == nil)
			absentActorMemory = new LookupTable();

		// If a memory for this obj already exists, update it
		if(absentActorMemory[obj]) {
			absentActorMemory[obj].update(obj.location);
			return;
		}

		// Create a new memory
		absentActorMemory[obj] =
			new AbsentActorMemory(obj.location);
	}

	// Called every turn, remember the stuff around us.
	afterAction() {
		absentActorRememberLocation();
		inherited();
	}

	// Remember all the AbsentActorMemorable things in our current location
	absentActorRememberLocation() {
		local infoTab;

		if(!location || !canSee(location))
			return;

		// Remember the location itself.
		setAbsentActorMemory(location);

		// Now remember all visible, memorable stuff.
		infoTab = visibleInfoTableFromPov(self);
		infoTab.forEachAssoc(function(obj, info) {
			if(obj.suppressAutoSeen)
				return;
			if(!obj.ofKind(AbsentActorMemorable)
				&& !obj.ofKind(Room))
				return;
			setAbsentActorMemory(obj);
		});
	}
;

// Twiddle the objVisible precondition to fail with memory-specific
// inaccessible() messages instead of the default.
modify objVisible
	verifyPreCondition(obj) {
		local mem;

		if(obj != nil && !gActor.canSee(obj)) {
			mem = gActor.getAbsentActorMemory(obj);
			if(mem)
				inaccessible(&absentActorMemory, obj, mem);
			if(obj.ofKind(Person))
				inaccessible(&absentActorNoMemory, obj);
		}
		inherited(obj);
	}
	
;
