/*
 =======================================================================================================================

	T8 Units Script

	Funktion:	fn_moveOut.sqf
	Author:		T-800a
	E-Mail:		t-800a@gmx.net

 =======================================================================================================================
*/

private [ "_unit", "_pos", "_oldGroup" ];

_unit = _this select 0;
_pos = _this select 1;

_oldGroup = group _unit;

waitUntil { sleep 5; ( _oldGroup != group _unit OR !alive _unit ) };

if ( alive _unit ) then { _unit setPos _pos; };
