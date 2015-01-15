/*
 =======================================================================================================================

	T8 Units Script

	Funktion:	fn_createWaypoint.sqf
	Author:		T-800a
	E-Mail:		t-800a@gmx.net

 =======================================================================================================================
*/
	
private [ "_group", "_pos", "_wpType", "_combatBehave", "_statement", "_statementIL", "_compRadius", "_speed", "_timeout", "_wp", "_n" ];

_group				= [ _this, 0, grpNull, [grpNull] ] call BIS_fnc_param;
_pos				= [ _this, 1, [], [[]] ] call BIS_fnc_param;
_wpType				= [ _this, 2, "MOVE", [""] ] call BIS_fnc_param;
_combatBehave		= [ _this, 3, "AWARE", [""] ] call BIS_fnc_param;
_statement			= [ _this, 4, "", [""] ] call BIS_fnc_param;
_compRadius			= [ _this, 5, 50, [123] ] call BIS_fnc_param;
_speed				= [ _this, 6, "FULL", [""] ] call BIS_fnc_param;
_timeout			= [ _this, 7, [ 2, 4, 6 ], [[]] ] call BIS_fnc_param;

if ( isNull _group OR { ( count _pos ) < 2 } ) exitWith { if ( T8U_var_DEBUG ) then { [ "fn_createWaypoint.sqf", "Can't create Waypoint", _this ] spawn T8U_fnc_DebugLog; }; false };

_n = count ( waypoints _group );

_statementIL = format [ "if ( local this ) then { %1 };", _statement ];

_wp = _group addWaypoint [ _pos , _n ];
_wp setWaypointType _wpType;
_wp setWaypointBehaviour _combatBehave;
_wp setWaypointCompletionRadius _compRadius;
_wp setWaypointStatements [ "true", _statementIL ];
_wp setWaypointSpeed _speed;
_wp setWaypointTimeout _timeout;

true
