/*
 =======================================================================================================================

	T8 Units Script
	
	Funktion:	fn_onHitEvent.sqf
	Author:		T-800a
	E-Mail:		t-800a@gmx.net

 =======================================================================================================================
*/

private [ "_group", "_units", "_targets", "_ptargets" ];

_group		= _this select 0;
_units		= units _group;
_ptargets	= [];

if ( T8U_var_DEBUG ) then { [ "fn_onHitEvent.sqf", "INIT", _this ] spawn T8U_fnc_DebugLog; };
if ( isNull _group ) exitWith { if ( T8U_var_DEBUG ) then { [ "fn_onHitEvent.sqf", "ABORT", _this ] spawn T8U_fnc_DebugLog; }; };

_targets = ( leader _group ) nearTargets 750;
{ if ( ( _x select 3 ) > 0 ) then { _ptargets pushBack ( _x select 4 ); }; false } count _targets;

if ( T8U_var_DEBUG ) then { [ "fn_onHitEvent.sqf", "PROCESSED TARGETS:", _ptargets ] spawn T8U_fnc_DebugLog; };

if ( ( count _ptargets ) < 1 ) then
{
	sleep ( random 2 );

	{ if ( alive _x AND !isNull _x ) then { _x setUnitPos "DOWN"; }; } count _units;

	sleep ( 5 + random 15 );

	{ if ( alive _x AND !isNull _x ) then { _x setUnitPos "AUTO"; }; } count _units;

} else {

	{
		if ( ( typeOf _x ) in T8U_var_SuppressingUnits ) then { _x suppressFor ( 10 + ( random 10 )); };
	} count ( units _group );
};



