#charset "us-ascii"
//
// absentActorAction.t
//
#include <adv3.h>
#include <en_us.h>

// Modify Action to add a flag that determines whether we include remembered
// things in our "pseudo scope".
modify Action
	// Boolean indicating whether or not this action uses the pseudo
	// scope.
	_useAbsentActorScope = nil

	// Check to see if we want to add a remembered object to the scope.
	objInScope(obj) {
		local r;

		// If we're already in scope, we don't have anything to do.
		r = inherited(obj);
		if(r) return(r);

		return(objInAbsentActorScope(obj));
	}

	// We add the object to the scope if the action is configured to
	// use the "memory" pseudo scope and the object is in that pseudo
	// scope for this turn's action.
	objInAbsentActorScope(obj) {
		if(_useAbsentActorScope && obj.inAbsentActorScope())
			return(true);
		return(nil);
	}
;

// Modifying individual actions to use the pseudo scope.
modify ExamineAction _useAbsentActorScope = true;
