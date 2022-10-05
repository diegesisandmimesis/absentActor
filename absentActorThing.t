#charset "us-ascii"
#include <adv3.h>
#include <en_us.h>

class AbsentActorMemorable: Thing;

modify AbsentActor
	afterAction() {
		absentActorRememberLocation();
		inherited();
	}

	// Remember all the AbsentActorMemorable things in our current location
	absentActorRememberLocation() {
		local infoTab;

		if(!location || !canSee(location))
			return;

		setAbsentActorMemory(location);
		infoTab = visibleInfoTableFromPov(self);
		infoTab.forEachAssoc(function(obj, info) {
			if(obj.suppressAutoSeen)
				return;
			if(!obj.ofKind(AbsentActorMemorable))
				return;
			setAbsentActorMemory(obj);
		});
	}
;
