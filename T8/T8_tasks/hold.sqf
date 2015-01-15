/*
 =======================================================================================================================
	
	Script: hold.sqf
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

private [ "_group", "_infGroup", "_target", "_time", "_sEP" ];

_group		= [ _this, 0, grpNull, [ grpNull ] ] call BIS_fnc_param;
_infGroup	= [ _this, 1, true, [ true ] ] call BIS_fnc_param; 
_target		= [ _this, 2, [], [[]] ] call BIS_fnc_param; 
_time		= [ _this, 3, 10, [123] ] call BIS_fnc_param;

if ( T8U_var_DEBUG ) then { [ "hold.sqf", "INIT", _this ] spawn T8U_fnc_DebugLog; };

if ( isNull _group OR count _target < 2 ) exitWith { false };

if ( _infGroup ) then { _sEP = format [ "( units ( group this ) ) orderGetIn false; [ group this, %1 ] spawn T8U_fnc_RedoOriginTask", _time ]; } else { _sEP = format ["[ group this, %1 ] spawn T8U_fnc_RedoOriginTask", _time ]; };


[ _group, getPos leader _group, "MOVE", "COMBAT", _sEP, 25 ] call T8U_fnc_CreateWP;

{
	if ( alive _x ) then { [ getPos _x, _target ] call T8U_fnc_SmokeScreen; };
} forEach ( units _group );



if ( T8U_var_DEBUG ) then { [ "hold.sqf", "EXECUTED" ] spawn T8U_fnc_DebugLog; };

// Return
true
