/*
 =======================================================================================================================

	T8 Units Script
	
	Funktion:	fn_spawn.sqf
	Author:		T-800a
	E-Mail:		t-800a@gmx.net

 =======================================================================================================================
*/
private [ "_MasterArray", "_posMkrArray", "_error" ];

_MasterArray = _this select 0;

if ( isNil "_MasterArray" ) exitWith { if ( T8U_var_DEBUG ) then { [ "fn_spawn.sqf", "NO SPAWNING: _masterArray IS NIL!" ] spawn T8U_fnc_DebugLog; }; false };
if ( typeName _MasterArray == "BOOL" ) exitWith { if ( T8U_var_DEBUG ) then { [ "fn_spawn.sqf", "NO SPAWNING: EVERYBODY WAS ALREADY KILLED", _this ] spawn T8U_fnc_DebugLog; }; false };
if ( typeName _MasterArray != "ARRAY" OR { !( count _MasterArray > 0 ) } ) exitWith { [ "Something went seriously wrong! Aborting T8U_fnc_Spawn!" ] call T8U_fnc_BroadcastHint; false };

_posMkrArray = []; // All Markers for Debug
_error = false;

// -> ForEach _MasterArray
{ 
	private [ 	"_abort", "_group", "_vehicleArray", "_posMkr", "_type", "_commArray", "_cacheArray", "_cachePos", "_PatrolMarkerArray", "_infGroup", "_groupSide", 
				"_PatrolMarkerDoSAD", "_overwatchMarker", "_attackMarker", "_newStyleArray", "_groupArray", "_taskArray", "_cAM", "_cA0", "_cA1", "_customFNC", "_spawnPos", "_relPos" ];
	
	_abort = false; // for error findings
	
	_PatrolMarkerArray	= false;
	_PatrolMarkerDoSAD	= false;
	_attackMarker		= "NO-POS-GIVEN";
	_overwatchMarker	= "NO-POS-GIVEN";
	_overwatchMinDist	= 50;
	_overwatchRange		= 50;
	
	_groupArray = [ _x, 0, [], [[]] ] call BIS_fnc_param;
	_taskArray = [ _x, 1, [], [[]] ] call BIS_fnc_param;

	_cAM = [ _x, 2, [ true, true ], [[]] ] call BIS_fnc_param;
	_cA0 = [ _cAM, 0, true, [true] ] call BIS_fnc_param;
	_cA1 = [ _cAM, 1, true, [true] ] call BIS_fnc_param;
	_cA2 = [ _cAM, 2, true, [true] ] call BIS_fnc_param;
	_commArray = [ _cA0, _cA1, _cA2 ];
	
	_type = [ _taskArray, 0, "NO-TASK-GIVEN", [""] ] call BIS_fnc_param;
	
	_cacheArray = [ _x, 3, [], [[]] ] call BIS_fnc_param;
	_cachePos = [ _cacheArray, 0, [], [[]] ] call BIS_fnc_param;
	
	_vehicleArray = [ _groupArray, 0, [], [[]] ] call BIS_fnc_param;
	_posMkr = [ _groupArray, 1, "NO-POS-GIVEN", [""] ] call BIS_fnc_param;	_posMkrArray pushBack _posMkr;
	
	_infGroup	= true;
	_groupSide	= T8U_var_EnemySide;
	_customFNC	= "NO-FUNC-GIVEN";
	
	if ( count _groupArray > 2 ) then 
	{
		switch ( typeName ( _groupArray select 2) ) do 
		{ 
			case "BOOL":	{ _infGroup		= [ _groupArray, 2, true, [true] ] call BIS_fnc_param; };
			case "SIDE":	{ _groupSide	= [ _groupArray, 2, T8U_var_EnemySide ] call BIS_fnc_param; };
			case "STRING":	{ _customFNC	= [ _groupArray, 2, "NO-FUNC-GIVEN", ["123"] ] call BIS_fnc_param; };
			default { _type = "NO-TASK-GIVEN"; };
		};
	};
	
	if ( count _groupArray > 3 ) then 
	{
		switch ( typeName ( _groupArray select 3) ) do 
		{ 
			case "BOOL":	{ _infGroup		= [ _groupArray, 3, true, [true] ] call BIS_fnc_param; };
			case "SIDE":	{ _groupSide	= [ _groupArray, 3, T8U_var_EnemySide ] call BIS_fnc_param; };
			case "STRING":	{ _customFNC	= [ _groupArray, 3, "NO-FUNC-GIVEN", ["123"] ] call BIS_fnc_param; };
			default { _type = "NO-TASK-GIVEN"; };
		};
	};
	
	if ( count _groupArray > 4 ) then 
	{
		switch ( typeName ( _groupArray select 4) ) do 
		{ 
			case "BOOL":	{ _infGroup		= [ _groupArray, 4, true, [true] ] call BIS_fnc_param; };
			case "SIDE":	{ _groupSide	= [ _groupArray, 4, T8U_var_EnemySide ] call BIS_fnc_param; };
			case "STRING":	{ _customFNC	= [ _groupArray, 4, "NO-FUNC-GIVEN", ["123"] ] call BIS_fnc_param; };
			default { _type = "NO-TASK-GIVEN"; };
		};
	};


	if ( 
		!( count _vehicleArray > 0 ) 
		OR { _posMkr == "NO-POS-GIVEN" } 
		OR { _type == "NO-TASK-GIVEN" } 
		OR { ( str ( getMarkerPos _posMkr ) ) == str ([0,0,0]) }
	) exitWith { [ ( format [ "Something went seriously wrong! Error in Unit's spawning definition!<br /><br />Marker: %1<br />Task: %2", _posMkr, _type ] ) ] call T8U_fnc_BroadcastHint; _error = true; };

	if ( count _cachePos > 0 ) then
	{
		_spawnPos = [ _cachePos ] call T8U_fnc_CreateSpawnPos;
	} else {
		_spawnPos = [ _posMkr ] call T8U_fnc_CreateSpawnPos;
	};
	
	_relPos = [];
	if ( ! _infGroup ) then 
	{ 
		private [ "_tempRelPos" ];
		_tempRelPos = [ [0,0], [0,9], [0,-9], [9,0], [9,9], [9,-9], [-9,0], [-9,9], [-9,-9], [18,0], [18,9], [18,-9], [-18,0], [-18,9], [-18,-9], [0,18], [9,18], [-9,18], [0,-18], [9,-18], [-9,-18], [18,18], [18,-18], [-18,18], [-18,-18] ];
		
		{
			private [ "_p" ];
			_p = [ _tempRelPos ] call BIS_fnc_arrayShift;
			_relPos pushBack _p;
			
			false
		} count _vehicleArray;
		
		// if ( count _vehicleArray < 2 ) then { _tempRelPos = []; };
	};

// ------------------ TASK SWITCH --- UNITS WILL BE SPAWNED NOW --------------------------------------------------------------

	switch ( _type ) do 
	{ 
		case "PATROL": 
		{
			_group = [ _spawnPos, _groupSide, _vehicleArray, _relPos ] call BIS_fnc_spawnGroup;
			[ _group, _posMkr, _infGroup ] spawn T8U_task_Patrol;				
		};
			
		case "PATROL_AROUND": 
		{
			_group = [ _spawnPos, _groupSide, _vehicleArray, _relPos ] call BIS_fnc_spawnGroup;
			[ _group, _posMkr, _infGroup ] spawn T8U_task_PatrolAround;
		};
			
		case "PATROL_URBAN": 
		{
			_group = [ _spawnPos, _groupSide, _vehicleArray, _relPos ] call BIS_fnc_spawnGroup;
			[ _group, _posMkr, _infGroup ] spawn T8U_task_PatrolUrban;
		};

		case "PATROL_GARRISON": 
		{
			// Force _infGroup = false !!!
			// _commArray = [ ( _commArray select 0 ), false ];				
			_group = [ _spawnPos, _groupSide, _vehicleArray, _relPos ] call BIS_fnc_spawnGroup;
			[ _group, _posMkr ] spawn T8U_task_PatrolGarrison;
		};
			
		case "PATROL_MARKER": 
		{

			_PatrolMarkerArray = [ _taskArray, 1, [], [[]] ] call BIS_fnc_param;
			_PatrolMarkerDoSAD = [ _taskArray, 2, true, [true] ] call BIS_fnc_param;				
			_group = [ _spawnPos, _groupSide, _vehicleArray, _relPos ] call BIS_fnc_spawnGroup;
			[ _group, _PatrolMarkerArray, _infGroup, _PatrolMarkerDoSAD ] spawn T8U_task_PatrolMarker;
		};

		case "GARRISON": 
		{
			_group = [ _spawnPos , _groupSide, _vehicleArray, _relPos ] call BIS_fnc_spawnGroup;
			[ _group, _posMkr ] spawn T8U_task_Garrison;
		};
				
		case "DEFEND": 
		{
			_group = [ _spawnPos , _groupSide, _vehicleArray, _relPos ] call BIS_fnc_spawnGroup;
			[ _group, _posMkr ] spawn T8U_task_Defend;
		};

		case "DEFEND_BASE": 
		{
			_group = [ _spawnPos , _groupSide, _vehicleArray, _relPos ] call BIS_fnc_spawnGroup;
			[ _group, _posMkr ] spawn T8U_task_DefendBase;
		};
			
		case "OVERWATCH": 
		{
			_overwatchMarker	= [ _taskArray, 1, "NO-POS-GIVEN", [""] ] call BIS_fnc_param;
			_overwatchMinDist	= [ _taskArray, 2, 250, [ 123 ] ] call BIS_fnc_param;
			_overwatchRange		= [ _taskArray, 3, 200, [ 123 ] ] call BIS_fnc_param;
			if ( _overwatchMarker == "NO-POS-GIVEN" ) then { _overwatchMarker = _posMkr; };
				
			_group = [ _spawnPos , _groupSide, _vehicleArray, _relPos ] call BIS_fnc_spawnGroup;
			[ _group, _overwatchMarker, _overwatchMinDist, _overwatchRange, _infGroup ] spawn T8U_task_Overwatch;
		};
			
		case "LOITER": 
		{
			_group = [ _spawnPos , _groupSide, _vehicleArray, _relPos ] call BIS_fnc_spawnGroup;
			[ _group, _posMkr ] spawn T8U_task_Loiter;
		};
		
		case "ATTACK": 
		{
			_attackMarker	= [ _taskArray, 1, "NO-POS-GIVEN", [""] ] call BIS_fnc_param;
			if ( _attackMarker == "NO-POS-GIVEN" ) then { _attackMarker = _posMkr; };
				
			_group = [ _spawnPos , _groupSide, _vehicleArray, _relPos ] call BIS_fnc_spawnGroup;
			[ _group, _attackMarker, _infGroup ] spawn T8U_task_Attack;
		};
			
		default
		{ 
			private [ "_msg" ]; _msg = format [ "The task %1 does not exist! WTF?!<br /><br /> Call 0800 - T800A#WTFH for help. Not!", _type ]; [ _msg ] call T8U_fnc_BroadcastHint;

			_abort = true;
			_error = true;
		}; 
	};

	if ( ! _abort ) then
	{
		if ( _groupSide != civilian ) then 
		{
	//
	//	Military Units - Add EventHandlers, Routines, Skill, etc.
	//
	
			private [ "_presetSkill", "_presetBehavior" ];
			_presetSkill	= 0;
			_presetBehavior = 0;
			
	// Setup Origin Array
			_originArray = [ _posMkr, _type, _infGroup, _taskArray, _customFNC ];
			
			switch ( _groupSide ) do
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
				
			if ( T8U_var_DEBUG ) then { [ "fn_spawn.sqf", "UNITS", units _group ] spawn T8U_fnc_DebugLog; };
				
			_group setVariable [ "T8U_gvar_Comm", _commArray, false ];
			_group setVariable [ "T8U_gvar_Origin", _originArray, false ];
			_group setVariable [ "T8U_gvar_Assigned", "NO_TASK", false ];
			_group setVariable [ "T8U_gvar_Member", ( units _group ), false ];
					
	// T8_UnitsVarLeaderGroup: saves group to leader (dead units loose group)
			leader _group setVariable [ "T8_UnitsVarLeaderGroup", group ( leader _group ), false ];
			
			if ( T8U_var_DEBUG ) then { [ "fn_spawn.sqf", "T8_UnitsVars", [ _group getVariable "T8U_gvar_Comm", _group getVariable "T8U_gvar_Origin", _group getVariable "T8U_gvar_Assigned", _group getVariable [ "T8U_gvar_Attacked", "not yet" ], leader _group getVariable "T8_UnitsVarLeaderGroup"] ] spawn T8U_fnc_DebugLog; };
	
			// Set the skill for the Group
			// -> forEach units _group		
			{
				private [ "_tmpUnit" ];
				_tmpUnit = _x;
				{
					_tmpUnit setskill [ ( _x select 0 ), ( _x select 1 ) ];
				} forEach ( T8U_var_SkillSets select _presetSkill );
				
				// Add a HIT event to all Units
				_tmpUnit addEventHandler [ "Hit", { _this call T8U_fnc_HitEvent; } ];
				
				// EXEC a custom Function for units
				if ( _customFNC	!= "NO-FUNC-GIVEN" ) then 
				{
					_x call ( missionNamespace getVariable _customFNC );
				};

			} foreach units _group;
		
			leader _group addEventHandler [ "FiredNear", { [ _this ] call T8U_fnc_FiredEvent; } ];
			leader _group addEventHandler [ "Killed", { [ _this ] spawn T8U_fnc_KilledEvent; } ];
					
			if ( T8U_var_DEBUG_marker ) then { [ _group  ] spawn T8U_fnc_Track; };
					
			[ _group ] spawn T8U_fnc_OnFiredEvent;
					
			if ( T8U_var_AllowCBM ) then { [ _group ] spawn T8U_fnc_CBM; };
			
			// Set the combat mode for the Group ( green, blue, red, white, ...)			
			_group setCombatMode ( ( T8U_var_BehaviorSets select _presetBehavior ) select 0 );
				
		} else {
	//
	//	Civilian Units
	//
			_group setSpeedMode "LIMITED";
			{
				_x setbehaviour "SAFE";
			} foreach units _group;
		};		
	
		if ( T8U_var_AllowZEUS ) then 
		{
			private [ "_units", "_vehicles" ];
			
			_units = units _group;
			_vehicles = [];
			
			{
				private [ "_v" ];
				_v = assignedVehicle _x;
				
				if ( !isNull _v AND { !(  _v in _vehicles ) } ) then { _vehicles pushBack _v; };
				
				false
			} count _units;
			
			{ _x addCuratorEditableObjects [ _units, true ]; } count T8U_var_ZeusModules;
			if ( count _vehicles > 0 ) then { { _x addCuratorEditableObjects [ _vehicles, true ]; } count T8U_var_ZeusModules; };
		};
	};
	
	// no hurry ...
	sleep 3;

} forEach _MasterArray;
	
if ( _error ) exitWith { false };

if ( T8U_var_DEBUG_hints ) then { private [ "_msg" ]; _msg = format [ "Your Units at %1 are spawned", _posMkrArray ]; [ _msg ] call T8U_fnc_BroadcastHint; };

true
