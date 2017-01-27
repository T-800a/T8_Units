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

private _MasterArray	= _this select 0;
private _posMkrArray	= []; // All Markers for Debug
private _error			= false;
private _return			= [];
private _cfg			= call T8U_fnc_selectConfigFile;

if ( isNull _cfg ) exitWith { [ "WARNING!<br /><br />You are missing a configfile.<br /><br />Please check your description.ext maybe you did not included the T8 Units config." ] call T8U_fnc_BroadcastHint; _return };
if ( isNil "_MasterArray" ) exitWith { __DEBUG( __FILE__, "NO SPAWNING", "_masterArray IS NIL!"); false };
if ( typeName _MasterArray == "BOOL" ) exitWith	{ __DEBUG( __FILE__, "NO SPAWNING", "EVERYBODY WAS ALREADY KILLED"); false };
if ( typeName _MasterArray != "ARRAY" OR { !( count _MasterArray > 0 ) } ) exitWith { [ "Something went seriously wrong! Aborting T8U_fnc_Spawn!" ] call T8U_fnc_BroadcastHint; false };


// -> ForEach _MasterArray
{
	private [ "_group", "_vehicleArray", "_posMkr", "_type", "_cachePos", "_markerArray", "_PatrolAroundDis", "_newStyleArray", "_spawnPos", "_startAngle", "_formation", "_behaviour" ];

	private _abort				= false; // for error findings
	private _PatrolMarkerArray	= false;
	private _PatrolMarkerDoSAD	= false;
	private _attackMarker		= "NO-POS-GIVEN";
	private _overwatchMarker	= "NO-POS-GIVEN";
	private _overwatchMinDist	= 50;
	private _overwatchRange		= 50;
	private _infGroup			= true;
	private _groupSide			= T8U_var_EnemySide;
	private _customFNC			= "NO-FUNC-GIVEN";
	private _relPos				= [];
	private _ovPresets			= false;
	private _ovSkillSets		= [];
	private _ovBehaviorSets		= [];
	private _teleport			= false;

	// get basic group setup
	private _groupArray			= _x param [ 0, [], [[]]];
	private _taskArray			= _x param [ 1, [], [[]]];
	private _cAM				= _x param [ 2, [], [[]]];
	private _sAM				= _x param [ 3, [], [[],"",true]];
	private _cachePos			= _x param [ 4, [], [[],""]];
	
	// get basic vehicle and marker setup
	private _vehicleArray		= _groupArray param [ 0, [], [[],configFile,""]];
	private _markerArray		= _groupArray param [ 1, false, ["",[]]];
	
	// parse marker setup
	switch ( typeName _markerArray ) do
	{
		case "ARRAY":	{ _posMkr = _markerArray call BIS_fnc_selectRandom; };
		case "STRING":	{ _posMkr = _markerArray; };
		default			{ _posMkr = "NO-POS-GIVEN"; };
	};

	_posMkrArray pushBack _posMkr;

	// parse additional group settings
	if ( count _groupArray > 2 ) then
	{
		switch ( typeName ( _groupArray select 2) ) do
		{
			case "BOOL":	{ _infGroup		= _groupArray param [ 2, true, [true]]; };
			case "SIDE":	{ _groupSide	= _groupArray param [ 2, T8U_var_EnemySide ]; };
			case "STRING":	{ _customFNC	= _groupArray param [ 2, "NO-FUNC-GIVEN", [""]]; };
			default { _type = "NO-TASK-GIVEN"; };
		};
	};

	if ( count _groupArray > 3 ) then
	{
		switch ( typeName ( _groupArray select 3) ) do
		{
			case "BOOL":	{ _infGroup		= _groupArray param [ 3, true, [true]]; };
			case "SIDE":	{ _groupSide	= _groupArray param [ 3, T8U_var_EnemySide ]; };
			case "STRING":	{ _customFNC	= _groupArray param [ 3, "NO-FUNC-GIVEN", [""]]; };
			default { _type = "NO-TASK-GIVEN"; };
		};
	};

	if ( count _groupArray > 4 ) then
	{
		switch ( typeName ( _groupArray select 4) ) do
		{
			case "BOOL":	{ _infGroup		= _groupArray param [ 4, true, [true]]; };
			case "SIDE":	{ _groupSide	= _groupArray param [ 4, T8U_var_EnemySide ]; };
			case "STRING":	{ _customFNC	= _groupArray param [ 4, "NO-FUNC-GIVEN", [""]]; };
			default { _type = "NO-TASK-GIVEN"; };
		};
	};
	
	// check if _vehicleArray should be loaded from T8U configFile / missionConfigFile
	if ( typeName _vehicleArray isEqualTo "STRING" ) then 
	{
		_vehicleArray = __CFGARRAY( _cfg >> "groupCompilations" >> T8U_var_modSet >> toLower ( str ( _groupSide )) >> _vehicleArray, [] );
	};


	// get task type setting
	private _type				= _taskArray param [ 0, "NO-TASK-GIVEN", [""]];

	// get communication setting
	private _cA0				= _cAM param [ 0, true, [true]];
	private _cA1				= _cAM param [ 1, true, [true]];
	private _cA2				= _cAM param [ 2, true, [true]];
	private _commArray			= [ _cA0, _cA1, _cA2 ];

	// get additional settings
	// parse from config
	
	if ( _sAM isEqualType true ) then { _teleport = _sAM; };
	if ( _sAM isEqualType [] ) then { _teleport = _sAM param [ 0, false, [false]]; };
	
	if ( _sAM isEqualType "" AND { isClass ( _cfg >> "groupSettings" >> _sAM )}) then
	{
		_ovPresets				= true;
		private _skill			= [];
		private _configSkill	= "true" configClasses ( _cfg >> "groupSettings" >> _sAM >> "behaviorAndSkills" >> "skills" );
		
		{
			_skill pushback [ configName _x, ( getNumber ( _x >> "value" ))];
			false
		} count _configSkill;
			
		_ovSkillSets	= [ _skill ];
		_ovBehaviorSets = [( getArray ( _cfg >> "groupSettings" >> _sAM >>  "behaviorAndSkills" >> "behaivior" ))];

		_teleport = switch ( getNumber ( _cfg >> "groupSettings" >> _sAM >> "teleport" )) do
		{
			case 1 :	{ false };
			case 2 :	{ true };
			default		{ false };
		};

	};
	

	// check for errors!
	if (
			(( _vehicleArray isEqualType [] ) AND { count _vehicleArray < 1 })
		OR	(( typeName _vehicleArray isEqualTo "CONFIG" ) AND { isNull _vehicleArray })
		OR	{ _posMkr isEqualTo "NO-POS-GIVEN" }
		OR	{ _type isEqualTo "NO-TASK-GIVEN" }
		OR	{ ( getMarkerPos _posMkr ) isEqualTo [0,0,0] }) exitWith
	{
		[( format [ "Something went seriously wrong! Error in Unit's spawning definition!<br /><br />Marker: %1<br />Task: %2", _posMkr, _type ])] call T8U_fnc_BroadcastHint;
		_error = true;
	};


	if (( typeName _vehicleArray ) isEqualTo "ARRAY" AND {!( count _vehicleArray > 0 )}) exitWith
	{
		[( format [ "Something went seriously wrong! Error in Unit's spawning definition!<br /><br />Marker: %1<br />Task: %2", _posMkr, _type ])] call T8U_fnc_BroadcastHint;
		_error = true;
	};


	// get our spawn pos
	if (( typeName _cachePos ) isEqualTo ( typeName "STR" )) then { _cachePos = getMarkerPos _cachePos; };
	if ( _cachePos isEqualTo [0,0,0]) then { _cachePos = _posMkr; };
	if ( count _cachePos > 1 ) then
	{
		_spawnPos = [ _cachePos ] call T8U_fnc_CreateSpawnPos;
	} else {
		_spawnPos = [ _posMkr ] call T8U_fnc_CreateSpawnPos;
	};


	// create some relative spawn positions for vehicle type stuff
	if (( typeName _vehicleArray ) isEqualTo "ARRAY" ) then
	{
		if !( _infGroup ) then
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
			_formation = _taskArray param [ 1, "RANDOM", [""]];
			_behaviour = _taskArray param [ 2, "SAFE", [""]];
			_group = [ _spawnPos, _groupSide, _vehicleArray, _relPos ] call BIS_fnc_spawnGroup;
			_group setVariable ["NEWLY_CREATED", true];
			[ _group, _markerArray, _infGroup, _teleport, _formation, _behaviour ] spawn T8U_tsk_fnc_patrol;
		};

		case "PATROL_AROUND":
		{
			_PatrolAroundDis	= _taskArray param [ 1, T8U_var_PatAroundRange, [123]];
			_startAngle			= _taskArray param [ 2, 0, [123]];
			_formation			= _taskArray param [ 3, "RANDOM", [""]];
			_behaviour			= _taskArray param [ 4, "SAFE", [""]];
			_group = [ _spawnPos, _groupSide, _vehicleArray, _relPos ] call BIS_fnc_spawnGroup;
			_group setVariable ["NEWLY_CREATED", true];
			[ _group, _markerArray, _infGroup, _teleport, _PatrolAroundDis, _startAngle, _formation, _behaviour ] spawn T8U_tsk_fnc_patrolAround;
		};

		case "PATROL_GARRISON":
		{
			// Force _infGroup = false !!!
			// _commArray = [ ( _commArray select 0 ), false ];
			_formation = _taskArray param [ 1, "RANDOM", [""]];
			_behaviour = _taskArray param [ 2, "SAFE", [""]];
			_group = [ _spawnPos, _groupSide, _vehicleArray, _relPos ] call BIS_fnc_spawnGroup;
			_group setVariable ["NEWLY_CREATED", true];
			[ _group, _posMkr, _infGroup, _teleport, _formation, _behaviour ] spawn T8U_tsk_fnc_patrolGarrison;
		};

		case "PATROL_MARKER":
		{
			_PatrolMarkerArray = _taskArray param [ 1, [], [[]]];
			_PatrolMarkerDoSAD = _taskArray param [ 2, true, [true]];
			_formation = _taskArray param [ 3, "RANDOM", [""]];
			_behaviour = _taskArray param [ 4, "SAFE", [""]];
			_group = [ _spawnPos, _groupSide, _vehicleArray, _relPos ] call BIS_fnc_spawnGroup;
			_group setVariable ["NEWLY_CREATED", true];
			[ _group, _PatrolMarkerArray, _infGroup, _teleport, _PatrolMarkerDoSAD, _formation, _behaviour ] spawn T8U_tsk_fnc_patrolMarker;
		};

		case "PATROL_URBAN":
		{
			_formation = _taskArray param [ 1, "RANDOM", [""]];
			_behaviour = _taskArray param [ 2, "SAFE", [""]];
			_group = [ _spawnPos, _groupSide, _vehicleArray, _relPos ] call BIS_fnc_spawnGroup;
			_group setVariable ["NEWLY_CREATED", true];
			[ _group, _markerArray, _infGroup, _teleport, _formation, _behaviour ] spawn T8U_tsk_fnc_patrolUrban;
		};


		default
		{
			private _msg = format [ "The task %1 does not exist! WTF?!<br /><br /> Call 0800 - T800A#WTFH for help. Not!", _type ]; [ _msg ] call T8U_fnc_BroadcastHint;

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

			// Setup Origin Array
			_originArray = [ _markerArray, _type, _infGroup, _taskArray, _customFNC ];

			
			// save needed variables to group
			__DEBUG( __FILE__, "UNITS", units _group );
			__SetOVAR( _group, "T8U_gvar_Comm", _commArray );
			__SetOVAR( _group, "T8U_gvar_Settings", _sAM );
			__SetOVAR( _group, "T8U_gvar_Origin", _originArray );
			__SetOVAR( _group, "T8U_gvar_Assigned", "NO_TASK" );
			__SetOVAR( _group, "T8U_gvar_Member", units _group );

			
			// Select skill and behaivior sets
			private _presetSkill	= 0;
			private _presetBehavior = 0;

			if ( _ovPresets ) then 
			{
				_presetSkill	= 0;
				_presetBehavior = 0;
			} else {
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
			};

			// Set the skill for the Group
			private _selectedSkillSet		= if ( count _ovSkillSets > 0 ) then { _ovSkillSets select _presetSkill } else { T8U_var_SkillSets select _presetSkill };
			private _selectedBehaviorSet	= if ( count _ovBehaviorSets > 0 ) then { _ovBehaviorSets select _presetBehavior } else { T8U_var_BehaviorSets select _presetBehavior };

			{
				private _tmpUnit = _x;

				{
					_tmpUnit setskill [ ( _x select 0 ), ( _x select 1 ) ];
					
					false
				} count _selectedSkillSet;

				// Add a HIT event to all Units
				_tmpUnit addEventHandler [ "Hit", { _this call T8U_fnc_HitEvent; } ];

				// enable / disable fatigue
				_tmpUnit enableFatigue T8U_var_enableFatigue;

				// add units to return array
				_return pushBack _tmpUnit;

				false
			} count units _group;

			// Set the combat mode for the Group ( green, blue, red, white, ...)
			_group setCombatMode ( _selectedBehaviorSet select 0 );


			if ( T8U_var_DEBUG_marker ) then { [ _group ] spawn T8U_fnc_Track; };


				// not going to happen anymore -> fn_handleGroups does this now
				// [ _group ] spawn T8U_fnc_OnFiredEvent;
				// leader _group addEventHandler [ "FiredNear", { [ _this ] call T8U_fnc_FiredEvent; } ];
				// leader _group addEventHandler [ "Killed", { [ _this ] spawn T8U_fnc_KilledEvent; } ];
				// if ( T8U_var_AllowCBM ) then { [ _group ] spawn T8U_fnc_CombatBehaviorMod; };


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

				__DEBUG( __FILE__, "_units", _units );
				__DEBUG( __FILE__, "_unitsOnFoot", _unitsOnFoot );

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

				__DEBUG( __FILE__, "_freeCargo", _freeCargo );

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
							( driver _x ) spawn { waitUntil { sleep 0.5; ( behaviour _this ) isEqualTo "COMBAT" }; [ _this ] spawn T8U_fnc_GetOutVehicle; };
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
			private _units		= units _group;
			private _vehicles	= [];

			{
				private _v = assignedVehicle _x;

				if ( !isNull _v AND { !(  _v in _vehicles ) } ) then { _vehicles pushBack _v; };

				false
			} count _units;

			{ _x addCuratorEditableObjects [ _units, true ]; } count allCurators;
			if ( count _vehicles > 0 ) then { { _x addCuratorEditableObjects [ _vehicles, true ]; } count allCurators; };
		};


		// EXEC a custom Function for units
		if ( _customFNC	!= "NO-FUNC-GIVEN" ) then {{ _x call ( __GetMVAR( _customFNC, "" )); false } count ( units _group );};
	};


	// no hurry ...
	sleep 1;

} forEach _MasterArray;

if ( _error ) exitWith { false };

if ( T8U_var_DEBUG_hints ) then { private _msg = format [ "Your Units at %1 are spawned", _posMkrArray ]; [ _msg ] call T8U_fnc_BroadcastHint; };



// return created units
_return
