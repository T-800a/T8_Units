/*
 =======================================================================================================================

	T8 Units Script
	
	Funktion:	fn_releaseGroup.sqf
	Author:		T-800a
	E-Mail:		t-800a@gmx.net

 =======================================================================================================================
*/

#include <..\MACRO.hpp>

private [ "_task", "_group", "_return", "_commArray", "_execTask" ];

_group = _this select 0;
if ( isNull _group ) exitWith { true };

_task = _group getVariable [ "T8U_gvar_Assigned", "NO_TASK" ];
_commArray = _group getVariable [ "T8U_gvar_Comm", [ false, false, false ]];

_execTask = _commArray select 1;

if ( _execTask ) then 
{
	if ( _task != "NO_TASK" ) then { _return = true; } else { _return = false; };
} else {
	if ( _task != "NO_TASK" AND { _task != "DC_ASSIST" } AND { _task != "FLANK_ATTACK" }  AND { _task != "CQC_SHOT" } ) then { _return = true; } else { _return = false; };
};

// Return
_return
