/*
 =======================================================================================================================

	T8 Units Script
	
	Funktion:	fn_zoneNotAktiv.sqf
	Author:		T-800a
	E-Mail:		t-800a@gmx.net

 =======================================================================================================================
*/

#include <..\MACRO.hpp>

private [ "_string" ];

_string			= param [ 0, "", [""]];

__SetMVAR( str( _string + "_active" ), false );

private [ "_created", "_creating", "_active" ];
_created		= __GetMVAR(  str( _string + "_created" ), "ERROR" );
_creating		= __GetMVAR(  str( _string + "_creating" ), "ERROR" );
_active			= __GetMVAR(  str( _string + "_active" ), "ERROR" );

__DEBUG( __FILE__, "ZONE DEACTIVATED", "=======================================" );
__DEBUG( __FILE__, "ZONE",							_string );
__DEBUG( __FILE__, str( _string + "_created" ),		_created );
__DEBUG( __FILE__, str( _string + "_creating" ),	_creating );
__DEBUG( __FILE__, str( _string + "_active" ),		_active );

true
