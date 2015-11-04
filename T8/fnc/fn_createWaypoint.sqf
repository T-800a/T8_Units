/*
 =======================================================================================================================

	T8 Units Script

	Funktion:	fn_createWaypoint.sqf
	Author:		T-800a
	E-Mail:		t-800a@gmx.net

 =======================================================================================================================
*/

#include <..\MACRO.hpp>

private [ "_group", "_pos", "_wpType", "_combatBehave", "_statement", "_statementIL", "_compRadius", "_speed", "_timeout", "_wp", "_n" ];

_group				= param [ 0, grpNull, [grpNull]];
_pos				= param [ 1, [], [[]]];
_wpType				= param [ 2, "MOVE", [""]];
_combatBehave		= param [ 3, "AWARE", [""]];
_statement			= param [ 4, "", [""]];
_compRadius			= param [ 5, 50, [123]];
_speed				= param [ 6, "FULL", [""]];
_timeout			= param [ 7, [ 2, 4, 6 ], [[]]];

if ( isNull _group OR { ( count _pos ) < 2 } ) exitWith { if ( T8U_var_DEBUG ) then { [ "fn_createWaypoint.sqf", "Can't create Waypoint", _this ] spawn T8U_fnc_DebugLog; }; false };

// make waypoint scripts only execute where unit is local
_statementIL = format [ "if ( local this ) then { %1 };", _statement ];

_n = count ( waypoints _group );
_wp = _group addWaypoint [ _pos , _n ];

_wp setWaypointPosition [ _pos, 1 ];
_wp setWaypointType _wpType;
_wp setWaypointBehaviour _combatBehave;
_wp setWaypointCompletionRadius _compRadius;
_wp setWaypointStatements [ "true", _statementIL ];
_wp setWaypointSpeed _speed;
_wp setWaypointTimeout _timeout;

// Return
true
