/*
 =======================================================================================================================

	T8 Units Script

	Funktion:	fn_combatBehaviorMod.sqf
	Author:		T-800a
	E-Mail:		t-800a@gmx.net

 =======================================================================================================================
*/

#include <..\MACRO.hpp>

private [ "_group", "_presetSkill", "_presetBehavior" ];

_group = param [ 0, grpNull, [grpNull]];
// _units = ( units _group ) - [ ( leader _group ) ];

switch ( side _group ) do
{
	case WEST:
	{
		_presetSkill	= ( T8U_var_Presets select 0 ) select 0;
		_presetBehavior = ( T8U_var_Presets select 0 ) select 1;
	};
	
	case EAST:
	{
		_presetSkill	= ( T8U_var_Presets select 1 ) select 0;
		_presetBehavior = ( T8U_var_Presets select 1 ) select 1;				
	};
	
	case RESISTANCE:
	{
		_presetSkill	= ( T8U_var_Presets select 2 ) select 0;
		_presetBehavior = ( T8U_var_Presets select 2 ) select 1;				
	};
};



///// MAIN LOOP //////////

while { sleep 5; ( count ( units _group ) ) > 0 } do
{
	if ( T8U_var_DEBUG ) then { [ "fn_combatBehaviorMod.sqf", "STARTED", [ _group ] ] spawn T8U_fnc_DebugLog; };

	waitUntil { sleep 5; if ( isNull _group OR { count ( units _group ) < 1 } ) exitWith {}; ( behaviour ( leader _group ) ) == "COMBAT" };
	if ( isNull _group OR { count ( units _group ) < 1 } ) exitWith {};
	
	if ( T8U_var_DEBUG ) then { [ "fn_combatBehaviorMod.sqf", "COMBAT", [ _group, ( ( T8U_var_BehaviorSets select _presetBehavior ) select 1 ) ] ] spawn T8U_fnc_DebugLog; };

	_group setCombatMode ( ( T8U_var_BehaviorSets select _presetBehavior ) select 1 );
	
	sleep ( ( T8U_var_BehaviorSets select _presetBehavior ) select 3 );
	if ( isNull _group OR { count ( units _group ) < 1 } ) exitWith {};
	
	if ( T8U_var_DEBUG ) then { [ "fn_combatBehaviorMod.sqf", "COMBAT", [ _group, ( ( T8U_var_BehaviorSets select _presetBehavior ) select 2 ) ] ] spawn T8U_fnc_DebugLog; };
	
	_group setCombatMode ( ( T8U_var_BehaviorSets select _presetBehavior ) select 2 );

	waitUntil { sleep 5; if ( isNull _group OR { count ( units _group ) < 1 } ) exitWith {}; ( behaviour ( leader _group ) ) != "COMBAT" };
	if ( isNull _group OR { count ( units _group ) < 1 } ) exitWith {};
	
	if ( T8U_var_DEBUG ) then { [ "fn_combatBehaviorMod.sqf", "OUT OF COMBAT", [ _group, ( ( T8U_var_BehaviorSets select _presetBehavior ) select 0 ) ] ] spawn T8U_fnc_DebugLog; };
	_group setCombatMode ( ( T8U_var_BehaviorSets select _presetBehavior ) select 0 );
};
