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
	[ "_marker", "NO-MARKER",	["",[]],[2,3]]
];

__DEBUG( __FILE__, "INIT", _this );
if ( isNull _leader ) exitWith {[]};
if (( typeName _marker ) isEqualTo ( typeName "STR" ) AND { _marker isEqualTo "NO-MARKER" }) exitWith {[]};

private _group	= group _leader;
private _side	= side _leader;

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

// private _units = if ( _side isEqualTo CIVILIAN ) then { units ( group _leader )} else {( units ( group _leader )) - [ _leader ] };
private _units = units ( group _leader );


if ( !(( count _units ) > 0 ) OR { _pos isEqualTo [ 0, 0, 0 ] }) exitWith { _units };

private _buildingList		= _pos nearObjects [ "House", _range ];
private _buildingPosArray	= [];
private _moveAround			= [];
_buildingList				= _buildingList call BIS_fnc_arrayShuffle;
__DEBUG( __FILE__, "_buildingList", _buildingList );

{
	if !( _x getvariable [ "occupied", false ] ) then
	{
		private [ "_temp" ];
		_temp = [ _x ] call T8U_fnc_findBuildingPositions;
		if (( typeName _temp ) isEqualTo ( typeName [] )) then { _buildingPosArray pushBack _temp };
	};

	false
} count _buildingList;

__DEBUG( __FILE__, "_buildingPosArray", _buildingPosArray );

if (( count _buildingPosArray ) > 0 ) then 
{
	{
		private _b	= _x select 0;
		private _pA	= _x select 1;

		__DEBUG( __FILE__, "_buildingPosArray > _x", _x );
		
		{
			if (( count _units ) > 0 ) then 
			{
				private _p	= _x select 0;
				private _d	= _x select 1;
				private _w	= _x select 2;

				_unit = _units call BIS_fnc_arrayPop;
				[ _unit, _p, false, _d, _w ] spawn T8U_fnc_MoveToPos;
				_b setvariable [ "occupied", true, false ];
				
				__DEBUG( __FILE__, "_buildingPosArray > _pA > _x", _x );
			};

			false
		} count _pA;

		false
	} count _buildingPosArray;
};














/*

if (( count _units ) > 0 OR {( count _moveAround ) <= 19 } ) then
{
	private [ "_coverArray" ];
	_coverArray = [ _pos, _range ] call T8U_fnc_GetCoverPos;
	_coverArray = _coverArray call BIS_fnc_arrayShuffle;

	{
		if (( count _units ) > 0 ) then 
		{
			_unit = _units call BIS_fnc_arrayPop;
			[ _unit, _x, true ] spawn T8U_fnc_MoveToPos;
			_unit setVariable [ "T8U_uvar_OccupiedPos", [ _x, "cover" ], false ];
		} else {
			_moveAround pushBack [ _x, "cover" ];
		};
		
		if (( count _moveAround ) > 19 ) exitWith { false };
		
		false
	} count _coverArray;
};

if ( T8U_var_DEBUG ) then { [ "fn_garrisonBuildings.sqf", "_moveAround", _moveAround ] spawn T8U_fnc_DebugLog; };

_group setVariable [ "T8U_gvar_garrisoning", true, false ];
if ( T8U_var_DEBUG ) then { [ "fn_garrisonBuildings.sqf", "FINISHED GARRISONING", [ _group ] ] spawn T8U_fnc_DebugLog; };


private [ "_loop", "_t", "_moveUnits", "_switchTime" ];
_loop = true;
_t = time;

if ( _side == CIVILIAN ) then { _moveUnits = ( units _group ); } else { _moveUnits = ( units _group ) - [ _leader ]; };

_switchTime = if ( _side == CIVILIAN ) then { 10 } else { 25 };

while { _loop } do 
{
	if ( ( _t + _switchTime + random _switchTime ) < time ) then
	{
		private [ "_u", "_newPos", "_oldPos" ];
		_u = _moveUnits call BIS_fnc_selectRandom;
		_newPos = [];
		_oldPos = [];
		if (( count _moveAround ) > 0 ) then { _newPos = [ _moveAround ] call BIS_fnc_arrayShift; };
		
		if (( count _newPos ) > 1 ) then
		{
//			if ( T8U_var_DEBUG ) then { [ "fn_garrisonBuildings.sqf", "[ _u, _moveUnits, _newPos ]", [ _u, _moveUnits, _newPos ] ] spawn T8U_fnc_DebugLog; };
			
			if ( typeName ( _newPos select 1 ) == typeName "ABC" AND { ( _newPos select 1 ) == "cover" } ) then
			{
				[ _u, ( _newPos select 0 ), true ] spawn T8U_fnc_MoveToPos;
			} else {
				[ _u, ( _newPos select 0 ) ] spawn T8U_fnc_MoveToPos;
			};
			
			_oldPos = _u getVariable [ "T8U_uvar_OccupiedPos", [] ];
			_moveAround pushBack _oldPos;
			_u setVariable [ "T8U_uvar_OccupiedPos", _newPos, false ];
		};
		_t = time;
		
//		if ( T8U_var_DEBUG ) then { [ "fn_garrisonBuildings.sqf", "OCCU POS VARS", [ _oldPos, _newPos, _moveAround ] ] spawn T8U_fnc_DebugLog; };
	};
	
	sleep 2;
//	if ( T8U_var_DEBUG ) then { [ "fn_garrisonBuildings.sqf", "Waiting...", [ _group ] ] spawn T8U_fnc_DebugLog; };
	
	if ( _side == CIVILIAN ) then 
	{

		if ( isNull _group OR ( count ( units _group )) < 1 ) then { _loop = false; if ( T8U_var_DEBUG ) then { [ "fn_garrisonBuildings.sqf", "Kill while", [ _group ] ] spawn T8U_fnc_DebugLog; }; };
	
	
	} else {
	
		if ( 
			isNull _group
			OR !alive _leader
			OR ( count ( units _group )) < 1
			OR !( _group getVariable [ "T8U_gvar_garrisoning", false ] )
		) then { _loop = false; if ( T8U_var_DEBUG ) then { [ "fn_garrisonBuildings.sqf", "Kill while", [ _group ] ] spawn T8U_fnc_DebugLog; }; };
		
		if ( ( group _leader ) getVariable [ "T8U_gvar_Assigned", "ERROR" ] != "NO_TASK" ) then { _loop = false; if ( T8U_var_DEBUG ) then { [ "fn_garrisonBuildings.sqf", "Kill while", [ _group ] ] spawn T8U_fnc_DebugLog; }; };	
	};
	
	if ( ! _loop ) exitWith {};
};

sleep 2;

// Remove occupation
{ _x setvariable [ "occupied", false, false ]; false } count _buildingList;

if ( isNull _group OR { ( count ( units _group )) < 1 } ) exitWith { if ( T8U_var_DEBUG ) then { [ "fn_garrisonBuildings.sqf", "TERMINATING", [ _group ] ] spawn T8U_fnc_DebugLog; }; };

if ( _group getVariable [ "T8U_gvar_garrisoning", false ] ) then 
{
	if ( alive _leader ) then { [ _leader ] call T8U_fnc_GetOutCover; } else { waitUntil { sleep 2; _leader != leader _group }; sleep 2; };
	
	{ [ _x ] joinSilent _group } forEach ( units _group );
	[ _group ] call T8U_fnc_ForceNextWaypoint;

} else {
	{ [ _x ] joinSilent _group; [ _x, false ] spawn T8U_fnc_MoveOut; } forEach ( units _group );
};
[ "fn_garrisonBuildings.sqf", "-- END --", [ _group ] ] spawn T8U_fnc_DebugLog;

*/