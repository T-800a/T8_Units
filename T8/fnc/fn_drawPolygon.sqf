/*
 =======================================================================================================================

	T8 Units Script
	
	Funktion:	fn_drawPolygon.sqf
	Author:		T-800a
	E-Mail:		t-800a@gmx.net
	
	if ( T8U_var_DEBUG ) then { [ "fn_drawPolygon.sqf", "some msg", [ _varstoshare ] ] spawn T8U_fnc_DebugLog; };
	if ( T8U_var_DEBUG AND { T8U_var_DEBUG_marker } ) then { [ getPos _unitCaller, "ICON", "mil_start_noShadow", 1, "ColorBlack", 0.33 ] call T8U_fnc_DebugMarker; };
	
	
	
	marker "creation" by ACE3 | ace3mod.com

 =======================================================================================================================
*/

#include <..\MACRO.hpp>

private [ "_positions" ];
_positions		= param [ 0, [], [[]]];

if ( T8U_var_DEBUG ) then { [ "fn_drawPolygon.sqf", "INIT", [ _positions ]] spawn T8U_fnc_DebugLog; };
if ( count _positions < 3 ) exitWith { if ( T8U_var_DEBUG ) then { [ "fn_drawPolygon.sqf", "EXIT: not enough points", [ _positions ]] spawn T8U_fnc_DebugLog; }; false }; 

{
	private [ "_iA", "_iB", "_startPos", "_endPos", "_name", "_marker", "_difPos", "_mag"];
	
	_iA	= _forEachIndex;
	_iB	= _forEachIndex + 1;
	
	if ( _iB isEqualTo ( count _positions )) then { _iB = 0; };
	
	_startPos	= _positions select _iA;
	_endPos		= _positions select _iB;
	_name		= format [ "%1-%2_%3", _startPos, _endPos, diag_tickTime ];
	
	_difPos = _endPos vectorDiff _startPos;
	_marker = createMarkerLocal [_name, _startPos];
	_name setMarkerShapeLocal "RECTANGLE";
	_name setMarkerAlphaLocal 1;
	_name setMarkerColorLocal "ColorOrange";
	_name setMarkerPosLocal ( _startPos vectorAdd ( _difPos vectorMultiply 0.5 ));
	_mag = vectorMagnitude _difPos;
	if ( _mag > 0 ) then 
	{
		_name setMarkerSizeLocal [ 10, _mag / 2 ];
		_name setMarkerDirLocal ( 180 + ( _difPos select 0 ) atan2 ( _difPos select 1 ) mod 360 );
	} else {
		_name setMarkerSizeLocal [ 5, 5 ];
		_name setMarkerDirLocal 0;
	};

} forEach _positions;






