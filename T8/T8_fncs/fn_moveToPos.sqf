/*
 =======================================================================================================================

	T8 Units Script

	Funktion:	fn_moveToPos.sqf
	Author:		Zorilya + T-800a

	form Garrison Script ( needed a small mod to work properly with T8 Units )

 =======================================================================================================================
*/

private [ "_unit", "_group", "_abort", "_pos", "_stance", "_move", "_reached", "_uPos", "_dist", "_cnt", "_b", "_d" ];

_unit		= _this select 0;
_pos		= _this select 1; if ( ( typeName _pos ) != "ARRAY" ) then { _pos = ( getPosATL _pos ) };
_stance		= [ _this, 2, false, [true] ] call BIS_fnc_param;

_unit setUnitPos "AUTO";
_unit setUnitPos "UP";
_group = group _unit;
_abort = false;

_move = { doStop _unit; sleep 0.01; _unit moveTo _pos; }; call _move;

_cnt = 0;
_idleCnt = 0;
_idle = false;
_reached = false;

while { !_reached } do
{
	_uPos = getPosATL _unit;
	_dist = _uPos distance _pos;
	_speed = speed _unit;

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
	if ( _stance AND { random 100 > 33 } ) then { _unit setUnitPos "Middle"; };
};

// Return
true
