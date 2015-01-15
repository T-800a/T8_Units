/*
 =======================================================================================================================

	T8 Units Script

	Funktion:	fn_triggerSpawn.sqf
	Author:		T-800a
	E-Mail:		t-800a@gmx.net

	[ _unitsArray, _marker, _distance, _condition, _actSide, _actType, _actRepeat, _onAct, _onDeAct ] call T8U_fnc_TriggerSpawn;
	
 =======================================================================================================================
*/

private [ "_unitsArray", "_marker", "_distance", "_actSide", "_actType", "_onAct", "_onDeAct", "_condition", "_trigger" ];

_unitsArray = [ _this, 0, "NO-UNITS-SET" ] call BIS_fnc_param;
_marker = [ _this, 1, "NO-MARKER-SET" ] call BIS_fnc_param;
_distance = [ _this, 2, 1000 ] call BIS_fnc_param;
_condition = [ _this, 3, "this" ] call BIS_fnc_param;
_actSide = [ _this, 4, "ANY" ] call BIS_fnc_param;
_actType = [ _this, 5, "PRESENT" ] call BIS_fnc_param;
_actRepeat = [ _this, 6, false ] call BIS_fnc_param;
_onAct = [ _this, 7, "" ] call BIS_fnc_param;
_onDeAct = [ _this, 8, "" ] call BIS_fnc_param;

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

true
