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
	objInScope(obj) { return(gActor.getAbsentActorMemory(obj) != nil); }
	//objInScope(obj) { return(true); }
;

VerbRule(Remember)
	'remember' singleDobj : RememberAction
	verbPhrase = 'remember/remembering (what)'
;

modify Thing
	dobjFor(Remember) {
		action() {
			local m;

			m = gActor.getAbsentActorMemory(self);
			if(!m) {
				defaultReport(&absentActorNoMemoryObject, self);
				return;
			}
			defaultReport(&absentActorMemoryObject, self, m);
		}
	}
;
