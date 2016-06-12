/*
 =======================================================================================================================

	T8 Units Script
	
	Funktion:	fn_onHitEvent.sqf
	Author:		T-800a
	E-Mail:		t-800a@gmx.net

 =======================================================================================================================
*/

#include <..\MACRO.hpp>

params [
	[ "_target",	objNull, [objNull]],
	[ "_shooter",	objNull, [objNull]]
];

__DEBUG( __FILE__, "INIT", _this );
if ( isNull _target ) exitWith {};

private _group	= group _target;
if ( isNull _group ) exitWith {};

private _units	= units _group;

// throw a smoke
if ( alive _target AND {( __GetOVAR( _target, "T8U_ovar_lastSmoke", -120 )) < ( time - 30 )}) then
{
	__SetOVAR( _target, "T8U_ovar_lastSmoke", time );
	
	sleep 1.5;
	
	[ _target, _shooter, "THROW" ] spawn T8U_fnc_SmokeScreen;
	__DEBUG( __FILE__, "THROWSMOKE", _target );
};

// order supressive fire
if ( alive ( leader _group ) AND { !isNull _shooter }) then
{
	{
		if ( ( typeOf _x ) in T8U_var_SuppressingUnits ) then { _x commandSuppressiveFire _shooter; };
		
		false
	} count _units;
	__DEBUG( __FILE__, "SUPPRESS", _group );
};



