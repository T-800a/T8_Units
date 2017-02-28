/*
 =======================================================================================================================

	T8 Units Script

	Funktion:	fn_createSpawnPos.sqf
	Author:		T-800a
	E-Mail:		t-800a@gmx.net

 =======================================================================================================================
*/

if !(isServer) exitWith {};

#include <..\MACRO.hpp>

private [ "_playerDir", "_objectPos", "_object", "_debug", "_minDis", "_n", "_range", "_startPos" ];

params [
	[ "_marker", [0,0,0], [ "", []]]
];

if ( _marker isEqualTo [0,0,0] ) exitWith { if ( T8U_var_DEBUG ) then { [ "fn_createSpawnPos.sqf", "Can't create SpawnPos" ] spawn T8U_fnc_DebugLog; }; false };

_range = 50;
_startPos = [0,0,0];
if (( typeName _marker ) isEqualTo ( typeName "STR" )) then {
	if (( getMarkerPos _marker ) isEqualTo [0,0,0]) exitWith { if ( T8U_var_DEBUG ) then { [ "fn_createSpawnPos.sqf", "Can't create SpawnPos" ] spawn T8U_fnc_DebugLog; }; false };
	
	_areaSizeX		= ( getMarkerSize _marker ) select 0;
	_areaSizeY		= ( getMarkerSize _marker ) select 1;
	_range		= if ((( _areaSizeX + _areaSizeY ) / 2 ) < 150 ) then { 50 } else {(( _areaSizeX + _areaSizeY ) / 2 ) / 3 };
	_startPos = getMarkerPos _marker;
} else {
    _startPos = _marker;
};

_objectPos = [];
_n = 1;
_minDis = 20;

while { count _objectPos < 1 } do
{
	private [ "_relPos", "_tmpPos", "_roadPos", "_roadObj" ];

	// find a relative location in a random 360 radius from given marker
	_relPos = [ _startPos , random _range, random 360 ] call BIS_fnc_relPos;
	
	// try and put the position on the nearest road like it was in the old createSpawnPos
	_roadObj = [ _relPos, 50 ] call BIS_fnc_nearestRoad;
	if ( !isNull _roadObj ) then {
		_relPos = getPos _roadObj; 	
	};
	
	// try and find an empty position
	_tmpPos = _relPos findEmptyPosition [ 5, 50, "Land_VR_Block_02_F" ];

	// check if the empty position isn't in the water or has any closeby object 
	// that could cause the unit to spawn inside
	if ( 	count _tmpPos > 1
			&& { !surfaceIsWater _tmpPos }
			&& { ( _tmpPos distance ( nearestObject _tmpPos )) > _minDis }) then { 
		_objectPos = _tmpPos; 
	};

	// the longer we attempt to find a valid location decrease the allowed distance
	// of a nearby object that could prevent spawning, exit the function when we are past
	// 500 tries
	if ( _n isEqualTo 300 ) then { _minDis = 10; };
	if ( _n isEqualTo 400 ) then { _minDis = 1; };
	if ( _n > 500 ) exitWith {};
	
	// increase the amount of tries to search for a random location
	_n = _n + 1;
};

__DEBUG( __FILE__, "_n", _n );
__DEBUG( __FILE__, "_minDis", _minDis );
__DEBUG( __FILE__, "_objectPos", _objectPos );

// return position
if ( count _objectPos > 1 ) exitWith { 
	_objectPos = [_objectPos, 1, 150, 3, 0, 20, 0] call BIS_fnc_findSafePos;
	_objectPos 
};

// or bool
false