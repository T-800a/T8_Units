/*
 =======================================================================================================================

	T8 Units Script

	Funktion:	fn_restartFiredEvent.sqf
	Author:		T-800a
	E-Mail:		t-800a@gmx.net

 =======================================================================================================================
*/

#include <..\MACRO.hpp>

private [ "_unit" ];

_unit = _this select 0;

sleep T8U_var_FiredEventTimeout;

if ( alive _unit ) then
{
	_unit addEventHandler ["FiredNear", { [ _this ] call T8U_fnc_FiredEvent; }];
	if ( T8U_var_DEBUG ) then { [ "fn_restartFiredEvent.sqf", "RESTART", [ _unit ] ] spawn T8U_fnc_DebugLog; };
} else {
	if ( T8U_var_DEBUG ) then { [ "fn_restartFiredEvent.sqf", "RESTART FAILED", [ _unit ] ] spawn T8U_fnc_DebugLog; }; 
};
