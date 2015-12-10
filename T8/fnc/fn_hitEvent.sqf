/*
 =======================================================================================================================

	T8 Units Script
	
	Funktion:	fn_hitEvent.sqf
	Author:		T-800a
	E-Mail:		t-800a@gmx.net

 =======================================================================================================================
*/

#include <..\MACRO.hpp>

private [ "_target", "_shooter", "_attacked" ];

_target		= _this select 0;
_shooter	= _this select 1;

if ( _target isEqualTo _shooter ) exitWith { if ( T8U_var_DEBUG ) then { [ "fn_hitEvent.sqf", "NOPE" ] spawn T8U_fnc_DebugLog; }; };
if ( T8U_var_DEBUG ) then { [ "fn_hitEvent.sqf", "INIT", _this ] spawn T8U_fnc_DebugLog; };


_attacked = ( group _target ) getVariable [ "T8U_gvar_Attacked", 0 ];

if ( T8U_var_DEBUG ) then { [ "fn_hitEvent.sqf", "_attacked", _attacked ] spawn T8U_fnc_DebugLog; };

if ( _attacked < ( time - 15 ) ) then { [ _target, _shooter ] spawn T8U_fnc_OnHitEvent; };

( group _target ) setVariable [ "T8U_gvar_Attacked", time, false ];
