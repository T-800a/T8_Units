/*
 =======================================================================================================================

	T8 Units Script
	
	Funktion:	fn_broadcastHint.sqf
	Author:		T-800a
	E-Mail:		t-800a@gmx.net

 =======================================================================================================================
*/

#include <..\MACRO.hpp>

private [ "_text" ];

_text = param [ 0, "", [""]];

[ _text ] remoteExecCall [ "T8U_fnc_Hint", 0, false ];

// [[ _text ], "T8U_fnc_Hint" ] spawn BIS_fnc_MP;
