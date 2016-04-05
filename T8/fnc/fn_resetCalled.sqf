/*
 =======================================================================================================================

	T8 Units Script

	Funktion:	fn_resetCalled.sqf
	Author:		T-800a
	E-Mail:		t-800a@gmx.net

 =======================================================================================================================
*/

#include <..\MACRO.hpp>

private [ "_unit", "_time" ];

_unit = param [ 0, objNull, [objNull]];
_time = param [ 1, 0, [123]];

sleep ( T8U_var_CallForHelpTimeout + _time );

if ( T8U_var_DEBUG ) then { [ "fn_resetCalled.sqf", "INIT", _this ] spawn T8U_fnc_DebugLog; };

if ( !alive _unit OR { isNull _unit } ) exitWith {};

if ( T8U_var_DEBUG ) then { [ "fn_resetCalled.sqf", "RESET", [ _unit ] ] spawn T8U_fnc_DebugLog; };

group _unit setVariable [ "T8U_gvar_Called", -99999, false ];
