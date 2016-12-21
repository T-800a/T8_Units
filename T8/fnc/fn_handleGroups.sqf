/*
 =======================================================================================================================

	T8 Units Script
	
	Funktion:	fn_handleGroups.sqf
	Author:		T-800a
	E-Mail:		t-800a@gmx.net

 =======================================================================================================================
*/

// include the few macros we use
#include <..\MACRO.hpp>

// cancel execute if not server / hc
__allowEXEC(__FILE__);

waitUntil { time > 5 };

__DEBUG( __FILE__, "+----------------------------------------------------------", "" );
__DEBUG( __FILE__, "| T8 Units", "GROUP HANDLE STARTED" );
__DEBUG( __FILE__, "+----------------------------------------------------------", "" );

while { time > 0 } do
{
	// start a forEach for allGroups
	{
	
		private _group		= _x;
		private _countGroup	= count ( units _group );
		
		// delete empty non DAC groups
		if ( _countGroup <= 0 AND {( _x getVariable [ "DAC_Excluded", "RM" ] ) == "RM" }) then { __DEBUGY( __FILE__, "GROUP", "SKIP: DELETED", _group ); deleteGroup _x; };
		
		if !( __GetOVAR( _group, "T8U_gvar_ignoreGroup", false )) then
		{
			private _skip			= false;
			private _skipCBM		= true;
			private _unit			= leader _group;
			private _units			= units _group;
			private _groupSide		= side _group;
			private _knownEnemies	= [];
			private _nearFriendlies	= [];
			private _task			= __GetOVAR( _group, "T8U_gvar_Assigned", "ERROR" );

			if ( isNull _group )					then { _skip = true; __DEBUGY( __FILE__, "GROUP", "SKIP: isNull", _group ); };
			if ( side _group isEqualTo CIVILIAN )	then { _skip = true; if !( __GetOVAR( _group, "T8U_gvar_introduce", false )) then { __SetOVAR( _group, "T8U_gvar_ignoreGroup", true ); }; __DEBUGY( __FILE__, "GROUP", "SKIP: CIVILIAN", _group ); };
			if ( _task isEqualTo "ERROR" )			then { _skip = true; if !( __GetOVAR( _group, "T8U_gvar_introduce", false )) then { __SetOVAR( _group, "T8U_gvar_ignoreGroup", true ); }; __DEBUGY( __FILE__, "GROUP", "SKIP: NO T8U GROUP", _group ); };



			if ( !_skip ) then
			{
				// check if group leader has the FiredNear event handler, if not add it.
				if ( __GetOVAR( _unit, "T8U_gvar_addEvenHandler", true )) then
				{
					__SetOVAR( _unit, "T8U_gvar_addEvenHandler", false );
					__SetOVAR( _group, "T8_UnitsVarLeaderGroup", _unit );
					if ( alive _unit ) then
					{
						__DEBUGY( __FILE__, "GROUP", "FIRED NEAR EVENT ADDED", _group );
						_unit addEventHandler [ "FiredNear", {[ _this ] call T8U_fnc_FiredEvent; }];
					};
				};

				// near enemies known to group (leader)
				private _nearEnemies	= [ _unit ] call T8U_fnc_FilterEntities;
				
				// get near friendlies
				_nearFriendlies	= [ _unit, 500, true ] call T8U_fnc_FilterEntities;

				{
					if ( ( _unit knowsAbout _x ) > 1 AND { side _x != _groupSide } AND { alive _x } ) then
					{
						 _knownEnemies pushBack _x;
					};

					false
				} count _nearEnemies;
				
				// check if CBM is allowed
				if ( T8U_var_AllowCBM ) then { _skipCBM = false; };
			};

			private _countFriendlies = count _nearFriendlies;
			private _countEnemies = count _knownEnemies;

			// skip if not enough known enemies or group members
			if ( _countGroup < 1 )	then { _skip = true; __DEBUGY( __FILE__, "GROUP", "SKIP: GROUP EMPTY", _group ); };
			if ( _countEnemies < 1 )	then { _skip = true; __DEBUGY( __FILE__, "GROUP", "SKIP: NO ENEMIES", _group ); };

			// do all the communication and handling
			if ( !_skip ) then
			{
				__DEBUGY( __FILE__, "GROUP", "VALID for HANDLING", _group );

				// just force the unit POS to AUTO ... maybe removes a bug
				{ _x setUnitPos "AUTO"; _x setUnitPosWeak "AUTO"; false } count _units;

				private _eventArray		= __GetOVAR( _group, "T8U_gvar_FiredEvent", []);
				private _shooter		= _eventArray param [ 1, objNull, [ objNull ]];
				private _time			= _eventArray param [ 5, 0, [ 123 ]];
				
				private _commArray		= __GetOVAR( _group, "T8U_gvar_Comm", []);
				private _shareInfo		= _commArray param [ 0, false, [ false ]];
				private _execTask		= _commArray param [ 1, false, [ false ]];
				private _reactTask		= _commArray param [ 2, false, [ false ]];
				
				if ( isNull _unit )				then { _skip = true; __DEBUGY( __FILE__, "GROUP", "SKIP: leader Null", _group ); };
				if ( !alive _unit )				then { _skip = true; __DEBUGY( __FILE__, "GROUP", "SKIP: leader DEAD", _group ); };
				if ( time > ( _time + 90 ))		then { _skip = true; __DEBUGY( __FILE__, "GROUP", "SKIP: leader TIMEOUT (no shots near leader last 90s)", _group ); };
				
				if ( !_skip ) then
				{

	///// 1. Share Enemy Informations via Reveal /////

					if ( count _knownEnemies > 0 ) then 
					{
						private _vRevealEntitiesArray = [ _unit, T8U_var_RevealRange, true ] call T8U_fnc_FilterEntities;

						{
							private _enemy = _x;
							{
								_x reveal _enemy;
								false
							} count _vRevealEntitiesArray;
							false
						} count _knownEnemies;
					};


					__DEBUGY( __FILE__, "_SHARE INFO", _shareInfo, _group );
					__DEBUGY( __FILE__, "____ENEMIES", _countEnemies, _group );
					__DEBUGY( __FILE__, "_FRIENDLIES", _countFriendlies, _group );
					__DEBUGY( __FILE__, "SUPERIORITY", _countFriendlies/_countEnemies, _group );
					


	///// 2. Look for possible Support or Groups to Held if conditions are met /////

					if ( _shareInfo AND { __GetOVAR( _group, "T8U_gvar_called", -99999 ) < ( time - T8U_var_CallForHelpTimeout )}) then
					{
						if ( ( _countFriendlies / _countEnemies ) > 0 AND { ( _countFriendlies / _countEnemies ) < T8U_var_OvSuperiority } ) then
						{
							if ( T8U_var_CommanderEnable ) then
							{

					// Share Info with Commander ... maybe in 2020 or so :x
					//
					// NYI
					//

							} else {

								private [ "_unitRank", "_supportUnits" ];

								_unitRank = getNumber ( configfile >> "CfgVehicles" >> typeOf _unit >> "cost" );
								_supportUnits = [ _unit ] call T8U_fnc_GetSupport;

					// call HALO or PARA or ELSE for Help

								if ( _unitRank > 460000 AND { count _supportUnits > 0 } AND { __GetOVAR( _group, "T8U_gvar_PARAcalled", -99999 ) < ( time - T8U_var_SupportTimeout ) } ) then 
								{
									private [ "_target" ];
									_target = _knownEnemies call BIS_fnc_selectRandom;

									[ _unit, _target, _supportUnits, side _unit ] spawn T8U_sup_fnc_HALO;
									
									__SetOVAR( _group, "T8U_gvar_PARAcalled", time );
									
									__DEBUGY( __FILE__, "EXEC SUPPORT-CALL", _unit, _group );
								};

					// [ _manonfire, _grouponfire, _firepos ] spawn DAC_fCallHelp;
					// DAC Timeout via var saved to group ...
								
								if ( T8U_var_AllowDAC AND { !isNil "DAC_fCallHelp" } AND { __GetOVAR( _group, "T8U_gvar_DACcalled", -99999 ) < ( time - T8U_var_DACtimeout ) } ) then 
								{
									private _target = _knownEnemies call BIS_fnc_selectRandom;
									
									[ leader _group , _group, getPos _target ] spawn DAC_fCallHelp;
									
									__SetOVAR( _group, "T8U_gvar_DACcalled", time );
									
									__DEBUGY( __FILE__, "[] spawn DAC_fCallHelp;", [_unit,_target], _group );
								};

					// call exisiting Group for Help
					// Search for near Friendly Units who can communicate

								__DEBUGY( __FILE__, "EXEC DIRECT-CALL", _unit, _group );
								
								private _rmVeh				= [];
								private _groups				= [];
								private _unitsInGroup		=  units _group;
								private _nearEnemies	= [ _unit, T8U_var_DirectCallRange, true ] call T8U_fnc_FilterEntities;

								_nearEnemies = _nearEnemies - _unitsInGroup;

								{ if !( group _x in _groups ) then { _groups pushBack ( group _x ); }; false } count _nearEnemies;					
								
								__DEBUGY( __FILE__, "D-CALL GROUPS AVAILABLE", [_unit,_groups], _group );
								
								if ( count _groups > 0 ) then
								{
									// forEach -> _groups
									{
										private [ "_commArray", "_asignedTask" ];
										
										scopeName "SEARCHHELP";

										if ( !isNull _x ) then
										{
											_commArray		= __GetOVAR( _x, "T8U_gvar_Comm", []);
											_asignedTask	= __GetOVAR( _x, "T8U_gvar_Assigned", "STRANGE_UNIT" );
										} else {
											_commArray = [];
											_asignedTask = "STRANGE_UNIT";
										};

										__DEBUGY( __FILE__, "D-CALL CHECKING", [_unit,_x], _group );

										if ( count _commArray > 1 ) then
										{
											private _canDoTask = _commArray select 1;

											if ( _canDoTask AND { _asignedTask == "NO_TASK" } ) then
											{
												__DEBUGY( __FILE__, "D-CALL ASSIGNED TO", [_unit,_x], _group );

												// set time when help was called
												__SetOVAR( _group, "T8U_gvar_called", time );

												// create SAD waypoint
												private _target = _knownEnemies call BIS_fnc_selectRandom;
												[ _unit, leader _x, _target ] call T8U_fnc_AssignTask;

												// We have found someone, let's get out of here
												breakOut "SEARCHHELP";

											} else {
												__DEBUGY( __FILE__, "D-CALL FAILED: GROUP HAS TASK", [_unit,_x], _group );
											};

										} else {
											__DEBUGY( __FILE__, "D-CALL FAILED: UNIT COULD NOT RESPOND", [_unit,_x], _group );
										};
									} forEach _groups;
								};
							};
						};
					} else {
						__DEBUGY( __FILE__, "SKIP DCALL - HELP WAS ALREADY CALLED", _unit, _group );
					};

					

	///// 3. Check how the attacked group should react to the enemies  /////

					__DEBUGY( __FILE__, "GROUP REACTIONS", _unit, _group );
					
					if ( T8U_var_CommanderEnable ) then
					{

					// Do Something if Commander is enabled ... maybe in 2020 or so :x
					//
					// NYI
					//

					} else {
					
						private _curTask	= __GetOVAR( _group, "T8U_gvar_Assigned", "NO_TASK" );
						private _target		= _knownEnemies call BIS_fnc_selectRandom;
						
						if ( _reactTask ) then
						{
							if ( side _shooter != _groupSide AND { count _knownEnemies < 1 } AND { _curTask in [ "NO_TASK" ] } ) then
							{
								if ( alive _unit ) then 
								{
									[ _unit, _unit, _shooter, "CQC_SHOT" ] call T8U_fnc_AssignTask;
									
									__DEBUGY( __FILE__, "CQC_SHOT", _unit, _group );
								} else {
									__DEBUGY( __FILE__, "CQC_SHOT >> UNIT DEAD", _unit, _group );
								};
							};

							if ( count _knownEnemies > 0 AND { ( _countFriendlies / _countEnemies ) > T8U_var_OvSuperiority } AND { _curTask in [ "NO_TASK" ] } ) then
							{
								if ( !isNil "_target" AND { alive _unit } ) then 
								{
									[ _unit, _unit, _target, "FLANK_ATTACK" ] call T8U_fnc_AssignTask;
									
									__DEBUGY( __FILE__, "FLANK_ATTACK", _unit, _group );
								} else {
									__DEBUGY( __FILE__, "FLANK_ATTACK >> UNIT OR TARGET DEAD", _unit, _group );
								};
							};
							
							//  AND { _curTask in [ "NO_TASK", "FLANK_ATTACK", "CQC_SHOT" ] }
							if ( count _knownEnemies > 0 AND { ( _countFriendlies / _countEnemies ) < T8U_var_OvSuperiority } AND { !( _curTask in [ "HOLD_POS" ] )}) then
							{
								if ( !isNil "_target" AND { alive _unit } ) then 
								{
									[ _unit, _unit, _target, "HOLD_POS", 300 ] call T8U_fnc_AssignTask;
									__DEBUGY( __FILE__, "HOLD_POS", _unit, _group );

								} else {
									__DEBUGY( __FILE__, "HOLD_POS >> UNIT OR TARGET DEAD", _unit, _group );
								};
							};
						};
					};					

					
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				};
			};



			// apply CMB changes
			if ( !_skipCBM ) then {[ _group ] call T8U_fnc_CombatBehaviorMod; };


		} else {
			__DEBUGY( __FILE__, "GROUP", "IGNORED", _group );
		};
		
	} forEach allGroups;
	
	sleep 5;
};


__DEBUG( __FILE__, "+----------------------------------------------------------", "" );
__DEBUG( __FILE__, "| T8 Units", "GROUP HANDLE ENDED" );
__DEBUG( __FILE__, "+----------------------------------------------------------", "" );
