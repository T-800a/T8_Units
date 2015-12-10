/*
 =======================================================================================================================

	T8 Units Script
	
	Funktion:	fn_inBuilding.sqf
	Author:		T-800a
	E-Mail:		t-800a@gmx.net
	
	if ( T8U_var_DEBUG ) then { [ ".sqf", "some msg", [ _varstoshare ] ] spawn T8U_fnc_DebugLog; };
	if ( T8U_var_DEBUG AND { T8U_var_DEBUG_marker } ) then { [ getPos _unitCaller, "ICON", "mil_start_noShadow", 1, "ColorBlack", 0.33 ] call T8U_fnc_DebugMarker; };

=======================================================================================================================
*/

#include <..\MACRO.hpp>

private [ "_unit", "_return", "_b", "_p1", "_p2" ];

_unit		= param [ 0, [], [[],objNull]];
_return		= false;

if ( T8U_var_DEBUG ) then { [ "fn_inBuilding.sqf", "INIT", _this ] spawn T8U_fnc_DebugLog; };

_b = nearestBuilding _unit;

if ( isNull _b OR { _unit distance _b > 50 }) exitWith { false };

_p1 = eyePos _unit;
_p2 = [( _p1 select 0 ), ( _p1 select 1 ), (( _p1 select 2 ) + 10 )];

if ( lineIntersects [ _p1, _p2, _unit ] ) then { _return = true; if ( T8U_var_DEBUG ) then { [ "fn_inBuilding.sqf", "IS IN BUILDING", _unit ] spawn T8U_fnc_DebugLog; }; };

//
_return
