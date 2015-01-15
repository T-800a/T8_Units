/*
 =======================================================================================================================

	T8 Units Script
	
	Funktion:	fn_zoneNotAktiv.sqf
	Author:		T-800a
	E-Mail:		t-800a@gmx.net

 =======================================================================================================================
*/

private [ "_string" ];

_string = _this select 0;

missionNamespace setVariable [ str( _string + "_active" ), false ];

true
