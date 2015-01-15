/*
 =======================================================================================================================

	T8 Units Script

	Funktion:	fn_getSupport.sqf
	Author:		T-800a
	E-Mail:		t-800a@gmx.net

 =======================================================================================================================
*/

private [ "_support", "_unit", "_side" ];

_unit = [ _this, 0, objNull ] call BIS_fnc_param;
_side = side _unit;

switch ( _side ) do
{
	case EAST:
	{
		if ( isNil "T8U_var_SupportUnitsEAST" OR { count T8U_var_SupportUnitsEAST < 1 } ) then
		{
			_support = [];
		} else {
			_support = T8U_var_SupportUnitsEAST call BIS_fnc_arrayPop;
		};
	};

	case WEST:
	{
		if ( isNil "T8U_var_SupportUnitsWEST" OR { count T8U_var_SupportUnitsWEST < 1 } ) then
		{
			_support = [];
		} else {
			_support = T8U_var_SupportUnitsWEST call BIS_fnc_arrayPop;
		};
	};

	case RESISTANCE:
	{
		if ( isNil "T8U_var_SupportUnitsRESISTANCE" OR { count T8U_var_SupportUnitsRESISTANCE < 1 } ) then
		{
			_support = [];
		} else {
			_support = T8U_var_SupportUnitsRESISTANCE call BIS_fnc_arrayPop;
		};
	};
};

_support
