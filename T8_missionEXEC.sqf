/*
 =======================================================================================================================

	T8 Units Script

	File:		T8_missionEXEC.sqf
	Author:		T-800a
	E-Mail:		t-800a@gmx.net

	This file creates the Units, kind of
	

	This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
	To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/ or send a letter to 
	Creative Commons, 444 Castro Street, Suite 900, Mountain View, California, 94041, USA.

 =======================================================================================================================
*/


// include the few macros we use ...
#include <T8\MACRO.hpp>

// wait until everything is initalized correctly
waitUntil { !isNil "T8U_var_useHC" };
waitUntil { !isNil "T8U_var_InitDONE" };

// cancel execute if not server / hc
__allowEXEC(__FILE__);


sleep 5;

//////////////////////////////////////  CUSTOM FUNCTION  //////////////////////////////////////
//
//			This function is called for every unit in a group 
//			where it is defined in the groups definiton below
//

T8U_fnc_rmNVG_TEST = 
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
		};
			
		sleep 1;
		group _this enableGunLights "forceon";
	};
};

//////////////////////////////////////  UNIT SETUP  //////////////////////////////////////

// Pre-defined Arrays for Groups ( group setup )
_groupArrayFireTeam = [ "O_soldier_TL_F", "O_medic_F", "O_soldier_F", "O_soldier_AR_F" ];
_groupArrayFullTeam = [ "O_soldier_TL_F", "O_medic_F", "O_soldier_F", "O_soldier_AR_F", "O_soldier_TL_F", "O_soldier_F", "O_soldier_F", "O_soldier_LAT_F" ];
_groupArrayMiniPat = [ "O_soldier_TL_F", "O_medic_F", "O_soldier_F" ];
_groupArrayFullPat = [ "O_soldier_SL_F", "O_medic_F", "O_soldier_F", "O_soldier_TL_F", "O_soldier_F", "O_soldier_AR_F" ];
// _groupArrayIfritPat = [ "O_MRAP_02_HMG_F", "O_MRAP_02_HMG_F" ];
_groupArrayIfritPat = [ "O_MRAP_02_F", "O_Truck_02_transport_F" ];
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
	[ [ ( configFile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfTeam" ), "Marker01", "T8u_fnc_rmNVG_TEST" ], [ "PATROL" ], [ true, true, true ], [], "Marker01_spawn" ],
	[ [ ( configFile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfTeam" ), "Marker01" ], [ "PATROL_AROUND" ], [ true, true, true ], [], getMarkerPos "Marker01_spawn" ],
	[ [ ( configFile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfTeam" ), "Marker04", "T8u_fnc_rmNVG_TEST" ], [ "DEFEND" ], [ true, false, false ]],
	
	[ [ ([ "infantry", 5, 3 ] call T8U_fnc_createUnitContainer ), [ "Marker02_01", "Marker02_02" ]], [ "PATROL_AROUND", 50 ], [], "teleport" ],
	
	[ [ _groupArrayFullTeam + _groupArrayFullTeam + _groupArrayFullTeam, "Marker02_02" ], [ "OCCUPY", true ], [ true, false, false ]],
	[ [ _groupArrayW_APC + _groupArrayFireTeam, "Marker07", false ], [ "PATROL_URBAN" ], [ false, false, false ]],
	[ [ _groupArrayW_APC + _groupArrayFireTeam, [ "marker_urban_01", "marker_urban_02" ], false ], [ "PATROL_URBAN" ]],
	[ [ _groupArrayFullTeam, "ip" ], [ "PATROL_MARKER", [ "ip1", "ip2", "ip3" ] ] ],
	[ [ _groupArrayIfritPat + _groupArrayFullTeam, "vp", false ], [ "PATROL_MARKER", [ "vp1", "vp2", "vp3" ], false ]],
	[ [ _groupArraySniperTeam, "spawnSnipers" ], [ "OVERWATCH", "overwatchTHIS" ]],
	
	[ [ "fireteam", [ "Marker08_01", "Marker08_02" ], "T8u_fnc_rmNVG_TEST" ], [ "PATROL" ]],
	[ [ "squad", "Marker03" ], [ "OCCUPY" ]],
	[ [ "squad", "Marker03" ], [ "GARRISON" ]],
	[ [ "squad", "Marker05" ], [ "LOITER" ]],
	[ [ "squad", "Marker06" ], [ "PATROL_GARRISON" ]],
	[ [ "squad", "Marker09" ], [ "PATROL_AROUND", 150, 135 ], [], [ true ]],
	[ [ "platoon", "MarkerRED" ], [ "DEFEND_BASE" ]],

	[ [ "squad", "MarkerGUR", true, "T8u_fnc_rmNVG_TEST", RESISTANCE ], [ "PATROL" ]],
	[ [ "squad", "MarkerGUR", RESISTANCE, "T8u_fnc_rmNVG_TEST" ], [ "PATROL" ]],
	
	[ [ "squad", "MarkerBLU", WEST ], [ "PATROL" ]],
	[ [ "squad", "MarkerBLU", WEST ], [ "PATROL" ]],
	
	[ [ _groupArrayCIV, "MarkerCIV", CIVILIAN ], [ "GARRISON" ]]
];

[ _SpawnThisUnits ] spawn T8U_fnc_Spawn;

// this groups of units are spawned on demand with triggers created by a function -> T8U_fnc_Zone 
// they are spawned when a WEST unit is near and they will be cached when no WEST unit is near
SpawnThisUnitsViaTrigger = 
[ 
	[ [ _groupArrayFullTeam, "MarkerByTrigger", "T8u_fnc_rmNVG_TEST" ], [ "DEFEND_BASE" ]],
	[ [ ( configFile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfTeam" ), "MarkerByTrigger", "T8u_fnc_rmNVG_TEST" ], [ "PATROL_AROUND" ]]
];

// [ _unitsArray, _marker, _distance, _condition, _actSide, _actType, _actRepeat, _onAct, _onDeAct ] call T8U_fnc_TriggerSpawn;
[ "SpawnThisUnitsViaTrigger", "MarkerByTrigger", 800, "this", "WEST", "PRESENT", false, "", "" ] call T8U_fnc_TriggerSpawn;


SpawnZonePU = 
[
	[ [ ( configFile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfTeam" ), "MarkerZonePU", "T8u_fnc_rmNVG_TEST" ], [ "PATROL_AROUND" ]],
	[ [ _groupArrayT_APC, "MarkerZonePU", false ], [ "PATROL_URBAN" ]] 
];

// [ _unitsArray, _marker, _owner, _actSide, _distance, _condition, _onAct, _onDeAct ] call T8U_fnc_Zone
[ "SpawnZonePU", "MarkerZonePU", "EAST", "WEST" ] spawn T8U_fnc_Zone;

BLUFOR_attack_01 = 
[
	[ [ [ "B_MRAP_01_F", "B_MRAP_01_F" ] + _groupArrayBluTeam, "BLUFOR_attack_spawn_01", false, WEST ], [ "ATTACK", "Marker04" ]],
	[ [ [ "B_Truck_01_transport_F" ] + _groupArrayBluTeam, "BLUFOR_attack_spawn_01", false, WEST ], [ "ATTACK", "Marker04" ]]
];
// im Radio-Trigger: [ BLUFOR_attack_01 ] spawn T8U_fnc_Spawn;

BLUFOR_attack_02 = 
[
	[ [ _groupArrayBluTeam, "BLUFOR_attack_spawn_02", true, WEST ], [ "ATTACK", "overwatchTHIS" ]],
	[ [ _groupArrayBluTeam, "BLUFOR_attack_spawn_02", true, WEST ], [ "ATTACK", "overwatchTHIS" ]]
];
// im Radio-Trigger: [ BLUFOR_attack_02 ] spawn T8U_fnc_Spawn;



testpol_01 = [ testlog_01 ] call T8U_fnc_getPolygon;
testpol_02 = [ testlog_02 ] call T8U_fnc_getPolygon;
testpol_03 = [ testlog_03 ] call T8U_fnc_getPolygon;
testpol_04 = [ testlog_04 ] call T8U_fnc_getPolygon;

private [ "_extreme", "_allPoints" ];

_extreme = [ testpol_01 ] call T8U_fnc_findExtreme;
hint str _extreme;
_allPoints = [];

for "_i" from 1 to 200 do 
{
	private [ "_pos" ];

	_posX = ( _extreme select 0 select 0 ) + random (( _extreme select 1 select 0 ) - ( _extreme select 0 select 0 ));
	_posY = ( _extreme select 0 select 1 ) + random (( _extreme select 1 select 1 ) - ( _extreme select 0 select 1 ));
	
	if ( [[ _posX, _posY ], testpol_01 ] call T8U_fnc_checkPolygon ) then 
	{
		[[ _posX, _posY ], "ICON", "mil_dot", 1, "ColorGreen" ] call T8U_fnc_DebugMarker;	
	} else {
		[[ _posX, _posY ], "ICON", "mil_dot", 1, "ColorRed" ] call T8U_fnc_DebugMarker;
	};
	
	_allPoints pushBack [ _posX, _posY ];
};

_extreme = [ testpol_02 ] call T8U_fnc_findExtreme;
hint str _extreme;
_allPoints = [];

for "_i" from 1 to 200 do 
{
	private [ "_pos" ];

	_posX = ( _extreme select 0 select 0 ) + random (( _extreme select 1 select 0 ) - ( _extreme select 0 select 0 ));
	_posY = ( _extreme select 0 select 1 ) + random (( _extreme select 1 select 1 ) - ( _extreme select 0 select 1 ));
	
	if ( [[ _posX, _posY ], testpol_02 ] call T8U_fnc_checkPolygon ) then 
	{
		[[ _posX, _posY ], "ICON", "mil_dot", 1, "ColorGreen" ] call T8U_fnc_DebugMarker;	
	} else {
		[[ _posX, _posY ], "ICON", "mil_dot", 1, "ColorRed" ] call T8U_fnc_DebugMarker;
	};
	
	_allPoints pushBack [ _posX, _posY ];
};

_extreme = [ testpol_03 ] call T8U_fnc_findExtreme;
hint str _extreme;
_allPoints = [];

for "_i" from 1 to 200 do 
{
	private [ "_pos" ];

	_posX = ( _extreme select 0 select 0 ) + random (( _extreme select 1 select 0 ) - ( _extreme select 0 select 0 ));
	_posY = ( _extreme select 0 select 1 ) + random (( _extreme select 1 select 1 ) - ( _extreme select 0 select 1 ));
	
	if ( [[ _posX, _posY ], testpol_03 ] call T8U_fnc_checkPolygon ) then 
	{
		[[ _posX, _posY ], "ICON", "mil_dot", 1, "ColorGreen" ] call T8U_fnc_DebugMarker;	
	} else {
		[[ _posX, _posY ], "ICON", "mil_dot", 1, "ColorRed" ] call T8U_fnc_DebugMarker;
	};
	
	_allPoints pushBack [ _posX, _posY ];
};

_extreme = [ testpol_04 ] call T8U_fnc_findExtreme;
hint str _extreme;
_allPoints = [];

for "_i" from 1 to 200 do 
{
	private [ "_pos" ];

	_posX = ( _extreme select 0 select 0 ) + random (( _extreme select 1 select 0 ) - ( _extreme select 0 select 0 ));
	_posY = ( _extreme select 0 select 1 ) + random (( _extreme select 1 select 1 ) - ( _extreme select 0 select 1 ));
	
	if ( [[ _posX, _posY ], testpol_04 ] call T8U_fnc_checkPolygon ) then 
	{
		[[ _posX, _posY ], "ICON", "mil_dot", 1, "ColorGreen" ] call T8U_fnc_DebugMarker;	
	} else {
		[[ _posX, _posY ], "ICON", "mil_dot", 1, "ColorRed" ] call T8U_fnc_DebugMarker;
	};
	
	_allPoints pushBack [ _posX, _posY ];
};


// ------------------------------------------------ THE END ---------------------------------------------------
