/*
 =======================================================================================================================

	T8 Units Script
	
	Funktion:	fn_getCoverPos.sqf
	Author:		T-800a
	E-Mail:		t-800a@gmx.net ( thanks to  fabrizio_T for the hint on how to find cover )

 =======================================================================================================================
*/

#include <..\MACRO.hpp>

private [ "_pos", "_range", "_cObj", "_rm", "_rmR", "_cover", "_coverPos", "_watchPos", "_dir", "_cm" ];

_pos		= param [ 0, [0,0,0], [[]], [2,3]];
_range		= param [ 1, 40, [123]];

if ( _range < 40 ) then { _range = 40; };

if ( T8U_var_DEBUG ) then { [ "fn_getCoverPos.sqf", "INIT", _this ] spawn T8U_fnc_DebugLog; };

if ( _pos isEqualTo [0,0,0] ) exitWith { false };

_cObj = nearestObjects [ _pos, [], _range ];
_rm = nearestObjects [ _pos, [ "HOUSE", "AllVehicles" ], _range ];
_rmR = _pos nearRoads _range;
_cObj = _cObj - _rm - _rmR;

_cover = [];

{ 
	private [ "_bbr", "_p1", "_p2", "_maxWidth", "_maxLength", "_maxHeight", "_name" ];
    _bbr = boundingBoxReal _x; 
	_p1 = _bbr select 0; 
	_p2 = _bbr select 1; 
	_maxWidth = abs ((_p2 select 0) - (_p1 select 0)); 
	_maxLength = abs ((_p2 select 1) - (_p1 select 1)); 
	_maxHeight = abs ((_p2 select 2) - (_p1 select 2));
	if ( _maxWidth > 2.0 AND { _maxLength > 0.5 } AND { _maxHeight > 1.0 } AND { _maxLength < 5.0 } AND { _maxHeight < 10.0 } AND { _pos distance _x > 2 } ) then
	{
		_cover pushBack _x;
	};
} forEach _cObj;

if ( T8U_var_DEBUG ) then { [ "fn_getInCover.sqf", "COVER", [ _cover ] ] spawn T8U_fnc_DebugLog; };

// Return
_cover
