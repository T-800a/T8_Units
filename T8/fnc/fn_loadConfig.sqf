/*
 =======================================================================================================================

	T8 Units Script
	
	File:		fn_loadConfig.sqf
	Author:		T-800a
	E-Mail:		t-800a@gmx.net
	
 =======================================================================================================================
*/

#include <..\MACRO.hpp>

// _myNumber = getNumber (missionConfigFile >> "myMissionConfig" >> "mySetup" >> "myNumber");
// _myArray = getArray (missionConfigFile >> "myMissionConfig" >> "mySetup" >> "myArray");
// _myText = getText (missionConfigFile >> "myMissionConfig" >> "mySetup" >> "myText");

private _cfg = call T8U_fnc_selectConfigFile;
if ( isNil "_cfg" ) then { [ "WARNING!<br /><br />You are missing a configfile.<br /><br />Please check your description.ext maybe you did not included the T8 Units config." ] call T8U_fnc_BroadcastHint; };

T8U_var_DEBUG = switch ( getNumber ( _cfg >> "debug" >> "enable" )) do
{
	case 1 :	{ false };
	case 2 :	{ true };
	default		{ true };
};

T8U_var_DEBUG_hints = switch ( getNumber ( _cfg >> "debug" >> "allow_hints" )) do
{
	case 1 :	{ false };
	case 2 :	{ true };
	default		{ true };
};

T8U_var_DEBUG_marker = switch ( getNumber ( _cfg >> "debug" >> "allow_marker" )) do
{
	case 1 :	{ false };
	case 2 :	{ true };
	default		{ true };
};

T8U_var_DEBUG_useCon = switch ( getNumber ( _cfg >> "debug" >> "allow_console" )) do
{
	case 1 :	{ false };
	case 2 :	{ true };
	default		{ true };
};

__DEBUG( "CONFIG", "======================================================================================", "" );
__DEBUG( "CONFIG", "T8 Units", "CONFIG LOADING STARTED" );
__DEBUG( "CONFIG", "_cfg", _cfg );
__DEBUG( "CONFIG", "T8U_var_DEBUG", T8U_var_DEBUG );
__DEBUG( "CONFIG", "T8U_var_DEBUG_hints", T8U_var_DEBUG_hints );
__DEBUG( "CONFIG", "T8U_var_DEBUG_marker", T8U_var_DEBUG_marker );
__DEBUG( "CONFIG", "T8U_var_DEBUG_useCon", T8U_var_DEBUG_useCon );

T8U_var_AllowDAC = switch ( getNumber ( _cfg >> "dac" >> "enable" )) do
{
	case 1 :	{ false };
	case 2 :	{ true };
	default		{ false };
};
__DEBUG( "CONFIG", "T8U_var_AllowDAC", T8U_var_AllowDAC );

T8U_var_DACtimeout = __CFGNUMBER( _cfg >> "dac" >> "timeout", 180 );
__DEBUG( "CONFIG", "T8U_var_DACtimeout", T8U_var_DACtimeout );

T8U_var_useHC = switch ( getNumber ( _cfg >> "main" >> "use_HeadlessClient" )) do
{
	case 1 :	{ false };
	case 2 :	{ true };
	default		{ false };
};
__DEBUG( "CONFIG", "T8U_var_useHC", T8U_var_useHC );

T8U_var_AllowZEUS = switch ( getNumber ( _cfg >> "main" >> "allow_ZEUS" )) do
{
	case 1 :	{ false };
	case 2 :	{ true };
	default		{ true };
};
__DEBUG( "CONFIG", "T8U_var_AllowZEUS", T8U_var_AllowZEUS );

T8U_var_EnemySide = switch ( getNumber ( _cfg >> "main" >> "enemySide" )) do
{
	case 1 :	{ EAST };
	case 2 :	{ WEST };
	case 3 :	{ RESISTANCE };
	case 4 :	{ CIVILIAN };
	default		{ EAST };
};
__DEBUG( "CONFIG", "T8U_var_EnemySide", T8U_var_EnemySide );

T8U_var_modSet				= __CFGTEXT( _cfg >> "main" >> "modSet", "vanilla" );
__DEBUG( "CONFIG", "T8U_var_modSet", T8U_var_modSet );

T8U_var_GuerDiplo			= __CFGNUMBER( _cfg >> "main" >> "diplomacy", 1 );
__DEBUG( "CONFIG", "T8U_var_GuerDiplo", T8U_var_GuerDiplo );

T8U_var_OvSuperiority		= __CFGNUMBER( _cfg >> "main" >> "superiority", 3 );
__DEBUG( "CONFIG", "T8U_var_OvSuperiority", T8U_var_OvSuperiority );

T8U_var_RevealRange			= __CFGNUMBER( _cfg >> "main" >> "range_reveal", 500 );
__DEBUG( "CONFIG", "T8U_var_RevealRange", T8U_var_RevealRange );

T8U_var_DirectCallRange		= __CFGNUMBER( _cfg >> "main" >> "range_helpCall", 1500 );
__DEBUG( "CONFIG", "T8U_var_DirectCallRange", T8U_var_DirectCallRange );

T8U_var_CallForHelpTimeout	= __CFGNUMBER( _cfg >> "main" >> "timeout_helpCall", 60 );
__DEBUG( "CONFIG", "T8U_var_CallForHelpTimeout", T8U_var_CallForHelpTimeout );

T8U_var_SupportTimeout		= __CFGNUMBER( _cfg >> "main" >> "timeout_support", 180 );
__DEBUG( "CONFIG", "T8U_var_SupportTimeout", T8U_var_SupportTimeout );

T8U_var_TaskReturnTime 		= __CFGNUMBER( _cfg >> "main" >> "timeout_taskReturn", 30 );
__DEBUG( "CONFIG", "T8U_var_TaskReturnTime", T8U_var_TaskReturnTime );

T8U_var_CacheTime			= __CFGNUMBER( _cfg >> "main" >> "timeout_caching", 15 );
__DEBUG( "CONFIG", "T8U_var_CacheTime", T8U_var_CacheTime );

T8U_var_PatAroundRange		= __CFGNUMBER( _cfg >> "main" >> "range_PatrolAround", 50 );
__DEBUG( "CONFIG", "T8U_var_PatAroundRange", T8U_var_PatAroundRange );

T8U_var_enableFatigue = switch ( getNumber ( _cfg >> "main" >> "enable_fatigue" )) do
{
	case 1 :	{ false };
	case 2 :	{ true };
	default		{ false };
};
__DEBUG( "CONFIG", "T8U_var_enableFatigue", T8U_var_enableFatigue );

T8U_var_ReinforceVehicle	= __CFGARRAY( _cfg >> "main" >> "reinforcementVehicles", [] );
__DEBUG( "CONFIG", "T8U_var_ReinforceVehicle", T8U_var_ReinforceVehicle );

T8U_var_SuppressingUnits	= __CFGARRAY( _cfg >> "main" >> "suppressingUnits", [] );
__DEBUG( "CONFIG", "T8U_var_SuppressingUnits", T8U_var_SuppressingUnits );

T8U_var_ignoredBuildings	= __CFGARRAY( _cfg >> "main" >> "ignoredBuildings", [] );
__DEBUG( "CONFIG", "T8U_var_ignoredBuildings", T8U_var_ignoredBuildings );


T8U_var_AllowCBM = switch ( getNumber ( _cfg >> "main" >> "enable_CBM" )) do
{
	case 1 :	{ false };
	case 2 :	{ true };
	default		{ false };
};
__DEBUG( "CONFIG", "T8U_var_AllowCBM", T8U_var_AllowCBM );


if ( isClass _cfg ) then 
{
	T8U_var_Presets = [[ 0, 0 ], [ 1, 1 ], [ 2, 2 ]];
	
	private _BLU = [];
	private _RED = [];
	private _GRN = [];
	
	private _BLUc = "true" configClasses ( _cfg >> "behaviorAndSkills" >> "west" >> "skills" );
	private _REDc = "true" configClasses ( _cfg >> "behaviorAndSkills" >> "east" >> "skills" );
	private _GRNc = "true" configClasses ( _cfg >> "behaviorAndSkills" >> "guer" >> "skills" );
	
	{
		_BLU pushback [ configName _x, ( getNumber ( _x >> "value" ))];
		false
	} count _BLUc;
	
	{
		_RED pushback [ configName _x, ( getNumber ( _x >> "value" ))];
		false
	} count _REDc;
	
	{
		_GRN pushback [ configName _x, ( getNumber ( _x >> "value" ))];
		false
	} count _GRNc;
	
	T8U_var_SkillSets = [ _BLU, _RED, _GRN ];
	T8U_var_BehaviorSets = [( getArray ( _cfg >>  "behaviorAndSkills" >> "west" >> "behaivior" )), ( getArray ( _cfg >>  "behaviorAndSkills" >> "east" >> "behaivior" )), ( getArray ( _cfg >>  "behaviorAndSkills" >> "guer" >> "behaivior" ))];

} else {

	// backup settings
	T8U_var_Presets = [[ 2, 1 ], [ 1, 0 ], [ 1, 2 ]];
	T8U_var_BehaviorSets = [[ "YELLOW", "RED", "WHITE", 180	], [ "GREEN", "YELLOW", "GREEN", 90 ], [ "GREEN", "RED", "GREEN", 120 ]];
	T8U_var_SkillSets = 
	[
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
};

__DEBUG( "CONFIG", "T8U_var_Presets", T8U_var_Presets );
__DEBUG( "CONFIG", "T8U_var_BehaviorSets", T8U_var_BehaviorSets );
__DEBUG( "CONFIG", "T8U_var_SkillSets", T8U_var_SkillSets );




////////// DO NOT CHANGE ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


// debug marker delteion queue
T8U_var_DebugMarkerCache = [];


// not implemented ( if it ever will!?)... if you set this true it will disable calling for help and reaction to combat of the groups
T8U_var_CommanderEnable = false;


// outdated XOR obsolete
T8U_var_KilledLeaderTimeout		= 20;
T8U_var_FiredEventTimeout		= 10;


__DEBUG( "CONFIG", "T8 Units", "CONFIG LOADING FINISHED" );
__DEBUG( "CONFIG", "======================================================================================", "" );

///// END OF CONFIG FILE ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////