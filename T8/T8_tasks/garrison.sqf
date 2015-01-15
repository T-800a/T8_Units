/*
 =======================================================================================================================

	Script: garrison.sqf
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
	null = [ group this, "MY_MARKER" ] execVM "garrison.sqf";
	
 =======================================================================================================================
*/

private [ 	"_group", "_marker", "_basePos", "_speedMode", "_formation", "_statementGetIn", "_statementGetOut", 
			"_wp", "_behaviour", "_wp" ];

_group		= [ _this, 0, objNull ] call BIS_fnc_param;
_marker		= [ _this, 1, "NO-MARKER-SET", [""] ] call BIS_fnc_param; 

if ( T8U_var_DEBUG ) then { [ "garrison.sqf", "INIT", _this ] spawn T8U_fnc_DebugLog; };

if ( isNull _group OR { str ( getMarkerPos _marker ) == str ([0,0,0]) } ) exitWith {};

if ( side _group != CIVILIAN ) then 
{
	_formation = [ "STAG COLUMN", "WEDGE", "VEE", "DIAMOND" ] call BIS_fnc_selectRandom;
	_speedMode = "LIMITED";
	_statementGetIn = format [ "[ this ] spawn T8U_fnc_GetInCover; [ this ] spawn T8U_fnc_GetOutVehicle; [ this, '%1' ] spawn T8U_fnc_GarrisonBuildings;", _marker ];
	_statementGetOut = '[ this ] spawn T8U_fnc_GetOutCover; ( group this ) setVariable [ "T8U_gvar_garrisoning", false, false ];';
	_behaviour = "SAFE";

	_group setBehaviour "AWARE";
	_group setSpeedMode _speedMode;
	_group setFormation _formation;

	_basePos = [ _marker ] call T8U_fnc_CreateSpawnPos;

	[ _group, _basePos, "MOVE", "SAFE", _statementGetIn, 5, "LIMITED", [ 15, 15, 15 ] ] call T8U_fnc_CreateWP;
	[ _group, _basePos, "HOLD", "SAFE", "", 5, "LIMITED" ] call T8U_fnc_CreateWP;
	[ _group, _basePos, "TALK", "SAFE", _statementGetOut, 5, "LIMITED", [ 5, 5, 5 ] ] call T8U_fnc_CreateWP;
	[ _group, _basePos, "CYCLE", "SAFE", "", 100, "LIMITED", [ 30, 30, 30 ] ] call T8U_fnc_CreateWP;

	if ( T8U_var_DEBUG ) then { [ "garrison.sqf", "MILITARY: Successfully Initialized", [ _group ] ] spawn T8U_fnc_DebugLog; };

	// Exit garrisoning when group gets new task assigned
	waitUntil { sleep 2; [ _group ] call T8U_fnc_ReleaseGroup };

	if ( T8U_var_DEBUG ) then { [ "garrison.sqf", "TERMINATING", [ _group ] ] spawn T8U_fnc_DebugLog; };

	if ( isNull _group ) exitWith {};

	[ _group ] call T8U_fnc_ForceNextWP;
	[ leader _group ] spawn T8U_fnc_GetOutCover;

	sleep 5;
	_group setVariable [ "T8U_gvar_Regrouped", true, false ];

} else {

	[ leader _group, _marker ] spawn T8U_fnc_GarrisonBuildings;
	
	if ( T8U_var_DEBUG ) then { [ "garrison.sqf", "MILITARY: Successfully Initialized", [ _group ] ] spawn T8U_fnc_DebugLog; };
};


