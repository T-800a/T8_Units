/*
 =======================================================================================================================
 
	Script: fn_loiter.sqf
	Author(s): T-800a
	Inspired and partly based on code by Binesi's BIN_taskDefend/Patrole

	Description:
	Group will sit and stand around a position in groups (by two man). They'll sit near Camping Tents and Fireplaces or stand 
	around near those. Units will try to face each other ... to give 'em the look as if they were talking to each other.

	If Campfire and Tent are present units will group according to table:

	Units		Loiterthingi
	1,2			Sit near a Tent or other "Camping_base_F" obj.
	3,4			Stand around, hopefully faceing each other
	5,6,7 		Sit near a fire, hopefully
	8,9			Stand around, hopefully faceing each other
	10,11,12	Stand around, hopefully faceing each other
	rest		standing on spawn pos doing a SAD


	Parameter(s):
	_this select 0: group (Group)
	_this select 1: position (Array)
	_this select 2: range (Number) [ optional ]

	Breakout Conditions:
	- all units have left the group 
	- group leades behaviour changes to "COMBAT"

	Example(s):
	tmp = [ group this, ( getPos this ) ] execVM "fn_loiter.sqf";
	tmp = [ group this, ( getPos this ), 100 ] execVM "fn_loiter.sqf";

	///
	
	acts_StandingSpeakingUnarmed
	Acts_listeningToRadio_Loop
	LHD_krajPaluby
	HubBriefing_loop
	InBaseMoves_HandsBehindBack2
	
	aidlpsitmstpsnonwnondnon_ground00	// sit
	AidlPknlMstpSnonWnonDnon_AI		 	// kneel
	
 =======================================================================================================================
*/

#include <..\MACRO.hpp>

private [ "_group", "_marker", "_pos", "_areaSizeX", "_areaSizeY", "_pos", "_range", "_units", "_unitLeader", "_unitsCount" , "_seats", "_seat", "_n", "_movePos", "_newGroup", "_wp1", "_wp2", "_behaviour" ];

_group		= param [ 0, grpNull, [grpNull]];
_marker		= param [ 1, "NO-MARKER-SET", ["",[]]]; 

if ((( typeName _marker ) isEqualTo "ARRAY" ) AND {( count _marker ) isEqualTo 0 }) exitWith { false };
if (( typeName _marker ) isEqualTo "ARRAY" ) then { _marker = _marker call BIS_fnc_selectRandom; };
if ( isNull _group OR { str ( getMarkerPos _marker ) == str ([0,0,0]) } ) exitWith { if ( T8U_var_DEBUG ) then { [ ">> %1 >>>>>>>>>> fn_loiter.sqf >> Missing Parameters", time ] call BIS_fnc_error; }; false };
if ( T8U_var_DEBUG ) then { [ ">> %1 >>>>>>>>>> fn_loiter.sqf >> EXEC >> %2 >> %3", time, _marker ] call BIS_fnc_error; };

_pos = getMarkerPos _marker;
_areaSizeX	= ( getMarkerSize _marker ) select 0;
_areaSizeY	= ( getMarkerSize _marker ) select 1;
_range = ( _areaSizeX + _areaSizeY ) / 2;
if ( _range < 30 ) then { _range = 30; };

_unitLeader = leader _group;
_unitsAll = units _group;
_units = units _group - [ _unitLeader ];
_unitsCount = count _units;
_seat = _units call BIS_fnc_selectRandom;
_dir = 0;

_group setBehaviour "AWARE";

_wp0 = _group addWaypoint [ _pos, 1 ];
_wp0 setWaypointType "MOVE";
_wp0 setWaypointBehaviour "SAFE";	
_wp0 setWaypointSpeed "FULL";
_wp0 setWaypointCompletionRadius 50;
_wp0 setWaypointTimeout [ 0, 0, 0 ];
_wp0 setWaypointStatements ["true", "[ this ] spawn T8U_fnc_GetOutVehicle;"];

// End back near start point and then pick a new random point
_wp1 = _group addWaypoint [ _pos, 2 ];
_wp1 setWaypointType "SAD";
_wp1 setWaypointBehaviour "SAFE";	
_wp1 setWaypointSpeed "LIMITED";
_wp1 setWaypointCompletionRadius (random (_range));
_wp setWaypointTimeout [ 10, 20, 30 ];
_wp1 setWaypointStatements ["true", "[ this ] spawn T8U_fnc_GetOutVehicle;"];

// Cycle
_wp2 = _group addWaypoint [ _pos, 3 ];
_wp2 setWaypointType "CYCLE";
_wp2 setWaypointBehaviour "SAFE";
_wp2 setWaypointSpeed "LIMITED";
_wp2 setWaypointCompletionRadius 200;
_wp2 setWaypointStatements ["true", "[ this ] spawn T8U_fnc_GetOutVehicle;"];

if ( T8U_var_DEBUG ) then { [ ">> %1 >>>>>>>>>> fn_loiter.sqf >> wait until unit is in Range of LoiterPos >> %2", time, _group ] call BIS_fnc_error; };
waitUntil { sleep 2; _unitLeader distance _pos < ( _range ) };
if ( T8U_var_DEBUG ) then {[ ">> %1 >>>>>>>>>> fn_loiter.sqf >> Unit is in Range of LoiterPos!! >> %2", time, _group ] call BIS_fnc_error; };

sleep 5;

// 3 units will sit near camping_base_f objects
_seats = nearestObjects [ _pos, [ "Camping_base_F" ], _range ];
if ( count _seats > 0 ) then {
	_seat = _seats call BIS_fnc_selectRandom;
	if ( T8U_var_DEBUG ) then { [ ">> %1 >>>>>>>>>> fn_loiter.sqf >> SEATS >> %2", time, _seats ] call BIS_fnc_error; };

	_n = 1;
	{
		_seatPos = getPos _seat findEmptyPosition [ 1, 5, "Man" ];
		_x doMove _seatPos; 
		_x spawn 
		{
			private [ "_x", "_dir", "_nearMen", "_nearMan" ];
			_x = _this;
			sleep 10;
			// doStop _x;
			[ _x, "SIT_LOW", "ASIS" ] call BIS_fnc_ambientAnim;			
			sleep 30;
			_nearMen = nearestObjects [ _x, ["Man"], 20 ];
			_nearMen = _nearMen - [ _x ];
			if ( count _nearMen > 0 ) then 
			{
				_dir = [ _x, _nearMen select 0 ] call BIS_fnc_relativeDirTo;
				_x setDir _dir;		
			};
		};
		_units = _units - [ _x ];
		if ( T8U_var_DEBUG ) then { [ ">> %1 >>>>>>>>>> fn_loiter.sqf >> %2 attached to %3", time, _x, _seat ] call BIS_fnc_error; };
		sleep 3;
		if ( count _units < 1 OR _n > 2 ) exitWith {};
		_n = _n + 1;
	} forEach _units;
};

// 2 Units will stand around "randomly"
_chatterPos = [ _pos , _range * 0.25 , random 120 ] call BIS_fnc_relPos;
_chatterPosEP = _chatterPos findEmptyPosition [ 1, 20, "B_Heli_Transport_01_F" ];
if ( count _chatterPosEP < 2 ) then { _chatterPosEP = _chatterPos; };
_n = 1;
{
	_x doMove _chatterPosEP; 
	_x spawn 
	{
		private [ "_x", "_dir", "_nearMen", "_nearMan", "_anim" ];
		_x = _this;
		sleep 10;
		// doStop _x;
		_anim = [ "GUARD", "BRIEFING", "STAND_IA", "KNEEL" ] call BIS_fnc_selectRandom;
		[ _x, _anim, "ASIS" ] call BIS_fnc_ambientAnim;
		sleep 30;
		_nearMen = nearestObjects [ _x, ["Man"], 20 ];
		_nearMen = _nearMen - [ _x ];
		if ( count _nearMen > 0 ) then 
		{
			_dir = [ _x, _nearMen select 0 ] call BIS_fnc_relativeDirTo;
			_x setDir _dir;		
		};
	};
	
	_units = _units - [ _x ];
	 if ( T8U_var_DEBUG ) then { [ ">> %1 >>>>>>>>>> fn_loiter.sqf >> %2 attached to %3", time, _x, _chatterPosEP ] call BIS_fnc_error; };
	sleep 3;
	if ( count _units < 1 OR _n > 1 ) exitWith {};
	_n = _n + 1;
} forEach _units;

// 3 Units will sit "near" campfire
_seats = nearestObjects [ _pos, [ "Land_Campfire_F", "Land_FirePlace_F" ], _range ];
if ( count _seats > 0 ) then {
	_seat = _seats call BIS_fnc_selectRandom;
	if ( T8U_var_DEBUG ) then { [ ">> %1 >>>>>>>>>> fn_loiter.sqf >> SEATS >> %2", time, _seats ] call BIS_fnc_error; };

	_n = 1;
	{
		_seatPos = getPos _seat findEmptyPosition [ 1, 5, "Man" ];
		_x doMove _seatPos; 
		_x spawn 
		{
			private [ "_x", "_dir", "_nearMen", "_nearMan" ];
			_x = _this;
			sleep 10;
			// doStop _x;
			[ _x, "SIT_LOW", "ASIS" ] call BIS_fnc_ambientAnim;
			sleep 30;
			_nearMen = nearestObjects [ _x, ["Land_Campfire_F", "Land_FirePlace_F"], 20 ];
			if ( count _nearMen > 0 ) then 
			{
				_dir = [ _x, _nearMen select 0 ] call BIS_fnc_relativeDirTo;
				_x setDir _dir;		
			};
		};
		_units = _units - [ _x ];
		if ( T8U_var_DEBUG ) then { [ ">> %1 >>>>>>>>>> fn_loiter.sqf >> %2 attached to %3", time, _x, _seat ] call BIS_fnc_error; };
		sleep 3;
		if ( count _units < 1 OR _n > 2 ) exitWith {};
		_n = _n + 1;
	} forEach _units;
};

// 2 Unit will stand around
_dir = [ _pos, getPos _seat ] call BIS_fnc_dirTo;
_chatterPos = [ _pos , _range * 0.5 , ( 120 + random 120 ) ] call BIS_fnc_relPos;
_chatterPosEP = _chatterPos findEmptyPosition [ 1, 20, "B_Heli_Transport_01_F" ];
if ( count _chatterPosEP < 2 ) then { _chatterPosEP = _chatterPos; };
_n = 1;
{
	_x doMove _chatterPosEP; 
	_x spawn 
	{
		private [ "_x", "_dir", "_nearMen", "_nearMan", "_anim" ];
		_x = _this;		
		sleep 10;
		// doStop _x;
		_anim = [ "GUARD", "BRIEFING", "STAND_IA", "KNEEL" ] call BIS_fnc_selectRandom;
		[ _x, _anim, "ASIS" ] call BIS_fnc_ambientAnim;	

		sleep 30;
		_nearMen = nearestObjects [ _x, ["Man"], 20 ];
		_nearMen = _nearMen - [ _x ];
		if ( count _nearMen > 0 ) then 
		{
			_dir = [ _x, _nearMen select 0 ] call BIS_fnc_relativeDirTo;
			_x setDir _dir;		
		};
	};
	
	_units = _units - [ _x ];
	if ( T8U_var_DEBUG ) then { [ ">> %1 >>>>>>>>>> fn_loiter.sqf >> %2 attached to %3", time, _x, _chatterPosEP ] call BIS_fnc_error; };
	sleep 3;
	if ( count _units < 1 OR _n > 1 ) exitWith {};
	_n = _n + 1;
} forEach _units;

// 2 Unit will stand around
_dir = [ _pos, getPos _seat ] call BIS_fnc_dirTo;
_chatterPos = [ _pos , _range * 0.75, ( 240 + random 120 ) ] call BIS_fnc_relPos;
_chatterPosEP = _chatterPos findEmptyPosition [ 1, 20, "B_Heli_Transport_01_F" ];
if ( count _chatterPosEP < 2 ) then { _chatterPosEP = _chatterPos; };
_n = 1;
{
	_x doMove _chatterPosEP; 
	_x spawn 
	{
		private [ "_x", "_dir", "_nearMen", "_nearMan", "_anim" ];
		_x = _this;		
		sleep 10;
		// doStop _x;
		_anim = [ "GUARD", "BRIEFING", "STAND_IA", "KNEEL" ] call BIS_fnc_selectRandom;
		[ _x, _anim, "ASIS" ] call BIS_fnc_ambientAnim;	

		sleep 30;
		_nearMen = nearestObjects [ _x, ["Man"], 20 ];
		_nearMen = _nearMen - [ _x ];
		if ( count _nearMen > 0 ) then 
		{
			_dir = [ _x, _nearMen select 0 ] call BIS_fnc_relativeDirTo;
			_x setDir _dir;		
		};
	};
	
	_units = _units - [ _x ];
	if ( T8U_var_DEBUG ) then { [ ">> %1 >>>>>>>>>> fn_loiter.sqf >> %2 attached to %3", time, _x, _chatterPosEP ] call BIS_fnc_error; };
	sleep 3;
	if ( count _units < 1 OR _n > 1 ) exitWith {};
	_n = _n + 1;
} forEach _units;

sleep 40; // now everything should be in order and we can exit

_group setCurrentWaypoint _wp1;
_initGroupcount = count ( units _group );

if ( T8U_var_DEBUG ) then { [ ">> %1 >>>>>>>>>> fn_loiter.sqf >> %2 >> Successfully Initialized", time, _group ] call BIS_fnc_error; };

// exit the ambient anim if units leave group / are attached to new group
waitUntil { sleep 0.5; ( ( count ( units _group ) ) < _initGroupcount ) OR ( behaviour _unitLeader == "COMBAT" ) };
// waitUntil { sleep 2; ( [ _group ] call T8U_fnc_ReleaseGroup ) OR ( behaviour _unitLeader == "COMBAT" ) OR ( ( count ( units _group ) ) < _initGroupcount ) };

if ( T8U_var_DEBUG ) then { [ ">> %1 >>>>>>>>>> fn_loiter.sqf >> %2 >> TERMINATING", time, _group ] call BIS_fnc_error; };

// _newGroup call BIS_fnc_ambientAnim__terminate;
{ _x call BIS_fnc_ambientAnim__terminate; } forEach _unitsAll;

group _unitLeader setCombatMode "YELLOW";
group _unitLeader setBehaviour "AWARE";
