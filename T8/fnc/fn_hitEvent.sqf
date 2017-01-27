/*
 =======================================================================================================================

	T8 Units Script
	
	Funktion:	fn_hitEvent.sqf
	Author:		T-800a
	E-Mail:		t-800a@gmx.net

 =======================================================================================================================
*/

#include <..\MACRO.hpp>

params [
	[ "_target",	objNull, [objNull]],
	[ "_shooter",	objNull, [objNull]]
];

__DEBUG( __FILE__, "INIT", _this );

if ( isNull _target ) exitWith {};
if ( _target isEqualTo _shooter ) exitWith {};

if (( __GetOVAR(( group _target ), "T8U_gvar_Attacked", 0 )) < ( time - 10 )) then { [ _target, _shooter ] spawn T8U_fnc_OnHitEvent; };

( group _target ) setVariable [ "T8U_gvar_Attacked", time, false ];

