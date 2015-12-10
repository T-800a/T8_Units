/*
 =======================================================================================================================

	T8 Units Script

	Funktion:	fn_zoneCreate.sqf
	Author:		T-800a
	E-Mail:		t-800a@gmx.net

 =======================================================================================================================
*/

#include <..\MACRO.hpp>
__allowEXEC(__FILE__);
__DEBUG( __FILE__, "INIT", _this );

private [ "_array", "_string", "_zoneDone", "_done", "_created", "_creating", "_active"  ];

_array = _this select 0;
_string = _this select 1;

__SetMVAR( str( _string + "_active" ), true );

_created		= __GetMVAR(  str( _string + "_created" ),	false );
_creating		= __GetMVAR(  str( _string + "_creating" ),	false );
_active			= __GetMVAR(  str( _string + "_active" ),	false );

if ( typeName ( _array ) == "BOOL" ) exitWith {	__DEBUG( __FILE__, "ZONE CREATION ABORTED: NO UNITS",				_string ); };
if ( _created ) exitWith {						__DEBUG( __FILE__, "ZONE CREATION ABORTED: IS ALREADY CREATED",		_string ); };
if ( _creating ) exitWith {						__DEBUG( __FILE__, "ZONE CREATION ABORTED: ALREADY IN CREATION",	_string ); };

__SetMVAR( str( _string + "_creating" ), true );

// spawn those damn units
_done = [ _array ] call T8U_fnc_Spawn;

if (( count _done ) > 0 ) then
{
	__SetMVAR( str( _string + "_created" ), true );
} else {
	__SetMVAR( str( _string + "_created" ), false );
};

__SetMVAR( str( _string + "_creating" ), false );

_created		= __GetMVAR(  str( _string + "_created" ), "ERROR" );
_creating		= __GetMVAR(  str( _string + "_creating" ), "ERROR" );
_active			= __GetMVAR(  str( _string + "_active" ), "ERROR" );

__DEBUG( __FILE__, "ZONE CREATED", "=======================================" );
__DEBUG( __FILE__, "ZONE",							_string );
__DEBUG( __FILE__, str( _string + "_created" ),		_created );
__DEBUG( __FILE__, str( _string + "_creating" ),	_creating );
__DEBUG( __FILE__, str( _string + "_active" ),		_active );


