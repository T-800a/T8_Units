/*
 =======================================================================================================================

	T8 Units Script
	
	Funktion:	fn_filterEntities.sqf
	Author:		T-800a
	E-Mail:		t-800a@gmx.net

	"CAManBase", "LandVehicle"
	
 =======================================================================================================================
*/

#include <..\MACRO.hpp>

private [ "_unit", "_range", "_array", "_friendly", "_base", "_parray", "_return" ];

_unit		= param [ 0, objNull, [objNull]];
_range		= param [ 1, 1000, [123]];
_friendly	= param [ 2, false, [true]];

if ( T8U_var_DEBUG ) then { [ "fn_filterEntities.sqf", "INIT", _this ] spawn T8U_fnc_DebugLog; };
if ( isNull _unit ) exitWith { if ( T8U_var_DEBUG ) then { [ "fn_filterEntities.sqf", "INPUT ERROR" ] spawn T8U_fnc_DebugLog; }; };

_array = _unit nearEntities [ [ "CAManBase", "LandVehicle" ], _range ];

_base 		= side _unit;
_parray		= [];
_return		= [];

{
	private [ "_e" ];
	_e = _x;
	
	if ( _e isKindOf "CAManBase" )		then { _parray pushBack _e; };
	if ( _e isKindOf "LandVehicle" )	then { _parray pushBack _e; { _parray pushBack _x; } forEach ( crew _e ); };
	
	false
} count _array;

switch ( _groupSide ) do
{
	case WEST:
	{
		{
			if ( _friendly ) then 
			{
				if ( side _x == WEST ) then { _return pushBack _x; };
				if ( T8U_var_GuerDiplo == 1 AND { side _x == RESISTANCE } ) then { _return pushBack _x; };
			} else {
				if ( side _x == EAST ) then { _return pushBack _x; };
				if ( T8U_var_GuerDiplo != 1 AND { T8U_var_GuerDiplo != 0 } AND { side _x == RESISTANCE } ) then { _return pushBack _x; };
			};
			
			false
		} count _parray;
	};

	case EAST:
	{
		{
			if ( _friendly ) then 
			{
				if ( side _x == EAST ) then { _return pushBack _x; };
				if ( T8U_var_GuerDiplo == 2 AND { side _x == RESISTANCE } ) then { _return pushBack _x; };
			} else {
				if ( side _x == WEST ) then { _return pushBack _x; };
				if ( T8U_var_GuerDiplo != 2 AND { T8U_var_GuerDiplo != 0 } AND { side _x == RESISTANCE } ) then { _return pushBack _x; };
			};
			
			false
		} count _parray;
	};

	case RESISTANCE:
	{
		{
			if ( _friendly ) then 
			{
				if ( side _x == RESISTANCE ) then { _return pushBack _x; };
				if ( T8U_var_GuerDiplo == 1 AND { side _x == WEST } ) then { _return pushBack _x; };
				if ( T8U_var_GuerDiplo == 2 AND { side _x == EAST } ) then { _return pushBack _x; };
			} else {
				if ( T8U_var_GuerDiplo == 1 AND { side _x == EAST } ) then { _return pushBack _x; };
				if ( T8U_var_GuerDiplo == 2 AND { side _x == WEST } ) then { _return pushBack _x; };
				if ( T8U_var_GuerDiplo == 3 AND { side _x != RESISTANCE } AND { side _x != CIVILIAN } ) then { _return pushBack _x; };
			};
			
			false
		} count _parray;
	};
};

if ( T8U_var_DEBUG ) then { [ "fn_filterEntities.sqf", "FILTERED", _return ] spawn T8U_fnc_DebugLog; };

// Return
_return
