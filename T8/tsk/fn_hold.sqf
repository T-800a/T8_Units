/*
 =======================================================================================================================
	
	Script: fn_hold.sqf
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

#include <..\MACRO.hpp>

private [ "_group", "_infGroup", "_target", "_time", "_sEP", "_holdPosArray", "_holdPos" ];

_group		= param [ 0, grpNull, [grpNull]];
_infGroup	= param [ 1, true, [true]]; 
_target		= param [ 2, [], [[]]]; 
_time		= param [ 3, 10, [123]];

if ( T8U_var_DEBUG ) then { [ "fn_hold.sqf", "INIT", _this ] spawn T8U_fnc_DebugLog; };

if ( isNull _group OR count _target < 2 ) exitWith { false };

if ( _infGroup ) then { _sEP = format [ "( units ( group this ) ) orderGetIn false; [ group this, %1 ] spawn T8U_fnc_RedoOriginTask", _time ]; } else { _sEP = format ["[ group this, %1 ] spawn T8U_fnc_RedoOriginTask", _time ]; };

_holdPosArray = [( getPos ( leader _group )), 20, 60, true ] call T8U_fnc_FindOverwatch;
if ( count _holdPosArray < 1 ) then { _holdPos = getPos ( leader _group ); } else { _holdPos = _holdPosArray call BIS_fnc_selectRandom; };

[ _group, _holdPos, "MOVE", "COMBAT", _sEP, 25 ] call T8U_fnc_CreateWaypoint;

{
	if ( alive _x ) then { [ _x, _target ] call T8U_fnc_SmokeScreen; };
} forEach ( units _group );



if ( T8U_var_DEBUG ) then { [ "fn_hold.sqf", "EXECUTED" ] spawn T8U_fnc_DebugLog; };

// Return
true
