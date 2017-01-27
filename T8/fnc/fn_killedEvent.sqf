/*
 =======================================================================================================================

	T8 Units Script

	Funktion:	fn_killedEvent.sqf
	Author:		T-800a
	E-Mail:		t-800a@gmx.net


	!!! FUNCTION OBSOLETE / OUTDATED !!!
	!!! FUNCTION OBSOLETE / OUTDATED !!!
	!!! FUNCTION OBSOLETE / OUTDATED !!!


 =======================================================================================================================
*/

#include <..\MACRO.hpp>

private [ "_eventArray", "_unit", "_group", "_t" ];
//  [unit, killer]

_eventArray = _this select 0;
_unit = _eventArray select 0;
_group = _unit getVariable "T8_UnitsVarLeaderGroup";

_unit removeAllEventHandlers "FiredNear";
_unit removeAllEventHandlers "Killed";

if ( T8U_var_DEBUG ) then { [ "fn_killedEvent.sqf", "INIT", _this ] spawn T8U_fnc_DebugLog; };
if ( T8U_var_DEBUG ) then { [ "fn_killedEvent.sqf", "Leader Killed: waiting for new leader" ] spawn T8U_fnc_DebugLog; };

if ( T8U_var_KilledLeaderTimeout < 10 ) then { _t = 10 } else { _t = T8U_var_KilledLeaderTimeout; };

// wait for AI to asign new leader ... sometimes it takes a few seconds
sleep _t;

if ( isNull _group ) exitWith { if ( T8U_var_DEBUG ) then { [ "fn_killedEvent.sqf", "NO LEADER FOUND" ] spawn T8U_fnc_DebugLog; }; };

if ( alive ( leader _group ) ) then
{
	leader _group setVariable [ "T8_UnitsVarLeaderGroup", group ( leader _group ), false ];
	leader _group addEventHandler [ "FiredNear", { [ _this ] call T8U_fnc_FiredEvent; } ];
	leader _group addEventHandler [ "Killed", { [ _this ] spawn T8U_fnc_KilledEvent; } ];
	
	// not going to happen anymore -> fn_handleGroups does this now
	// [ _group ] spawn T8U_fnc_OnFiredEvent;

	if ( T8U_var_DEBUG ) then { [ "fn_killedEvent.sqf", "New Leader:", [ ( leader _group ), _group ] ] spawn T8U_fnc_DebugLog; };
	
} else {

	if ( T8U_var_DEBUG ) then { [ "fn_killedEvent.sqf", "NO LEADER FOUND" ] spawn T8U_fnc_DebugLog; };

	// maybe some joinSilent other Group stuff here ...
};
