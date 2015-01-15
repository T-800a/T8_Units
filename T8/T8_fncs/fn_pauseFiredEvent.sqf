/*
 =======================================================================================================================

	T8 Units Script
	
	Funktion:	fn_pauseFiredEvent.sqf
	Author:		T-800a
	E-Mail:		t-800a@gmx.net

 =======================================================================================================================
*/

private [ "_unit" ];
_unit = _this select 0;
_unit removeAllEventHandlers "FiredNear";
if ( T8U_var_DEBUG ) then { [ "fn_pauseFiredEvent.sqf", "removeAllEventHandlers -> FiredNear", _this ] spawn T8U_fnc_DebugLog; };
true
