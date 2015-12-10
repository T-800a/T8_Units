/*
 =======================================================================================================================

	T8 Units Script

	Funktion:	fn_forceNextWaypoint.sqf
	Author:		T-800a
	E-Mail:		t-800a@gmx.net

 =======================================================================================================================
*/

#include <..\MACRO.hpp>

private [ "_group", "_type", "_i", "_t" ];

_group = _this select 0;

if ( T8U_var_DEBUG ) then { [ "fn_forceNextWaypoint.sqf", "INIT", _this ] spawn T8U_fnc_DebugLog; };

if ( isNull _group ) exitWith {};

_i = ( currentWaypoint _group ) + 1;
_t = waypointType [ _group, _i ];

if ( _t in [ "TALK", "SCRIPTED", "HOLD" ] ) then { _i = _i + 1; };
if ( _i >= ( count ( waypoints _group )) ) then { _i = 0; };

_group setCurrentWaypoint [ _group, _i ];

if ( T8U_var_DEBUG ) then { [ "fn_forceNextWaypoint.sqf", "WAYPOINTS", [ waypoints _group ] ] spawn T8U_fnc_DebugLog; };
if ( T8U_var_DEBUG ) then { [ "fn_forceNextWaypoint.sqf", "NEXT WAYPOINTS", [ _group, _i ] ] spawn T8U_fnc_DebugLog; };
