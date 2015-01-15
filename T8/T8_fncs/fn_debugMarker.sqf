/*
 =======================================================================================================================

	T8 Units Script
	
	Funktion:	fn_.sqf
	Author:		T-800a
	E-Mail:		t-800a@gmx.net

	Return:		_markerName / Name of the Marker
	
	_mkr = [ _mp (, _ms, _mt, _mg, _mc, _mtxt) ] call T8U_fnc_DebugMarker;
	_mkr = [ _mp, "ICON", "mil_dot", 1, "ColorBlack", " There it is!") ] call T8U_fnc_DebugMarker;
	
 =======================================================================================================================
*/

if ( !T8U_var_DEBUG_marker ) exitWith {};

private [ "_mp", "_ms", "_mt", "_mg", "_mc", "_ma", "_mtxt", "_m", "_mn" ];

_mp		= [ _this, 0, [], [[]] ] call BIS_fnc_param;

if ( count _mp < 2 ) exitWith {};

_ms		= [ _this, 1, "ICON", [""] ] call BIS_fnc_param;
_mt		= [ _this, 2, "waypoint", [""] ] call BIS_fnc_param;
_mg		= [ _this, 3, 1, [123] ] call BIS_fnc_param;
_mc		= [ _this, 4, "ColorBlack", [""] ] call BIS_fnc_param;
_ma		= [ _this, 5, 0.66, [123] ] call BIS_fnc_param;
_mtxt	= [ _this, 6, "", [""] ] call BIS_fnc_param;

_mn = format ["dM_%1_%2", _mp, ( random time ) ]; 
_m = createMarker [ _mn, _mp ]; 
_m setMarkerShape _ms;
_m setMarkerType _mt;
_m setMarkerSize [ _mg, _mg ];
_m setMarkerColor _mc;
_m setMarkerAlpha _ma;
_m setMarkerText _mtxt;

T8U_var_DebugMarkerCache pushBack [ _m, time ];

// Return
_mn
