diag_log format ["Calling fn_deleteUnitsFromMarkedGroup.sqf"];
if (!isServer ) exitWith {};

params ["_targetLabel", ["_targetSide", east, [east]]];

if ( isNil "_targetLabel" ) exitWith { if ( T8U_var_DEBUG ) then { [ "fn_deleteUnitsFromMarkedGroup.sqf", "NO DELETION: No group label given" ] spawn T8U_fnc_DebugLog; }; false };

_clearOutGroup = {
		params ["_groupToClear","_sideToClear"];

		diag_log format ["side group to clear: %1", side _groupToClear];
		diag_log format ["_sideToClear: %1", _sideToClear];
		if((side _groupToClear) == _sideToClear) then {
			_groupToClear call T8U_fnc_DeleteVehicleAndCrew;
			deleteGroup _groupToClear;
		};
};

_clearedOutGroups = [];
{
	_groupLabel = _x getVariable "T8U_gvar_Label";
	if(!isNil "_groupLabel") then {
		diag_log format ["Finding groups with label: %1", _groupLabel];
		if (_groupLabel == _targetLabel) then {
			[_x, _targetSide] call _clearOutGroup;
			_clearedOutGroups pushBack (groupId _x);
		};
	} else {
		// we found a group not made by the T8 system they need to be cleared up regardless they would only contaminate any mission
		[_x, _targetSide] call _clearOutGroup;
		_clearedOutGroups pushBack (groupId _x);
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