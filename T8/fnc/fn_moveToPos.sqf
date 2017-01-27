/*
 =======================================================================================================================

	T8 Units Script

	Funktion:	fn_moveToPos.sqf
	Author:		Zorilya + T-800a

	form Garrison Script ( needed a small mod to work properly with T8 Units )

 =======================================================================================================================
*/

#include <..\MACRO.hpp>

params [
	[ "_unit", objNull, [objNull]],
	[ "_pos", [], [[],objNull]],
	[ "_stance", false, [true]],
	[ "_dir", 99999, [123]],
	[ "_watchPos", [], [[]]],
	[ "_immobile", false, [true]]
];

// __DEBUG( __FILE__, "INIT", _this );

if ( ( typeName _pos ) != "ARRAY" ) then { _pos = ( getPosATL _pos ) };

_unit setUnitPos "AUTO";
_unit setUnitPos "UP";

private _group		= group _unit;
private _abort		= false;
private _move		= { doStop _unit; sleep 0.01; _unit moveTo _pos; }; call _move;
private _cnt		= 0;
private _idleCnt	= 0;
private _idle		= false;
private _reached	= false;

while { !_reached } do
{
	private _uPos		= getPosATL _unit;
	private _dist		= _uPos distance _pos;
	private _speed		= speed _unit;

	if ( _group != group _unit ) exitWith { _abort = true; };
	if ( !( alive _unit ) ) exitwith {};

	if ( _speed <= 0.1 ) then { _idleCnt = _idleCnt + 1 } else { _idleCnt = 0; _idle = false };
	if ( _idleCnt >= 4 ) then { _idle = true };

	if ( _idle ) then
	{
		_cnt = _cnt + 1;
		call _move;
	};

	if ( _dist < 1 ) exitwith { _reached = true };
	if ( _cnt > 3 ) exitwith {};
	sleep 3;
};

if ( ! _abort ) then
{
	doStop _unit;
	if ( _dir < 99999 ) then { _unit setDir _dir; };
	if (( count _watchPos ) > 0 ) then { _unit doWatch _watchPos; };
	if ( _immobile ) then { _unit disableAI "MOVE"; };
	if ( _stance AND { random 100 > 33 } ) then { _unit setUnitPos "Middle"; };
};

// __DEBUG( __FILE__, "FINISHED", _this );

// Return
true
