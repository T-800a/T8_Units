/*
 =======================================================================================================================

	Script: patrollUrban.sqf
	Author(s): T-800a
	Inspired and partly based on code by Binesi's BIN_taskDefend/Patrole

	Description:
	Creates a continually randomized patrol path which circles inside a given marker area.
	!! All Waypoints are positioned on a Street !!
	The Size of the Marker is important, if its under 100m, the patrole area is set to 100m in diameter!
	On each Waypoint there is a 50% chance to switch to a random next Waypoint.

	Parameter(s):
	_this select 0: the group to which to assign the waypoints (Group)
	_this select 1: the position on which to base the patrol (Markername / String)
	_this select 2: (optional) is infantry group (Bool) Will force group to leave vehicle on waypoints!

	Returns:
	Boolean - success flag

	Example(s):
	null = [ group this, "MY_MARKER" ] execVM "patrollUrban.sqf";
	null = [ group this, "MY_MARKER", false ] execVM "patrollUrban.sqf";  // Not a Infantry Group

 =======================================================================================================================
*/

private [ "_group", "_marker", "_infGroup", "_formation", "_statement", "_range", "_wp", "_wpArray", "_cycle", "_behaviour", "_speedMode" ];

_group		= [ _this, 0, objNull ] call BIS_fnc_param;
_marker		= [ _this, 1, "NO-MARKER-SET", [ "" ] ] call BIS_fnc_param; 
_infGroup	= [ _this, 2, true, [ true ] ] call BIS_fnc_param; 

if ( T8U_var_DEBUG ) then { [ "patrollUrban.sqf", "INIT", _this ] spawn T8U_fnc_DebugLog; };

if ( isNull _group OR { str ( getMarkerPos _marker ) == str ([0,0,0]) } ) exitWith { false };

if ( _infGroup ) then
{
	_formation = ["STAG COLUMN", "WEDGE", "ECH LEFT", "ECH RIGHT", "VEE", "DIAMOND"] call BIS_fnc_selectRandom;
	_statement = "[ this ] spawn T8U_fnc_GetOutVehicle; if ((random 10)>5) then { group this setCurrentWaypoint [(group this), (ceil (random (count (waypoints (group this)))))];};";
	_range = 20;
	_behaviour = "SAFE";
	_speedMode = "LIMITED";
} else {
	_formation = "COLUMN";
	_statement = "if ((random 10)>5) then { group this setCurrentWaypoint [(group this), (ceil (random (count (waypoints (group this)))))];};";
	_range = 30;
	_behaviour = "AWARE";
	_speedMode = "LIMITED";
};

_group setBehaviour "AWARE";
_group setSpeedMode "LIMITED";
_group setFormation _formation;

// Create waypoints based on array of positions
_wpArray = [ _marker, _infGroup, true ] call T8U_fnc_CreateWaypointPositions;
_wpArray = _wpArray call BIS_fnc_arrayShuffle;

{
	if ( count _x > 0 ) then 
	{
		[ _group, _x, "MOVE", _behaviour, _statement, _range, _speedMode, [ 0, 15, 60 ] ] call T8U_fnc_CreateWP;

		_cycle = _x;
		
		if ( T8U_var_DEBUG_marker ) then { [ _x ] call T8U_fnc_DebugMarker; };
	};
} forEach _wpArray;

// Cycle in case we reach the end
[ _group, _cycle, "CYCLE", "SAFE", "", 100 ] call T8U_fnc_CreateWP;

if ( T8U_var_DEBUG ) then { [ "patrolUrban.sqf", "Successfully Initialized", [ _group ] ] spawn T8U_fnc_DebugLog; };

// Return
true
