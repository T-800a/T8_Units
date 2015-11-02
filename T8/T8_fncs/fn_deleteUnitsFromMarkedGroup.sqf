if (!isServer ) exitWith {};

if ( isNil "_this" ) exitWith { if ( T8U_var_DEBUG ) then { [ "fn_deleteUnitsFromMarkedGroup.sqf", "NO DELETION: No group label given" ] spawn T8U_fnc_DebugLog; }; false };

_clearedOutGroups = [];
{
	_groupLabel = _x getVariable "T8U_gvar_Label";
	if(!isNil "_groupLabel") then {
		if (_groupLabel == _this) then {
			{
				_vehicleToDelete = _x;
				if(count (crew _vehicleToDelete) > 0) then {
					{_vehicleToDelete deleteVehicleCrew _x} forEach crew _vehicleToDelete;
				};
				deleteVehicle _vehicleToDelete;
			} forEach units _x;
			_clearedOutGroups pushBack (groupId _x);
			deleteGroup _x;
		};
	};
} forEach allGroups;

if ( T8U_var_DEBUG ) then {
	if (count _clearedOutGroups > 0) then {
			[ "Cleared out groups:" ] spawn T8U_fnc_DebugLog;
			{
				[ format ["Group: %1", _x] ] spawn T8U_fnc_DebugLog;
			} forEach _clearedOutGroups;
	} else {
		[ "No groups found to clear out" ] spawn T8U_fnc_DebugLog;
	};
};

true