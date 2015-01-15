/*
 =======================================================================================================================

	___ T8 Units _______________________________________________________________________________________________________

	File:		T8_Units.sqf
	Author:		T-800a
	E-Mail:		t-800a@gmx.net
	
	Functions Libary / Collector / Whatever

 =======================================================================================================================
*/


///// T8 Units FUNCTIONS /////////////////////////////////////////////////////////////////////////////////////////////////////

if ( isnil "T8U_fnc_AssignTask" ) then {				T8U_fnc_AssignTask = compile preProcessFileLineNumbers					( T8U_dir_ROOT + T8U_dir_FNCS + "fn_assignTask.sqf" ); };
if ( isnil "T8U_fnc_Cache" ) then {						T8U_fnc_Cache = compile preProcessFileLineNumbers						( T8U_dir_ROOT + T8U_dir_FNCS + "fn_cache.sqf" ); };
if ( isnil "T8U_fnc_CBM" ) then {						T8U_fnc_CBM = compile preProcessFileLineNumbers							( T8U_dir_ROOT + T8U_dir_FNCS + "fn_combatBehaviorMod.sqf" ); };
if ( isnil "T8U_fnc_CreateFlankingPos" ) then {			T8U_fnc_CreateFlankingPos = compile preProcessFileLineNumbers			( T8U_dir_ROOT + T8U_dir_FNCS + "fn_createFlankingPos.sqf" ); };
if ( isnil "T8U_fnc_CreateSpawnPos" ) then {			T8U_fnc_CreateSpawnPos = compile preProcessFileLineNumbers				( T8U_dir_ROOT + T8U_dir_FNCS + "fn_createSpawnPos.sqf" ); };
if ( isnil "T8U_fnc_CreateWP" ) then {					T8U_fnc_CreateWP = compile preProcessFileLineNumbers					( T8U_dir_ROOT + T8U_dir_FNCS + "fn_createWaypoint.sqf" ); };
if ( isnil "T8U_fnc_CreateWaypointPositions" ) then {	T8U_fnc_CreateWaypointPositions = compile preProcessFileLineNumbers		( T8U_dir_ROOT + T8U_dir_FNCS + "fn_createWaypointPositions.sqf" ); };
if ( isnil "T8U_fnc_DebugLog" ) then {					T8U_fnc_DebugLog = compile preProcessFileLineNumbers					( T8U_dir_ROOT + T8U_dir_FNCS + "fn_debugLog.sqf" ); };
if ( isnil "T8U_fnc_DebugMarker" ) then {				T8U_fnc_DebugMarker = compile preProcessFileLineNumbers					( T8U_dir_ROOT + T8U_dir_FNCS + "fn_debugMarker.sqf" ); };
if ( isnil "T8U_fnc_DebugMarkerDelete" ) then {			T8U_fnc_DebugMarkerDelete = compile preProcessFileLineNumbers			( T8U_dir_ROOT + T8U_dir_FNCS + "fn_debugMarkerDelete.sqf" ); };
if ( isnil "T8U_fnc_FilterEntities" ) then {			T8U_fnc_FilterEntities = compile preProcessFileLineNumbers				( T8U_dir_ROOT + T8U_dir_FNCS + "fn_filterEntities.sqf" ); };
if ( isnil "T8U_fnc_FiredEvent" ) then {				T8U_fnc_FiredEvent = compile preProcessFileLineNumbers					( T8U_dir_ROOT + T8U_dir_FNCS + "fn_firedEvent.sqf" ); };
if ( isnil "T8U_fnc_ForceNextWP" ) then {				T8U_fnc_ForceNextWP = compile preProcessFileLineNumbers					( T8U_dir_ROOT + T8U_dir_FNCS + "fn_forceNextWaypoint.sqf" ); };
if ( isnil "T8U_fnc_GarrisonBuildings" ) then {			T8U_fnc_GarrisonBuildings = compile preProcessFileLineNumbers			( T8U_dir_ROOT + T8U_dir_FNCS + "fn_garrisonBuildings.sqf" ); };
if ( isnil "T8U_fnc_GetCoverPos" ) then {				T8U_fnc_GetCoverPos = compile preProcessFileLineNumbers					( T8U_dir_ROOT + T8U_dir_FNCS + "fn_getCoverPos.sqf" ); };
if ( isnil "T8U_fnc_GetInBuilding" ) then {				T8U_fnc_GetInBuilding = compile preProcessFileLineNumbers				( T8U_dir_ROOT + T8U_dir_FNCS + "fn_getInBuilding.sqf" ); };
if ( isnil "T8U_fnc_GetInCover" ) then {				T8U_fnc_GetInCover = compile preProcessFileLineNumbers					( T8U_dir_ROOT + T8U_dir_FNCS + "fn_getInCover.sqf" ); };
if ( isnil "T8U_fnc_GetInGunner" ) then {				T8U_fnc_GetInGunner = compile preProcessFileLineNumbers					( T8U_dir_ROOT + T8U_dir_FNCS + "fn_getInGunner.sqf" ); };
if ( isnil "T8U_fnc_GetOutCover" ) then {				T8U_fnc_GetOutCover = compile preProcessFileLineNumbers					( T8U_dir_ROOT + T8U_dir_FNCS + "fn_getOutCover.sqf" ); };
if ( isnil "T8U_fnc_GetOutVehicle" ) then {				T8U_fnc_GetOutVehicle = compile preProcessFileLineNumbers				( T8U_dir_ROOT + T8U_dir_FNCS + "fn_getOutVehicle.sqf" ); };
if ( isnil "T8U_fnc_GetSupport" ) then {				T8U_fnc_GetSupport = compile preProcessFileLineNumbers					( T8U_dir_ROOT + T8U_dir_FNCS + "fn_getSupport.sqf" ); };
if ( isnil "T8U_fnc_GroupClearEmpty" ) then {			T8U_fnc_GroupClearEmpty = compile preProcessFileLineNumbers				( T8U_dir_ROOT + T8U_dir_FNCS + "fn_groupClearEmpty.sqf" ); };
if ( isnil "T8U_fnc_GroupClearWP" ) then {				T8U_fnc_GroupClearWP = compile preProcessFileLineNumbers				( T8U_dir_ROOT + T8U_dir_FNCS + "fn_groupClearWaypoints.sqf" ); };
if ( isnil "T8U_fnc_GroupCopyVars" ) then {				T8U_fnc_GroupCopyVars = compile preProcessFileLineNumbers				( T8U_dir_ROOT + T8U_dir_FNCS + "fn_groupCopyVars.sqf" ); };
if ( isnil "T8U_fnc_GroupRegroup" ) then {				T8U_fnc_GroupRegroup = compile preProcessFileLineNumbers				( T8U_dir_ROOT + T8U_dir_FNCS + "fn_groupRegroup.sqf" ); };
if ( isnil "T8U_fnc_HitEvent" ) then {					T8U_fnc_HitEvent = compile preProcessFileLineNumbers					( T8U_dir_ROOT + T8U_dir_FNCS + "fn_hitEvent.sqf" ); };
if ( isnil "T8U_fnc_KilledEvent" ) then {				T8U_fnc_KilledEvent = compile preProcessFileLineNumbers					( T8U_dir_ROOT + T8U_dir_FNCS + "fn_killedEvent.sqf" ); };
if ( isnil "T8U_fnc_MoveOut" ) then {					T8U_fnc_MoveOut = compile preProcessFileLineNumbers						( T8U_dir_ROOT + T8U_dir_FNCS + "fn_moveOut.sqf" ); };
if ( isnil "T8U_fnc_MoveTo" ) then {					T8U_fnc_MoveTo = compile preProcessFileLineNumbers						( T8U_dir_ROOT + T8U_dir_FNCS + "fn_moveTo.sqf" ); };
if ( isnil "T8U_fnc_MoveToPos" ) then {					T8U_fnc_MoveToPos = compile preProcessFileLineNumbers					( T8U_dir_ROOT + T8U_dir_FNCS + "fn_moveToPos.sqf" ); };
if ( isnil "T8U_fnc_OnFiredEvent" ) then {				T8U_fnc_OnFiredEvent = compile preProcessFileLineNumbers				( T8U_dir_ROOT + T8U_dir_FNCS + "fn_onFiredEvent.sqf" ); };
if ( isnil "T8U_fnc_OnHitEvent" ) then {				T8U_fnc_OnHitEvent = compile preProcessFileLineNumbers					( T8U_dir_ROOT + T8U_dir_FNCS + "fn_onHitEvent.sqf" ); };
if ( isnil "T8U_fnc_PauseFiredEvent" ) then {			T8U_fnc_PauseFiredEvent = compile preProcessFileLineNumbers				( T8U_dir_ROOT + T8U_dir_FNCS + "fn_pauseFiredEvent.sqf" ); };
if ( isnil "T8U_fnc_RedoOriginTask" ) then {			T8U_fnc_RedoOriginTask = compile preProcessFileLineNumbers				( T8U_dir_ROOT + T8U_dir_FNCS + "fn_redoOriginTask.sqf" ); };
if ( isnil "T8U_fnc_ReleaseGroup" ) then {				T8U_fnc_ReleaseGroup = compile preProcessFileLineNumbers				( T8U_dir_ROOT + T8U_dir_FNCS + "fn_releaseGroup.sqf" ); };
if ( isnil "T8U_fnc_ResetCalled" ) then {				T8U_fnc_ResetCalled = compile preProcessFileLineNumbers					( T8U_dir_ROOT + T8U_dir_FNCS + "fn_resetCalled.sqf" ); };
if ( isnil "T8U_fnc_RestartFiredEvent" ) then {			T8U_fnc_RestartFiredEvent = compile preProcessFileLineNumbers			( T8U_dir_ROOT + T8U_dir_FNCS + "fn_restartFiredEvent.sqf" ); };
if ( isnil "T8U_fnc_SmokeScreen" ) then {				T8U_fnc_SmokeScreen = compile preProcessFileLineNumbers					( T8U_dir_ROOT + T8U_dir_FNCS + "fn_smokeScreen.sqf" ); };
if ( isnil "T8U_fnc_Spawn" ) then {						T8U_fnc_Spawn = compile preProcessFileLineNumbers						( T8U_dir_ROOT + T8U_dir_FNCS + "fn_spawn.sqf" ); };
if ( isnil "T8U_fnc_Track" ) then {						T8U_fnc_Track = compile preProcessFileLineNumbers						( T8U_dir_ROOT + T8U_dir_FNCS + "fn_track.sqf" ); };
if ( isnil "T8U_fnc_TrackAllUnits" ) then {				T8U_fnc_TrackAllUnits = compile preProcessFileLineNumbers				( T8U_dir_ROOT + T8U_dir_FNCS + "fn_trackAllUnits.sqf" ); };
if ( isnil "T8U_fnc_TriggerSpawn" ) then {				T8U_fnc_TriggerSpawn = compile preProcessFileLineNumbers				( T8U_dir_ROOT + T8U_dir_FNCS + "fn_triggerSpawn.sqf" ); };
if ( isnil "T8U_fnc_Zone" ) then {						T8U_fnc_Zone = compile preProcessFileLineNumbers						( T8U_dir_ROOT + T8U_dir_FNCS + "fn_zone.sqf" ); };
if ( isnil "T8U_fnc_ZoneCreate" ) then {				T8U_fnc_ZoneCreate = compile preProcessFileLineNumbers					( T8U_dir_ROOT + T8U_dir_FNCS + "fn_zoneCreate.sqf" ); };
if ( isnil "T8U_fnc_ZoneNotAktiv" ) then {				T8U_fnc_ZoneNotAktiv = compile preProcessFileLineNumbers				( T8U_dir_ROOT + T8U_dir_FNCS + "fn_zoneNotAktiv.sqf" ); };


///// T8 Units TASKS /////////////////////////////////////////////////////////////////////////////////////////////////////

// basic tasks
if ( isnil "T8U_task_Attack" ) then {					T8U_task_Attack = compile preProcessFileLineNumbers						( T8U_dir_ROOT + T8U_dir_TASK + "attack.sqf" ); };
if ( isnil "T8U_task_Defend" ) then {					T8U_task_Defend = compile preProcessFileLineNumbers						( T8U_dir_ROOT + T8U_dir_TASK + "defend.sqf" ); };
if ( isnil "T8U_task_DefendBase" ) then {				T8U_task_DefendBase = compile preProcessFileLineNumbers					( T8U_dir_ROOT + T8U_dir_TASK + "defendBase.sqf" ); };
if ( isnil "T8U_task_Garrison" ) then {					T8U_task_Garrison = compile preProcessFileLineNumbers					( T8U_dir_ROOT + T8U_dir_TASK + "garrison.sqf" ); };
if ( isnil "T8U_task_Loiter" ) then {					T8U_task_Loiter = compile preProcessFileLineNumbers						( T8U_dir_ROOT + T8U_dir_TASK + "loiter.sqf" ); };
if ( isnil "T8U_task_Overwatch" ) then {				T8U_task_Overwatch = compile preProcessFileLineNumbers					( T8U_dir_ROOT + T8U_dir_TASK + "overwatch.sqf" ); };
if ( isnil "T8U_task_Patrol" ) then {					T8U_task_Patrol = compile preProcessFileLineNumbers						( T8U_dir_ROOT + T8U_dir_TASK + "patrol.sqf" ); };
if ( isnil "T8U_task_PatrolAround" ) then {				T8U_task_PatrolAround = compile preProcessFileLineNumbers				( T8U_dir_ROOT + T8U_dir_TASK + "patrolAround.sqf" ); };
if ( isnil "T8U_task_PatrolGarrison" ) then {			T8U_task_PatrolGarrison = compile preProcessFileLineNumbers				( T8U_dir_ROOT + T8U_dir_TASK + "patrolGarrison.sqf" ); };
if ( isnil "T8U_task_PatrolMarker" ) then {				T8U_task_PatrolMarker = compile preProcessFileLineNumbers				( T8U_dir_ROOT + T8U_dir_TASK + "patrolMarker.sqf" ); };
if ( isnil "T8U_task_PatrolUrban" ) then {				T8U_task_PatrolUrban = compile preProcessFileLineNumbers				( T8U_dir_ROOT + T8U_dir_TASK + "patrolUrban.sqf" ); };

// response tasks
if ( isnil "T8U_task_Hold" ) then {						T8U_task_Hold = compile preProcessFileLineNumbers						( T8U_dir_ROOT + T8U_dir_TASK + "hold.sqf" ); };


///// T8 Units SUPPORTS /////////////////////////////////////////////////////////////////////////////////////////////////////

if ( isnil "T8U_supp_HALO" ) then {						T8U_supp_HALO = compile preProcessFileLineNumbers						( T8U_dir_ROOT + T8U_dir_SUPP + "supportHALO.sqf" ); };




/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////