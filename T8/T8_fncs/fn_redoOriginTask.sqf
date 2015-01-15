/*
 =======================================================================================================================

	T8 Units Script

	Funktion:	fn_redoOriginTask.sqf
	Author:		T-800a
	E-Mail:		t-800a@gmx.net

 =======================================================================================================================
*/

private [	"_group", "_oldTask", "_newTask", "_originArray", "_posMkr", "_type", "_PatrolMarkerArray", "_infGroup", "_PatrolMarkerDoSAD", "_overwatchMarker", "_overwatchMinDist",
			"_overwatchRange", "_attackMarker", "_presetBehavior" ];

_group		= [ _this, 0, grpNull, [grpNull] ] call BIS_fnc_param;
_time		= [ _this, 1, 10, [123] ] call BIS_fnc_param;
_oldTask	= _group getVariable [ "T8U_gvar_Assigned", "NO_TASK" ];

if ( T8U_var_DEBUG ) then { [ "fn_redoOriginTask.sqf", "INIT", _this ] spawn T8U_fnc_DebugLog; };
if ( isNull _group ) exitWith { false };

if ( T8U_var_DEBUG ) then { [ "fn_redoOriginTask.sqf", "SLEEP", [ _group ] ] spawn T8U_fnc_DebugLog; };

sleep ( _time + T8U_var_TaskReturnTime );

if ( T8U_var_DEBUG ) then { [ "fn_redoOriginTask.sqf", "EXEC", [ _group ] ] spawn T8U_fnc_DebugLog; };

if ( isNil "_group" OR { isNull _group } ) exitWith { false };
_newTask = _group getVariable [ "T8U_gvar_Assigned", "NO_TASK" ];
if ( _oldTask != _newTask ) exitWith { if ( T8U_var_DEBUG ) then { [ "fn_redoOriginTask.sqf", "EXIT - TASK CHANGED", [ _group ] ] spawn T8U_fnc_DebugLog; }; };

_newGroup = [ _group ] call T8U_fnc_GroupClearWP;
_originArray = _newGroup getVariable [ "T8U_gvar_Origin", [] ],

if ( count _originArray < 1 ) exitWith { if ( T8U_var_DEBUG ) then { [ "fn_redoOriginTask.sqf", "EXIT - ORIGIN ARRAY EMPTY", [ _group ] ] spawn T8U_fnc_DebugLog; }; };

_posMkr			= _originArray select 0;
_type			= _originArray select 1;
_infGroup		= _originArray select 2;
_taskArray		= _originArray select 3;

if ( T8U_var_DEBUG ) then { [ "fn_redoOriginTask.sqf", "NEW GROUP", [ _newGroup, _originArray ] ] spawn T8U_fnc_DebugLog; };

switch ( _type ) do
{
		case "PATROL":
		{
			[ _newGroup, _posMkr, _infGroup ] spawn T8U_task_Patrol;
		};

		case "PATROL_AROUND":
		{
			[ _newGroup, _posMkr, _infGroup ] spawn T8U_task_PatrolAround;
		};

		case "PATROL_URBAN":
		{
			[ _newGroup, _posMkr, _infGroup ] spawn T8U_task_PatrolUrban;
		};

		case "PATROL_MARKER":
		{
			_PatrolMarkerArray = [ _taskArray, 1, [], [[]] ] call BIS_fnc_param;
			_PatrolMarkerDoSAD = [ _taskArray, 2, true, [true] ] call BIS_fnc_param;
			[ _newGroup, _PatrolMarkerArray, _infGroup, _PatrolMarkerDoSAD ] spawn T8U_task_PatrolMarker;
		};

		case "LOITER":
		{
			[ _newGroup, _posMkr ] spawn T8U_task_Loiter;
		};

		case "DEFEND":
		{
			[ _newGroup, _posMkr ] spawn T8U_task_Defend;
		};

		case "DEFEND_BASE":
		{
			[ _newGroup, _posMkr ] spawn T8U_task_DefendBase;
		};

		case "OVERWATCH":
		{
			_overwatchMarker	= [ _taskArray, 1, "NO-POS-GIVEN", [""] ] call BIS_fnc_param;
			_overwatchMinDist	= [ _taskArray, 2, 250, [ 123 ] ] call BIS_fnc_param;
			_overwatchRange		= [ _taskArray, 3, 300, [ 123 ] ] call BIS_fnc_param;
			if ( _overwatchMarker == "NO-POS-GIVEN" ) then { _overwatchMarker = _posMkr; };
			[ _newGroup, _overwatchMarker, _overwatchMinDist, _overwatchRange, _infGroup ] spawn T8U_task_Overwatch;
		};
		
		case "ATTACK": 
		{
			_attackMarker	= [ _taskArray, 1, "NO-POS-GIVEN", [""] ] call BIS_fnc_param;
			if ( _attackMarker == "NO-POS-GIVEN" ) then { _attackMarker = _posMkr; };
			[ _newGroup, _attackMarker, _infGroup ] spawn T8U_task_Attack;
		};

		case "GARRISON":
		{
			[ _newGroup, _posMkr ] spawn T8U_task_Garrison;
		};

		case "PATROL_GARRISON":
		{
			[ _newGroup, _posMkr ] spawn T8U_task_PatrolGarrison;
		};

	default { private [ "_msg" ]; _msg = format [ "Your Task %1 does not exist!", _type ]; [ _msg ] call T8U_fnc_BroadcastHint; };
};

_newGroup setVariable [ "T8U_gvar_Assigned", "NO_TASK", false ];

leader _newGroup addEventHandler ["FiredNear", { [ _this ] call T8U_fnc_FiredEvent; }];
leader _newGroup addEventHandler ["Killed", { [ _this ] spawn T8U_fnc_KilledEvent; }];
[ _newGroup ] spawn T8U_fnc_OnFiredEvent;
if ( T8U_var_AllowCBM ) then { [ _newGroup ] spawn T8U_fnc_CBM; };

switch ( side _newGroup ) do
{
	case WEST:			{ _presetBehavior = ( T8U_var_Presets select 0 ) select 1; };
	case EAST:			{ _presetBehavior = ( T8U_var_Presets select 1 ) select 1; };	
	case RESISTANCE:	{ _presetBehavior = ( T8U_var_Presets select 2 ) select 1; };
};

if ( behaviour ( leader _newGroup ) != "COMBAT" ) then { _newGroup setBehaviour "SAFE"; _newGroup setCombatMode ( ( T8U_var_BehaviorSets select _presetBehavior ) select 0 ); };


// Return
true
