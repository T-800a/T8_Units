/*
 =======================================================================================================================

	T8 Units Script
	
	Funktion:	fn_introduce.sqf
	Author:		T-800a
	E-Mail:		t-800a@gmx.net

 =======================================================================================================================
*/

#include <..\MACRO.hpp>
__allowEXEC(__FILE__);

__DEBUG( __FILE__, "INIT", _this );
if ( isNull _this ) exitWith {};

private _group = _this;
private _units = units _group;
private _error = false;

if ( __GetOVAR( _group, "T8U_gvar_Introduced", false ) ) exitWith { __DEBUG( __FILE__, "EXIT", "GROUP ALREADY INTRODUCED" ); };
__SetOVAR( _group, "T8U_gvar_Introduced", true );

private _cfg = call T8U_fnc_selectConfigFile;
if ( isNull _cfg ) exitWith { [ "WARNING!<br /><br />You are missing a configfile.<br /><br />Please check your description.ext maybe you did not included the T8 Units config." ] call T8U_fnc_BroadcastHint; _return };

// build comm array
private _cA0				= __GetOVAR( _group, "T8U_introduce_comm_share", true );
private _cA1				= __GetOVAR( _group, "T8U_introduce_comm_call", true );
private _cA2				= __GetOVAR( _group, "T8U_introduce_comm_react", true );
private _commArray			= [ _cA0, _cA1, _cA2 ];

private _teleport			= __GetOVAR( _group, "T8U_introduce_set_teleport", false );
private _settingsArray		= [ _teleport ];

private _task				= __GetOVAR( _group, "T8U_introduce_task", "ERROR" );
private _markerArray		= __GetOVAR( _group, "T8U_introduce_markerArray", [] );
private _infGroup			= __GetOVAR( _group, "T8U_introduce_infGroup", true );
private _EXECfunction		= __GetOVAR( _group, "T8U_introduce_EXECfunction", false );
private _function			= __GetOVAR( _group, "T8U_introduce_function", "ERROR" );

private _patrolAroundDis	= __GetOVAR( _group, "T8U_introduce_patrolAroundDis", T8U_var_PatAroundRange );
private _patrolMarkerSAD	= __GetOVAR( _group, "T8U_introduce_patrolMarkerSAD", false );
private _overwatchMinDis	= __GetOVAR( _group, "T8U_introduce_overwatchMinDis", 250 );
private _overwatchRange		= __GetOVAR( _group, "T8U_introduce_overwatchRange", 200 );
private _occupyImmobile		= __GetOVAR( _group, "T8U_introduce_occupyImmobile", false );

__DEBUG( __FILE__, "_commArray", _commArray );
__DEBUG( __FILE__, "_task", _task );
__DEBUG( __FILE__, "_markerArray", _markerArray );
__DEBUG( __FILE__, "_infGroup", _infGroup );
__DEBUG( __FILE__, "_EXECfunction", _EXECfunction );
__DEBUG( __FILE__, "_function", _function );

__DEBUG( __FILE__, "_patrolAroundDis", _patrolAroundDis );
__DEBUG( __FILE__, "_patrolMarkerSAD", _patrolMarkerSAD );
__DEBUG( __FILE__, "_overwatchMinDis", _overwatchMinDis );
__DEBUG( __FILE__, "_overwatchRange", _overwatchRange );
__DEBUG( __FILE__, "_occupyImmobile", _occupyImmobile );

// task error? Abort abort abort ...
if ( _task isEqualTo "ERROR" ) exitWith
{
	private _msg = format [ "No task %1 was given! WTF BRU?!<br /><br /> Call 0800 - T800A#WTFH for help. Not!", _task ];
	[ _msg ] call T8U_fnc_BroadcastHint;
	__DEBUG( __FILE__, "_task", "ERROR: ABORT" );
};

private _taskArray = [ _task ];
__DEBUG( __FILE__, "_taskArray", _taskArray );

private [ "_posMkr" ];
switch ( typeName _markerArray ) do 
{ 
	case "ARRAY":	{ _posMkr = _markerArray call BIS_fnc_selectRandom; };
	case "STRING":	{ _posMkr = _markerArray; };
	default			{ _posMkr = "ERROR"; };
};

switch ( _task ) do 
{
	case "ATTACK":
	{
		_taskArray pushBack _posMkr;
		[ _group, _posMkr, _infGroup ] spawn T8U_tsk_fnc_Attack;
	};

	case "DEFEND":
	{
		[ _group, _posMkr ] spawn T8U_tsk_fnc_defend;
	};

	case "DEFEND_BASE": 
	{
		[ _group, _posMkr ] spawn T8U_tsk_fnc_defendBase;
	};

	case "GARRISON": 
	{
		[ _group, _posMkr ] spawn T8U_tsk_fnc_garrison;
	};

/*
	case "LOITER": 
	{
		[ _group, _posMkr ] spawn T8U_tsk_fnc_loiter;
	};
*/

	case "OCCUPY": 
	{
		_taskArray pushBack _occupyImmobile;
		[ _group, _posMkr, _occupyImmobile ] spawn T8U_tsk_fnc_occupy;
	};

	case "OVERWATCH": 
	{
		_taskArray pushBack _posMkr;
		_taskArray pushBack _overwatchMinDis;
		_taskArray pushBack _overwatchRange;
		[ _group, _posMkr, _overwatchMinDis, _overwatchRange, _infGroup ] spawn T8U_tsk_fnc_overwatch;
	};

	case "PATROL": 
	{
		[ _group, _markerArray, _infGroup, _teleport ] spawn T8U_tsk_fnc_patrol;				
	};

	case "PATROL_AROUND": 
	{
		_taskArray pushBack _patrolAroundDis;
		[ _group, _markerArray, _infGroup, _teleport, _PatrolAroundDis ] spawn T8U_tsk_fnc_patrolAround;
	};

	case "PATROL_GARRISON": 
	{
		[ _group, _posMkr, _infGroup, _teleport ] spawn T8U_tsk_fnc_patrolGarrison;
	};

	case "PATROL_MARKER": 
	{
		_taskArray pushBack _markerArray;
		_taskArray pushBack _patrolMarkerSAD;				
		[ _group, _markerArray, _infGroup, _teleport, _patrolMarkerSAD ] spawn T8U_tsk_fnc_patrolMarker;
	};

	case "PATROL_URBAN": 
	{
		[ _group, _markerArray, _infGroup, _teleport ] spawn T8U_tsk_fnc_patrolUrban;
	};


	default
	{ 
		private _msg = format [ "The task %1 is not valid (here)! WTF?!<br /><br /> Call 0800 - T800A#WTFH for help. Not!", _task ];
		[ _msg ] call T8U_fnc_BroadcastHint;
		__DEBUG( __FILE__, "_task", "UNVALID: ABORT" );
		_error = true;
	}; 
};

// if we haven' found a matching task: abort abort abort ...
if ( _error ) exitWith {};
_error = false;

private _presetSkill	= 0;
private _presetBehavior = 0;
switch ( side _group ) do
{
	case WEST:
	{
		_presetSkill	= ( T8U_var_Presets select 0 ) select 0;
		_presetBehavior = ( T8U_var_Presets select 0 ) select 1;
	};
	
	case EAST:
	{
		_presetSkill	= ( T8U_var_Presets select 1 ) select 0;
		_presetBehavior = ( T8U_var_Presets select 1 ) select 1;				
	};
	
	case RESISTANCE:
	{
		_presetSkill	= ( T8U_var_Presets select 2 ) select 0;
		_presetBehavior = ( T8U_var_Presets select 2 ) select 1;				
	};
};


private _originArray = [ _markerArray, _task, _infGroup, _taskArray, _function ];
	
__SetOVAR( _group, "T8U_gvar_Comm", _commArray );
__SetOVAR( _group, "T8U_gvar_Settings", _settingsArray );
__SetOVAR( _group, "T8U_gvar_Origin", _originArray );
__SetOVAR( _group, "T8U_gvar_Assigned", "NO_TASK" );
__SetOVAR( _group, "T8U_gvar_Member", _units );	
__SetOVAR(( leader _group ), "T8_UnitsVarLeaderGroup", _group );	



//
//	Military Units - Add EventHandlers, Routines, Skill, etc.
//

if !(( side _group ) isEqualTo civilian ) then
{
	_group setCombatMode ( ( T8U_var_BehaviorSets select _presetBehavior ) select 0 );
	
	{
		private _u = _x;
		{
			_u setskill [ ( _x select 0 ), ( _x select 1 ) ];
			false
		} count ( T8U_var_SkillSets select _presetSkill );
		
		_u addEventHandler [ "Hit", { _this call T8U_fnc_HitEvent; } ];
		_u enableFatigue T8U_var_enableFatigue;
		
		false
	} count _units;

	// not going to happen anymore -> fn_handleGroups does this now
	// [ _group ] spawn T8U_fnc_OnFiredEvent;
	// leader _group addEventHandler [ "FiredNear",	{[ _this ] call T8U_fnc_FiredEvent; }];
	// leader _group addEventHandler [ "Killed",		{[ _this ] spawn T8U_fnc_KilledEvent; }];
	// if ( T8U_var_AllowCBM ) then { [ _group ] spawn T8U_fnc_CombatBehaviorMod; };
	
	if ( T8U_var_DEBUG_marker ) then { [ _group  ] spawn T8U_fnc_Track; };	


	// move units in vehicles for non infantry groups
	sleep 2;
			
	if !( _infGroup ) then 
	{
		private _units			= units _group;
		private _unitsOnFoot	= units _group;
		private _vehicles		= [];
		private _freeCargo		= [];
		
		{
			if !(( vehicle _x ) isEqualTo _x ) then
			{
				if (( gunner ( vehicle _x )) isEqualTo _x )		then { _unitsOnFoot = _unitsOnFoot - [ _x ]; };
				if (( commander ( vehicle _x )) isEqualTo _x )	then { _unitsOnFoot = _unitsOnFoot - [ _x ]; };
				if (( driver ( vehicle _x )) isEqualTo _x )		then { _unitsOnFoot = _unitsOnFoot - [ _x ]; };
				
				if !(( vehicle _x ) in _vehicles ) then 
				{
					_vehicles pushBack ( vehicle _x );
				};
			};

			false
		} count _units;
		
		{
			private _v = _x;
			
			for [{ _x = 0 }, { _x < _v emptyPositions "cargo" }, { _x = _x + 1 }] do
			{
				_freeCargo pushBack [ _v, _x, "cargo" ];
			};

			false
		} count _vehicles;

		_freeCargo = _freeCargo call BIS_fnc_arrayShuffle;
		
		{
			if (( count _freeCargo ) > 0 ) then
			{
				private _p = _freeCargo call BIS_fnc_arrayPop;
				_x assignAsCargo ( _p select 0 );
				_x moveInCargo ( _p select 0 );
				_x action [ "GETIN CARGO", ( _p select 0 )];
			};
			false
		} count _unitsOnFoot;
		
		
		_vehicles spawn 
		{
			sleep 5;
			{
				if ( isNull ( gunner _x ) ) then
				{
					( driver _x ) spawn { waitUntil { sleep 0.5; ( behaviour _this ) isEqualTo "COMBAT" }; [ _this ] spawn T8U_fnc_GetOutVehicle; };
				};
				
				false
			} count _this;
		};
	};



//
//	Civilian Units
//
} else {
	_group setSpeedMode "LIMITED";
	{
		_x setbehaviour "SAFE";
		false
	} count _units;
};


// register units for zeus
if ( T8U_var_AllowZEUS ) then 
{
	private _vehicles = [];
	
	{
		private _v = assignedVehicle _x;
		if ( !isNull _v AND { !(  _v in _vehicles ) } ) then { _vehicles pushBack _v; };
		false
	} count _units;
	
	{ _x addCuratorEditableObjects [ _units, true ]; } count allCurators;
	if ( count _vehicles > 0 ) then { { _x addCuratorEditableObjects [ _vehicles, true ]; } count allCurators; };
};


// EXEC a custom function for units
if ( _EXECfunction AND !( _function isEqualTo "ERROR" )) then { if ( !isNil "_function" ) then {{ _x call ( missionNamespace getVariable _function ); false } count _units; };};



// return units
_units
