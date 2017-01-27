/*
 =======================================================================================================================

	T8 Units Script

	Funktion:	fn_occupyBuildings.sqf
	Author:		T-800a
	E-Mail:		t-800a@gmx.net

 =======================================================================================================================
*/

#include <..\MACRO.hpp>

private [ "_range", "_pos", "_units" ];

params [
	[ "_leader", objNull, 		[objNull]],
	[ "_marker", "NO-MARKER",	["",[]],[2,3]],
	[ "_immobile", false, [true]]
];

__DEBUG( __FILE__, "INIT", _this );
if ( isNull _leader ) exitWith {[]};
if (( typeName _marker ) isEqualTo ( typeName "STR" ) AND { _marker isEqualTo "NO-MARKER" }) exitWith {[]};

private _group			= group _leader;
private _side			= side _leader;
private _units			= units _group;
private _unitsRelease	= units _group;

if ( typeName _marker == typeName "STR" ) then
{
	private _areaSizeX	= ( getMarkerSize _marker ) select 0;
	private _areaSizeY	= ( getMarkerSize _marker ) select 1;
	_range				= ( _areaSizeX + _areaSizeY ) / 2; if ( _range < 50 ) then { _range = 50; };
	_pos				= getMarkerPos _marker;
	
} else {
	_range				= 50;
	_pos				= _marker;
};

if ( !(( count _units ) > 0 ) OR { _pos isEqualTo [ 0, 0, 0 ] }) exitWith { _units };

private _buildings			= _pos nearObjects [ "House", _range ];
private _buildingsUsed		= [];
private _buildingPositions	= [];
private _moveAround			= [];

_buildings = _buildings call BIS_fnc_arrayShuffle;
__DEBUG( __FILE__, "_buildings", _buildings );

{
	if (!( __GetOVAR( _x, "occupied", false )) AND { !(( typeOf _x ) in T8U_var_ignoredBuildings )}) then
	{
		private _temp = [ _x ] call T8U_fnc_findBuildingPositions;
		
		if (( typeName _temp ) isEqualTo ( typeName [] )) then
		{
			_buildingPositions pushBack _temp;
		};
	};

	false
} count _buildings;

__DEBUG( __FILE__, "_buildingPositions", _buildingPositions );

if (( count _buildingPositions ) > 0 ) then 
{
	{
		private _b	= _x select 0;
		private _pA	= _x select 1;

		__DEBUG( __FILE__, "_buildingPositions > _x", _x );
		
		{
			if (( count _units ) > 0 ) then 
			{
				private _p	= _x select 0;
				private _d	= _x select 1;
				private _w	= _x select 2;

				_unit = _units call BIS_fnc_arrayPop;
				[ _unit, _p, false, _d, _w, _immobile ] spawn T8U_fnc_MoveToPos;
				
				__SetOVAR( _b, "occupied", true );
				_buildingsUsed pushBack _b;
				
				__DEBUG( __FILE__, "_buildingPositions > _pA > _x", _x );
			};

			false
		} count _pA;

		false
	} count _buildingPositions;
};


// waiting for group to get a new task
waitUntil { sleep 2; [( group _leader )] call T8U_fnc_ReleaseGroup };

__DEBUG( __FILE__, "END OCCUPY > _immobile", _immobile );

if ( _immobile ) then
{
	{ if !( isNull _x ) then { _x enableAI "MOVE"; }; false } count _unitsRelease;
};

// remove occupation
{ __SetOVAR( _x, "occupied", false ); false } count _buildingsUsed;

