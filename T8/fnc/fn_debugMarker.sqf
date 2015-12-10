/*
 =======================================================================================================================

	T8 Units Script
	
	Funktion:	fn_debugMarker.sqf
	Author:		T-800a
	E-Mail:		t-800a@gmx.net

	Return:		_markerName / Name of the Marker
	
	_mkr = [ _mp (, _ms, _mt, _mg, _mc, _mtxt) ] call T8U_fnc_DebugMarker;
	_mkr = [ _mp, "ICON", "mil_dot", 1, "ColorBlack", " There it is!") ] call T8U_fnc_DebugMarker;
	
 =======================================================================================================================
*/

#include <..\MACRO.hpp>

if ( !T8U_var_DEBUG_marker ) exitWith {};

private [ "_mp", "_ms", "_mt", "_mg", "_mc", "_ma", "_mtxt", "_m", "_mn", "_t" ];

_mp		= param [ 0, [], [[]]];

if ( count _mp < 2 ) exitWith {};

_t		= if ( time > 10 ) then { time } else { ceil ( random 10 )};

_ms		= param [ 1, "ICON", [""]];
_mt		= param [ 2, "waypoint", [""]];
_mg		= param [ 3, 1, [123]];
_mc		= param [ 4, "ColorBlack", [""]];
_ma		= param [ 5, 0.66, [123]];
_mtxt	= param [ 6, "", [""]] ;

_mn = format ["dM_%1_%2", _mp, ( random _t ) ]; 
_m = createMarker [ _mn, _mp ]; 
_m setMarkerShape _ms;
_m setMarkerType _mt;
_m setMarkerSize [ _mg, _mg ];
_m setMarkerColor _mc;
_m setMarkerAlpha _ma;
_m setMarkerText _mtxt;

T8U_var_DebugMarkerCache pushBack [ _m, _t ];

// Return
_mn
