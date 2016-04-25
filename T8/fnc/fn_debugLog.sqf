/*
 =======================================================================================================================

	T8 Units Script
	
	Funktion:	fn_debugLog.sqf
	Author:		T-800a
	E-Mail:		t-800a@gmx.net

	[ "", "", _this ] spawn T8U_fnc_DebugLog;
	
 =======================================================================================================================
*/

#define conBeep() "debug_console" callExtension ("A")
#define conClear() "debug_console" callExtension ("C")
#define conClose() "debug_console" callExtension ("X")
#define conWhite(_msg) "debug_console" callExtension (_msg + "#1110")
#define conWhiteTime(_msg) "debug_console" callExtension (_msg + "#1111")
#define conRed(_msg) "debug_console" callExtension (_msg + "#1000")
#define conRedTime(_msg) "debug_console" callExtension (_msg + "#1001")
#define conGreen(_msg) "debug_console" callExtension (_msg + "#0100")
#define conGreenTime(_msg) "debug_console" callExtension (_msg + "#0101")
#define conBlue(_msg) "debug_console" callExtension (_msg + "#0010")
#define conBlueTime(_msg) "debug_console" callExtension (_msg + "#0011")
#define conYellow(_msg) "debug_console" callExtension (_msg + "#1100")
#define conYellowTime(_msg) "debug_console" callExtension (_msg + "#1101")
#define conPurple(_msg) "debug_console" callExtension (_msg + "#1010")
#define conPurpleTime(_msg) "debug_console" callExtension (_msg + "#1011")
#define conCyan(_msg) "debug_console" callExtension (_msg + "#0110")
#define conCyanTime(_msg) "debug_console" callExtension (_msg + "#0111")
#define conFile(_msg) "debug_console" callExtension (_msg + "~0000")
#define conFileTime(_msg) "debug_console" callExtension (_msg + "~0001")

if ( !T8U_var_DEBUG ) exitWith {};

params [
	[ "_f", "___no_file___" ],
	[ "_t", "___" ],
	[ "_v", "___" ],
	[ "_h", true, [true]],
	"_ftxt"
];

_f = _f splitString "\";
reverse _f;

_ftxt	= format [ "T8U >> %1 >> %2 >>>>> %3 >> %4", ( round diag_fps ), ( _f select 0 ), _t, _v ]; 

if ( T8U_var_DEBUG_useCon ) exitWith { if ( _h ) then { conCyan( _ftxt )} else { conWhite( _ftxt ); }; };
[ "%1", _ftxt ] call BIS_fnc_error;

