/*
 =======================================================================================================================

	T8 Units Script
	
	Funktion:	fn_smokeScreen.sqf
	Author:		T-800a
	E-Mail:		t-800a@gmx.net

 =======================================================================================================================
*/

#include <..\MACRO.hpp>

private [ "_unit", "_target", "_switch", "_dir", "_vehicle" ];

_unit		= param [ 0, objNull, [objNull]];
_target		= param [ 1, objNull, [objNull,[]]];
_switch		= param [ 2, "CREATE", [""]];

if ( T8U_var_DEBUG ) then { [ "fn_smokeScreen.sqf", "INIT", _this ] spawn T8U_fnc_DebugLog; };
if ( ( typeName _unit ) == ( typename objNull ) AND { isNull _unit } ) exitWith {};

if !( alive _unit )							exitWith { if ( T8U_var_DEBUG ) then { [ "fn_smokeScreen.sqf", "NO SMOKE > DEAD", _this ] spawn T8U_fnc_DebugLog; }; };
if !( _unit isEqualTo ( vehicle _unit ))	exitWith { if ( T8U_var_DEBUG ) then { [ "fn_smokeScreen.sqf", "NO SMOKE > IN VEHICLE", _this ] spawn T8U_fnc_DebugLog; };};
if ([ _unit ] call T8U_fnc_InBuilding )		exitWith { if ( T8U_var_DEBUG ) then { [ "fn_smokeScreen.sqf", "NO SMOKE > IN BUILDING", _this ] spawn T8U_fnc_DebugLog; }; };

if ( ( ( typeName _target ) == ( typename objNull ) AND { isNull _target } ) OR ( ( typeName _target ) == ( typeName [] ) AND { count _target < 2 } ) ) exitWith {};
if ( typeName _target == typename objNull ) then { _target = getPosATL _target; };

_dir = [ _unit, _target ] call BIS_fnc_dirTo;

switch ( _switch ) do 
{ 
	default { if ( T8U_var_DEBUG ) then { [ "fn_smokeScreen.sqf", "WRONG PARAM: _switch", _this ] spawn T8U_fnc_DebugLog; }; };

	case "THROW":
	{
		if ( T8U_var_DEBUG ) then { [ "fn_smokeScreen.sqf", "THROW SMOKE", _this ] spawn T8U_fnc_DebugLog; };
		
		_unit addMagazine [ "SmokeShell", 1 ];
		_unit doWatch _target;
		_unit setDir _dir;
		sleep 0.5;
		_unit forceWeaponFire [ "SmokeShellMuzzle", "SmokeShellMuzzle" ];
		_unit doWatch objNull;
	};
	
	case "CREATE":
	{
		if ( T8U_var_DEBUG ) then { [ "fn_smokeScreen.sqf", "CREATE SMOKE", _this ] spawn T8U_fnc_DebugLog; };
		_vehicle = "SmokeShell" createVehicle ( getPos _unit );
		_vehicle setVelocity [ ( sin ( _dir ) * ( 7 + random 3 ) ), ( cos ( _dir ) * ( 7 + random 3 ) ), ( 6 + random 3 ) ];
	};
};


