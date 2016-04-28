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

private _group	= group _target;
private _units	= units _group;

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
		
		false
	} count _units;
	__DEBUG( __FILE__, "SUPPRESS", _group );
};



