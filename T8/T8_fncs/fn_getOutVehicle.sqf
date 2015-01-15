/*
 =======================================================================================================================

	T8 Units Script
	
	Funktion:	fn_getOutVehicle.sqf
	Author:		T-800a
	E-Mail:		t-800a@gmx.net
	
	Should be called: -Leave the vehicle behind and don't give a fuck about it anymore!-

 =======================================================================================================================
*/

private [ "_unit" ];

_unit		= [ _this, 0, objNull ] call BIS_fnc_param;

if ( T8U_var_DEBUG ) then { [ "fn_getOutVehicle.sqf", "INIT", _this ] spawn T8U_fnc_DebugLog; };

if ( isNull _unit ) exitWith { false };

( units ( group _unit ) ) orderGetIn false;
( group _unit ) leaveVehicle ( assignedVehicle _unit );

true
