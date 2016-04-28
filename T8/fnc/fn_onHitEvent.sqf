/*
 =======================================================================================================================

	T8 Units Script
	
	Funktion:	fn_onHitEvent.sqf
	Author:		T-800a
	E-Mail:		t-800a@gmx.net

 =======================================================================================================================
*/

#include <..\MACRO.hpp>

private [ "_target", "_shooter", "_group", "_units", "_targets", "_ptargets" ];

_target		= _this select 0;
_shooter	= _this select 1;
_group		= group _target;

_units		= units _target;

__DEBUG( __FILE__, "INIT", _this );

if ( isNull _group ) exitWith { __DEBUG( __FILE__, "INIT", "ABORT" ); };


if ( alive _target AND {( _target findNearestEnemy _target ) isEqualTo objNull }) then
{
	sleep 1.5;
	[ _target, _shooter, "CREATE" ] spawn T8U_fnc_SmokeScreen;
	__DEBUG( __FILE__, "THROWSMOKE", _group );

};

if ( alive ( leader _group ) AND { !isNull _shooter }) then
{
	{
		if ( ( typeOf _x ) in T8U_var_SuppressingUnits ) then { _x suppressFor ( 10 + ( random 10 )); };
	} count ( units _group );
	__DEBUG( __FILE__, "SUPPRESS", _group );
};



