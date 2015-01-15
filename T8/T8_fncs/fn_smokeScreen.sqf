/*
 =======================================================================================================================

	T8 Units Script
	
	Funktion:	fn_smokeScreen.sqf
	Author:		T-800a
	E-Mail:		t-800a@gmx.net

 =======================================================================================================================
*/

private [ "_unit", "_target", "_dir", "_vehicle" ];

_unit		= [ _this, 0, objNull, [objNull,[]] ] call BIS_fnc_param;
_target		= [ _this, 1, objNull, [objNull,[]] ] call BIS_fnc_param;

if ( T8U_var_DEBUG ) then { [ "fn_smokeScreen.sqf", "INIT", _this ] spawn T8U_fnc_DebugLog; };
if ( ( ( typeName _unit ) == ( typename objNull ) AND { isNull _unit } ) OR ( ( typeName _unit ) == ( typeName [] ) AND { count _unit < 2 } ) ) exitWith {};
if ( ( ( typeName _target ) == ( typename objNull ) AND { isNull _target } ) OR ( ( typeName _target ) == ( typeName [] ) AND { count _target < 2 } ) ) exitWith {};

if ( typeName _unit == typename objNull ) then { _unit = getPosATL _unit; };
if ( typeName _target == typename objNull ) then { _target = getPosATL _target; };

_dir		= [ _unit, _target ] call BIS_fnc_dirTo;

_vehicle = "SmokeShell" createVehicle _unit;
_vehicle setVelocity [ ( sin ( _dir ) * ( 15 + random 5 ) ), ( cos ( _dir ) * ( 15 + random 5 ) ), ( 5 + random 5 ) ];


