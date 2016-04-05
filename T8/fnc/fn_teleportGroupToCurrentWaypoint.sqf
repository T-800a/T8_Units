params ["_group"];

if(isNil("_group")) exitWith { [ "No group given for teleport" ] call T8U_fnc_BroadcastHint; false };

if(_group getVariable ["NEWLY_CREATED", false]) then {
	_currentWP = currentWaypoint _group;
	{
		_x setPos (getWPPos [_group, _currentWP]);
	} foreach units _group;
	_group setVariable ["NEWLY_CREATED", false];
};