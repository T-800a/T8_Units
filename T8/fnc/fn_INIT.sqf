/*
 =======================================================================================================================

	T8 Units Script

	File:		fn_INIT.sqf
	Author:		T-800a
	E-Mail:		t-800a@gmx.net
	
	Open < T8\CONFIG.hpp > to change basic variables !

 =======================================================================================================================
*/

// include the few macros we use ...
#include <..\MACRO.hpp>

// include CONFIG FILE
#include <..\CONFIG.hpp>


// cancel execute if not server / hc
__allowEXEC(__FILE__);


// if ( T8U_var_DEBUG_useCon ) exitWith { "debug_console" callExtension ("C"); };

__DEBUG( __FILE__, "======================================================================================", "" );
__DEBUG( __FILE__, "T8 Units", "INIT STARTED" );

// Clear empty groups every 30 seconds (ignores DAC groups)
[] spawn T8U_fnc_GroupClearEmpty;

// Per Unit Tracking on Debug ( only in SP editor or when User = Server ) / Delete DebugMarker (check every 30s for ones older than 180s)
if ( T8U_var_DEBUG ) then { [] spawn T8U_fnc_TrackAllUnits; [] spawn T8U_fnc_DebugMarkerDelete; };

// Were are good to go!
// only used for missionEXEC.sqf! 
T8U_var_InitDONE = true;

__DEBUG( __FILE__, "T8 Units", "INIT FINISHED" );
__DEBUG( __FILE__, "======================================================================================", "" );
