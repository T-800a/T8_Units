/*
 =======================================================================================================================

	T8 Units Script
	
	Funktion:	fn_hitEvent.sqf
	Author:		T-800a
	E-Mail:		t-800a@gmx.net

 =======================================================================================================================
*/

private [ "_unit", "_attacked" ];

_unit		= _this select 0;
if ( T8U_var_DEBUG ) then { [ "fn_hitEvent.sqf", "INIT", _this ] spawn T8U_fnc_DebugLog; };
_attacked = ( group _unit ) getVariable [ "T8U_gvar_Attacked", -9999 ];

if ( _attacked < ( time - 30 ) ) then { [ group _unit ] spawn T8U_fnc_OnHitEvent; };

( group _unit ) setVariable [ "T8U_gvar_Attacked", time, false ];
