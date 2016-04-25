/*
 =======================================================================================================================

	T8 Units Script

	Funktion:	fn_assignTask.sqf
	Author:		Celludriel, (T-800a)
	E-Mail:		t-800a@gmx.net
	
	Will teleport any group with the variable NEWLY_CREATED true to it's current selected waypoint
	
	USAGE: [<group>] call T8U_fnc_teleportGroupToCurrentWaypoint;
	<group>: group of units

 =======================================================================================================================
*/

#include <..\MACRO.hpp>

params [[ "_group", grpNull, [grpNull]]];

__DEBUG( __FILE__, "INIT", _this );

if( isNull _group ) exitWith { __DEBUG( __FILE__, "ABORT", _this ); false };

private _alreadyTeleportedVehicle = [];

if(_group getVariable ["NEWLY_CREATED", false]) then {
	_currentWP = currentWaypoint _group;
	{
		private _waypointPosition = getWPPos [_group, _currentWP];
		if(_x isKindOf "Man" && vehicle _x == _x) then {
			_x setPos (_waypointPosition);
		} else {
			private _veh = vehicle _x;
			if( !(_veh in _alreadyTeleportedVehicle)) then {
				private _specialPlacementCondition = "NONE";
				if(_veh isKindOf "Air") then {
					_specialPlacementCondition = "FLY";
				};
				_veh setVehiclePosition [_waypointPosition, [], 50, _specialPlacementCondition];
				_alreadyTeleportedVehicle pushBack _veh;
			};
		};
	} foreach units _group;
	_group setVariable ["NEWLY_CREATED", false];
};

__DEBUG( __FILE__, "GROUP TELEPORTED", _this );