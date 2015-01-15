/*
 =======================================================================================================================

	T8 Units Script

	Funktion:	fn_getInGunner.sqf
	Author:		T-800a
	E-Mail:		t-800a@gmx.net

 =======================================================================================================================
*/

private [ "_units", "_marker", "_range", "_objects", "_vehicleList", "_staticWeapons" ];

_units		= [ _this, 0, [] ] call BIS_fnc_param;
_marker		= [ _this, 1, "NO-MARKER-SET" ] call BIS_fnc_param;
_range		= [ _this, 2, 30 ] call BIS_fnc_param;
_objects	= [ _this, 3, "StaticWeapon" ] call BIS_fnc_param;

if ( T8U_var_DEBUG ) then { [ "fn_getInGunner.sqf", "INIT", _this ] spawn T8U_fnc_DebugLog; };

if ( !( count _units > 0 ) OR { str ( getMarkerPos _marker ) == str ([0,0,0]) } ) exitWith { _units };

if ( _range < 30 ) then { _range = 30; };
_staticWeapons = [];
_vehicleList = ( getMarkerPos _marker ) nearObjects [ _objects, _range ];

{
	if ( ( _x emptyPositions "gunner" ) > 0 AND ! ( count ( crew _x ) > 0 ) ) then 
	{
		_staticWeapons pushBack _x;
	}; 
} forEach _vehicleList;

// forEach -> _staticWeapons
{
	if ( ( count _units ) > 0) then
	{
		private [ "_unit" ];
		_unit = _units call BIS_fnc_arrayPop;
		[ _unit, _x ] spawn
		{
			private [ "_unit", "_gun", "_oldPos" ];
			_unit = _this select 0;
			_gun = _this select 1;
			_unit assignAsGunner _gun;
			[ _unit ] orderGetIn true;
			sleep 10;
			_oldPos = getPosATL _unit;
			[ _unit, _oldPos ] spawn T8U_fnc_MoveOut;
			sleep 5;
			_unit moveInGunner _gun;
		};
	};
} forEach _staticWeapons;

_units
