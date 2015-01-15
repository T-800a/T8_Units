/*
 =======================================================================================================================

	___ T8 Units _______________________________________________________________________________________________________

	File:		T8_missionEXEC.sqf
	Author:		T-800a
	E-Mail:		t-800a@gmx.net

	This file creates the Units, kind of
	

	This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
	To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/ or send a letter to 
	Creative Commons, 444 Castro Street, Suite 900, Mountain View, California, 94041, USA.

 =======================================================================================================================
*/

// We dont want players here
waitUntil { !isNil "T8U_var_useHC" };
private [ "_exit" ]; _exit = false;
if ( T8U_var_useHC ) then { if ( isDedicated ) then { _exit = true; } else { waitUntil { !isNull player };	if ( hasInterface ) then { _exit = true; }; }; } else { if ( !isServer ) then { _exit = true; }; };
if ( _exit ) exitWith {};


// check if T8_Units is loaded
waitUntil { !isNil "T8U_var_InitDONE" };
sleep 5;

//////////////////////////////////////  CUSTOM FUNCTION  //////////////////////////////////////
//
//			This function is called for every unit in a group 
//			where it is defined in the groups definiton below
//

T8u_fnc_rmNVG_TEST = 
{
	_this spawn
	{
		sleep 5;
	
		private ["_i"];
		_i = true;
		switch ( side _this ) do 
		{ 
			case WEST:			{ _this unlinkItem "NVGoggles"; };
			case EAST:			{ _this unlinkItem "NVGoggles_OPFOR"; };
			case RESISTANCE:	{ _this unlinkItem "NVGoggles_INDEP";  };
			default				{ _i = false; };
		};
		
		if ( _i ) then 
		{
			_this removePrimaryWeaponItem "acc_pointer_IR";
			_this addPrimaryWeaponItem "acc_flashlight";
			
			sleep 1;
			
			group _this enableGunLights "forceon";
		};
	};
};

//////////////////////////////////////  UNIT SETUP  //////////////////////////////////////

// Pre-defined Arrays for Groups ( group setup )
_groupArrayFireTeam = [ "O_soldier_TL_F", "O_medic_F", "O_soldier_F", "O_soldier_AR_F" ];
_groupArrayFullTeam = [ "O_soldier_TL_F", "O_medic_F", "O_soldier_F", "O_soldier_AR_F", "O_soldier_TL_F", "O_soldier_F", "O_soldier_F", "O_soldier_LAT_F" ];
_groupArrayMiniPat = [ "O_soldier_TL_F", "O_medic_F", "O_soldier_F" ];
_groupArrayFullPat = [ "O_soldier_SL_F", "O_medic_F", "O_soldier_F", "O_soldier_TL_F", "O_soldier_F", "O_soldier_AR_F" ];
// _groupArrayIfritPat = [ "O_MRAP_02_HMG_F", "O_MRAP_02_HMG_F" ];
_groupArrayIfritPat = [ "O_G_Offroad_01_armed_F", "O_Truck_02_covered_F", "O_Truck_02_covered_F", "O_G_Offroad_01_armed_F" ];
_groupArrayW_APC = [ "O_APC_WHEELED_02_RCWS_F" ];
_groupArrayT_APC = [ "O_APC_Tracked_02_cannon_F" ];
_groupArraySniperTeam = [ "O_sniper_F", "O_spotter_F" ];

_groupArrayT_APCtest = [ "O_APC_Tracked_02_cannon_F", "O_APC_Tracked_02_cannon_F", "O_APC_Tracked_02_cannon_F", "O_APC_Tracked_02_cannon_F", "O_APC_Tracked_02_cannon_F", "O_APC_Tracked_02_cannon_F", "O_APC_Tracked_02_cannon_F", "O_APC_Tracked_02_cannon_F", "O_APC_Tracked_02_cannon_F" ];

_groupArrayGurTeam = [ "I_soldier_TL_F", "I_medic_F", "I_soldier_F", "I_soldier_F", "I_soldier_F", "I_soldier_AR_F" ];
_groupArrayBluTeam = [ "B_soldier_TL_F", "B_medic_F", "B_soldier_F", "B_soldier_F", "B_soldier_F", "B_soldier_AR_F" ];

_groupArrayCIV		= [ "C_man_1", "C_man_polo_1_F_asia", "C_man_1_1_F", "C_man_1_2_F", "C_man_1_3_F", "C_man_polo_1_F", "C_man_polo_2_F", "C_man_polo_3_F", "C_man_polo_4_F", "C_man_polo_5_F", "C_man_polo_6_F", "C_man_p_fugitive_F", "C_man_p_fugitive_F_afro", "C_man_p_fugitive_F_euro" ];

// Groups, available for HALO, ... support!  - this means EAST has two groups with 4 man, which are available as HALP Drop
T8U_var_SupportUnitsEAST = [ _groupArrayFireTeam, _groupArrayFireTeam ];
T8U_var_SupportUnitsWEST = [];
T8U_var_SupportUnitsRESISTANCE = [];

// this groups of units are spawned directly at mission start
_SpawnThisUnits = 
[ 
	[ [ _groupArrayMiniPat, "Marker01", "T8u_fnc_rmNVG_TEST" ], [ "PATROL" ] ],
	[ [ _groupArrayMiniPat, "Marker08", "T8u_fnc_rmNVG_TEST" ], [ "PATROL" ]  ],
	[ [ _groupArrayFullPat, "Marker02" ], [ "PATROL_AROUND" ] ],
	[ [ _groupArrayFullPat, "Marker09" ], [ "PATROL_AROUND" ] ],
	[ [ _groupArrayFullTeam, "Marker03" ], [ "GARRISON" ] ],
	[ [ _groupArrayFullTeam, "Marker03_f" ], [ "GARRISON" ] ],
	[ [ _groupArrayFireTeam, "Marker04", "T8u_fnc_rmNVG_TEST" ], [ "DEFEND" ], [ true, false, false ] ],
	[ [ _groupArrayFullTeam, "Marker05" ], [ "LOITER" ] ],
	[ [ _groupArrayFullTeam, "Marker06" ], [ "PATROL_GARRISON" ] ],
	[ [ _groupArrayW_APC, "Marker07", false ], [ "PATROL_URBAN" ] ],
	[ [ _groupArrayFullTeam, "ip" ], [ "PATROL_MARKER", [ "ip1", "ip2", "ip3" ] ] ],
	[ [ _groupArrayIfritPat, "vp", false ], [ "PATROL_MARKER", [ "vp1", "vp2", "vp3" ], false ] ],
	[ [ _groupArraySniperTeam, "spawnSnipers" ], [ "OVERWATCH", "overwatchTHIS" ] ],
	[ [ _groupArrayFullTeam + _groupArrayFullTeam, "MarkerRED" ], [ "DEFEND_BASE" ] ],

	[ [ _groupArrayGurTeam, "MarkerGUR", "T8u_fnc_rmNVG_TEST", RESISTANCE ], [ "PATROL" ] ],
	[ [ _groupArrayGurTeam, "MarkerGUR", RESISTANCE, "T8u_fnc_rmNVG_TEST", true ], [ "PATROL" ] ],
	
	[ [ _groupArrayBluTeam, "MarkerBLU", WEST ], [ "PATROL" ] ],
	[ [ _groupArrayBluTeam, "MarkerBLU", WEST ], [ "PATROL" ] ],
	
	[ [ _groupArrayCIV, "MarkerCIV", CIVILIAN ], [ "GARRISON" ] ]	
];

[ _SpawnThisUnits ] spawn T8U_fnc_Spawn;

// this groups of units are spawned on demand with triggers created by a function -> T8U_fnc_Zone 
// they are spawned when a WEST unit is near and they will be cached when no WEST unit is near
SpawnThisUnitsViaTrigger = 
[ 
	[ [ _groupArrayFullTeam, "MarkerByTrigger", "T8u_fnc_rmNVG_TEST" ], [ "DEFEND_BASE" ] ],
	[ [ _groupArrayFireTeam, "MarkerByTrigger", "T8u_fnc_rmNVG_TEST" ], [ "PATROL_AROUND" ] ]
];

// [ _unitsArray, _marker, _distance, _condition, _actSide, _actType, _actRepeat, _onAct, _onDeAct ] call T8U_fnc_TriggerSpawn;
[ "SpawnThisUnitsViaTrigger", "MarkerByTrigger", 800, "this", "WEST", "PRESENT", false, "", "" ] call T8U_fnc_TriggerSpawn;


SpawnZonePU = 
[
	[ [ _groupArrayFireTeam, "MarkerZonePU", "T8u_fnc_rmNVG_TEST" ], [ "PATROL_AROUND" ] ],
	[ [ _groupArrayT_APC, "MarkerZonePU", false ], [ "PATROL_URBAN" ] ] 
];

// [ _unitsArray, _marker, _owner, _actSide, _distance, _condition, _onAct, _onDeAct ] call T8U_fnc_Zone
[ "SpawnZonePU", "MarkerZonePU", "EAST", "WEST" ] spawn T8U_fnc_Zone;

BLUFOR_attack_01 = 
[
	[ [ _groupArrayBluTeam, "BLUFOR_attack_spawn_01", true, WEST ], [ "ATTACK", "Marker04" ] ],
	[ [ _groupArrayBluTeam, "BLUFOR_attack_spawn_01", true, WEST ], [ "ATTACK", "Marker04" ] ]
];
// im Radio-Trigger: [ BLUFOR_attack_01 ] spawn T8U_fnc_Spawn;

BLUFOR_attack_02 = 
[
	[ [ _groupArrayBluTeam, "BLUFOR_attack_spawn_02", true, WEST ], [ "ATTACK", "overwatchTHIS" ] ],
	[ [ _groupArrayBluTeam, "BLUFOR_attack_spawn_02", true, WEST ], [ "ATTACK", "overwatchTHIS" ] ]
];
// im Radio-Trigger: [ BLUFOR_attack_02 ] spawn T8U_fnc_Spawn;





// ------------------------------------------------ THE END ---------------------------------------------------