#charset "us-ascii"
#include <adv3.h>
#include <en_us.h>

/*
DefineIAction(RememberAll)
	execAction() {
		local m;

		if(!gActor.ofKind(AbsentActor)) {
			"No memories.";
			return;
		}
		m = gActor.absentActorMemory;
		if(!m) {
			"No memories.";
			return;
		}
		m.forEachAssoc(function(obj, mem) {
			"<<obj.name>>:  <<mem.location.roomName>>, <<toString(mem.getAge())>>\n ";
		});
	}
;

VerbRule(RememberAll)
	'remember' : RememberAllAction
	verbPhrase = 'remember/remembering'
;
*/

DefineTAction(Remember)
	objInScope(obj) {
		return((gActor.getAbsentActorMemory(obj) != nil)
			|| (obj.ofKind(Actor)));
	}
;

VerbRule(Remember)
	'remember' singleDobj : RememberAction
	verbPhrase = 'remember/remembering (what)'
;

modify Thing
	dobjFor(Remember) {
		verify() {
			if(!gActor.getAbsentActorMemory(self))
				absentActorRememberFailed();
		}
		action() { absentActorRemember(); }
	}
	absentActorRememberFailed() {
		if(ofKind(Actor)) {
			absentActorRememberFailedActor();
			return;
		}
		if(ofKind(Room)) {
			absentActorRememberFailedRoom();
			return;
		}
		absentActorRememberFailedDefault();
	}
	absentActorRememberFailedActor() {
		defaultReport(&absentActorNoMemory, self);
	}
	absentActorRememberFailedRoom() {
		defaultReport(&absentActorNoMemoryRoom, self);
	}
	absentActorRememberFailedDefault() {
		defaultReport(&absentActorNoMemoryObject, self);
	}
	absentActorRemember() {
		local m;

		m = gActor.getAbsentActorMemory(self);
		if(ofKind(Actor)) {
			absentActorRememberActor(m);
			return;
		}
		if(ofKind(Room)) {
			absentActorRememberRoom(m);
			return;
		}
		absentActorRememberDefault(m);
	}
	absentActorRememberActor(mem) {
		if(mem) {
			defaultReport(&absentActorMemory, self, mem);
		} else {
			reportFailure(&absentActorNoMemory, self);
		}
	}
	absentActorRememberRoom(mem) {
		if(mem) {
			defaultReport(&absentActorMemoryRoom, self, mem);
		} else {
			reportFailure(&absentActorNoMemoryRoom, self);
		}
	}
	absentActorRememberDefault(mem) {
		if(mem) {
			defaultReport(&absentActorMemoryObject, self, mem);
		} else {
			reportFailure(&absentActorNoMemoryObject, self);
		}
	}
;
