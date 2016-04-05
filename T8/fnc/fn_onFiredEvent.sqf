/*
 =======================================================================================================================

	T8 Units Script

	Funktion:	fn_onFiredEvent.sqf
	Author:		T-800a
	E-Mail:		t-800a@gmx.net

 =======================================================================================================================
*/

#include <..\MACRO.hpp>

private [ "_group", "_unit", "_groupSide", "_doLoop", "_enemyEntities", "_friendEntities", "_isGurEnemy", "_revealTo" ];

_group = _this select 0;
_unit = leader _group;
_groupSide = side _group;

_enemyEntities = [];
_friendEntities = [];
_isGurEnemy = false;
_revealTo = [];

if ( T8U_var_DEBUG ) then { [ "fn_onFiredEvent.sqf", "INIT", _this ] spawn T8U_fnc_DebugLog; };

switch ( _groupSide ) do
{
	case EAST:
	{
		_enemyEntities = [ "SoldierWB", "LandVehicle" ];
		_friendEntities = [ "SoldierEB", "Motorcycle", "Car", "Tank" ];
		_revealTo = [ "SoldierEB" ];
		if ( T8U_var_GuerDiplo == 2 ) then { _revealTo pushBack "SoldierGB"; };
		if ( T8U_var_GuerDiplo == 1 OR T8U_var_GuerDiplo == 3 ) then { _enemyEntities pushBack "SoldierGB"; _isGurEnemy = true; };
	};

	case WEST:
	{
		_enemyEntities = [ "SoldierEB", "LandVehicle" ];
		_friendEntities = [ "SoldierWB", "Motorcycle", "Car", "Tank" ];
		_revealTo = [ "SoldierWB" ];
		if ( T8U_var_GuerDiplo == 1 ) then { _revealTo pushBack "SoldierGB"; };
		if ( T8U_var_GuerDiplo == 2 OR T8U_var_GuerDiplo == 3 ) then { _enemyEntities pushBack "SoldierGB"; _isGurEnemy = true; };
	};

	case RESISTANCE:
	{
		_revealTo = [ "SoldierGB" ];
		_friendEntities = [ "SoldierGB", "Motorcycle", "Car", "Tank" ];
		if ( T8U_var_GuerDiplo == 1 ) then { _enemyEntities = [ "SoldierEB", "LandVehicle" ]; _revealTo pushBack "SoldierWB"; };
		if ( T8U_var_GuerDiplo == 2 ) then { _enemyEntities = [ "SoldierWB", "LandVehicle" ]; _revealTo pushBack "SoldierEB"; };
		if ( T8U_var_GuerDiplo == 3 ) then { _enemyEntities = [ "SoldierEB", "SoldierWB", "LandVehicle" ]; };
	};
};

// ---------- MAIN LOOP -------------------------------------------------------------------------------------

// return here if _unit ( the leader of the group) is killed OR the Group has changed THEN exit everything. 
scopeName "INITDONE";

if ( !alive _unit OR { isNull _unit } OR { count ( units _group ) < 1 } OR { isNull _group } OR { leader _group != _unit } ) then 
{
	_doLoop = false;
	[ _unit ] call T8U_fnc_PauseFiredEvent;
	if ( T8U_var_DEBUG ) then { [ "fn_onFiredEvent.sqf", "EXIT FUNCTION", [ _unit ] ] spawn T8U_fnc_DebugLog; };
} else {
	_doLoop = true;
};

while { _doLoop } do
{
	private [	"_eventArray", "_shooter", "_originGroup", "_nearEntitiesArray", "_knownEnemies", "_rmEnVeh", "_commArray", "_shareInfo", "_execTask", "_reactTask", "_called", "_onMission", 
				"_countGroup", "_countEnemy", "_units" ];

	if ( T8U_var_DEBUG ) then { [ "fn_onFiredEvent.sqf", "WAIT for FiredNear", [ _unit ] ] spawn T8U_fnc_DebugLog; };

// waituntil a shot is fired near our group leader or exit the whole thing if our group leader is dead
	waitUntil
	{
		sleep 1; 
		if ( !alive _unit OR { isNull _unit } OR { count ( units _group ) < 1 } OR { isNull _group } OR { leader _group != _unit } ) then { if ( T8U_var_DEBUG ) then { [ "fn_onFiredEvent.sqf", "EXIT LOOP - UNIT / GROUP DEAD", [ _unit ] ] spawn T8U_fnc_DebugLog; }; breakTo "INITDONE"; };
		count ( _group getVariable [ "T8U_gvar_FiredEvent", [] ] ) > 0 
	};

	if ( T8U_var_DEBUG ) then { [ "fn_onFiredEvent.sqf", "EXEC LOOP", [ _unit ] ] spawn T8U_fnc_DebugLog; };

/*	_eventArray ---- check for silencers and stuff

    unit:		Object - Object the event handler is assigned to
    firer:		Object - Object which fires a weapon near the unit
    distance:	Number - Distance in meters between the unit and firer (max. distance ~69m)
    weapon:		String - Fired weapon
    muzzle: 	String - Muzzle that was used
    (mode:)		String - Current mode of the fired weapon
    (ammo:)		String - Ammo used 
*/
	_eventArray		= _group getVariable [ "T8U_gvar_FiredEvent", [] ];
	_shooter		= _eventArray select 1;
	
	_commArray		= _group getVariable [ "T8U_gvar_Comm", [ false, false, true ] ];
	_shareInfo		= [ _commArray, 0, false, [false] ] call BIS_fnc_param;
	_execTask		= [ _commArray, 1, false, [false] ] call BIS_fnc_param;
	_reactTask		= [ _commArray, 2, true, [true] ] call BIS_fnc_param;

	if ( !alive _unit OR { isNull _unit } OR { count ( units _group ) < 1 } OR { isNull _group } OR { leader _group != _unit } ) then 
	{
		if ( T8U_var_DEBUG ) then { [ "fn_onFiredEvent.sqf", "EXIT LOOP - UNIT / GROUP DEAD", [ _unit ] ] spawn T8U_fnc_DebugLog; };
		breakTo "INITDONE";
	};

	_knownEnemies = [];
	_rmEnVeh = [];

	// "CAManBase", "LandVehicle"
	// hint str ( player nearEntities [ "CAManBase", "LandVehicle", 50 ] );
	
	// _nearEntitiesArray = _unit nearEntities [ _enemyEntities, 1000 ];
	
	_nearEntitiesArray = [ _unit ] call T8U_fnc_FilterEntities;
	
	/*
	{
		if (  _x isKindOf "LandVehicle" ) then
		{
			if ( ( side _x == _groupSide ) OR ( ! _isGurEnemy AND ( side _x == RESISTANCE ) ) OR ( side _x == CIVILIAN ) ) then
			{
				_rmEnVeh pushBack _x;
			};
		};
	} count _nearEntitiesArray;

	_unitsInGroup =  units _group;
	_nearEntitiesArray = _nearEntitiesArray  - _rmEnVeh;
	*/
	
	{
		if ( ( _unit knowsAbout _x ) > 1 AND { side _x != _groupSide } AND { alive _x } ) then
		{
//			if ( _isGurEnemy AND { side _x == RESISTANCE } ) then { _knownEnemies pushBack _x; };
//			if ( side _x != RESISTANCE ) then { _knownEnemies pushBack _x; };
			
			 _knownEnemies pushBack _x;
		};
		
		false
	} count _nearEntitiesArray;

	_units = units _group;
	_countGroup	= count ( units _group );
	_countEnemy = count _knownEnemies;
	
	if ( _countEnemy < 1 ) then { _countEnemy = -1; };



///// 1. Share Enemy Informations via Reveal /////

	if ( count _knownEnemies > 0 ) then 
	{
		private [ "_vRevealEntitiesArray" ];
		_vRevealEntitiesArray = [ _unit, T8U_var_RevealRange, true ] call T8U_fnc_FilterEntities;
		// _vRevealEntitiesArray = _unit nearEntities [ _revealTo, T8U_var_RevealRange ];

		// -> count _knownEnemies
		{
			private [ "_enemy" ];
			_enemy = _x;
			// -> count _vRevealEntitiesArray
			{
				_x reveal _enemy;
			} count _vRevealEntitiesArray;
		} forEach _knownEnemies;
	};
	
	if ( T8U_var_DEBUG ) then { [ "fn_onFiredEvent.sqf", "_shareInfo", [ _shareInfo ] ] spawn T8U_fnc_DebugLog; };
	if ( T8U_var_DEBUG ) then { [ "fn_onFiredEvent.sqf", "_knownEnemies", [ _knownEnemies ] ] spawn T8U_fnc_DebugLog; }; 
	if ( T8U_var_DEBUG ) then { [ "fn_onFiredEvent.sqf", "_countGroup / _countEnemy", [ (_countGroup / _countEnemy) ] ] spawn T8U_fnc_DebugLog; }; 



///// 2. Look for possible Support or Groups to Held if conditions are met /////

	if ( _shareInfo AND { ( _group getVariable [ "T8U_gvar_called", -99999 ] ) < ( time - T8U_var_CallForHelpTimeout ) } ) then
	{
		if ( ( _countGroup / _countEnemy ) > 0 AND { ( _countGroup / _countEnemy ) < T8U_var_OvSuperiority } ) then
		{
			if ( T8U_var_CommanderEnable ) then
			{

	// Share Info with Commander ... maybe in 2016 or so :x
	//
	// NYI
	//

			} else {

				private [ "_unitRank", "_supportUnits" ];

				_unitRank = getNumber ( configfile >> "CfgVehicles" >> typeOf _unit >> "cost" );
				_supportUnits = [ _unit ] call T8U_fnc_GetSupport;

	// call HALO or PARA or ELSE for Help

				if ( _unitRank > 460000 AND { count _supportUnits > 0 } AND { ( _group getVariable [ "T8U_gvar_PARAcalled", -99999 ] ) < ( time - T8U_var_SupportTimeout ) } ) then 
				{
					private [ "_target" ];
					_target = _knownEnemies call BIS_fnc_selectRandom;

					[ _unit, _target, _supportUnits, side _unit ] spawn T8U_sup_fnc_HALO;
					
					_group setVariable [ "T8U_gvar_PARAcalled", time, false ];
					
					if ( T8U_var_DEBUG ) then { [ "fn_onFiredEvent.sqf", "EXEC SUPPORT-CALL", [ _unit ] ] spawn T8U_fnc_DebugLog; };
				};

	// [ _manonfire, _grouponfire, _firepos ] spawn DAC_fCallHelp;
	// DAC Timeout via var saved to group ...
				
				if ( T8U_var_AllowDAC AND { !isNil "DAC_fCallHelp" } AND { ( _group getVariable [ "T8U_gvar_DACcalled", -99999 ] ) < ( time - T8U_var_DACtimeout ) } ) then 
				{
					private [ "_target" ];
					_target = _knownEnemies call BIS_fnc_selectRandom;
					
					[ leader _group , _group, getPos _target ] spawn DAC_fCallHelp;
					
					_group setVariable [ "T8U_gvar_DACcalled", time, false ];
					
					if ( T8U_var_DEBUG ) then { [ "fn_onFiredEvent.sqf", "[] spawn DAC_fCallHelp;", [ _unit, _target ] ] spawn T8U_fnc_DebugLog; };
				};

	// call exisiting Group for Help
	// Search for near Friendly Units who can communicate

				if ( T8U_var_DEBUG ) then { [ "fn_onFiredEvent.sqf", "EXEC DIRECT-CALL", [ _unit ] ] spawn T8U_fnc_DebugLog; };
				
				private [ "_nearEntitiesArray", "_unitsInGroup", "_rmVeh", "_groups" ];
				_rmVeh = [];
				_groups = [];
				
				// _nearEntitiesArray = _unit nearEntities [ _friendEntities, T8U_var_DirectCallRange ];
				_nearEntitiesArray = [ _unit, T8U_var_DirectCallRange, true ] call T8U_fnc_FilterEntities;
				// { if (  _x isKindOf "LandVehicle" AND { side _x != _groupSide } ) then { _rmVeh pushBack _x; }; } forEach _nearEntitiesArray;
				_unitsInGroup =  units _group;
				// _nearEntitiesArray = _nearEntitiesArray - _unitsInGroup - _rmVeh;
				_nearEntitiesArray = _nearEntitiesArray - _unitsInGroup;

				{ if !( group _x in _groups ) then { _groups pushBack ( group _x ); }; false } count _nearEntitiesArray;					
				
				if ( T8U_var_DEBUG ) then { [ "fn_onFiredEvent.sqf", "D-CALL GROUPS AVAILABLE", [ _unit, _groups ] ] spawn T8U_fnc_DebugLog; };
				
				if ( count _groups > 0 ) then
				{
					// forEach -> _groups
					{
						private [ "_commArray", "_canDoTask", "_asignedTask" ];
						
						scopeName "SEARCHHELP";

						if ( !isNull _x ) then
						{
							_commArray = _x getVariable [ "T8U_gvar_Comm", [] ];
							_asignedTask = _x getVariable [ "T8U_gvar_Assigned", "STRANGE_UNIT" ];
						} else {
							_commArray = [];
							_asignedTask = "STRANGE_UNIT";
						};

						if ( T8U_var_DEBUG ) then { [ "fn_onFiredEvent.sqf", "D-CALL CHECKING", [ _unit, _x ] ] spawn T8U_fnc_DebugLog; };

						if ( count _commArray > 1 ) then
						{
							_canDoTask = _commArray select 1;

							if ( _canDoTask AND { _asignedTask == "NO_TASK" } ) then
							{
								if ( T8U_var_DEBUG ) then { [ "fn_onFiredEvent.sqf", "D-CALL ASSIGNED TO", [ _unit, _x ] ] spawn T8U_fnc_DebugLog; };

								// set time when help was called
								_group setVariable [ "T8U_gvar_called", time, false ];

								// create SAD waypoint
								private [ "_target" ];
								_target = _knownEnemies call BIS_fnc_selectRandom;
								[ _unit, leader _x, _target ] call T8U_fnc_AssignTask;

								// We have found someone, let's get out of here
								breakOut "SEARCHHELP";

							} else {
								if ( T8U_var_DEBUG ) then { [ "fn_onFiredEvent.sqf", "D-CALL FAILED: GROUP HAS TASK", [ _unit, _x ] ] spawn T8U_fnc_DebugLog; };
							};

						} else {
							if ( T8U_var_DEBUG ) then { [ "fn_onFiredEvent.sqf", "D-CALL FAILED: UNIT COULD NOT RESPOND", [ _unit, _x ] ] spawn T8U_fnc_DebugLog; };
						};
					} forEach _groups;
				};
			};
		};
	} else {
		if ( T8U_var_DEBUG ) then { [ "fn_onFiredEvent.sqf", "SKIP DCALL - HELP WAS ALREADY CALLED", [ _unit ] ] spawn T8U_fnc_DebugLog; };
	};

	

///// 3. Check how the attacked group should react to the enemies  /////

	if ( T8U_var_DEBUG ) then { [ "fn_onFiredEvent.sqf", "GROUP REACTIONS", [ _unit ] ] spawn T8U_fnc_DebugLog; };
	
	if ( T8U_var_CommanderEnable ) then
	{

	// Do Something if Commander is enabled ... maybe in 2016 or so :x
	//
	// NYI
	//

	} else {
		private [ "_curTask" ];
		
		_curTask = _group getVariable [ "T8U_gvar_Assigned", "NO_TASK" ];
		
		if ( _reactTask ) then
		{
			if ( side _shooter != _groupSide AND { count _knownEnemies < 1 } AND { _curTask in [ "NO_TASK" ] } ) then
			{
				if ( alive _unit ) then 
				{
					[ _unit, _unit, _shooter, "CQC_SHOT" ] call T8U_fnc_AssignTask;
					
					if ( T8U_var_DEBUG ) then { [ "fn_onFiredEvent.sqf", "CQC_SHOT", [ _unit ] ] spawn T8U_fnc_DebugLog; };
				} else {
					if ( T8U_var_DEBUG ) then { [ "fn_onFiredEvent.sqf", "CQC_SHOT >> UNIT DEAD", [ _unit ] ] spawn T8U_fnc_DebugLog; };
				};
			};

			if ( count _knownEnemies > 0 AND { ( _countGroup / _countEnemy ) > T8U_var_OvSuperiority } AND { _curTask in [ "NO_TASK" ] } ) then
			{
				private [ "_target" ];
				_target = _knownEnemies call BIS_fnc_selectRandom;
				if ( !isNil "_target" AND { alive _unit } ) then 
				{
					[ _unit, _unit, _target, "FLANK_ATTACK" ] call T8U_fnc_AssignTask;
					
					if ( T8U_var_DEBUG ) then { [ "fn_onFiredEvent.sqf", "FLANK_ATTACK", [ _unit ] ] spawn T8U_fnc_DebugLog; };
				} else {
					if ( T8U_var_DEBUG ) then { [ "fn_onFiredEvent.sqf", "FLANK_ATTACK >> UNIT OR TARGET DEAD", [ _unit ] ] spawn T8U_fnc_DebugLog; };
				};
			};
			
			//  AND { _curTask in [ "NO_TASK", "FLANK_ATTACK", "CQC_SHOT" ] }
			if ( count _knownEnemies > 0 AND { ( _countGroup / _countEnemy ) < T8U_var_OvSuperiority } AND { !( _curTask in [ "HOLD_POS" ] )}) then
			{
				private [ "_target" ];
				_target = _knownEnemies call BIS_fnc_selectRandom;
				if ( !isNil "_target" AND { alive _unit } ) then 
				{
					[ _unit, _unit, _target, "HOLD_POS", 300 ] call T8U_fnc_AssignTask;
					if ( T8U_var_DEBUG ) then { [ "fn_onFiredEvent.sqf", "HOLD_POS", [ _unit ] ] spawn T8U_fnc_DebugLog; };

				} else {
					if ( T8U_var_DEBUG ) then { [ "fn_onFiredEvent.sqf", "HOLD_POS >> UNIT OR TARGET DEAD", [ _unit ] ] spawn T8U_fnc_DebugLog; };
				};
			};
		};
	};



///// 4. take some 'minimum perforemance timeout' - Reset T8U_gvar_FiredEvent - check if group still exists otherwise cancel loop /////

	sleep 5;
	// Reset Fired Event Var
	_group setVariable [ "T8U_gvar_FiredEvent", [], false ];
	
	if ( !alive _unit OR { isNull _unit } OR { count ( units _group ) < 1 } OR { isNull _group } OR { leader _group != _unit } ) then 
	{
		if ( T8U_var_DEBUG ) then { [ "fn_onFiredEvent.sqf", "EXIT LOOP - UNIT / GROUP DEAD", [ _unit ] ] spawn T8U_fnc_DebugLog; };
		breakTo "INITDONE";
	};
	
	if ( T8U_var_DEBUG ) then { [ "fn_onFiredEvent.sqf", "END OF LOOP --> REDO", [ _unit ] ] spawn T8U_fnc_DebugLog; };
};