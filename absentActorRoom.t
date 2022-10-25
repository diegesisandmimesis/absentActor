#charset "us-ascii"
#include <adv3.h>
#include <en_us.h>

// Preinit juggling to make sure all rooms have vocabulary associate with
// them.
// We do this because we often identify the location of objects in
// the output of REMEMBER, and we don't want to have situations where
// we tell the player that they remember seeing a pebble in Alice's Room
// and then plead ignorance when they tell us that they want
// to >REMEMBER PEBBLE IN ALICE'S ROOM or something similar.
absentActorRoomPreinit: PreinitObject
	execute() {
		local obj;

		obj = firstObj(Room);
		while(obj) {
			// We add vocabularity consisting of the room's
			// name, as well as "room".
			obj.initializeVocabWith(obj.roomName + '/room');
			obj.disambigName = obj.roomName;
			obj = nextObj(obj, Room);
		}
	}
;
