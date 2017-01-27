/*
 =======================================================================================================================

	T8 Units Script
	
	Funktion:	fn_checkOutside.sqf
	Author:		T-800a
	E-Mail:		t-800a@gmx.net
	
	if ( T8U_var_DEBUG ) then { [ "fn_checkOutside.sqf", "some msg", [ _varstoshare ] ] spawn T8U_fnc_DebugLog; };
	if ( T8U_var_DEBUG AND { T8U_var_DEBUG_marker } ) then { [ getPos _unitCaller, "ICON", "mil_start_noShadow", 1, "ColorBlack", 0.33 ] call T8U_fnc_DebugMarker; };

 =======================================================================================================================
*/

#include <..\MACRO.hpp>

params [[ "_pos", [], [[]]]];

private _posGroundASL	= ATLToASL [( _pos select 0 ), ( _pos select 1 ), 2 ];
private _posSkyASL		= ATLToASL [( _pos select 0 ), ( _pos select 1 ), 50 ];

private _return = lineIntersects [ _posGroundASL, _posSkyASL ];

// Return
_return
