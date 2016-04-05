/*
 =======================================================================================================================

	T8 Units Script

	Funktion:	fn_groupCopyVars.sqf
	Author:		T-800a
	E-Mail:		t-800a@gmx.net

 =======================================================================================================================
*/

#include <..\MACRO.hpp>

private [ "_oldGroup", "_newGroup", "_var01", "_var02", "_var03", "_var04", "_var05", "_var06", "_var07", "_var08", "_var09" ];

_oldGroup = _this select 0;
_newGroup = _this select 1;

if ( isNull	_oldGroup OR isNil "_oldGroup" OR isNull _newGroup OR isNil "_newGroup" ) exitWith { if ( T8U_var_DEBUG ) then { [ "fn_groupClearWaypoints.sqf", "ABORT: ANY GROUP isNULL or isNIL", [] ] spawn T8U_fnc_DebugLog; }; };

_var01 = _oldGroup getVariable [ "T8U_gvar_Comm",		[] ];
_var02 = _oldGroup getVariable [ "T8U_gvar_Origin",		[] ];
_var03 = _oldGroup getVariable [ "T8U_gvar_Assigned",	"NO_TASK" ];
_var04 = _oldGroup getVariable [ "T8U_gvar_Member",		[] ];
_var05 = _oldGroup getVariable [ "T8U_gvar_Attacked", 	-99999 ];
_var06 = _oldGroup getVariable [ "T8U_gvar_called",		-99999 ];
_var07 = _oldGroup getVariable [ "T8U_gvar_DACcalled",	-99999 ];
_var08 = _oldGroup getVariable [ "T8U_gvar_PARAcalled",	-99999 ];
_var09 = _oldGroup getVariable [ "T8U_gvar_Regrouped",	false ];

_oldGroup setVariable [ "T8U_gvar_Comm",		[], false ];
_oldGroup setVariable [ "T8U_gvar_Origin",		[], false ];
_oldGroup setVariable [ "T8U_gvar_Assigned",	"---", false ];
_oldGroup setVariable [ "T8U_gvar_Member",		[], false ];
_oldGroup setVariable [ "T8U_gvar_Attacked",	-99999, false ];
_oldGroup setVariable [ "T8U_gvar_called",		-99999, false ];
_oldGroup setVariable [ "T8U_gvar_DACcalled",	-99999, false ];
_oldGroup setVariable [ "T8U_gvar_PARAcalled",	-99999, false ];
_oldGroup setVariable [ "T8U_gvar_Regrouped",	false, false ];

_newGroup setVariable [ "T8U_gvar_Comm",		_var01, false ];
_newGroup setVariable [ "T8U_gvar_Origin",		_var02, false ];
_newGroup setVariable [ "T8U_gvar_Assigned",	_var03, false ];
_newGroup setVariable [ "T8U_gvar_Member",		_var04, false ];
_newGroup setVariable [ "T8U_gvar_Attacked",	_var05, false ];
_newGroup setVariable [ "T8U_gvar_called",		_var06, false ];
_newGroup setVariable [ "T8U_gvar_DACcalled",	_var07, false ];
_newGroup setVariable [ "T8U_gvar_PARAcalled",	_var08, false ];
_newGroup setVariable [ "T8U_gvar_Regrouped",	_var09, false ];

leader _oldGroup setVariable [ "T8_UnitsVarLeaderGroup", _newGroup, false ];

if ( T8U_var_DEBUG ) then { [ "fn_groupClearWaypoints.sqf", "GROUP", [ _oldGroup, _newGroup ] ] spawn T8U_fnc_DebugLog; };
if ( T8U_var_DEBUG ) then { [ "fn_groupClearWaypoints.sqf", "COPYIED VARS", [ _var01, _var02, _var03, _var04, _var05, _var06, _var07, _var08 ] ] spawn T8U_fnc_DebugLog; };
