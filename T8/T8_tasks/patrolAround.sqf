/*
 =======================================================================================================================

	Script: patrolAround.sqf
	Author(s): T-800a
	Inspired and partly based on code by Binesi's BIN_taskDefend/Patrole

	Description:
	Creates a continually randomized patrol path which circles around a given marker with some distance.
	The Size of the Marker is important!
	On each Waypoint there is a 20% chance to switch to a random next Waypoint.

	Parameter(s):
	_this select 0: the group to which to assign the waypoints (Group)
	_this select 1: the position on which to base the patrol (Markername / String)
	_this select 2: (optional) is infantry group (Bool) Will force group to leave vehicle on waypoints!
	_this select 3: (optional) distance between patrole points and marker zone (Integer)

	Returns:
	Boolean - success flag

	Example(s):
	null = [ group this, "MY_MARKER" ] execVM "patrolAround.sqf"

	null = [ group this, "MY_MARKER", false, 100 ] execVM "patrolAround.sqf"  
	// Is not a Infantry Group, distance between marker border and Waypoints = 100m

 =======================================================================================================================
*/

private [ "_group", "_marker", "_infGroup", "_speedMode", "_formation", "_statement", "_range", "_wp", "_wpArray", "_cycle", "_behaviour" ];

_group		= [ _this, 0, objNull ] call BIS_fnc_param;
_marker		= [ _this, 1, "NO-MARKER-SET", [ "" ] ] call BIS_fnc_param; 
_infGroup	= [ _this, 2, true, [ true ] ] call BIS_fnc_param;

if ( T8U_var_DEBUG ) then { [ "patrolAround.sqf", "INIT", _this ] spawn T8U_fnc_DebugLog; };

if ( isNull _group OR { str ( getMarkerPos _marker ) == str ([0,0,0]) } ) exitWith { false };

if ( _infGroup ) then
{
	_formation = ["STAG COLUMN", "WEDGE", "ECH LEFT", "ECH RIGHT", "VEE", "DIAMOND"] call BIS_fnc_selectRandom;
	_statement = "[ this ] spawn T8U_fnc_GetOutVehicle; if ((random 10)>8) then { group this setCurrentWaypoint [(group this), (ceil (random (count (waypoints (group this)))))];};";
	_speedMode = "LIMITED";
	_range = 20;
} else {
	_formation = "COLUMN";
	_statement = "if ((random 10)>8) then { group this setCurrentWaypoint [(group this), (ceil (random (count (waypoints (group this)))))];};";
	_speedMode = "FULL";
	_range = 50;
};

_group setBehaviour "AWARE";
_group setSpeedMode _speedMode;
_group setFormation _formation;

// Create waypoints based on array of positions
_wpArray = [ _marker, _infGroup, false, false ] call T8U_fnc_CreateWaypointPositions;

{
    private [ "_wp", "_markerName", "_markerFP" ];

	if ( count _x > 0 ) then 
	{
		[ _group, _x, "MOVE", "SAFE", _statement, _range, _speedMode, [ 0, 15, 60 ] ] call T8U_fnc_CreateWP;

		_cycle = _x;
		
		if ( T8U_var_DEBUG_marker ) then { [ _x ] call T8U_fnc_DebugMarker; };
	};
} forEach _wpArray;

// Cycle in case we reach the end
[ _group, _cycle, "CYCLE", "SAFE", "", 100 ] call T8U_fnc_CreateWP;

_group setCurrentWaypoint [ _group, ceil ( random ( count ( waypoints _group ) ) ) ];

if ( T8U_var_DEBUG ) then { [ "patrolAround.sqf", "Successfully Initialized", [ _group ] ] spawn T8U_fnc_DebugLog; };

// Return
true
