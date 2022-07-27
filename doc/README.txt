
absentActor
Version 1.0
Copyright 2022 jbg, distributed under the MIT License



ABOUT THIS LIBRARY

The absentActor library implements a few features related to actor memory:
remembering what they've seen and when and where they saw it.

The basic usage is just adding the AbsentActor class as a mixin when declaring
an actor, for example:

	me:	Person, AbsentActor;

When applied to the player, by itself it will change the behavior of the
objVisible precondition, resulting in:

	>X ALICE
	You see no alice here.

...becoming...

	>X ALICE
	You don't know anyone named Alice.

...assuming there's an NPC named "Alice" elsewhere in the game that the player
hasn't seen, and something like...

	>X ALICE
	She isn't here.  The last place you remember seeing her is
	Alice's Room, 2 turns ago.

...if the player has seen her.


GETTING AND SETTING MEMORIES

The AbsentActor class defines a getter and setter for memories, both of which
take a single argument:  the actor object to remember.  Assuming the me
object has been defined to include the AbsentActor class:

	// Remember the passed actor object
	// NOTE:  Defining AbsentActor on an Actor will automagically take
	// care of remembering "normal" sighting, so calling
	// setAbsentActorMemory() is only necessary when a memory is
	// needed/wanted in other circumstances (for example if you want
	// characters to "remember" seeing each other when the game starts).
	me.setAbsentActorMemory(actor);

	// Get me's current memory of the passed actor
	mem = me.getAbsentActorMemory(actor);

The memories are instances of the AbsentActorMemory class.  Each memory
consists of the location the actor was in when the memory was formed, and
the turn number when the memory was recorded.  These can be accessed via
the location and turn properties, and there's a getAge() method that
returns the number of turns since the memory was recorded.

	// Get me's current memory of the passed actor
	mem = me.getAbsentActorMemory(actor);

	// Report the memory location
	"The memory's location is <<mem.location.roomName>>. ";

	// Report the turn the memory was recorded on
	"The memory is from turn <<toString(mem.turn)>>. ";

	// Report the memory's age
	i = mem.getAge();
	"The memory is <<toString(i)>> turn<<if (i != 1)>>s<<end>> old. ";




LIBRARY CONTENTS

The files in the library are:

	absentActor.t
		The source for the library itself.

	absentActor.tl
		The library file for the library.

	LICENSE.txt
		This file contains a copy of the MIT License, which is
		the license this library is distributed under.

	demo/makefile.t3m
		Makefile for the sample "game".

	demo/sample.t
		A sample "game" that illustrates the library's functions.

	doc/README.txt
		This file
