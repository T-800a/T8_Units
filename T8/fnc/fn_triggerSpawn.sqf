/*
 =======================================================================================================================

	T8 Units Script

	Funktion:	fn_triggerSpawn.sqf
	Author:		T-800a
	E-Mail:		t-800a@gmx.net

	[ _unitsArray, _marker, _distance, _condition, _actSide, _actType, _actRepeat, _onAct, _onDeAct, _timeout ] call T8U_fnc_TriggerSpawn;
	
 =======================================================================================================================
*/

#include <..\MACRO.hpp>

private [ "_unitsArray", "_marker", "_distance", "_actSide", "_actType", "_onAct", "_onDeAct", "_condition", "_timeout", "_trigger" ];

_unitsArray		= param [ 0, "NO-UNITS-SET", [""]];
_marker			= param [ 1, "NO-MARKER-SET", [""]];
_distance		= param [ 2, 1000, [123]];
_condition		= param [ 3, "this", [""]];
_actSide		= param [ 4, "ANY", [""]];
_actType		= param [ 5, "PRESENT", [""]];
_actRepeat		= param [ 6, false, [true]];
_onAct			= param [ 7, "", [""]];
_onDeAct		= param [ 8, "", [""]];
_timeout		= param [ 9, [ 0, 0, 0, false ], [[]], [4]];

_onActCompiled = format [ "[ %1 ] spawn T8U_fnc_Spawn; %2", _unitsArray, _onAct ];

if ( T8U_var_DEBUG ) then { [ "fn_triggerSpawn.sqf", "INIT", _this ] spawn T8U_fnc_DebugLog; };
if ( T8U_var_DEBUG ) then { [ "fn_triggerSpawn.sqf", "_onActCompiled", [ _onActCompiled ] ] spawn T8U_fnc_DebugLog; };

if ( _unitsArray == "NO-UNITS-SET" OR { _marker == "NO-MARKER-SET" } ) exitWith 
{
	private [ "_msg" ]; 
	_msg = format [ "There is a serious error in your T8U_fnc_TriggerSpawn call!<br /><br />%1", _this ];
	[ _msg ] call T8U_fnc_BroadcastHint;
	false 
};

_trigger = createTrigger [ "EmptyDetector", ( getMarkerPos _marker ) ];
_trigger setTriggerActivation [ _actSide, _actType, _actRepeat ];
_trigger setTriggerArea [ _distance, _distance, 0, false ];
_trigger setTriggerStatements [ _condition, _onActCompiled, _onDeAct ];
_trigger setTriggerTimeout _timeout;

true
