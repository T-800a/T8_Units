/*
 =======================================================================================================================

	Script: fn_garrison.sqf
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
	null = [ group this, "MY_MARKER" ] execVM "fn_garrison.sqf";
	
 =======================================================================================================================
*/

#include <..\MACRO.hpp>

private [ 	"_group", "_marker", "_leader", "_basePos", "_speedMode", "_formation", "_statementGetIn", "_statementGetOut", 
			"_wp", "_behaviour", "_wp" ];

_group		= param [ 0, grpNull, [grpNull]];
_marker		= param [ 1, "NO-MARKER-SET", [""]];
_leader		= leader _group;

if ( T8U_var_DEBUG ) then { [ "fn_garrison.sqf", "INIT", _this ] spawn T8U_fnc_DebugLog; };

if ( isNull _group OR { str ( getMarkerPos _marker ) == str ([0,0,0]) } ) exitWith {};

if ( side _group != CIVILIAN ) then 
{
	_formation = [ "STAG COLUMN", "WEDGE", "VEE", "DIAMOND" ] call BIS_fnc_selectRandom;
	_speedMode = "LIMITED";
	_statementGetIn = format [ "[ this, '%1' ] spawn T8U_fnc_GetInCover; [ this ] spawn T8U_fnc_GetOutVehicle; [ this, '%1' ] spawn T8U_fnc_GarrisonBuildings;", _marker ];
	_statementGetOut = '[ this ] spawn T8U_fnc_GetOutCover; ( group this ) setVariable [ "T8U_gvar_garrisoning", false, false ];';
	_behaviour = "SAFE";

	_group setBehaviour "AWARE";
	_group setSpeedMode _speedMode;
	_group setFormation _formation;

	_basePos = [( getMarkerPos _marker ), 400, true ] call T8U_fnc_findEmptyPos;

	[ _group, _basePos, "MOVE", "SAFE", _statementGetIn, 5, "LIMITED", [ 15, 15, 15 ] ] call T8U_fnc_CreateWaypoint;
	[ _group, _basePos, "HOLD", "SAFE", "", 5, "LIMITED" ] call T8U_fnc_CreateWaypoint;
	[ _group, _basePos, "TALK", "SAFE", _statementGetOut, 5, "LIMITED", [ 5, 5, 5 ] ] call T8U_fnc_CreateWaypoint;
	[ _group, _basePos, "CYCLE", "SAFE", "", 100, "LIMITED", [ 30, 30, 30 ] ] call T8U_fnc_CreateWaypoint;

	if ( T8U_var_DEBUG ) then { [ "fn_garrison.sqf", "MILITARY: Successfully Initialized", [ _group ] ] spawn T8U_fnc_DebugLog; };

	_group enableAttack false;
	
	// Exit garrisoning when group gets new task assigned
	waitUntil { sleep 2; [ _group ] call T8U_fnc_ReleaseGroup };
	
	_group enableAttack true;
	
	[ _leader ] spawn T8U_fnc_GetOutCover;

	if ( T8U_var_DEBUG ) then { [ "fn_garrison.sqf", "TERMINATING", [ _group ] ] spawn T8U_fnc_DebugLog; };

	if ( isNull _group ) exitWith {};
	
	[ _group ] call T8U_fnc_ForceNextWaypoint;
	
	sleep 5;
	_group setVariable [ "T8U_gvar_Regrouped", true, false ];

} else {

	[ leader _group, _marker ] spawn T8U_fnc_GarrisonBuildings;
	
	if ( T8U_var_DEBUG ) then { [ "fn_garrison.sqf", "MILITARY: Successfully Initialized", [ _group ] ] spawn T8U_fnc_DebugLog; };
};


