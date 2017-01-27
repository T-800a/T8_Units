/*
 =======================================================================================================================

	T8 Units Script
	
	Funktion:	fn_getOutCover.sqf
	Author:		T-800a
	E-Mail:		t-800a@gmx.net

 =======================================================================================================================
*/

#include <..\MACRO.hpp>

private [ "_unit", "_group", "_units" ];

_unit		= param [ 0, objNull, [objNull]];
if ( isNull _unit ) exitWith { false };

_group		= group _unit;
_units 		= units _group;

__DEBUG( __FILE__, "INIT", _this );

_unit setUnitPos "UP";
_unit setUnitPos "AUTO";
_unit forceSpeed -1;
_unit switchMove "";

[ _group ] call T8U_fnc_ForceNextWaypoint;

{
	[ _x ] joinSilent _group;
	[ _x, false ] spawn T8U_fnc_MoveOut; 
	false
} count _units;

__DEBUG( __FILE__, "FINISHED", _this );

// Return
true
