/*
 =======================================================================================================================

	T8 Units Script

	Funktion:	fn_moveOut.sqf
	Author:		T-800a
	E-Mail:		t-800a@gmx.net

 =======================================================================================================================
*/

#include <..\MACRO.hpp>

private [ "_unit", "_pos", "_wait", "_oldGroup" ];

_unit		= param [ 0, objNull, [objNull]];
_pos		= [];
_wait		= true;

if ( T8U_var_DEBUG ) then { [ "fn_moveOut.sqf", "INIT", _this ] spawn T8U_fnc_DebugLog; };
if ( isNull _unit ) exitWith {};

if (( count _this ) > 1 ) then 
{
	switch ( typeName ( _this select 1 )) do 
	{ 
		case "ARRAY":	{ _pos		= [ _this, 1, [], [[]] ] call BIS_fnc_param; };
		case "BOOL":	{ _wait		= [ _this, 1, false, [true] ] call BIS_fnc_param; };
		default {};
	};
};

if (( count _this ) > 2 ) then 
{
	switch ( typeName ( _this select 2 )) do 
	{ 
		case "ARRAY":	{ _pos		= [ _this, 2, [], [[]] ] call BIS_fnc_param; };
		case "BOOL":	{ _wait		= [ _this, 2, false, [true] ] call BIS_fnc_param; };
		default {};
	};
};

if ( _wait ) then 
{
	_oldGroup = group _unit;
	waitUntil { sleep 5; ( _oldGroup != ( group _unit )) OR ( !alive _unit ) };
};

if ( alive _unit ) then 
{
	private [ "_veh" ];
	_veh = assignedVehicle _unit;
	
	if ( !isNull _veh ) then
	{
		[ _unit ] orderGetIn false;
		_unit leaveVehicle _veh;
		_unit action [ "getOut", _veh ];
		unassignVehicle _unit;
	};
	
	if (( count _pos ) > 0 ) then
	{
		sleep 1;
		_unit setPos _pos;
	};
	
	_unit setUnitPos "UP";
	_unit setUnitPos "AUTO";
	_unit forceSpeed -1;
	_unit switchMove "";
};
