/*
 =======================================================================================================================

	Script: patrolGarrison.sqf
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
	_this select 2: (optional) debug markers on or off (Bool)

	Returns:
	Boolean - success flag

	Example(s):
	null = [ group this, "MY_MARKER" ] execVM "patrolGarrison.sqf";

 =======================================================================================================================
*/

private [ "_group", "_marker", "_n", "_speedMode", "_formation", "_statementGetIn", "_statementGetOut", "_range", "_wp", "_wpArray", "_behaviour" ];

_group		= [ _this, 0, objNull ] call BIS_fnc_param;
_marker		= [ _this, 1, "NO-MARKER-SET", [""] ] call BIS_fnc_param; 

if ( T8U_var_DEBUG ) then { [ "patrolGarrison.sqf", "INIT", _this ] spawn T8U_fnc_DebugLog; };

if ( isNull _group OR { str ( getMarkerPos _marker ) == str ([0,0,0]) } ) exitWith { false };

_formation = [ "STAG COLUMN", "WEDGE", "VEE", "DIAMOND" ] call BIS_fnc_selectRandom;
_speedMode = "LIMITED";

_statementGetIn		= '[ this ] spawn T8U_fnc_GetInCover; [ this ] spawn T8U_fnc_GetOutVehicle; [ this, ( getPos this ) ] spawn T8U_fnc_GarrisonBuildings;';
_statementGetOut	= '[ this ] spawn T8U_fnc_GetOutCover; ( group this ) setVariable [ "T8U_gvar_garrisoning", false, false ];';
_range = 50;

_group setBehaviour "AWARE";
_group setSpeedMode _speedMode;
_group setFormation _formation;

[ _group, getMarkerPos _marker, "MOVE", "SAFE", "", _range, _speedMode ] call T8U_fnc_CreateWP;

// Create waypoints based on array of positions
_wpArray = [ _marker, true, true ] call T8U_fnc_CreateWaypointPositions;
_wpArray = _wpArray call BIS_fnc_arrayShuffle;

_n = 2;
{
    private [ "_wp", "_markerName", "_markerFP" ];

	if ( count _x > 0 ) then 
	{
		[ _group, _x, "MOVE", "SAFE", _statementGetIn, _range, _speedMode, [ 30, 30, 30 ] ] call T8U_fnc_CreateWP;
		[ _group, _x, "TALK", "SAFE", _statementGetOut, _range, _speedMode, [ 90, 120, 150 ] ] call T8U_fnc_CreateWP;
		
		if ( T8U_var_DEBUG_marker ) then { [ _x ] call T8U_fnc_DebugMarker; };
    };
} forEach _wpArray;

// Cycle in case we reach the end
[ _group, ( _wpArray call BIS_fnc_selectRandom ), "CYCLE", "SAFE", "", 100, _speedMode, [ 30, 30, 30 ] ] call T8U_fnc_CreateWP;

_group setCurrentWaypoint [ _group, 2 ];

if ( T8U_var_DEBUG ) then { [ "patrolGarrison.sqf", "Successfully Initialized", [ _group ] ] spawn T8U_fnc_DebugLog; };

// Exit garrisoning when group gets new task assigned
waitUntil { sleep 2; [ _group ] call T8U_fnc_ReleaseGroup };

if ( T8U_var_DEBUG ) then { [ "patrolGarrison.sqf", "TERMINATING", [ _group ] ] spawn T8U_fnc_DebugLog; };

if ( isNull _group ) exitWith {};

[ _group ] call T8U_fnc_ForceNextWP;
[ leader _group ] spawn T8U_fnc_GetOutCover;

sleep 5;
_group setVariable [ "T8U_gvar_Regrouped", true, false ];
