params ["_group", "_waypointPosition"];

if(isNil("_group")) exitWith { [ "No group given for teleport" ] call T8U_fnc_BroadcastHint; false };

diag_log format ["Calling teleport group to current waypoint"];

if(_group getVariable ["NEWLY_CREATED", false]) then {
	diag_log format ["Teleporting to waypoint"];
	_currentWP = currentWaypoint _group;
	diag_log format ["Current waypoint %1", _currentWP];
	{
		_waypointPosition = getWPPos [_group, _currentWP];
		if(_x isKindOf "Man") then {
			_x setPos (_waypointPosition);
		} else {
			_x setVehiclePosition [_waypointPosition, [], 0, "NONE"];
		};
	} foreach units _group;
	_group setVariable ["NEWLY_CREATED", false];
};