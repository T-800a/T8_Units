/*
 =======================================================================================================================

	___ T8 Units _______________________________________________________________________________________________________
	
	Unit Spawn & Communication Script
	
	File:		T8_UnitINIT.sqf
	Author:		T-800a
	E-Mail:		t-800a@gmx.net
	
	
	Open < T8_UnitsCONFIG.hpp > to change basic variables !

	
	This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
	To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/ or send a letter to 
	Creative Commons, 444 Castro Street, Suite 900, Mountain View, California, 94041, USA.

 =======================================================================================================================
*/

// File Locations / Folders
T8U_dir_ROOT		= "T8\";
T8U_dir_FNCS		= "T8_fncs\";
T8U_dir_TASK		= "T8_tasks\";
T8U_dir_SUPP		= "T8_supports\";

// run the script on Headless Client and not on the Server
//			!! WARNING: this is untested !!
T8U_var_useHC		= false;

// include the Hint Broadcast
#include <T8\T8_UnitsHB.sqf>


// Rest of the Script is Server Only!
private [ "_exit" ]; _exit = false;
if ( T8U_var_useHC ) then { if ( isDedicated ) then { _exit = true; } else { waitUntil { !isNull player };	if ( hasInterface ) then { _exit = true; }; }; } else { if ( !isServer ) then { _exit = true; }; };
if ( _exit ) exitWith {};



// include CONFIG FILE
#include <T8_UnitsCONFIG.sqf>

// include the T8_Units functions
#include <T8\T8_Units.sqf>

// debug marker delteion queue
T8U_var_DebugMarkerCache = [];

waituntil { !isNil "bis_fnc_init" };


// Were are good to go!
T8U_var_InitDONE = true;

// Clear empty groups every 30 seconds (ignores DAC groups)
[] spawn T8U_fnc_GroupClearEmpty;

// Per Unit Tracking on Debug ( only in SP editor or when User = Server ) / Delete DebugMarker (check every 30s for ones older than 180s)
if ( T8U_var_DEBUG ) then { [] spawn T8U_fnc_TrackAllUnits; [] spawn T8U_fnc_DebugMarkerDelete; };
