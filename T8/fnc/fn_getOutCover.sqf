/*
 =======================================================================================================================

	T8 Units Script
	
	Funktion:	fn_getOutCover.sqf
	Author:		T-800a
	E-Mail:		t-800a@gmx.net

 =======================================================================================================================
*/

#include <..\MACRO.hpp>

private [ "_unit" ];

_unit		= param [ 0, objNull, [objNull]];

if ( T8U_var_DEBUG ) then { [ "fn_getOutCover.sqf", "INIT", _this ] spawn T8U_fnc_DebugLog; };

if ( isNull _unit ) exitWith { false };

_unit setUnitPos "UP";
_unit setUnitPos "AUTO";
_unit forceSpeed -1;
_unit switchMove "";

// Return
true
