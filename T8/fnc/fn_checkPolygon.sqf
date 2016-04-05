/*
 =======================================================================================================================

	T8 Units Script
	
	Funktion:	fn_checkPolygon.sqf
	Author:		T-800a
	E-Mail:		t-800a@gmx.net
	
	if ( T8U_var_DEBUG ) then { [ "fn_checkOutside.sqf", "some msg", [ _varstoshare ] ] spawn T8U_fnc_DebugLog; };
	if ( T8U_var_DEBUG AND { T8U_var_DEBUG_marker } ) then { [ getPos _unitCaller, "ICON", "mil_start_noShadow", 1, "ColorBlack", 0.33 ] call T8U_fnc_DebugMarker; };

 =======================================================================================================================
*/

#include <..\MACRO.hpp>

private [ "_pos", "_pol", "_return", "_posX", "_posY", "_n" ];

_pos		= _this select 0;
_pol		= _this select 1;

_return		= false;
_posX		= _pos select 0;
_posY		= _pos select 1;

// if ( T8U_var_DEBUG ) then { [ "fn_checkPolygon.sqf", "( count _pol )", [ ( count _pol ) ]] call T8U_fnc_DebugLog; };

{
	private [ "_aX", "_aY", "_bX", "_bY", "_n" ];
	
	if ( _forEachIndex isEqualTo 0 ) then { _n = ( count _pol ) - 1; } else { _n = ( _forEachIndex ) - 1;  };
	
	_aX = _pol select _forEachIndex select 0;
	_aY = _pol select _forEachIndex select 1;
	
	_bX = _pol select _n select 0;
	_bY = _pol select _n select 1;
	
	/*
	if ( T8U_var_DEBUG ) then { [ "fn_checkPolygon.sqf", "_forEachIndex", [ _forEachIndex ]] call T8U_fnc_DebugLog; };
	if ( T8U_var_DEBUG ) then { [ "fn_checkPolygon.sqf", "_n", [ _n ]] call T8U_fnc_DebugLog; };
	if ( T8U_var_DEBUG ) then { [ "fn_checkPolygon.sqf", "_posX", [ _posX ]] call T8U_fnc_DebugLog; };
	if ( T8U_var_DEBUG ) then { [ "fn_checkPolygon.sqf", "_posY", [ _posY ]] call T8U_fnc_DebugLog; };	
	if ( T8U_var_DEBUG ) then { [ "fn_checkPolygon.sqf", "_aX", [ _aX ]] call T8U_fnc_DebugLog; };
	if ( T8U_var_DEBUG ) then { [ "fn_checkPolygon.sqf", "_aY", [ _aY ]] call T8U_fnc_DebugLog; };
	if ( T8U_var_DEBUG ) then { [ "fn_checkPolygon.sqf", "_bX", [ _bX ]] call T8U_fnc_DebugLog; };
	if ( T8U_var_DEBUG ) then { [ "fn_checkPolygon.sqf", "_bY", [ _bY ]] call T8U_fnc_DebugLog; };
	*/
	
	if (!(( _aY > _posY ) isEqualTo ( _bY > _posY )) AND ( _posX < ((( _bX - _aX ) * ( _posY - _aY )) / ( _bY - _aY )) + _aX )) then { _return = !_return; };

		
} forEach _pol;


// Return
_return
