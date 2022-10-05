#charset "us-ascii"
#include <adv3.h>
#include <en_us.h>

absentActorRoomPreinit: PreinitObject
	execute() {
		local obj;

		obj = firstObj(Room);
		while(obj) {
			obj.initializeVocabWith(obj.name + '/room');
			obj = nextObj(obj, Room);
		}
	}
;
