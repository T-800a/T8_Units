/*
 =======================================================================================================================

	Script: supportHALO.sqf
	Author(s): T-800a

	Description:
	Creates a group of units as HALO drop near a calling unit. The group than gets two waypoints added, the position of the
	caller as move, the position of the target as sad. a smoke grenade and flares are generated when 

	Parameter(s):
	_this select 0: unit that called support
	_this select 1: unit that is the target of the attack / where the dropped troops should attack
	_this select 2: array with unit strings which are created as halodrop units e.G: [ "O_soldier_TL_F", "O_medic_F", "O_soldier_F" ]
	_this select 3: (optional) if not set, side of _this select 0 is used.

	Returns:
	Boolean - success flag

	Example(s):
	0 = [ player, target, [ "B_soldier_TL_F", "B_medic_F", "B_soldier_F", "B_soldier_F", "B_soldier_F" ], WEST ] execVM "T8\T8_supports\supportHALO.sqf";

 =======================================================================================================================
*/

private [ "_caller", "_target", "_units", "_useSide", "_callerPos", "_spawnPos", "_targetPos", "_group", "_formation", "_loop", "_tmpDist", "_side", "_shell", "_flares", "_jetType" ];
waitUntil { !isNil "bis_fnc_init" };

_caller			= [ _this, 0, objNull, [objNull,[]] ] call BIS_fnc_param;
_target			= [ _this, 1, objNull, [objNull,[]] ] call BIS_fnc_param;
_units			= [ _this, 2, [], [[]] ] call BIS_fnc_param;
_useSide		= [ _this, 3, T8U_var_EnemySide, [WEST] ] call BIS_fnc_param;

if ( T8U_var_DEBUG ) then { [ "supportHALO.sqf", "INIT", _this ] spawn T8U_fnc_DebugLog; };

if ( ( ( typeName _caller ) == ( typename objNull ) AND { isNull _caller } ) OR ( ( typeName _caller ) == ( typeName [] ) AND { count _caller < 2 } ) ) exitWith { if ( T8U_var_DEBUG ) then { [ "supportHALO.sqf", "ERROR: _caller" ] spawn T8U_fnc_DebugLog; }; false };
if ( ( ( typeName _target ) == ( typename objNull ) AND { isNull _target } ) OR ( ( typeName _target ) == ( typeName [] ) AND { count _target < 2 } ) ) exitWith { if ( T8U_var_DEBUG ) then { [ "supportHALO.sqf", "ERROR: _target" ] spawn T8U_fnc_DebugLog; };false };
if ( typeName _caller == typename [] AND { count _this < 4 } ) exitWith { if ( T8U_var_DEBUG ) then { [ "supportHALO.sqf", "ERROR: _caller is PosArray, need Spawnside" ] spawn T8U_fnc_DebugLog; }; false };
if ( count _units <= 0 ) exitWith { if ( T8U_var_DEBUG ) then { [ "supportHALO.sqf", "ERROR: _units" ] spawn T8U_fnc_DebugLog; }; false };

if ( typeName _caller == typename objNull ) then { _callerPos = getPosATL _caller; } else { _callerPos = _caller; };
if ( typeName _target == typename objNull ) then { _targetPos = getPos _target; } else { _targetPos = _target;};

if ( count _this > 3 ) then { _side = _useSide; } else { _side = side _caller; };

_tmpDist = 50;
_loop = true;
while { _loop } do 
{
	_spawnPos = [ _callerPos, _tmpDist, random 360 ] call BIS_fnc_relPos;
	if ( surfaceIsWater _spawnPos ) then { _tmpDist = _tmpDist + 1; } else { _loop = false; };
};

_spawnPos = [ ( _spawnPos select 0 ), ( _spawnPos select 1 ), 2000 ];

private [ "_rDir", "_fB1", "_fB2", "_cX1", "_cY1", "_cX2", "_cY2", "_rfB1", "_rfB1" ];
_rDir = random ( round 360 );

_fB1 = [ ( _spawnPos select 0 ) + 3000, ( _spawnPos select 1 ) ];
_fB2 = [ ( _spawnPos select 0 ) - 3000, ( _spawnPos select 1 ) ];

_cX1 = cos ( _rDir ) * ( ( _fB1 select 0 ) - ( _spawnPos select 0 ) ) - sin ( _rDir ) * ( ( _fB1 select 1 ) - ( _spawnPos select 1 ) ) + ( _spawnPos select 0 );
_cY1 = sin ( _rDir ) * ( ( _fB1 select 0 ) - ( _spawnPos select 0 ) ) + cos ( _rDir ) * ( ( _fB1 select 1 ) - ( _spawnPos select 1 ) ) + ( _spawnPos select 1 );

_cX2 = cos ( _rDir ) * ( ( _fB2 select 0 ) - ( _spawnPos select 0 ) ) - sin ( _rDir ) * ( ( _fB2 select 1 ) - ( _spawnPos select 1 ) ) + ( _spawnPos select 0 );
_cY2 = sin ( _rDir ) * ( ( _fB2 select 0 ) - ( _spawnPos select 0 ) ) + cos ( _rDir ) * ( ( _fB2 select 1 ) - ( _spawnPos select 1 ) ) + ( _spawnPos select 1 );

_rfB1 = [ _cX1, _cY1, 500 ];
_rfB2 = [ _cX2, _cY2, 500 ];

switch ( _side ) do
{
	case WEST:			{ _jetType = "B_Plane_CAS_01_F"; };
	case EAST:			{ _jetType = "O_Plane_CAS_02_F"; };
	case RESISTANCE:	{ _jetType = "I_Plane_Fighter_03_AA_F"; };
};

[ _rfB1, _rfB2, 500, "FULL", _jetType, _side ] call BIS_fnc_ambientFlyby;

if ( T8U_var_DEBUG_marker ) then 
{ 
	[ _spawnPos,	"ICON", "mil_dot_noShadow", 1, "ColorGreen" ] call T8U_fnc_DebugMarker;
	[ _targetPos,	"ICON", "mil_dot_noShadow", 1, "ColorRed" ] call T8U_fnc_DebugMarker;
	[ _rfB1,		"ICON", "mil_dot_noShadow", 1, "ColorBlue" ] call T8U_fnc_DebugMarker;
	[ _rfB2,		"ICON", "mil_dot_noShadow", 1, "ColorBlue" ] call T8U_fnc_DebugMarker;
};

_group = [ _spawnPos, _side, _units ] call BIS_fnc_spawnGroup;
_group setVariable [ "T8U_gvar_Comm", [ "isRemoveAble" ], false ];

if ( T8U_var_AllowZEUS ) then 
{
	private [ "_ua" ];
	_ua = units _group;
	{ _x addCuratorEditableObjects [ _ua, true ]; } count T8U_var_ZeusModules;
};

if ( T8U_var_DEBUG_marker ) then { [ _group  ] spawn T8U_fnc_Track; };

{
	private [ "_tmpPos" ];
	_tmpPos = [ _spawnPos, 30, random 360 ] call BIS_fnc_relPos;
	_x setPosATL [ _tmpPos select 0, _tmpPos select 1, 2000 ];

	removeBackpack _x; 
	_x switchMove "HaloFreeFall_non"; 
	_x disableAI "ANIM";
	
	[ _x ] spawn 
	{
		private [ "_unit", "_presetSkill" ];
		_unit = _this select 0;
		
		switch ( side _unit ) do
		{
			case WEST:			{ _presetSkill = ( T8U_var_Presets select 0 ) select 0; };
			case EAST:			{ _presetSkill = ( T8U_var_Presets select 1 ) select 0; };
			case RESISTANCE:	{ _presetSkill = ( T8U_var_Presets select 2 ) select 0; };
		};
		
		if ( ! isNil "T8U_var_SkillSets" ) then 
		{
			{ _unit setskill [ ( _x select 0 ), ( _x select 1 ) ]; } forEach ( T8U_var_SkillSets select _presetSkill );
				
		} else {
			_unit setskill 0.6;
		};
		
		waitUntil { ( getPos _unit select 2 ) < 150 AND alive _unit };
		_unit addBackpack "b_parachute"; 
		
		waitUntil { ( getPos _unit select 2 ) < 30 AND alive _unit };
		if ( ! alive _unit ) exitWith {}; 
		_unit allowDamage false;
		
		waitUntil { ( isTouchingGround _unit OR { ( getPos _unit select 2 ) < 1 } ) AND { alive _unit } };
		_unit enableAI "ANIM";
		_unit setPos [ ( getPos _unit select 0 ), ( getPos _unit select 1 ), 0 ];
		_unit setVelocity [ 0, 0, 0 ];
		_unit setVectorUp [ 0, 0, 1 ]; 
		sleep 2;
		_unit allowDamage true;
		_unit setDamage 0;
	};

} forEach units _group;

if ( T8U_var_AllowZEUS ) then 
{
	private [ "_units" ];
	_units = units _group;	
	{ _x addCuratorEditableObjects [ _units, true ]; } count T8U_var_ZeusModules;
};

_formation = ["STAG COLUMN", "WEDGE", "ECH LEFT", "ECH RIGHT", "VEE", "DIAMOND"] call BIS_fnc_selectRandom;
_group setBehaviour "AWARE";
_group setSpeedMode "FULL";
_group setFormation _formation;

[ _group, [ ( _spawnPos select 0 ), ( _spawnPos select 1 ), 0 ], "MOVE", "AWARE", "", 75, "FULL", [ 10, 10, 10 ] ] call T8U_fnc_CreateWP;
[ _group, [ ( _targetPos select 0 ), ( _targetPos select 1 ), 0 ], "SAD", "COMBAT", "", 50, "FULL"] call T8U_fnc_CreateWP;

sleep 5;

switch ( _side ) do 
{ 	
	case EAST:			{ _shell = "SmokeShellRed"; _flares = [ "F_40mm_Red", "F_40mm_Red", "F_40mm_Red" ]; };
	case WEST:			{ _shell = "SmokeShellBlue"; _flares = [ "F_40mm_White", "F_40mm_White", "F_40mm_White" ]; };
	case RESISTANCE:	{ _shell = "SmokeShellGreen"; _flares = [ "F_40mm_Green", "F_40mm_Green", "F_40mm_Green" ]; };
};

private [ "_s" ]; _s = _shell createVehicle _callerPos; _s setVelocity [ 1, 1, 20 ];
{ private [ "_f" ]; _f = _x createvehicle _callerPos; _f setPosATL [ _callerPos select 0, _callerPos select 1, 5 ]; _f setVelocity [ 1, 1, 45 ]; sleep 15; } forEach _flares;
true
