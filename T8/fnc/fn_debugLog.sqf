/*
 =======================================================================================================================

	T8 Units Script
	
	Funktion:	fn_debugLog.sqf
	Author:		T-800a
	E-Mail:		t-800a@gmx.net

	[ "", "", _this ] spawn T8U_fnc_DebugLog;
	
 =======================================================================================================================
*/

#define conFile(_msg) "debug_console" callExtension (_msg + "~0000")
#define conFileTime(_msg) "debug_console" callExtension (_msg + "~0001")

if ( !T8U_var_DEBUG ) exitWith {};

params [
	[ "_f", "___no_file___" ],
	[ "_t", "___" ],
	[ "_v", "___" ],
	"_ftxt"
];

_f = _f splitString "\";
reverse _f;

_ftxt	= format [ "T8U >> %1 >> %2 >>>>> %3 >> %4", ( round diag_fps ), ( _f select 0 ), _t, _v ]; 

if ( T8U_var_DEBUG_useCon ) exitWith { conFileTime( _ftxt ); };
[ "%1", _ftxt ] call BIS_fnc_error;