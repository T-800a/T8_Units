/*
 =======================================================================================================================

	T8 Units Script

	Funktion:	fn_redoOriginTask.sqf
	Author:		T-800a
	E-Mail:		t-800a@gmx.net

 =======================================================================================================================
*/

#include <..\MACRO.hpp>

private [	"_group", "_oldTask", "_newTask", "_originArray", "_posMkr", "_type", "_infGroup", "_presetBehavior" ];

_group		= param [ 0, grpNull, [grpNull]];
_time		= param [ 1, 10, [123]];
_oldTask	= _group getVariable [ "T8U_gvar_Assigned", "NO_TASK" ];

if ( T8U_var_DEBUG ) then { [ "fn_redoOriginTask.sqf", "INIT", _this ] spawn T8U_fnc_DebugLog; };
if ( isNull _group ) exitWith { false };

if ( T8U_var_DEBUG ) then { [ "fn_redoOriginTask.sqf", "SLEEP", [ _group ] ] spawn T8U_fnc_DebugLog; };

sleep ( _time + T8U_var_TaskReturnTime );

if ( T8U_var_DEBUG ) then { [ "fn_redoOriginTask.sqf", "EXEC", [ _group ] ] spawn T8U_fnc_DebugLog; };

if ( isNil "_group" OR { isNull _group } ) exitWith { false };
_newTask = _group getVariable [ "T8U_gvar_Assigned", "NO_TASK" ];
if ( _oldTask != _newTask ) exitWith { if ( T8U_var_DEBUG ) then { [ "fn_redoOriginTask.sqf", "EXIT - TASK CHANGED", [ _group ] ] spawn T8U_fnc_DebugLog; }; };

_newGroup = [ _group ] call T8U_fnc_GroupClearWaypoints;
_originArray = _newGroup getVariable [ "T8U_gvar_Origin", [] ],

if ( count _originArray < 1 ) exitWith { if ( T8U_var_DEBUG ) then { [ "fn_redoOriginTask.sqf", "EXIT - ORIGIN ARRAY EMPTY", [ _group ] ] spawn T8U_fnc_DebugLog; }; };

_posMkr			= _originArray select 0;
_type			= _originArray select 1;
_infGroup		= _originArray select 2;
_taskArray		= _originArray select 3;

if ( T8U_var_DEBUG ) then { [ "fn_redoOriginTask.sqf", "NEW GROUP", [ _newGroup, _originArray ] ] spawn T8U_fnc_DebugLog; };

switch ( _type ) do
{
	case "ATTACK": 
	{
		private _attackMarker = _taskArray param [ 1, "NO-POS-GIVEN", [""]];
		if ( _attackMarker == "NO-POS-GIVEN" ) then { _attackMarker = _posMkr; };
		[ _newGroup, _attackMarker, _infGroup ] spawn T8U_tsk_fnc_Attack;
	};

	case "DEFEND":
	{
		[ _newGroup, _posMkr ] spawn T8U_tsk_fnc_defend;
	};

	case "DEFEND_BASE":
	{
		[ _newGroup, _posMkr ] spawn T8U_tsk_fnc_defendBase;
	};

	case "GARRISON":
	{
		[ _newGroup, _posMkr ] spawn T8U_tsk_fnc_garrison;
	};

	case "LOITER":
	{
		[ _newGroup, _posMkr ] spawn T8U_tsk_fnc_loiter;
	};

	case "OCCUPY": 
	{
		private _immobile = _taskArray param [ 1, false, [true]];
		[ _newGroup, _posMkr, _immobile ] spawn T8U_tsk_fnc_occupy;
	};

	case "OVERWATCH":
	{
		private _overwatchMarker	= _taskArray param [ 1, "NO-POS-GIVEN", [""]];
		private _overwatchMinDist	= _taskArray param [ 2, 250, [ 123 ]];
		private _overwatchRange		= _taskArray param [ 3, 300, [ 123 ]];
		if ( _overwatchMarker == "NO-POS-GIVEN" ) then { _overwatchMarker = _posMkr; };
		[ _newGroup, _overwatchMarker, _overwatchMinDist, _overwatchRange, _infGroup ] spawn T8U_tsk_fnc_overwatch;
	};

	case "PATROL":
	{
		[ _newGroup, _posMkr, _infGroup ] spawn T8U_tsk_fnc_patrol;
	};

	case "PATROL_AROUND":
	{
		[ _newGroup, _posMkr, _infGroup ] spawn T8U_tsk_fnc_patrolAround;
	};

	case "PATROL_GARRISON":
	{
		[ _newGroup, _posMkr ] spawn T8U_tsk_fnc_patrolGarrison;
	};

	case "PATROL_MARKER":
	{
		private _PatrolMarkerArray = _taskArray param [ 1, [], [[]]];
		private _PatrolMarkerDoSAD = _taskArray param [ 2, true, [true]];
		[ _newGroup, _PatrolMarkerArray, _infGroup, _PatrolMarkerDoSAD ] spawn T8U_tsk_fnc_patrolMarker;
	};

	case "PATROL_URBAN":
	{
		[ _newGroup, _posMkr, _infGroup ] spawn T8U_tsk_fnc_patrolUrban;
	};

	default { private [ "_msg" ]; _msg = format [ "Your Task %1 does not exist!", _type ]; [ _msg ] call T8U_fnc_BroadcastHint; };
};

_newGroup setVariable [ "T8U_gvar_Assigned", "NO_TASK", false ];

leader _newGroup addEventHandler ["FiredNear", { [ _this ] call T8U_fnc_FiredEvent; }];
leader _newGroup addEventHandler ["Killed", { [ _this ] spawn T8U_fnc_KilledEvent; }];
[ _newGroup ] spawn T8U_fnc_OnFiredEvent;
if ( T8U_var_AllowCBM ) then { [ _newGroup ] spawn T8U_fnc_CombatBehaviorMod; };

switch ( side _newGroup ) do
{
	case WEST:			{ _presetBehavior = ( T8U_var_Presets select 0 ) select 1; };
	case EAST:			{ _presetBehavior = ( T8U_var_Presets select 1 ) select 1; };	
	case RESISTANCE:	{ _presetBehavior = ( T8U_var_Presets select 2 ) select 1; };
};

if ( behaviour ( leader _newGroup ) != "COMBAT" ) then { _newGroup setBehaviour "SAFE"; _newGroup setCombatMode ( ( T8U_var_BehaviorSets select _presetBehavior ) select 0 ); };


// Return
true
