/*
 =======================================================================================================================

	T8 Units Script
	
	Funktion:	fn_selectConfigFile.sqf
	Author:		T-800a
	E-Mail:		t-800a@gmx.net
	
 =======================================================================================================================
*/

#include <..\MACRO.hpp>

private _CFalloc	= isClass ( configFile >> "cfgT8Units" );
private _CFMalloc	= isClass ( missionConfigFile >> "cfgT8Units" );

private _return = switch ( true ) do
{
	case ( _CFalloc AND _CFMalloc ):	{ missionConfigFile >> "cfgT8Units" };
	case ( _CFalloc AND !_CFMalloc ):	{ configFile >> "cfgT8Units" };
	case ( !_CFalloc AND _CFMalloc ):	{ missionConfigFile >> "cfgT8Units" };
	default								{ configNull };
};

if ( isNull _return ) then
{
	[ "WARNING!<br /><br />You are missing a configfile.<br /><br />Please check your description.ext maybe you did not included the T8 Units config." ] call T8U_fnc_BroadcastHint;
};

// return
_return
