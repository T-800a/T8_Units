/*
 =======================================================================================================================

	T8 Units Script
	
	File:		fn_loadConfig.sqf
	Author:		T-800a
	E-Mail:		t-800a@gmx.net
	
 =======================================================================================================================
*/

#include <..\MACRO.hpp>

__DEBUG( "INIT", "T8 Units", "CONFIG LOADING STARTED" );

// _myNumber = getNumber (missionConfigFile >> "myMissionConfig" >> "mySetup" >> "myNumber");
// _myArray = getArray (missionConfigFile >> "myMissionConfig" >> "mySetup" >> "myArray");
// _myText = getText (missionConfigFile >> "myMissionConfig" >> "mySetup" >> "myText");

private _CFalloc	= isClass ( configFile >> "cfgT8Units" );
private _CFMalloc	= isClass ( missionConfigFile >> "cfgT8Units" );

__DEBUG( "INIT", "_CFalloc", _CFalloc );
__DEBUG( "INIT", "_CFMalloc", _CFMalloc );

private _cfg = switch ( true ) do
{
	case ( _CFalloc AND _CFMalloc ):	{ missionConfigFile >> "cfgT8Units"; };
	case ( _CFalloc AND !_CFMalloc ):	{ configFile >> "cfgT8Units"; };
	case ( !_CFalloc AND _CFMalloc ):	{ missionConfigFile >> "cfgT8Units"; };
	default								{ nil };
};
__DEBUG( "INIT", "_cfg", _cfg );

if ( isNil "_cfg" ) then { [ "WARNING!<br /><br />You are missing a configfile.<br /><br />Please check your description.ext maybe you did not included the T8 Units config." ] call T8U_fnc_BroadcastHint; };

T8U_var_DEBUG = switch ( getNumber ( _cfg >> "debug" >> "enable" )) do
{
	case 1 :	{ false };
	case 2 :	{ true };
	default		{ true };
};
__DEBUG( "INIT", "T8U_var_DEBUG", T8U_var_DEBUG );

T8U_var_DEBUG_hints = switch ( getNumber ( _cfg >> "debug" >> "allow_hints" )) do
{
	case 1 :	{ false };
	case 2 :	{ true };
	default		{ true };
};
__DEBUG( "INIT", "T8U_var_DEBUG_hints", T8U_var_DEBUG_hints );

T8U_var_DEBUG_marker = switch ( getNumber ( _cfg >> "debug" >> "allow_marker" )) do
{
	case 1 :	{ false };
	case 2 :	{ true };
	default		{ true };
};
__DEBUG( "INIT", "T8U_var_DEBUG_marker", T8U_var_DEBUG_marker );

T8U_var_DEBUG_useCon = switch ( getNumber ( _cfg >> "debug" >> "allow_console" )) do
{
	case 1 :	{ false };
	case 2 :	{ true };
	default		{ true };
};
__DEBUG( "INIT", "T8U_var_DEBUG_useCon", T8U_var_DEBUG_useCon );

T8U_var_AllowDAC = switch ( getNumber ( _cfg >> "dac" >> "enable" )) do
{
	case 1 :	{ false };
	case 2 :	{ true };
	default		{ false };
};
__DEBUG( "INIT", "T8U_var_AllowDAC", T8U_var_AllowDAC );

T8U_var_DACtimeout = if ( isClass _cfg ) then { getNumber ( _cfg >> "dac" >> "timeout" ) } else { 180 };
__DEBUG( "INIT", "T8U_var_DACtimeout", T8U_var_DACtimeout );

T8U_var_useHC = switch ( getNumber ( _cfg >> "main" >> "use_HeadlessClient" )) do
{
	case 1 :	{ false };
	case 2 :	{ true };
	default		{ false };
};
__DEBUG( "INIT", "T8U_var_useHC", T8U_var_useHC );

T8U_var_AllowZEUS = switch ( getNumber ( _cfg >> "main" >> "allow_ZEUS" )) do
{
	case 1 :	{ false };
	case 2 :	{ true };
	default		{ true };
};
__DEBUG( "INIT", "T8U_var_AllowZEUS", T8U_var_AllowZEUS );

T8U_var_EnemySide = switch ( getNumber ( _cfg >> "main" >> "enemySide" )) do
{
	case 1 :	{ EAST };
	case 2 :	{ WEST };
	case 3 :	{ RESISTANCE };
	case 4 :	{ CIVILIAN };
	default		{ EAST };
};
__DEBUG( "INIT", "T8U_var_EnemySide", T8U_var_EnemySide );

T8U_var_GuerDiplo = if ( isClass _cfg ) then { getNumber ( _cfg >> "main" >> "diplomacy" ) } else { 1 };
__DEBUG( "INIT", "T8U_var_GuerDiplo", T8U_var_GuerDiplo );

T8U_var_OvSuperiority = if ( isClass _cfg ) then { getNumber ( _cfg >> "main" >> "superiority" ) } else { 3 };
__DEBUG( "INIT", "T8U_var_OvSuperiority", T8U_var_OvSuperiority );

T8U_var_RevealRange = if ( isClass _cfg ) then { getNumber ( _cfg >> "main" >> "range_reveal" ) } else { 500 };
__DEBUG( "INIT", "T8U_var_RevealRange", T8U_var_RevealRange );

T8U_var_DirectCallRange = if ( isClass _cfg ) then { getNumber ( _cfg >> "main" >> "range_helpCall" ) } else { 1500 };
__DEBUG( "INIT", "T8U_var_DirectCallRange", T8U_var_DirectCallRange );

T8U_var_CallForHelpTimeout = if ( isClass _cfg ) then { getNumber ( _cfg >> "main" >> "timeout_helpCall" ) } else { 60 };
__DEBUG( "INIT", "T8U_var_CallForHelpTimeout", T8U_var_CallForHelpTimeout );

T8U_var_SupportTimeout = if ( isClass _cfg ) then { getNumber ( _cfg >> "main" >> "timeout_support" ) } else { 180 };
__DEBUG( "INIT", "T8U_var_SupportTimeout", T8U_var_SupportTimeout );

T8U_var_TaskReturnTime = if ( isClass _cfg ) then { getNumber ( _cfg >> "main" >> "timeout_taskReturn" ) } else { 30 };
__DEBUG( "INIT", "T8U_var_TaskReturnTime", T8U_var_TaskReturnTime );

T8U_var_CacheTime = if ( isClass _cfg ) then { getNumber ( _cfg >> "main" >> "timeout_caching" ) } else { 15 };
__DEBUG( "INIT", "T8U_var_CacheTime", T8U_var_CacheTime );

T8U_var_PatAroundRange = if ( isClass _cfg ) then { getNumber ( _cfg >> "main" >> "range_PatrolAround" ) } else { 50 };
__DEBUG( "INIT", "T8U_var_PatAroundRange", T8U_var_PatAroundRange );

T8U_var_enableFatigue = switch ( getNumber ( _cfg >> "main" >> "enable_fatigue" )) do
{
	case 1 :	{ false };
	case 2 :	{ true };
	default		{ false };
};
__DEBUG( "INIT", "T8U_var_enableFatigue", T8U_var_enableFatigue );



T8U_var_AllowCBM = switch ( getNumber ( _cfg >> "main" >> "enable_CBM" )) do
{
	case 1 :	{ false };
	case 2 :	{ true };
	default		{ false };
};
__DEBUG( "INIT", "T8U_var_AllowCBM", T8U_var_AllowCBM );


// outdated XOR obsolete
T8U_var_KilledLeaderTimeout		= 20;
T8U_var_FiredEventTimeout		= 10;





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








///// END OF CONFIG FILE ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////