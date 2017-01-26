/*
 =======================================================================================================================

	T8 Units Script

	Funktion:	fn_createSpawnPos.sqf
	Author:		T-800a
	E-Mail:		t-800a@gmx.net

 =======================================================================================================================
*/

#include <..\MACRO.hpp>

private [ "_areaSize", "_areaSizeX", "_areaSizeY", "_wpPosFEP", "_loop", "_tmpAreaSize", "_markerPos" ];

private _marker = param [ 0, [0,0,0], [ "", []]];

if ( _marker isEqualTo [0,0,0] ) exitWith { if ( T8U_var_DEBUG ) then { [ "fn_createSpawnPos.sqf", "Can't create SpawnPos" ] spawn T8U_fnc_DebugLog; }; false };

if (( typeName _marker ) isEqualTo ( typeName "STR" )) then 
{
	if (( getMarkerPos _marker ) isEqualTo [0,0,0]) exitWith { if ( T8U_var_DEBUG ) then { [ "fn_createSpawnPos.sqf", "Can't create SpawnPos" ] spawn T8U_fnc_DebugLog; }; false };
	
	_areaSizeX		= ( getMarkerSize _marker ) select 0;
	_areaSizeY		= ( getMarkerSize _marker ) select 1;
	_areaSize		= if ((( _areaSizeX + _areaSizeY ) / 2 ) < 150 ) then { 50 } else {(( _areaSizeX + _areaSizeY ) / 2 ) / 3 };
	_tmpAreaSize	= _areaSize;
	_markerPos		= getMarkerPos _marker;

} else {
	_areaSizeX		= 50;
	_areaSizeY		= 50;
	_areaSize		= 50;
	_tmpAreaSize	= 50;
	_markerPos		= _marker;
};

_wpPosFEP		= [];
_loop			= true;


while { _loop } do
{
	private [ "_spawnPos", "_roadObj", "_roadPos"];
	_spawnPos = [ _markerPos, random _tmpAreaSize, random 360 ] call BIS_fnc_relPos;
	_roadObj = [ _spawnPos, 50 ] call BIS_fnc_nearestRoad;
	if ( isNull _roadObj ) then { _roadPos = _spawnPos; } else {  _roadPos = getpos _roadObj; };
	_wpPosFEP =  _roadPos findEmptyPosition [ 1 , 50 , "Land_VR_Block_02_F" ]; // 20x20 block ... should be enough space for a Trooper
	if (( surfaceIsWater _roadPos OR (( count _wpPosFEP  ) < 2 ) AND {( _wpPosFEP distance ( nearestObject _wpPosFEP )) < 10 })) then { _tmpAreaSize = _tmpAreaSize + 5; } else { _loop = false; };
};

if ( T8U_var_DEBUG ) then { [ "fn_createSpawnPos.sqf", "SpawnPos", _wpPosFEP ] spawn T8U_fnc_DebugLog; };

// Return
_wpPosFEP
