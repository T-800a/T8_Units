/*
 =======================================================================================================================

	T8 Units Script

	Funktion:	FUNCTIONS.hpp
	Author:		T-800a
	E-Mail:		t-800a@gmx.net

	Open < T8\CONFIG.hpp > to change basic variables !

 =======================================================================================================================
*/

#define addFunction(fncName)		class fncName { headerType = -1; }
#define addFunctionPre(fncName)		class fncName { headerType = -1; preInit = 1; }
#define addFunctionPost(fncName)	class fncName { headerType = -1; postInit = 1; }

// uncomment if not defined in description.ext
// class cfgFunctions
// {

	class T8U
	{
		class client
		{
			file = "T8\fnc";
			
			addFunction(hint);
			addFunction(broadcastHint);
		};
		
		class server
		{
			file = "T8\fnc";
			
			addFunctionPost(INIT);
			
			addFunction(assignTask);
			addFunction(cache);
			addFunction(checkEXEC);
			addFunction(combatBehaviorMod);
			addFunction(createFlankingPos);
			addFunction(createSpawnPos);
			addFunction(createWaypoint);
			addFunction(createWaypointPositions);
			addFunction(debugLog);
			addFunction(debugMarker);
			addFunction(debugMarkerDelete);
			addFunction(filterEntities);
			addFunction(findBuildingPositions);
			addFunction(findOverwatch);
			addFunction(findEmptyPos);
			addFunction(firedEvent);
			addFunction(forceNextWaypoint);
			addFunction(garrisonBuildings);
			addFunction(getCoverPos);
			addFunction(getInBuilding);
			addFunction(getInCover);
			addFunction(getInGunner);
			addFunction(getOutCover);
			addFunction(getOutVehicle);
			addFunction(getSupport);
			addFunction(groupClearEmpty);
			addFunction(groupClearWaypoints);
			addFunction(groupCopyVars);
			addFunction(groupRegroup);
			addFunction(hitEvent);
			addFunction(inBuilding);
			addFunction(killedEvent);
			addFunction(moveOut);
			addFunction(moveTo);
			addFunction(moveToPos);
			addFunction(occupyBuildings);
			addFunction(onFiredEvent);
			addFunction(onHitEvent);
			addFunction(pauseFiredEvent);
			addFunction(redoOriginTask);
			addFunction(releaseGroup);
			addFunction(resetCalled);
			addFunction(restartFiredEvent);
			addFunction(smokeScreen);
			addFunction(spawn);
			addFunction(track);
			addFunction(trackAllUnits);
			addFunction(triggerSpawn);
			addFunction(zone);
			addFunction(zoneCreate);
			addFunction(zoneNotAktiv);
			
			// polygon stuff
			addFunction(getPolygon);
			addFunction(drawPolygon);
			addFunction(findExtreme);
			addFunction(checkPolygon);
			addFunction(checkFlatGround);
			addFunction(checkOutside);
		};
	};
	
	class T8U_tsk
	{
		class task
		{
			file = "T8\tsk";
			
			// basic tasks
			addFunction(attack);
			addFunction(defend);
			addFunction(defendBase);
			addFunction(garrison);
			addFunction(loiter);
			addFunction(overwatch);
			addFunction(occupy);
			addFunction(patrol);
			addFunction(patrolAround);
			addFunction(patrolGarrison);
			addFunction(patrolMarker);
			addFunction(patrolUrban);

			// response tasks
			addFunction(hold);
		};
	};

	class T8U_sup
	{
		class support
		{
			file = "T8\sup";

			addFunction(HALO);
		};
	};
	
// uncomment if not defined in description.ext
// };
	