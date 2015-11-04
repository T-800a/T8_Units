/*
 =======================================================================================================================

	T8 Units Script
	
	Funktion:	fn_findExtreme.sqf
	Author:		T-800a
	E-Mail:		t-800a@gmx.net
	
	if ( T8U_var_DEBUG ) then { [ "fn_findExtreme.sqf", "some msg", [ _varstoshare ] ] spawn T8U_fnc_DebugLog; };
	if ( T8U_var_DEBUG AND { T8U_var_DEBUG_marker } ) then { [ getPos _unitCaller, "ICON", "mil_start_noShadow", 1, "ColorBlack", 0.33 ] call T8U_fnc_DebugMarker; };
	
	
	
	marker "creation" by ACE3 | ace3mod.com

 =======================================================================================================================
*/

#include <..\MACRO.hpp>

private [ "_positions", "_xCoordinates", "_yCoordinates", "_xMin", "_xMax", "_yMin", "_yMax", "_return" ];
_positions		= param [ 0, [], [[]]];

if ( T8U_var_DEBUG ) then { [ "fn_findExtreme.sqf", "INIT", [ _positions ]] spawn T8U_fnc_DebugLog; };
if ( count _positions < 3 ) exitWith { if ( T8U_var_DEBUG ) then { [ "fn_findExtreme.sqf", "EXIT: not enough points", [ _positions ]] spawn T8U_fnc_DebugLog; }; false }; 

_xCoordinates = [];
_yCoordinates = [];

{
	_xCoordinates pushback ( _x select 0 );
	_yCoordinates pushback ( _x select 1 );
	
	false
} count _positions;

_xMin = _xCoordinates select 0;
_xMax = _xCoordinates select 0;
{ _xMin = _xMin min _x; false } count _xCoordinates;
{ _xMax = _xMax max _x; false } count _xCoordinates;

_yMin = _yCoordinates select 0;
_yMax = _yCoordinates select 0;
{ _yMin = _yMin min _x; false } count _yCoordinates;
{ _yMax = _yMax max _x; false } count _yCoordinates;

_return = [[ _xMin, _yMin ], [ _xMax, _yMax ]];

if ( T8U_var_DEBUG ) then { [ "fn_findExtreme.sqf", "RETURN", [ _return ]] spawn T8U_fnc_DebugLog; };
// if ( T8U_var_DEBUG AND { T8U_var_DEBUG_marker } ) then { [[ _xMin, _yMin ], "ICON", "mil_dot" ] call T8U_fnc_DebugMarker; [[ _xMax, _yMax ], "ICON", "mil_dot" ] call T8U_fnc_DebugMarker; };

// return
_return
