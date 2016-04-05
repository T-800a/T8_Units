/*
 =======================================================================================================================

	T8 Units Script

	Funktion:	fn_getSupport.sqf
	Author:		T-800a
	E-Mail:		t-800a@gmx.net

 =======================================================================================================================
*/

#include <..\MACRO.hpp>

private [ "_support", "_unit", "_side" ];

_unit = param [ 0, objNull, [objNull]];
_side = side _unit;
_support = [];

switch ( _side ) do
{
	case EAST:
	{
		if (( !isNil "T8U_var_SupportUnitsEAST" ) AND {( count T8U_var_SupportUnitsEAST ) > 0 }) then
		{
			if (( count T8U_var_SupportUnitsEAST ) isEqualTo 1 ) then{ _support = T8U_var_SupportUnitsEAST select 0; T8U_var_SupportUnitsEAST = nil; } else { _support = T8U_var_SupportUnitsEAST call BIS_fnc_arrayPop; };
			
		};
	};

	case WEST:
	{
		if (( !isNil "T8U_var_SupportUnitsWEST" ) AND {( count T8U_var_SupportUnitsWEST ) > 0 }) then
		{
			if (( count T8U_var_SupportUnitsWEST ) isEqualTo 1 ) then{ _support = T8U_var_SupportUnitsWEST select 0; T8U_var_SupportUnitsWEST = nil;  } else { _support = T8U_var_SupportUnitsWEST call BIS_fnc_arrayPop; };
		};
	};

	case RESISTANCE:
	{
		if (( !isNil "T8U_var_SupportUnitsRESISTANCE" ) AND {( count T8U_var_SupportUnitsRESISTANCE ) > 0 }) then
		{
			if (( count T8U_var_SupportUnitsRESISTANCE ) isEqualTo 1 ) then{ _support = T8U_var_SupportUnitsRESISTANCE select 0; T8U_var_SupportUnitsRESISTANCE = nil;  } else { _support = T8U_var_SupportUnitsRESISTANCE call BIS_fnc_arrayPop; };
		};
	};
};

_support
