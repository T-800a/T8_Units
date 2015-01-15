/*
 =======================================================================================================================

	T8 Units Script

	Funktion:	fn_groupClearWaypoints.sqf
	Author:		T-800a
	E-Mail:		t-800a@gmx.net

 =======================================================================================================================
*/

private [ "_originGroup", "_originUnits", "_newGroup", "_newSide" ];

_originGroup = _this select 0;
_originUnits = _originGroup getVariable [ "T8U_gvar_Member", [] ];
_newSide = side _originGroup;

if ( T8U_var_DEBUG ) then { [ "fn_groupClearWaypoints.sqf", "INIT", _this ] spawn T8U_fnc_DebugLog; };

_newGroup = createGroup _newSide;

[ _originGroup, _newGroup ] call T8U_fnc_GroupCopyVars;

{ if ( alive _x ) then { [ _x ] joinSilent _newGroup; }; } forEach _originUnits;

// [ _originGroup, _newGroup ] call T8U_fnc_GroupCopyVars;

deleteGroup _originGroup;

if ( T8U_var_DEBUG ) then { [ "fn_groupClearWaypoints.sqf", "NEW GROUP", [ _newGroup ] ] spawn T8U_fnc_DebugLog; };

// ReturnValue
_newGroup
