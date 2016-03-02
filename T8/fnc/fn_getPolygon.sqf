/*
 =======================================================================================================================

	T8 Units Script
	
	Funktion:	fn_getPolygon.sqf
	Author:		T-800a
	E-Mail:		t-800a@gmx.net
	
	if ( T8U_var_DEBUG ) then { [ "fn_getPolygon.sqf", "some msg", [ _varstoshare ] ] spawn T8U_fnc_DebugLog; };
	if ( T8U_var_DEBUG AND { T8U_var_DEBUG_marker } ) then { [ getPos _unitCaller, "ICON", "mil_start_noShadow", 1, "ColorBlack", 0.33 ] call T8U_fnc_DebugMarker; };

 =======================================================================================================================
*/

#include <..\MACRO.hpp>

private [ "_logic", "_return" ];

_logic		= param [ 0, objNull, [ objNull ]];
_return		= [];

if ( T8U_var_DEBUG ) then { [ "fn_getPolygon.sqf", "INIT", [ _this ]] spawn T8U_fnc_DebugLog; };
if ( isNull _logic ) exitWith { if ( T8U_var_DEBUG ) then { [ "fn_getPolygon.sqf", "EXIT", []] spawn T8U_fnc_DebugLog; }; false };

private _syncObjs = synchronizedObjects _logic;

if ( T8U_var_DEBUG ) then { [ "fn_getPolygon.sqf", "_syncObjs", [ _syncObjs ]] spawn T8U_fnc_DebugLog; };

if ( count _syncObjs < 2 ) exitWith { if ( T8U_var_DEBUG ) then { [ "fn_getPolygon.sqf", "EXIT: not enough waypoints", [ _syncObjs ]] spawn T8U_fnc_DebugLog; }; false }; 

_return pushBack [(( getPos _logic ) select 0 ), (( getPos _logic ) select 1 ), 0 ];

{
	private [ "_wpos" ];
	_wpos = getPos _x;
	_return pushBack [( _wpos select 0 ), ( _wpos select 1 ), 0 ];
	false
} count _syncObjs;

if ( T8U_var_DEBUG ) then { [ _return ] spawn T8U_fnc_drawPolygon; [ _return ] spawn T8U_fnc_findExtreme; };

// return
_return
