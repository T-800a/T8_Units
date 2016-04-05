/*
 =======================================================================================================================

	T8 Units Script
	
	Funktion:	fn_spawn.sqf
	Author:		T-800a
	E-Mail:		t-800a@gmx.net

 =======================================================================================================================
*/

#include <..\MACRO.hpp>
__allowEXEC(__FILE__);


private [ "_MasterArray", "_posMkrArray", "_error", "_return" ];

_MasterArray = _this select 0;

if ( isNil "_MasterArray" ) exitWith { if ( T8U_var_DEBUG ) then { [ "fn_spawn.sqf", "NO SPAWNING: _masterArray IS NIL!" ] spawn T8U_fnc_DebugLog; }; false };
if ( typeName _MasterArray == "BOOL" ) exitWith { if ( T8U_var_DEBUG ) then { [ "fn_spawn.sqf", "NO SPAWNING: EVERYBODY WAS ALREADY KILLED", _this ] spawn T8U_fnc_DebugLog; }; false };
if ( typeName _MasterArray != "ARRAY" OR { !( count _MasterArray > 0 ) } ) exitWith { [ "Something went seriously wrong! Aborting T8U_fnc_Spawn!" ] call T8U_fnc_BroadcastHint; false };

_posMkrArray = []; // All Markers for Debug
_error = false;
_return = [];

// -> ForEach _MasterArray
{ 
	private [ 	"_abort", "_group", "_vehicleArray", "_posMkr", "_type", "_commArray", "_cacheArray", "_cachePos", "_PatrolMarkerArray", "_infGroup", "_groupSide", "_markerArray",
				"_PatrolMarkerDoSAD", "_PatrolAroundDis", "_overwatchMarker", "_attackMarker", "_newStyleArray", "_groupArray", "_taskArray", "_cAM", "_cA0", "_cA1", "_customFNC", "_spawnPos", "_relPos" ];
	
	_abort = false; // for error findings
	
	_PatrolMarkerArray	= false;
	_PatrolMarkerDoSAD	= false;
	_attackMarker		= "NO-POS-GIVEN";
	_overwatchMarker	= "NO-POS-GIVEN";
	_overwatchMinDist	= 50;
	_overwatchRange		= 50;
	
	_groupArray			= _x param [ 0, [], [[]]];
	_taskArray			= _x param [ 1, [], [[]]];
	_cAM				= _x param [ 2, [ true, true ], [[]]];
	
	_cA0				= _cAM param [ 0, true, [true]];
	_cA1				= _cAM param [ 1, true, [true]];
	_cA2				= _cAM param [ 2, true, [true]];
	_commArray			= [ _cA0, _cA1, _cA2 ];
	
	_type				= _taskArray param [ 0, "NO-TASK-GIVEN", [""]];
	
	_cacheArray			= _x param [ 3, [], [[]]];
	_cachePos			= _cacheArray param [ 0, [], [[],""]];
	
	_vehicleArray		= _groupArray param [ 0, [], [[]]];
	_markerArray		= _groupArray param [ 1, false, ["",[]]];	
	
	_infGroup	= true;
	_groupSide	= T8U_var_EnemySide;
	_customFNC	= "NO-FUNC-GIVEN";
	
	switch ( typeName _markerArray ) do 
	{ 
		case "ARRAY":	{ _posMkr = _markerArray call BIS_fnc_selectRandom; };
		case "STRING":	{ _posMkr = _markerArray; };
		default			{ _posMkr = "NO-POS-GIVEN"; };
	};
	
	_posMkrArray pushBack _posMkr;
		
	if ( count _groupArray > 2 ) then 
	{
		switch ( typeName ( _groupArray select 2) ) do 
		{ 
			case "BOOL":	{ _infGroup		= _groupArray param [ 2, true, [true]]; };
			case "SIDE":	{ _groupSide	= _groupArray param [ 2, T8U_var_EnemySide ]; };
			case "STRING":	{ _customFNC	= _groupArray param [ 2, "NO-FUNC-GIVEN", ["123"]]; };
			default { _type = "NO-TASK-GIVEN"; };
		};
	};
	
	if ( count _groupArray > 3 ) then 
	{
		switch ( typeName ( _groupArray select 3) ) do 
		{ 
			case "BOOL":	{ _infGroup		= _groupArray param [ 3, true, [true]]; };
			case "SIDE":	{ _groupSide	= _groupArray param [ 3, T8U_var_EnemySide ]; };
			case "STRING":	{ _customFNC	= _groupArray param [ 3, "NO-FUNC-GIVEN", ["123"]]; };
			default { _type = "NO-TASK-GIVEN"; };
		};
	};
	
	if ( count _groupArray > 4 ) then 
	{
		switch ( typeName ( _groupArray select 4) ) do 
		{ 
			case "BOOL":	{ _infGroup		= _groupArray param [ 4, true, [true]]; };
			case "SIDE":	{ _groupSide	= _groupArray param [ 4, T8U_var_EnemySide ]; };
			case "STRING":	{ _customFNC	= _groupArray param [ 4, "NO-FUNC-GIVEN", ["123"]]; };
			default { _type = "NO-TASK-GIVEN"; };
		};
	};

	if ( 
		!( count _vehicleArray > 0 ) 
		OR { _posMkr == "NO-POS-GIVEN" } 
		OR { _type == "NO-TASK-GIVEN" } 
		OR { ( getMarkerPos _posMkr ) isEqualTo [0,0,0] }
	) exitWith { [ ( format [ "Something went seriously wrong! Error in Unit's spawning definition!<br /><br />Marker: %1<br />Task: %2", _posMkr, _type ] ) ] call T8U_fnc_BroadcastHint; _error = true; };

	
	if (( typeName _cachePos ) isEqualTo ( typeName "STR" )) then { _cachePos = getMarkerPos _cachePos; };
	if ( _cachePos isEqualTo [0,0,0]) then { _cachePos = _posMkr; };
	if ( count _cachePos > 1 ) then
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
			if (( count _tempRelPos  ) > 0 ) then 
			{
				private [ "_p" ];
				_p = [ _tempRelPos ] call BIS_fnc_arrayShift;
				_relPos pushBack _p;
			} else {
				_relPos pushBack [0,4];
			};
			
			false
		} count _vehicleArray;
		
		// if ( count _vehicleArray < 2 ) then { _tempRelPos = []; };
	};

// ------------------ TASK SWITCH --- UNITS WILL BE SPAWNED NOW --------------------------------------------------------------

	switch ( _type ) do 
	{
		case "ATTACK": 
		{
			_attackMarker = _taskArray param [ 1, "NO-POS-GIVEN", [""]];
			if ( _attackMarker == "NO-POS-GIVEN" ) then { _attackMarker = _posMkr; };
				
			_group = [ _spawnPos , _groupSide, _vehicleArray, _relPos ] call BIS_fnc_spawnGroup;
			[ _group, _attackMarker, _infGroup ] spawn T8U_tsk_fnc_Attack;
		};

		case "DEFEND": 
		{
			_group = [ _spawnPos , _groupSide, _vehicleArray, _relPos ] call BIS_fnc_spawnGroup;
			[ _group, _posMkr ] spawn T8U_tsk_fnc_defend;
		};

		case "DEFEND_BASE": 
		{
			_group = [ _spawnPos , _groupSide, _vehicleArray, _relPos ] call BIS_fnc_spawnGroup;
			[ _group, _posMkr ] spawn T8U_tsk_fnc_defendBase;
		};

		case "GARRISON": 
		{
			_group = [ _spawnPos , _groupSide, _vehicleArray, _relPos ] call BIS_fnc_spawnGroup;
			[ _group, _posMkr ] spawn T8U_tsk_fnc_garrison;
		};

		case "LOITER": 
		{
			_group = [ _spawnPos , _groupSide, _vehicleArray, _relPos ] call BIS_fnc_spawnGroup;
			[ _group, _posMkr ] spawn T8U_tsk_fnc_loiter;
		};

		case "OCCUPY": 
		{
			_group = [ _spawnPos , _groupSide, _vehicleArray, _relPos ] call BIS_fnc_spawnGroup;
			private _immobile = _taskArray param [ 1, false, [true]];
			[ _group, _posMkr, _immobile ] spawn T8U_tsk_fnc_occupy;
		};

		case "OVERWATCH": 
		{
			_overwatchMarker	= _taskArray param [ 1, "NO-POS-GIVEN", [""]];
			_overwatchMinDist	= _taskArray param [ 2, 250, [ 123 ]];
			_overwatchRange		= _taskArray param [ 3, 200, [ 123 ]];
			if ( _overwatchMarker == "NO-POS-GIVEN" ) then { _overwatchMarker = _posMkr; };
				
			_group = [ _spawnPos , _groupSide, _vehicleArray, _relPos ] call BIS_fnc_spawnGroup;
			[ _group, _overwatchMarker, _overwatchMinDist, _overwatchRange, _infGroup ] spawn T8U_tsk_fnc_overwatch;
		};

		case "PATROL": 
		{
			_group = [ _spawnPos, _groupSide, _vehicleArray, _relPos ] call BIS_fnc_spawnGroup;
			[ _group, _markerArray, _infGroup ] spawn T8U_tsk_fnc_patrol;				
		};

		case "PATROL_AROUND": 
		{
			_PatrolAroundDis = _taskArray param [ 1, T8U_var_PatAroundRange, [123]];
			_group = [ _spawnPos, _groupSide, _vehicleArray, _relPos ] call BIS_fnc_spawnGroup;
			[ _group, _markerArray, _infGroup, _PatrolAroundDis ] spawn T8U_tsk_fnc_patrolAround;
		};

		case "PATROL_GARRISON": 
		{
			// Force _infGroup = false !!!
			// _commArray = [ ( _commArray select 0 ), false ];			
			_group = [ _spawnPos, _groupSide, _vehicleArray, _relPos ] call BIS_fnc_spawnGroup;
			[ _group, _posMkr ] spawn T8U_tsk_fnc_patrolGarrison;
		};

		case "PATROL_MARKER": 
		{
			_PatrolMarkerArray = _taskArray param [ 1, [], [[]]];
			_PatrolMarkerDoSAD = _taskArray param [ 2, true, [true]];				
			_group = [ _spawnPos, _groupSide, _vehicleArray, _relPos ] call BIS_fnc_spawnGroup;
			[ _group, _PatrolMarkerArray, _infGroup, _PatrolMarkerDoSAD ] spawn T8U_tsk_fnc_patrolMarker;
		};

		case "PATROL_URBAN": 
		{
			_group = [ _spawnPos, _groupSide, _vehicleArray, _relPos ] call BIS_fnc_spawnGroup;
			[ _group, _markerArray, _infGroup ] spawn T8U_tsk_fnc_patrolUrban;
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
			_originArray = [ _markerArray, _type, _infGroup, _taskArray, _customFNC ];
			
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
				
				// enable / disable fatigue
				_tmpUnit enableFatigue T8U_var_enableFatigue;

				// add units to return array
				_return pushBack _tmpUnit;

			} foreach units _group;
		
			leader _group addEventHandler [ "FiredNear", { [ _this ] call T8U_fnc_FiredEvent; } ];
			leader _group addEventHandler [ "Killed", { [ _this ] spawn T8U_fnc_KilledEvent; } ];
					
			if ( T8U_var_DEBUG_marker ) then { [ _group  ] spawn T8U_fnc_Track; };
					
			[ _group ] spawn T8U_fnc_OnFiredEvent;
					
			if ( T8U_var_AllowCBM ) then { [ _group ] spawn T8U_fnc_CombatBehaviorMod; };
			
			// Set the combat mode for the Group ( green, blue, red, white, ...)			
			_group setCombatMode ( ( T8U_var_BehaviorSets select _presetBehavior ) select 0 );
			
			// move units in vehicles for non infantry groups
			sleep 2;
			
			if !( _infGroup ) then 
			{
				private [ "_units", "_unitsOnFoot", "_vehicles", "_freeCargo" ];
				_units			= units _group;
				_unitsOnFoot	= units _group;
				_vehicles		= [];
				_freeCargo		= [];
				
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
				
				if ( T8U_var_DEBUG ) then { [ "fn_spawn.sqf", "_units", [ count _units, _units ]] call T8U_fnc_DebugLog; };
				if ( T8U_var_DEBUG ) then { [ "fn_spawn.sqf", "_unitsOnFoot", [ count _unitsOnFoot, _unitsOnFoot ]] call T8U_fnc_DebugLog; };
				
				{
					private [ "_v" ];
					_v = _x;
					
					for [{ _x = 0 }, { _x < _v emptyPositions "cargo" }, { _x = _x + 1 }] do
					{
						_freeCargo pushBack [ _v, _x, "cargo" ];
					};

					false
				} count _vehicles;

				_freeCargo = _freeCargo call BIS_fnc_arrayShuffle;

				if ( T8U_var_DEBUG ) then { [ "fn_spawn.sqf", "_freeCargo", [ count _freeCargo, _freeCargo ]] call T8U_fnc_DebugLog; };
				
				{
					private [ "_p" ];
					if (( count _freeCargo ) > 0 ) then
					{
						_p = _freeCargo call BIS_fnc_arrayPop;
						// _x assignAsCargoIndex [( _p select 0 ), ( _p select 1 )];
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
							( driver _x ) spawn { waitUntil {( behaviour _this ) isEqualTo "COMBAT" }; [ _this ] spawn T8U_fnc_GetOutVehicle; };
						};
						
						false
					} count _this;
				};
			};

				
		} else {
	//
	//	Civilian Units
	//
			_group setSpeedMode "LIMITED";
			{
				_x setbehaviour "SAFE";
				
				// add units to return array
				_return pushBack _x;
	
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
			
			{ _x addCuratorEditableObjects [ _units, true ]; } count allCurators;
			if ( count _vehicles > 0 ) then { { _x addCuratorEditableObjects [ _vehicles, true ]; } count allCurators; };
		};
	
	
		// EXEC a custom Function for units
		if ( _customFNC	!= "NO-FUNC-GIVEN" ) then {{ _x call ( missionNamespace getVariable _customFNC ); false } count ( units _group );};
	};

	
	// no hurry ...
	sleep 1;

} forEach _MasterArray;
	
if ( _error ) exitWith { false };

if ( T8U_var_DEBUG_hints ) then { private [ "_msg" ]; _msg = format [ "Your Units at %1 are spawned", _posMkrArray ]; [ _msg ] call T8U_fnc_BroadcastHint; };



// return created units
_return
