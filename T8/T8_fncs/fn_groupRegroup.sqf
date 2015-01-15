/*
 =======================================================================================================================

	T8 Units Script

	Funktion:	fn_groupRegroup.sqf
	Author:		T-800a
	E-Mail:		t-800a@gmx.net
	
	NYI

 =======================================================================================================================
*/

private [ "_group", "_pos", "_wpArray", "_wp" ];

_group		= [ _this, 0, objNull ] call BIS_fnc_param;
_pos		= getPos ( leader _group );

if ( T8U_var_DEBUG ) then { [ "fn_groupRegroup.sqf", "INIT", _this ] spawn T8U_fnc_DebugLog; };

if ( isNull _group ) exitWith { false };

_wpArray = waypoints _group;

{ deleteWaypoint _x; } forEach _wpArray;

_wp = _group addWaypoint [ _pos , 0 ];
_wp setWaypointType "MOVE";

{ [ _x ] joinSilent _group } forEach ( units _group );

if ( T8U_var_DEBUG ) then { [ "fn_groupRegroup.sqf", "REGROUP DONE", [ _group ] ] spawn T8U_fnc_DebugLog; };

// ReturnValue
_group
