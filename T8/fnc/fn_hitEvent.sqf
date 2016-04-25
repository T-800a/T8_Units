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

__DEBUG( __FILE__, "INIT", _this );

if ( isNull _target ) exitWith {};
if ( isNull _shooter ) exitWith {};
if ( _target isEqualTo _shooter ) exitWith {};

_attacked = ( group _target ) getVariable [ "T8U_gvar_Attacked", 0 ];
__DEBUG( __FILE__, "_attacked", _attacked );

if ( _attacked < ( time - 15 ) ) then { [ _target, _shooter ] spawn T8U_fnc_OnHitEvent; };

( group _target ) setVariable [ "T8U_gvar_Attacked", time, false ];
