/*
 =======================================================================================================================

	T8 Units Script
	
	Funktion:	fn_checkEXEC.sqf
	Author:		T-800a
	E-Mail:		t-800a@gmx.net

 =======================================================================================================================
*/

#include <..\MACRO.hpp>

params [
	[ "_f", "____NO_FILE____" ],
	"_return"
];

if ( T8U_var_useHC ) then 
{
	_return		= if ( !isDedicated AND !hasInterface ) then { false } else { true };
} else {
	_return		= if ( isServer ) then { false } else { true };
};
if ( _return ) then 
{
	_f = _f splitString "\";
	reverse _f;
	__DEBUG( "INIT", "======================================================================================", "" );
	__DEBUG( "INIT", "NO EXECUTION ON THIS MACHINE OF:", ( _f select 0 ));
	__DEBUG( "INIT", "======================================================================================", "" );
};

// return
_return
