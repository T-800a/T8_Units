/*
 =======================================================================================================================

	T8 Units Script

	Funktion:	fn_combatBehaviorMod.sqf
	Author:		T-800a
	E-Mail:		t-800a@gmx.net

 =======================================================================================================================
*/

#include <..\MACRO.hpp>

params [[ "_group", grpNull, [grpNull]]];

if ( isNull _group ) exitWith {};
private _ba = [ 0, time ];

private _behaviourSet	= __GetOVAR( _group, "T8U_gvar_behaviourSet", false );
private _lastBehaviour	= __GetOVAR( _group, "T8U_gvar_lastBehaviour", _ba );

if (( typeName _behaviourSet ) isEqualTo "BOOL" ) then
{
	switch ( side _group ) do
	{
		case WEST:			{ _behaviourSet = ( T8U_var_Presets select 0 ) select 1; };
		case EAST:			{ _behaviourSet = ( T8U_var_Presets select 1 ) select 1; };
		case RESISTANCE:	{ _behaviourSet = ( T8U_var_Presets select 2 ) select 1; };
	};
	
	__SetOVAR( _group, "T8U_gvar_behaviourSet", _behaviourSet );
	
	__DEBUG( __FILE__, "INIT", _this );
	__DEBUG( __FILE__, "_behaviourSet", _behaviourSet );
	__DEBUG( __FILE__, "_lastBehaviour", _lastBehaviour );
	
};

if (( behaviour ( leader _group )) in [ "CARELESS", "SAFE" ]) exitWith
{
	_group setCombatMode (( T8U_var_BehaviorSets select _behaviourSet ) select 0 );
	__SetOVAR( _group, "T8U_gvar_lastBehaviour", _ba );
	// __DEBUG( __FILE__, "CBM", "OUT OF COMBAT" );
};

switch ( _lastBehaviour select 0 ) do
{
	case 0:
	{
		_group setCombatMode (( T8U_var_BehaviorSets select _behaviourSet ) select 1 );
		private _na = [ 1, ( time + (( T8U_var_BehaviorSets select _behaviourSet ) select 3 ))];
		__SetOVAR( _group, "T8U_gvar_lastBehaviour", _na );
		__DEBUG( __FILE__, "CBM", "COMBAT STARTED" );
	};
	
	case 1:
	{
		if ( time > ( _lastBehaviour select 1 )) then
		{
			_group setCombatMode (( T8U_var_BehaviorSets select _behaviourSet ) select 2 );
			_ba = [ 2, time ];
			__SetOVAR( _group, "T8U_gvar_lastBehaviour", _ba );
			__DEBUG( __FILE__, "CBM", "MODE SWITCHED" );
		};
	};
	
	default {};
};

// lesser spam
// __DEBUG( __FILE__, "CBM: FIRE MODE",  combatMode _group );
// __DEBUG( __FILE__, "CBM: TIME", ( _lastBehaviour select 1 ) - time );
