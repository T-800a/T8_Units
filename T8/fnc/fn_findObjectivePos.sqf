/*
 =======================================================================================================================
	SME.Gen - Small Military Encounter Genenerator=
	SERVER
	File:		fn_findObjectivePos.sqf
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

if ( _marker isEqualTo [0,0,0] ) exitWith { if ( T8U_var_DEBUG ) then { [ "fn_findObjectivePos.sqf", "Can't create SpawnPos" ] spawn T8U_fnc_DebugLog; }; false };

_range = 50;
_startPos = [0,0,0];
if (( typeName _marker ) isEqualTo ( typeName "STR" )) then {
	if (( getMarkerPos _marker ) isEqualTo [0,0,0]) exitWith { if ( T8U_var_DEBUG ) then { [ "fn_findObjectivePos.sqf", "Can't create SpawnPos" ] spawn T8U_fnc_DebugLog; }; false };
	
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
	private [ "_relPos", "_tmpPos" ];

	_relPos = [ _startPos , random _range, random 360 ] call BIS_fnc_relPos;
	_tmpPos = _relPos findEmptyPosition [ 5, 50, "Land_VR_Block_02_F" ];

	if ( 	count _tmpPos > 1
			&& { !isOnRoad _tmpPos }
			&& { !surfaceIsWater _tmpPos }
			&& { ( _tmpPos distance ( nearestObject _tmpPos )) > _minDis }
	) then { _objectPos = _tmpPos; };

	if ( _n isEqualTo 300 ) then { _minDis = 10; };
	if ( _n isEqualTo 400 ) then { _minDis = 1; };
	if ( _n > 500 ) exitWith {};
	_n = _n + 1;
};

__DEBUG( __FILE__, "_n", _n );
__DEBUG( __FILE__, "_minDis", _minDis );
__DEBUG( __FILE__, "_objectPos", _objectPos );

// return position
if ( count _objectPos > 1 ) exitWith { _objectPos };

// or bool
false