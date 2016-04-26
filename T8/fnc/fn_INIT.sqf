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
// 
// #include <..\CONFIG.hpp>

// cancel execute if not server / hc
__allowEXEC(__FILE__);


__DEBUGCLEAR();
__DEBUG( "INIT", "======================================================================================", "" );
__DEBUG( "INIT", "T8 Units", "INIT STARTED" );


// loading main configuration from missionConfigFile / configFile 
[] call T8U_fnc_loadConfig;


if ( T8U_var_DEBUG ) then 
{
	// per unit tracking on Debug (only in SP editor or when player = server )
	[] spawn T8U_fnc_TrackAllUnits;
	
	// delete debug markers (checks every 30s for markers older than 180s)
	[] spawn T8U_fnc_DebugMarkerDelete;
};


// start our group handling / communication management
[] spawn T8U_fnc_handleGroups;


// clear empty groups every 30 seconds (ignores DAC owned groups)
[] spawn T8U_fnc_GroupClearEmpty;


// we are good to go!
// only used for missionEXEC.sqf! 
T8U_var_InitDONE = true;

__DEBUG( "INIT", "T8 Units", "INIT FINISHED" );
__DEBUG( "INIT", "======================================================================================", "" );

