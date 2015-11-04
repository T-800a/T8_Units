/*
 =======================================================================================================================

	T8 Units Script
	
	Funktion:	fn_findEmptyPos.sqf
	Author:		T-800a
	E-Mail:		t-800a@gmx.net

 =======================================================================================================================
*/

#include <..\MACRO.hpp>


params [
	[ "_p",			[0,0,0],				[[]]],
	[ "_d",			100,					[123]],
	[ "_r",			false,					[true]],
	[ "_road",		objNull ],
	[ "_return",	[] ],
	[ "_range",		10 ]
];

if ( _r ) then { _road = [ _p, ( _d / 4 ) ] call BIS_fnc_nearestRoad; _range = 100; };

if ( !isNull _road  ) then 
{
	_return = ( getpos _road );
} else {
	_return = _p findEmptyPosition [ 1, _range, "Land_VR_Block_02_F" ];
};

if ( isNil "_return" OR { _return isEqualTo [0,0,0] }) then { _return = []; };

// return
_return
