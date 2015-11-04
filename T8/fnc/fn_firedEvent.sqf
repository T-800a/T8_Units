/*
 =======================================================================================================================

	T8 Units Script
	
	Funktion:	fn_firedEvent.sqf
	Author:		T-800a
	E-Mail:		t-800a@gmx.net

    unit:		Object - Object the event handler is assigned to
    firer:		Object - Object which fires a weapon near the unit
    distance:	Number - Distance in meters between the unit and firer (max. distance ~69m)
    weapon:		String - Fired weapon
    muzzle: 	String - Muzzle that was used
    (mode:)		String - Current mode of the fired weapon
   ( ammo:)		String - Ammo used 
	
 =======================================================================================================================
*/

#include <..\MACRO.hpp>

private [ "_eventArray", "_unit", "_shooter", "_distance", "_weapon", "_muzzle" ];

_eventArray		= _this select 0;
_unit			= _eventArray select 0;
_shooter		= _eventArray select 1;
_distance		= _eventArray select 2;
_weapon			= _eventArray select 3;
_muzzle			= _eventArray select 4;

[ _unit ] call T8U_fnc_PauseFiredEvent;
	
if ( alive _unit ) then 
{
	( group _unit ) setVariable [ "T8U_gvar_FiredEvent", [ _unit, _shooter, _distance, _weapon, _muzzle ], false ];
	[ _unit ] spawn T8U_fnc_RestartFiredEvent;
	
	if ( T8U_var_DEBUG ) then { [ "fn_firedEvent.sqf", "EVENT EXEC", _eventArray ] spawn T8U_fnc_DebugLog; };
	
} else { if ( T8U_var_DEBUG ) then { [ "fn_firedEvent.sqf", "UNIT DEAD", _eventArray ] spawn T8U_fnc_DebugLog; }; };