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


// cancel double execution (if script and addon present)
if ( !isNil "T8U_var_INIT" ) exitWith {};
T8U_var_INIT = true;


// loading main configuration from missionConfigFile / configFile 
[] call T8U_fnc_loadConfig;


__DEBUG( "INIT", "======================================================================================", "" );
__DEBUG( "INIT", "T8 Units", "INIT STARTED" );


// cancel execute if not server / hc
__allowEXEC(__FILE__);


if ( T8U_var_DEBUG ) then 
{
	// per unit tracking on Debug (only in SP editor or when player = server )
	[] spawn T8U_fnc_TrackAllUnits;
	
	// delete debug markers (checks every 30s for markers older than 180s)
	[] spawn T8U_fnc_DebugMarkerDelete;
};


// start our group handling / communication management
[] spawn T8U_fnc_handleGroups;


// we are good to go!
// only used for missionEXEC.sqf! 
T8U_var_InitDONE = true;

__DEBUG( "INIT", "T8 Units", "INIT FINISHED" );
__DEBUG( "INIT", "======================================================================================", "" );

