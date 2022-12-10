#charset "us-ascii"
#include <adv3.h>
#include <en_us.h>

// Precondition for the Remember action.
canRemember: PreCondition
	checkPreCondition(obj, allowImplicit) {
		// If an object isn't specified, assume it's the actor
		// taking the action.
		if(obj == nil)
			obj = gActor;

		// If we don't have an object, we can't figure out if
		// remembering makes sense or not, so we bail.
		if(gDobj == nil) exit;

		// If the actor doesn't know about the object being
		// remembered, we display the object's "you have no
		// memory of that" message (which will be specific to
		// the class of object, and possibly the object itself)
		// and we're done.
		if(!gActor.knowsAbout(gDobj)) {
			gDobj.absentActorRememberFailed();
			exit;
		}
	}
;

DefineTAction(Remember)
	// Everything is, in principle, capable of being remembered,
	// regardless of normal scope rules.
	objInScope(obj) { return(true); }
;
VerbRule(Remember)
	'remember' singleDobj : RememberAction
	verbPhrase = 'remember/remembering (what)'
;

modify Thing
	dobjFor(Remember) {
		verify() {
			// First we check to see if the object we're trying
			// to remember is present.  If so, we don't need to
			// remember it, it's there.
			if(gActor.canSee(self))
				illogicalNow(&absentActorCanSee);

			// Now we mark objects we don't know about as dangerous.
			// This means they won't end up in resolved objects
			// lists unless they're explicitly named.  This will
			// prevent unseen/unknown objects showing up in
			// disambiguation prompts.
			if(!gActor.knowsAbout(self))
				dangerous;
		}

		// For action() we just punt to the memory logic.
		action() { absentActorRemember(); }
	}

	// No memory of the requested object.
	absentActorRememberFailed() {
		inaccessible(&absentActorNoMemoryObject, self);
	}

	// Successfully remembering the object.
	absentActorRemember() {
		local m;

		m = gActor.getAbsentActorMemory(self);
		if(m != null)
			defaultReport(&absentActorMemoryObject, self, m);
		else
			reportFailure(&absentActorNoMemoryObject, self);
	}

	// We're trying to remember something we can see.
	absentActorRememberVisible() {
		defaultReport(&absentActorCanSee);
	}
;

modify Actor
	absentActorRememberFailed() {
		inaccessible(&absentActorNoMemoryActor, self);
	}
	absentActorRemember() {
		local m;

		m = gActor.getAbsentActorMemory(self);
		if(m != nil)
			defaultReport(&absentActorMemoryActor, self, m);
		else
			reportFailure(&absentActorNoMemoryActor, self);
	}
;

modify Room
	absentActorRememberFailed() {
		inaccessible(&absentActorNoMemoryRoom, self);
	}
	absentActorRemember() {
		local m;

		m = gActor.getAbsentActorMemory(self);
		if(m != nil)
			defaultReport(&absentActorMemoryRoom, self, m);
		else
			reportFailure(&absentActorNoMemoryRoom, self);
	}
;
