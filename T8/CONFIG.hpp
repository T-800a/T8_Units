/*
 =======================================================================================================================

	T8 Units Script
	
	Unit Spawn & Communication Script
	
	File:		CONFIG.hpp
	Author:		T-800a
	E-Mail:		t-800a@gmx.net
	
	init.sqf: 	[] execVM "T8_UnitINIT.sqf";
				[] execVM "T8_missionEXEC.sqf";


	check  "T8_missionEXEC.sqf" to start spawning stuff...
		
	// Some information about variables saved to groups

	T8U_gvar_Comm 			-> [ bool, bool, bool ]		-> shares info, can be called, can react when attacked
	T8U_gvar_Origin			-> array					-> originTask: Marker, originTask: Order, ... 
	T8U_gvar_Assigned		-> string					-> has Task Assigned: NO_TASK, CQC_SHOT, DC_ASSIST, ...
	T8U_gvar_Member			-> array					-> array of the origin units who are spawned
	T8U_gvar_Regrouped		-> bool						-> for GARRISON, PATROL_GARRISON: is set true when after group is released from task, now they can do their new task
	T8U_gvar_FiredEvent		-> array					-> Array filled by Fired Event
	T8U_gvar_Attacked		-> integer					-> time units of the group were last HIT ... if 'first time' force prone (0 targets) / suppressing fire (1++ targets)
	T8U_gvar_called			-> integer					-> time unit sent last call for help (general / set if other T8U group is called)
	T8U_gvar_DACcalled		-> integer					-> time Group last called DAC for HELP
	T8U_gvar_PARAcalled		-> integer					-> time Group last called for a Support (e.g. Para drop)
	T8U_gvar_ignoreGroup	-> bool						-> set by group handle if it shall ignore group (for quicker execution after 'first check')
	
	T8U_gvar_Introduced		-> bool						-> set true after editor groub is introduced to T8U

	This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
	To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/ or send a letter to 
	Creative Commons, 444 Castro Street, Suite 900, Mountain View, California, 94041, USA.

 =======================================================================================================================
*/

#define false			1
#define true			2

#define EAST			0
#define WEST			1
#define RESISTANCE		2
#define CIVILIAN		3


class cfgT8Units
{
	// DEBUG Settings
	class debug
	{
		// general debug switch
		enable				= true;

		// show debug Hints
		allow_hints			= true;

		// create debug markers
		allow_marker		= true;

		// send debug messages to Killzone Kids console instead of RPT file
		// http://killzonekid.com/arma-console-extension-debug_console-dll-v3-0/
		allow_console		= true;	
	};

	// MAIN configuration
	class main
	{
		// run the script on headless client and not on the Server
		// !! WARNING: this is untested !!
		use_HeadlessClient	= false;

		// option to register units with ZEUS
		// this may slow down spawning
		// will registers spawned units with "allCurators"
		allow_ZEUS			= true;

		// standard side for spawned units
		enemySide			= EAST;

		// RESISTANCE diplomacy 'switch'
		// for finding enemies and allies when calling for help - check with your mission settings
		//   0 : RESISTANCE neutral
		//   1 : RESISTANCE friendly to WEST
		//   2 : RESISTANCE friendly to EAST
		//   3 : RESISTANCE enemy of both; 
		diplomacy			= 1;
	};
	
	
	// options to work with DAC by Silola
	class dac
	{
		// allow T8U to send a "call for help" to DAC
		enable				= false;
		
		// timeout for a group until it can sent the next "call for help"
		timeout				= 180;			
	};
	
};





/*



// Units will go RED when in combat, then go GREEN after some time ( T8_UnitsEngageAtWillTime ), and then return to T8U_fnc_SpawnCombatMode
T8U_var_AllowCBM				= true;

T8U_var_TaskReturnTime			= 30;			// when SAD WP is finished group will redo origin task after x sec
T8U_var_CacheTime				= 15;			// units in Zones are cached after X seconds when zone is left
T8U_var_DirectCallRange			= 1500;			// group leader searches for help within XXX m
T8U_var_RevealRange				= 500;			// group leader shares info of enemies he "knowsabout > 1" to friendly units within XXX m
T8U_var_PatAroundRange			= 50;			// zone radius + T8U_var_PatAroundRange (e.g. 40 m) is the distance where units will patrol around zones.
T8U_var_KilledLeaderTimeout		= 20;			// if group leader killed, x sec no communication > then check for new group leader who can communicate
T8U_var_FiredEventTimeout		= 10;			// if fired near event triggered, pause it for XX sec ... spam reduce
T8U_var_CallForHelpTimeout		= 60;			// a group can only call one other group each x sec for help
T8U_var_SupportTimeout			= 180;			// every X sec a group (with a SL or Officer) can call in for a Support (e.g. para drop)
T8U_var_OvSuperiority			= 3;			// if enemy units have a overwhelming superiority of 3 : 1 they wont call for help ( checked at that moment when they call for help )
T8U_var_enableFatigue			= false;		// enable/disable Fatigue for all spawned units

T8U_var_Presets =
[
//	[ --index from T8U_var_SkillSets--, --index from T8U_var_BehaviorSets-- ],
	[ 2, 1 ],		// 0 for WEST
	[ 1, 0 ],		// 1 for EAST
	[ 1, 2 ]		// 2 for RESISTANCE
];

T8U_var_SkillSets = 
[
// 0 - militia ( untrained )
	[
		[ "aimingAccuracy",		0.20 ],
		[ "aimingShake",		0.15 ],
		[ "aimingSpeed",		0.20 ],
		[ "spotDistance",		0.75 ],
		[ "spotTime",			0.70 ],
		[ "courage",			0.30 ],
		[ "reloadSpeed",		0.20 ],
		[ "commanding",			0.50 ],
		[ "general",			0.50 ]
	],
	
// 1 - regular forces
	[
		[ "aimingAccuracy",		0.30 ],
		[ "aimingShake",		0.25 ],
		[ "aimingSpeed",		0.30 ],
		[ "spotDistance",		0.85 ],
		[ "spotTime",			0.75 ],
		[ "courage",			0.50 ],
		[ "reloadSpeed",		0.40 ],
		[ "commanding",			0.70 ],
		[ "general",			0.70 ]
	],

// 2 - special forces
	[
		[ "aimingAccuracy",		0.45 ],
		[ "aimingShake",		0.40 ],
		[ "aimingSpeed",		0.50 ],
		[ "spotDistance",		0.95 ],
		[ "spotTime",			0.90 ],
		[ "courage",			0.70 ],
		[ "reloadSpeed",		0.60 ],
		[ "commanding",			0.90 ],
		[ "general",			0.90 ]
	]
];

T8U_var_BehaviorSets = 
[
// 0 - aggressive
	[
		"YELLOW",				// spawn Combat-Mode
		"RED",					// max. Combat-Mode when unit behaviour changes to COMBAT
		"WHITE",				// Combat-Mode after some time in max. Combat-Mode
		180						// time the group stays in max. Combat-Mode
	],

// 1 - defensive
	[
		"GREEN",
		"YELLOW",
		"GREEN",
		90
	],
	
// 2 - medicore
	[
		"GREEN",
		"RED",
		"GREEN",
		120
	]
];

// Vehicles a group can use to travel greater distance (when they are called for help) 
//		if you want to allow vehicles from other Add-ons, add them here
T8U_var_ReinforceVehicle = [	"APC_Tracked_01_base_F", "APC_Tracked_02_base_F", "Wheeled_APC_F", "Truck_01_base_F", "Truck_02_base_F", "MRAP_01_base_F",
								"MRAP_02_base_F", "MRAP_03_base_F", "C_Offroad_01_F", "I_G_Offroad_01_F" ];

T8U_var_SuppressingUnits = [	"B_soldier_AR_F", "B_G_soldier_AR_F", "O_soldier_AR_F", "O_soldierU_AR_F", "O_G_soldier_AR_F", "I_soldier_AR_F", "I_G_soldier_AR_F" ];

// debug marker delteion queue
T8U_var_DebugMarkerCache = [];



///// NOT IN USE ///// DO NOT CHANGE ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// not implemented ( if it ever will!?)... if you set this true it will disable calling for help and reaction to combat of the groups
T8U_var_CommanderEnable = false;


*/





///// END OF CONFIG FILE ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////