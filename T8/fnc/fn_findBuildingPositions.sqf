/*
 =======================================================================================================================

	T8 Units Script
	
	Funktion:	fn_findBuildingPositions.sqf
	Author:		T-800a
	E-Mail:		t-800a@gmx.net
	
	Inspired by Zapat:
	https://forums.bistudio.com/topic/159352-set-a-unit-to-look-out-of-window-function/?p=2544740
	https://forums.bistudio.com/topic/159352-set-a-unit-to-look-out-of-window-function/?p=2545329
	
 =======================================================================================================================
*/

#include <..\MACRO.hpp>

params [
	[ "_building", objNull, [objNull]]
];

__DEBUG( __FILE__, "INIT", _this );
if ( isNull _building ) exitWith { false };

private _buildingPosArray	= [];
private _returnPosArray		= [];
private _return				= [];
private _buildingDir		= getDir _building;

if !( __GetOVAR( _building, "occupied", false )) then
{
	private _loop = true;
	private _n = 0;

	while { _loop } do
	{
		if !(( _building buildingPos _n ) isEqualTo [0,0,0] ) then { _buildingPosArray pushBack ( _building buildingPos _n ); } else { _loop = false; };
		_n = _n + 1;
	};
};

__DEBUG( __FILE__, "_buildingPosArray", _buildingPosArray );
{
	private _pos = _x;
	private _start = ATLToASL [( _pos select 0 ), ( _pos select 1 ), (( _pos select 2 ) +  1.2 )];
	private _above = ATLToASL [( _pos select 0 ), ( _pos select 1 ), (( _pos select 2 ) + 20.0 )];
	
	private _dis = 0;
	private _use = [];
	
	if ( lineIntersects [ _start, _above ]) then
	{
		{
			private _dir = ( _buildingDir + _x );
			private _end = [(( _start select 0 ) + sin _dir * 10 ), ((_start select 1) + cos _dir * 10 ), ( _start select 2 )];

			if !( lineIntersects [ _start, _end ]) then
			{
				if (( _end distance2D ( getPos _building )) > _dis ) then { _use = [ _pos, _dir, [ _end select 0, _end select 1, 0 ]]; _dis = ( _end distance2D ( getPos _building )); };
			};
			
			false
		} count [ 0, 90, 180, 270 ];

		if (( count _use ) > 0 ) then { _returnPosArray pushBack _use; };
	};
	
	false
} count _buildingPosArray;

_returnPosArray = _returnPosArray call BIS_fnc_arrayShuffle;
__DEBUG( __FILE__, "_returnPosArray", _returnPosArray );

if ( count _returnPosArray > 6 ) then { _returnPosArray resize 6; };

_return = if (( count _returnPosArray ) > 1 ) then { [ _building, _returnPosArray ] } else { false };


// return
_return
