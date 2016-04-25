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
_ptargets	= [];

__DEBUG( __FILE__, "INIT", _this );

if ( isNull _group ) exitWith { __DEBUG( __FILE__, "INIT", "ABORT" ); };

_targets = ( leader _group ) nearTargets 750;
{ if ( ( _x select 3 ) > 0 ) then { _ptargets pushBack ( _x select 4 ); }; false } count _targets;

__DEBUG( __FILE__, "PROCESSED TARGETS:", [ _ptargets, ( _target findNearestEnemy _target ) ]);

// if ( ( count _ptargets ) < 1 ) then
if (( _target findNearestEnemy _target ) isEqualTo objNull ) then
{
	sleep 1.5;
	[ _target, _shooter, "CREATE" ] spawn T8U_fnc_SmokeScreen;

} else {

	{
		if ( ( typeOf _x ) in T8U_var_SuppressingUnits ) then { _x suppressFor ( 10 + ( random 10 )); };
	} count ( units _group );
};



