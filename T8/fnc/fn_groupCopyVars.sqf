/*
 =======================================================================================================================

	T8 Units Script

	Funktion:	fn_groupCopyVars.sqf
	Author:		T-800a
	E-Mail:		t-800a@gmx.net

 =======================================================================================================================
*/

#include <..\MACRO.hpp>

params [ "_oldGroup", "_newGroup" ];

if ( isNil "_oldGroup" OR isNil "_newGroup" ) exitWith { __DEBUG( __FILE__, "ABORT", "ONE GROUP is NIL"); false };
if ( isNull	_oldGroup  OR isNull _newGroup  ) exitWith { __DEBUG( __FILE__, "ABORT", "ONE GROUP is NULL"); false };

private _var01 = __GetOVAR( _oldGroup, "T8U_gvar_Comm",			[] );
private _var02 = __GetOVAR( _oldGroup, "T8U_gvar_Origin",		[] );
private _var03 = __GetOVAR( _oldGroup, "T8U_gvar_Assigned",		"NO_TASK" );
private _var04 = __GetOVAR( _oldGroup, "T8U_gvar_Member",		[] );
private _var05 = __GetOVAR( _oldGroup, "T8U_gvar_Attacked", 	-99999 );
private _var06 = __GetOVAR( _oldGroup, "T8U_gvar_called",		-99999 );
private _var07 = __GetOVAR( _oldGroup, "T8U_gvar_DACcalled",	-99999 );
private _var08 = __GetOVAR( _oldGroup, "T8U_gvar_PARAcalled",	-99999 );
private _var09 = __GetOVAR( _oldGroup, "T8U_gvar_Regrouped",	false );
private _var10 = __GetOVAR( _oldGroup, "T8U_gvar_Settings",		[] );

__SetOVAR( _oldGroup, "T8U_gvar_Comm",			[] );
__SetOVAR( _oldGroup, "T8U_gvar_Origin",		[] );
__SetOVAR( _oldGroup, "T8U_gvar_Assigned",		"---" );
__SetOVAR( _oldGroup, "T8U_gvar_Member",		[] );
__SetOVAR( _oldGroup, "T8U_gvar_Attacked",		-99999 );
__SetOVAR( _oldGroup, "T8U_gvar_called",		-99999 );
__SetOVAR( _oldGroup, "T8U_gvar_DACcalled",		-99999 );
__SetOVAR( _oldGroup, "T8U_gvar_PARAcalled",	-99999 );
__SetOVAR( _oldGroup, "T8U_gvar_Regrouped",		false );
__SetOVAR( _oldGroup, "T8U_gvar_Settings",		[] );

__SetOVAR( _newGroup, "T8U_gvar_Comm",			_var01 );
__SetOVAR( _newGroup, "T8U_gvar_Origin",		_var02 );
__SetOVAR( _newGroup, "T8U_gvar_Assigned",		_var03 );
__SetOVAR( _newGroup, "T8U_gvar_Member",		_var04 );
__SetOVAR( _newGroup, "T8U_gvar_Attacked",		_var05 );
__SetOVAR( _newGroup, "T8U_gvar_called",		_var06 );
__SetOVAR( _newGroup, "T8U_gvar_DACcalled",		_var07 );
__SetOVAR( _newGroup, "T8U_gvar_PARAcalled",	_var08 );
__SetOVAR( _newGroup, "T8U_gvar_Regrouped",		_var09 );
__SetOVAR( _newGroup, "T8U_gvar_Settings",		_var10 );

__DEBUG( __FILE__, "T8U_gvar_Comm",				_var01 );
__DEBUG( __FILE__, "T8U_gvar_Origin",			_var02 );
__DEBUG( __FILE__, "T8U_gvar_Assigned",			_var03 );
__DEBUG( __FILE__, "T8U_gvar_Member",			_var04 );
__DEBUG( __FILE__, "T8U_gvar_Attacked",			_var05 );
__DEBUG( __FILE__, "T8U_gvar_called",			_var06 );
__DEBUG( __FILE__, "T8U_gvar_DACcalled",		_var07 );
__DEBUG( __FILE__, "T8U_gvar_PARAcalled",		_var08 );
__DEBUG( __FILE__, "T8U_gvar_Regrouped",		_var09 );
__DEBUG( __FILE__, "T8U_gvar_Settings",			_var10 );

// return
true
