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

private [ "_logic", "_return", "_waypoints" ];

_logic		= param [ 0, objNull, [ objNull ]];
_return		= [];

if ( T8U_var_DEBUG ) then { [ "fn_getPolygon.sqf", "INIT", [ _this ]] spawn T8U_fnc_DebugLog; };
if ( isNull _logic ) exitWith { if ( T8U_var_DEBUG ) then { [ "fn_getPolygon.sqf", "EXIT", []] spawn T8U_fnc_DebugLog; }; false };


_waypoints = waypoints _logic;
if ( T8U_var_DEBUG ) then { [ "fn_getPolygon.sqf", "_waypoints", [ _waypoints ]] spawn T8U_fnc_DebugLog; };

if ( count _waypoints < 3 ) exitWith { if ( T8U_var_DEBUG ) then { [ "fn_getPolygon.sqf", "EXIT: not enough waypoints", [ _waypoints ]] spawn T8U_fnc_DebugLog; }; false }; 

{
	private [ "_wpos" ];
	_wpos = waypointPosition _x;
	_return pushBack [( _wpos select 0 ), ( _wpos select 1 ), 0 ];
	false
} count _waypoints;

if ( T8U_var_DEBUG ) then { [ _return ] spawn T8U_fnc_drawPolygon; [ _return ] spawn T8U_fnc_findExtreme; };

// return
_return
