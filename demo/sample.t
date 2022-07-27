#charset "us-ascii"
//
// sample.t
// Version 1.0
// Copyright 2022 Diegesis & Mimesis
//
// This is a very simple demonstration "game" that illustrates the
// functionality of the absentActor library
//
// It can be compiled via the included makefile with
//
//	# t3make -f makefile.t3m
//
// ...or the equivalent, depending on what TADS development environment
// you're using.
//
// This "game" is distributed under the MIT License, see LICENSE.txt
// for details.
//
#include <adv3.h>
#include <en_us.h>

versionInfo:    GameID
        name = 'absentActor Library Demo Game'
        byline = 'Diegesis & Mimesis'
        desc = 'Demo game for the absentActor library. '
        version = '1.0'
        IFID = '12345'
	showAbout() {
		"This is a simple test game that demonstrates the features
		of the absentActor library.
		<.p>
		Alice lives in the room to the north, Bob lives to the
		south, and we start in the middle.  To test the library's
		behavior you can >X ALICE from the starting position,
		then >N, >S, >X ALICE and compare the difference.
		<.p>
		Consult the README.txt document distributed with the library
		source for a quick summary of how to use the library in your
		own games.
		<.p>
		The library source is also extensively commented in a way
		intended to make it as readable as possible. ";
	}
;

// Our game world is three rooms, two NPCs, and the player.
startRoom:      Room 'Void'
        "This is a featureless void.  Alice's room is to the north, and
		Bob's room lies to the south. "
	north = alicesRoom
	south = bobsRoom
;
alicesRoom:	Room 'Alice\'s Room'
	"This is Alice's room.  It is not a restaurant. "
	south = startRoom
;
+ alice: Person 'alice' 'Alice'
	"She looks like the first person you'd turn to in a problem. "
	isHer = true
	isProperName = true
;
bobsRoom:	Room 'Bob\'s Room'
	"This is Bob's room. "
	north = startRoom
;
+ bob: Person 'bob' 'Bob'
	"He looks like a Robert, only shorter. "
	isProperName = true
	isHim = true
;

me:     Person, AbsentActor
        location = startRoom
;

gameMain:       GameMainDef
        initialPlayerChar = me
;
