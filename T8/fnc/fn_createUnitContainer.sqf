/*
 =======================================================================================================================

	T8 Units Script
	
	Funktion:	fn_createUnitContainer.sqf
	Author:		Celludriel, T-800a
	E-Mail:		t-800a@gmx.net

 =======================================================================================================================
*/

#include <..\MACRO.hpp>

params [
	[ "_type",		"infantry", [""]],
	[ "_min",		4, [123]],
	[ "_random",	4, [123]],
	[ "_faction",	T8U_var_EnemySide, [WEST]],
	[ "_modSet",	T8U_var_modSet, [""]]
];

__DEBUG( __FILE__, "INIT", _this );

private _return	= [];
private _cfg	= call T8U_fnc_selectConfigFile;

if ( isNull _cfg ) exitWith { [ "WARNING!<br /><br />You are missing a configfile.<br /><br />Please check your description.ext maybe you did not included the T8 Units config." ] call T8U_fnc_BroadcastHint; _return };
if( !isClass ( _cfg >> "groupRandomCompilations" >> ( toLower _modSet ) >> ( toLower ( str _faction )))) exitWith { __DEBUG( __FILE__, "ERROR MISSING FACTION", _faction ); _return };

private _units = __CFGARRAY( _cfg >> "groupRandomCompilations" >> ( toLower _modSet ) >> ( toLower ( str _faction )) >> ( toLower _type ), [] );
if ( count _units < 1 ) exitWith { __DEBUG( __FILE__, "ERROR", "EMPTY ARRAY" ); [] };

// build minimum units
for [{ _i = 0 },{ _i < _min }, { _i = _i + 1 }] do { _return pushBack ( _units call BIS_fnc_selectRandom ); };

// build additional random units
if( _random != 0 ) then 
{
	private _randomPick = random _random;
	for [{ _i = 0 }, { _i < _randomPick }, { _i = _i + 1 }] do { _return pushBack ( _units call BIS_fnc_selectRandom );	};
};


__DEBUG( __FILE__, "_return", _return );

// return
_return
