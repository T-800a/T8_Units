diag_log format ["Calling fn_deleteVehicleAndCrew.sqf with %1", _this];
if (!isServer ) exitWith {};

if ( isNil "_this") exitWith { if ( T8U_var_DEBUG ) then { [ "fn_deleteVehicleAndCrew.sqf", "NO DELETION: No group given" ] spawn T8U_fnc_DebugLog; }; false };

private ["_groupToClearOut"];

_groupToClearOut = _this;

{
	diag_log format ["Deleting vehicle and crew: %1", _x];
	_vehicleToDelete = _x;
	if(count (crew _vehicleToDelete) > 0) then {
		{_vehicleToDelete deleteVehicleCrew _x} forEach crew _vehicleToDelete;
	};
	deleteVehicle _vehicleToDelete;
} forEach units _groupToClearOut;