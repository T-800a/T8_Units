/*
 =======================================================================================================================

	T8 Units Script

	Funktion:	fn_getInBuilding.sqf
	Author:		T-800a
	E-Mail:		t-800a@gmx.net

 =======================================================================================================================
*/

private [ "_range", "_units", "_building", "_buildingList", "_buildingPos", "_buildingPosArray", "_ocBuild" ];

_units		= [ _this, 0, [] ] call BIS_fnc_param;
_marker		= [ _this, 1, "NO-MARKER", [ "" ] ] call BIS_fnc_param; 
_range		= [ _this, 2, 20 ] call BIS_fnc_param;
_building	= [ _this, 3, "Cargo_Patrol_base_F" ] call BIS_fnc_param;

_ocBuild = [];

if ( _range < 20 ) then { _range = 20; };

if ( T8U_var_DEBUG ) then { [ "fn_getInBuilding.sqf", "INIT", _this ] spawn T8U_fnc_DebugLog; };

if ( !( count _units > 0 ) OR { str ( getMarkerPos _marker ) == str ([0,0,0]) } ) exitWith { _units };

_buildingList = ( getMarkerPos _marker ) nearObjects [ _building, _range ];
_buildingPos = [];

switch ( _building ) do
{
	case "Cargo_Patrol_base_F":		{ _buildingPosArray = [ 1, 0 ]; };
	case "Cargo_HQ_base_F":			{ _buildingPosArray = [ 3, 4, 5, 7, 8 ]; };
	case "Cargo_Tower_base_F":		{ _buildingPosArray = [ 0, 1, 2, 7, 8, 10, 11, 12, 13, 14, 16, 17 ]; };
};

{
	private [ "_b" ];
	_b = _x;
	if !( _b getvariable [ "occupied", false ] ) then
	{
		{ _buildingPos pushBack [ _b buildingPos _x, _b ]; } forEach _buildingPosArray;
	};
} forEach _buildingList;

if ( T8U_var_DEBUG ) then { [ "fn_getInBuilding.sqf", "_buildingList", _buildingList ] spawn T8U_fnc_DebugLog; };
if ( T8U_var_DEBUG ) then { [ "fn_getInBuilding.sqf", "_buildingPos", _buildingPos ] spawn T8U_fnc_DebugLog; };

_buildingPos = _buildingPos call BIS_fnc_arrayShuffle;

{ // forEach _buildingPos
	if ( ( count _units ) > 1 ) then
	{
		private [ "_unit", "_b", "_p" ];
		
		_b = _x select 1;
		_p = _x select 0;
		
		_unit = _units call BIS_fnc_arrayPop;
		[ _unit, _p ] spawn T8U_fnc_MoveTo;
		
		_b setvariable [ "occupied", true, false ];
		
		if ( !( _b in _ocBuild ) ) then { _ocBuild pushBack _b; };
	};
} forEach _buildingPos;

_ocBuild
