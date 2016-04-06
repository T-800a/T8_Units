/*
 =======================================================================================================================
	
	Script: fn_occupy.sqf
	Author(s): T-800a
	Inspired and partly based on code by Binesi's BIN_taskDefend/Patrol

	Description:
	A group of units will occupy nearby buildings, if no buildings are in the area, they will patrol.

	Parameter(s):
	_this select 0: the group to which to assign the waypoints (group)
	_this select 1: the position on which to base the patrol (marker/position)
	_this select 2: (optional) is infantry group (Bool) Will force group to leave vehicle on waypoints!

	Returns:
	-

	Example(s):
	null = [ group this, "MY_MARKER" ] execVM "fn_occupy.sqf"
	null = [ group this, "MY_MARKER", false, true ] execVM "fn_occupy.sqf"  // Not a Infantry Group, Debug Enabled

 =======================================================================================================================
*/

#include <..\MACRO.hpp>

private [ "_wpArray", "_cycle" ];

params [
	[ "_group", grpNull, [grpNull]],
	[ "_marker", "NO-MARKER-SET", ["",[]]],
	[ "_immobile", false, [true]]
];

__DEBUG( __FILE__, "INIT", _this );

if ( isNull _group ) exitWith { false };
if ((( typeName _marker ) isEqualTo "ARRAY" ) AND {( count _marker ) isEqualTo 0 }) exitWith { false };
if (( typeName _marker ) isEqualTo "ARRAY" ) then { _marker = _marker call BIS_fnc_selectRandom; };
if (( typeName _marker ) isEqualTo ( typeName "" ) AND {( getMarkerPos _marker ) isEqualTo [0,0,0] }) exitWith { false };

private _formation	= ["STAG COLUMN", "WEDGE", "ECH LEFT", "ECH RIGHT", "VEE", "DIAMOND"] call BIS_fnc_selectRandom;
private _range		= 20;
private _speedMode	= "LIMITED";

_group setBehaviour "AWARE";
_group setSpeedMode _speedMode;
_group setFormation _formation;

private _statementArrive	= "[ this ] spawn T8U_fnc_getOutVehicle;";
private _statementOccupy	= format [ "[ this, '%1', %2 ] spawn T8U_fnc_occupyBuildings;", _marker, _immobile ];
private _statementPatrol	= "";
private _statementCycle		= "( group this ) setCurrentWaypoint [( group this ), 3 ];";


// Create waypoints based on array of positions
_wpArray = [ _marker, true ] call T8U_fnc_CreateWaypointPositions;
_wpArray = _wpArray call BIS_fnc_arrayShuffle;
__DEBUG( __FILE__, "_wpArray", _wpArray );

private _firstWP = [ _marker ] call T8U_fnc_createSpawnPos;
[ _group, _firstWP, "MOVE", "SAFE", _statementArrive, _range, _speedMode, [ 15, 15, 15 ]] call T8U_fnc_CreateWaypoint;
[ _group, _firstWP, "MOVE", "SAFE", _statementOccupy, _range, _speedMode, [ 15, 15, 15 ]] call T8U_fnc_CreateWaypoint;

{
	if ( count _x > 0 ) then 
	{
		[ _group, _x, "MOVE", "SAFE", _statementPatrol, _range, _speedMode, [ 0, 15, 60 ]] call T8U_fnc_CreateWaypoint;

		_cycle = _x;

		if ( T8U_var_DEBUG_marker ) then { [ _x ] call T8U_fnc_DebugMarker; };
	};
} forEach _wpArray;

// Cycle in case we reach the end
[ _group, _cycle, "MOVE", "SAFE", _statementCycle, _range, _speedMode, [ 0, 15, 60 ]] call T8U_fnc_CreateWaypoint;

__DEBUG( __FILE__, "Successfully Initialized", _group );


// return
true
