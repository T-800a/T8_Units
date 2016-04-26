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
	[ "_faction",	"OPF_F",	["STR"]],
	[ "_type",		"infantry",	["STR"]],
	[ "_min",		4,			[123]],
	[ "_random",	4,			[123]]
	
];

__DEBUG( __FILE__, "INIT", _this );

private _return = [];
private _CFalloc	= isClass ( configFile >> "cfgT8Units" );
private _CFMalloc	= isClass ( missionConfigFile >> "cfgT8Units" );

private _cfg = switch ( true ) do
{
	case ( _CFalloc AND _CFMalloc ):	{ missionConfigFile >> "cfgT8Units"; };
	case ( _CFalloc AND !_CFMalloc ):	{ configFile >> "cfgT8Units"; };
	case ( !_CFalloc AND _CFMalloc ):	{ missionConfigFile >> "cfgT8Units"; };
	default								{ nil };
};

if ( isNil "_cfg" ) exitWith { [ "WARNING!<br /><br />You are missing a configfile.<br /><br />Please check your description.ext maybe you did not included the T8 Units config." ] call T8U_fnc_BroadcastHint; _return };
if( !isClass ( _cfg >> "randomUnitContainer" >> ( toUpper _faction ))) exitWith { __DEBUG( __FILE__, "MISSING FACTION", _faction ); _return };

private _units = getArray ( _cfg >> "randomUnitContainer" >> ( toUpper _faction ) >> ( toLower _type ));

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
