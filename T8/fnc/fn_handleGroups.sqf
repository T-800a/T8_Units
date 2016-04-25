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

waitUntil { time > 1 };

__DEBUG( __FILE__, "INIT", "" );

while { time > 0 } do
{
	{
	// count allGroups
		private _group = _x;
		
		if !( __GetOVAR( _group, "T8U_gvar_ignoreGroup", false )) then
		{
			private _skip		= false;
			
			private _unit		= leader _group;
			private _units		= units _group;
			private _groupSide	= side _group;
			private _task		= __GetOVAR( _group, "T8U_gvar_Assigned", "ERROR" );
			
			if ( isNull _group )					then { _skip = true; };
			if ( side _group isEqualTo CIVILIAN )	then { _skip = true; __SetOVAR( _group, "T8U_gvar_ignoreGroup", true ); };
			if ( _task isEqualTo "ERROR" )			then { _skip = true; __SetOVAR( _group, "T8U_gvar_ignoreGroup", true ); };
			
			// get enemies known to group (leader)
			private _knownEnemies = [];
			
			if ( !_skip ) then
			{
				private _nearEntitiesArray	= [ _unit ] call T8U_fnc_FilterEntities;
						
				{
					if ( ( _unit knowsAbout _x ) > 1 AND { side _x != _groupSide } AND { alive _x } ) then
					{
						 _knownEnemies pushBack _x;
					};

					false
				} count _nearEntitiesArray;
			};

			private _countGroup	= count ( units _group );
			private _countEnemy = count _knownEnemies;
			__DEBUG( __FILE__, "GROUP: _countEnemy", _countEnemy );
			
			// skip if not enough known enemies or group members
			if ( _countGroup < 1 )	then { _skip = true; };
			if ( _countEnemy < 1 )	then { _skip = true; };
			
			// do all the communication and handling
			if ( !_skip ) then
			{
				__DEBUG( __FILE__, "GROUP VALID for HANDLING", _group );
				
				private _eventArray		= _group getVariable [ "T8U_gvar_FiredEvent", []];
				private _shooter		= _eventArray param [ 1, objNull, [ objNull ]];
				private _time			= _eventArray param [ 5, -1, [ 123 ]];
				
				private _commArray		= _group getVariable [ "T8U_gvar_Comm", [ false, false, true ]];
				private _shareInfo		= _commArray param [ 0, false, [ false ]];
				private _execTask		= _commArray param [ 1, false, [ false ]];
				private _reactTask		= _commArray param [ 2, true, [ true ]];
				
				if ( isNull _unit )				then { _skip = true; };
				if ( !alive _unit )				then { _skip = true; };
				if ( time > ( _time + 60 ))		then { _skip = true; };
				
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
					
					__DEBUG( __FILE__, "_shareInfo", _shareInfo );
					__DEBUG( __FILE__, "_knownEnemies", _knownEnemies );
					__DEBUG( __FILE__, "_countGroup / _countEnemy", (_countGroup / _countEnemy) );
					
					
					
		/////////////////////////////////////////////////////////			
				};
				
			} else {
				__DEBUG( __FILE__, "GROUP SKIPPED", _group );
			};
		} else {
			__DEBUG( __FILE__, "GROUP IGNORED", _group );
		};
		
	} count allGroups;
	
	sleep 5;
};