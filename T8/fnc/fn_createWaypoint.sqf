/*
 =======================================================================================================================

	T8 Units Script

	Funktion:	fn_createWaypoint.sqf
	Author:		T-800a
	E-Mail:		t-800a@gmx.net

 =======================================================================================================================
*/

#include <..\MACRO.hpp>

params [
	[ "_group", grpNull, [grpNull]],
	[ "_pos", [], [[]]],
	[ "_wpType", "MOVE", [""]],
	[ "_combatBehave", "AWARE", [""]],
	[ "_statement", "", [""]],
	[ "_compRadius", 50, [123]],
	[ "_speed", "FULL", [""]],
	[ "_timeout", [ 2, 4, 6 ], [[]]]
];

if ( isNull _group OR { ( count _pos ) < 2 } ) exitWith { if ( T8U_var_DEBUG ) then { [ "fn_createWaypoint.sqf", "Can't create Waypoint", _this ] spawn T8U_fnc_DebugLog; }; false };

// make waypoint scripts only execute where unit is local
private _statementIL = format [ "if ( local this ) then { %1 };", _statement ];
private _n	= count ( waypoints _group );

private _wp	= _group addWaypoint [ _pos , _n ];

_wp setWaypointPosition [ _pos, 1 ];
_wp setWaypointType _wpType;
_wp setWaypointBehaviour _combatBehave;
_wp setWaypointCompletionRadius _compRadius;
_wp setWaypointStatements [ "true", _statementIL ];
_wp setWaypointSpeed _speed;
_wp setWaypointTimeout _timeout;
_wp setWaypointFormation "NO_CHANGE";

// Return
true
