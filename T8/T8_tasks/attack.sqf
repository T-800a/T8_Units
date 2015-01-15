/*
 =======================================================================================================================
	
	Script: attack.sqf
	Author(s): T-800a
	Inspired and partly based on code by Binesi's BIN_taskDefend/Patrole

	Description:
	

	Parameter(s):
	_this select 0: the group to which to assign the waypoints (Group)
	_this select 1: the position on which to base the attack (Markername / String)
	_this select 2: (optional) is infantry group (Bool)

	Returns:
	Boolean - success flag

	Example(s):
	null = [ group this, "MY_MARKER" ] execVM "attack.sqf"
	null = [ group this, "MY_MARKER", false ] execVM "attack.sqf"  // Not a Infantry Group

 =======================================================================================================================
*/

private [ "_group", "_marker", "_infGroup", "_speedMode", "_formation", "_statement", "_range", "_behaviour" ];

_group		= [ _this, 0, objNull ] call BIS_fnc_param;
_marker		= [ _this, 1, "NO-MARKER-SET", [ "" ] ] call BIS_fnc_param; 
_infGroup	= [ _this, 2, true, [ true ] ] call BIS_fnc_param; 

if ( T8U_var_DEBUG ) then { [ "attack.sqf", "INIT", _this ] spawn T8U_fnc_DebugLog; };

if ( isNull _group OR { ! alive ( leader _group ) } OR { str ( getMarkerPos _marker ) == str ([0,0,0]) } ) exitWith { false };

_formation = [ "WEDGE", "VEE" ] call BIS_fnc_selectRandom;
_statement = "";
_range = 50;
_speedMode = "FULL";
_behaviour = "AWARE";

_group setBehaviour "AWARE";
_group setSpeedMode _speedMode;
_group setFormation _formation;

if ( random 100 > 50 ) then
{
	private [ "_fpA", "_fp" ];
	_fpA	= [ leader _group, getMarkerPos _marker ] call T8U_fnc_CreateFlankingPos;
	_fp		= [ _fpA, getPos ( leader _group ) ] call BIS_fnc_nearestPosition;
	
	[ _group, _fp, "MOVE", "AWARE", "", _range ] call T8U_fnc_CreateWP;
	if ( T8U_var_DEBUG_marker ) then { private [ "_dmt" ]; _dmt = format [ "%1 [%2]", _group, "MOVE" ]; [ _fp, "ICON", "waypoint", 1, "ColorBlack", 0.33, _dmt ] call T8U_fnc_DebugMarker; };
};

[ _group, getMarkerPos _marker, "SAD", "AWARE", "", _range ] call T8U_fnc_CreateWP;
if ( T8U_var_DEBUG_marker ) then { private [ "_dmt" ]; _dmt = format [ "%1 [%2]", _group, "SAD" ]; [ getMarkerPos _marker, "ICON", "waypoint", 1, "ColorBlack", 0.33, _dmt ] call T8U_fnc_DebugMarker; };

if ( T8U_var_DEBUG ) then { [ "attack.sqf", "Successfully Initialized", [ _group ] ] spawn T8U_fnc_DebugLog; };

// Return
true
