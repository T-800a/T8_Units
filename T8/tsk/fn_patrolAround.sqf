/*
 =======================================================================================================================

	Script: fn_patrolAround.sqf
	Author(s): T-800a
	Inspired and partly based on code by Binesi's BIN_taskDefend/Patrol

	Description:
	Creates a continually randomized patrol path which circles around a given marker with some distance.
	The size of the marker is important!
	On each waypoint there is a 20% chance to switch to a random next waypoint.

	Parameter(s):
	_this select 0: (group)					the group to which to assign the waypoints
	_this select 1: (string/array)			the position on which to base the patrol
	_this select 2: (bool)		(optional)	is infantry group will force group to leave vehicle on waypoints!
	_this select 3: (integer)	(optional)	distance between patrole points and marker zone
	_this select 4: (integer)	(optional)	angle of first created waypoint
	_this select 5: (string)	(optional)	formation of group
	_this select 6: (string)	(optional)	behaviour of group

	Returns:
	boolean - success flag

	Example(s):
	// group partrols around MY_MARKER
	fun = [ group this, "MY_MARKER" ] execVM "fn_patrolAround.sqf"

	// group partrols around MY_MARKER; group is not a infantry group; distance between marker border and waypoints = 100m
	fun = [ group this, "MY_MARKER", false, 100 ] execVM "fn_patrolAround.sqf"

 =======================================================================================================================
*/

#include <..\MACRO.hpp>

private [ "_speedMode", "_statement", "_range", "_cycle" ];

params [
	[ "_group", grpNull, [grpNull]],
	[ "_marker", "NO-MARKER-SET", ["",[]]],
	[ "_infGroup", true, [true]],
	[ "_teleport", false, [false]],
	[ "_PatrolAroundDis", T8U_var_PatAroundRange, [123]],
	[ "_startAngle", 0, [123]],
	[ "_formation", "RANDOM", [""]],
	[ "_behaviour", "SAFE", [""]]
];


__DEBUG( __FILE__, "INIT", _this );

if ( isNull _group ) exitWith { false };
if (( typeName _marker ) isEqualTo ( typeName "" ) AND {( getMarkerPos _marker ) isEqualTo [0,0,0] }) exitWith { false };
if (( typeName _marker ) isEqualTo ( typeName [] ) AND {( count _marker ) isEqualTo 0 }) exitWith { false };

private _wpArrayTmp		= [];
private _wpArray		= [];

if ( _infGroup ) then
{
	if(_formation == "RANDOM") then {
		_formation = ["STAG COLUMN", "WEDGE", "ECH LEFT", "ECH RIGHT", "VEE", "DIAMOND"] call BIS_fnc_selectRandom;
	};
	_statement = "[ this ] spawn T8U_fnc_GetOutVehicle; if ((random 10)>9) then { group this setCurrentWaypoint [(group this), (ceil (random (count (waypoints (group this)))))];};";
	_speedMode = "LIMITED";
	_range = 20;
} else {
	_formation = "COLUMN";
	_statement = "if ((random 10)>9) then { group this setCurrentWaypoint [(group this), (ceil (random (count (waypoints (group this)))))];};";
	_speedMode = "FULL";
	_range = 50;
};

_group setBehaviour "AWARE";
_group setSpeedMode _speedMode;
_group setFormation _formation;

// Create waypoints based on array of positions
if (( typeName _marker ) isEqualTo ( typeName [] )) then
{
	{
		__DEBUG( __FILE__, "_marker > _x", _x );

		if !(( getMarkerPos _x ) isEqualTo [0,0,0] ) then
		{
			_wpArrayTmp = [ _x, _infGroup, false, false, _PatrolAroundDis, _startAngle ] call T8U_fnc_CreateWaypointPositions;
			_wpArray append _wpArrayTmp;
		};

		__DEBUG( __FILE__, "_wpArray", _wpArray );

		false
	} count _marker;

} else {
	_wpArray = [ _marker, _infGroup, false, false, _PatrolAroundDis, _startAngle ] call T8U_fnc_CreateWaypointPositions;
	__DEBUG( __FILE__, "_wpArray", _wpArray );
};

{
	if ( count _x > 0 ) then
	{
		[ _group, _x, "MOVE", _behaviour, _statement, _range, _speedMode, [ 0, 15, 60 ] ] call T8U_fnc_CreateWaypoint;

		_cycle = _x;

		if ( T8U_var_DEBUG_marker ) then { [ _x ] call T8U_fnc_DebugMarker; };
	};
} forEach _wpArray;

// Cycle in case we reach the end
[ _group, _cycle, "CYCLE", _behaviour, "", 100, _speedMode ] call T8U_fnc_CreateWaypoint;

// Select random waypoint on the patrol
if ( _startAngle isEqualTo 0 ) then { _group setCurrentWaypoint [ _group, ceil ( random ( count ( waypoints _group )))];};

// teleport the group to the current waypoint so they can start their loop, only if the group is newly created
if ( _teleport ) then {[ _group ] call T8U_fnc_teleportGroupToCurrentWaypoint; };

__DEBUG( __FILE__, "Successfully Initialized", _group );

// Return
true
