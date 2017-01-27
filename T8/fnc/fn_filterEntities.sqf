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

params [
	[ "_unit", objNull, [objNull]],
	[ "_range", 1000, [123]],
	[ "_friendly", false, [true]]
];

private _parray		= [];
private _return		= [];

// __DEBUG( __FILE__,  "INIT", _this );
if ( isNull _unit ) exitWith { __DEBUG( __FILE__, "INIT", "INPUT ERROR" ); _return };

private _array	= _unit nearEntities [[ "CAManBase", "LandVehicle" ], _range ];
private _base	= side _unit;

{
	private _e = _x;
	
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

// Return
if !(( typeName _return ) isEqualTo "ARRAY" ) then { _return = []; };
// __DEBUG( __FILE__,  "FILTERED", _return );
_return
