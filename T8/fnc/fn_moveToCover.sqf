/*
 =======================================================================================================================

	T8 Units Script
	
	Funktion:	fn_getInCover.sqf
	Author:		T-800a
	E-Mail:		t-800a@gmx.net ( thanks to  fabrizio_T for the hint on how to find cover )

 =======================================================================================================================
*/

#include <..\MACRO.hpp>

private [ "_unit", "_cover", "_cObj", "_rm", "_rmR", "_coverPos", "_watchPos", "_dir", "_cm" ];

_unit		= param [ 0, objNull, [objNull]];

if ( T8U_var_DEBUG ) then { [ "fn_getInCover.sqf", "INIT", _this ] spawn T8U_fnc_DebugLog; };

if ( isNull _unit ) exitWith { false };

doStop _unit;
_watchPos = getPos _unit;

_cObj = nearestObjects [ _unit, [], 25 ];
_rm = nearestObjects [ _unit, [ "HOUSE", "AllVehicles" ], 25 ];
_rmR = _unit nearRoads 25;
_cObj = _cObj - _rm - _rmR;

_cover = [];

{ 
	private [ "_bbr", "_p1", "_p2", "_maxWidth", "_maxLength", "_maxHeight", "_name" ];
    _bbr = boundingBoxReal _x; 
	_p1 = _bbr select 0; 
	_p2 = _bbr select 1; 
	_maxWidth = abs ((_p2 select 0) - (_p1 select 0)); 
	_maxLength = abs ((_p2 select 1) - (_p1 select 1)); 
	_maxHeight = abs ((_p2 select 2) - (_p1 select 2));
	if ( _maxWidth > 2.0 AND { _maxLength > 0.5 } AND { _maxHeight > 1.0 } AND { _maxLength < 5.0 } AND { _maxHeight < 10.0 } ) then
	{
		_cover pushBack _x;
	};
} forEach _cObj;

if ( T8U_var_DEBUG ) then { [ "fn_getInCover.sqf", "COVER", [ _cover ] ] spawn T8U_fnc_DebugLog; };

if ( count _cover > 0 ) then 
{
	_cover = _cover call BIS_fnc_selectRandom;
	_coverPos = getPos _cover;
	_coverPos = [ ( _coverPos select 0 ), ( _coverPos select 1 ), 0 ];
	
	if ( T8U_var_DEBUG ) then 
	{ 
		_a = "Sign_Arrow_Blue_F" createVehicle _coverPos;
		_a setPosATL [ ( _coverPos select 0 ), ( _coverPos select 1 ), 2 ];
	};

	if ( T8U_var_DEBUG ) then { [ "fn_getInCover.sqf", "COVER POS", [ _coverPos ] ] spawn T8U_fnc_DebugLog; };

	_unit doMove _coverPos;
	
	_cm = behaviour _unit; 
	_t = time + 20;
	waitUntil 
	{
		sleep 0.5;
		if ( _cm != behaviour _unit ) exitWith {};
		_unit doMove _coverPos; 
		if ( _t > time ) then { ( ( getPos _unit ) distance _coverPos ) < 3 } else { true };
	};
	
	doStop _unit; 
	if ( _cm == behaviour _unit ) then { _unit forceSpeed 0; };
	
	if ( T8U_var_DEBUG ) then { [ "fn_getInCover.sqf", "DISTANCE TO COVER", [ (( getPos _unit ) distance _coverPos ) ] ] spawn T8U_fnc_DebugLog; };

	_unit doWatch _watchPos;
};

if ( T8U_var_DEBUG ) then { [ "fn_getInCover.sqf", "DONE" ] spawn T8U_fnc_DebugLog; };

_unit setUnitPos "Middle";
doStop _unit;

// Return
true
