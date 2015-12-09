/*
 =======================================================================================================================

	T8 Units Script
	
	Funktion:	fn_getInCover.sqf
	Author:		T-800a
	E-Mail:		t-800a@gmx.net ( thanks to  fabrizio_T for the hint on how to find cover )

 =======================================================================================================================
*/

#include <..\MACRO.hpp>

private [ "_unit", "_marker", "_coverArray", "_cover", "_cObj", "_rm", "_rmR", "_coverPos", "_watchPos", "_dir", "_cm" ];

_unit		= param [ 0, objNull, [objNull]];
_marker		= param [ 1, "", [""]];

if ( T8U_var_DEBUG ) then { [ "fn_getInCover.sqf", "INIT", _this ] spawn T8U_fnc_DebugLog; };

if ( isNull _unit ) exitWith { false };

doStop _unit;
_watchPos = getPos _unit;

if !( _marker isEqualTo "" ) then 
{
	_size = if ((( getMarkerSize _marker ) select 0 ) < (( getMarkerSize _marker ) select 1 )) then { ( getMarkerSize _marker ) select 0 } else { ( getMarkerSize _marker ) select 1 };
	_coverArray = [ _watchPos, _size ] call T8U_fnc_GetCoverPos;
} else {
	_coverArray = [ _watchPos ] call T8U_fnc_GetCoverPos;
};

if ( T8U_var_DEBUG ) then { [ "fn_getInCover.sqf", "COVER", [ _coverArray ] ] spawn T8U_fnc_DebugLog; };

if ( count _coverArray > 0 ) then 
{
	_cover = _coverArray call BIS_fnc_selectRandom;
	_coverPos = getPos _cover;
	_coverPos = [ ( _coverPos select 0 ), ( _coverPos select 1 ), 0 ];
	
	if ( T8U_var_DEBUG ) then 
	{ 
		_a = "Sign_Arrow_Blue_F" createVehicle _coverPos;
		_a setPosATL [ ( _coverPos select 0 ), ( _coverPos select 1 ), 2 ];
	};

	[ _unit, _coverPos, true ] call T8U_fnc_MoveToPos;
};

if ( side _unit == CIVILIAN ) then 
{
	doStop _unit;
	_unit forceSpeed 0;
	_unit disableAI "MOVE";
} else {
	doStop _unit;
	_unit setUnitPos "Middle";
	if ( count _coverArray > 0 ) then { _unit doWatch _watchPos; };
};

if ( T8U_var_DEBUG ) then { [ "fn_getInCover.sqf", "DONE" ] spawn T8U_fnc_DebugLog; };

// Return
true
