/*
 =======================================================================================================================

	Script: patrolMarker.sqf
	Author(s): T-800a
	Inspired and partly based on code by Binesi's BIN_taskDefend/Patrole

	Description:
	Group will patrol given marker positions and cycle.
	If not set to Infantry Group, waypoints will be placed on nearest street!

	Parameter(s):
	_this select 0: Group ( Group )
	_this select 1: patrol positions ( Array with marker )
	_this select 2: Group is a pure infantry Group -> force units to leave vehicles ( bool )
	_this select 3: do SAD waypoint on each marker ( bool )
	_this select 3: DEBUG ( bool )

	Example(s):
	tmp = [ group this, [ "marker01", "marker02", "marker03" ] ] execVM "patrolMarker.sqf";
	tmp = [ group this, [ "marker01", "marker02", "marker03" ], true, false, true ] execVM "patrolMarker.sqf";

 =======================================================================================================================
*/

private [ "_group", "_markerArray", "_infGroup", "_doSAD", "_formation", "_statement", "_range", "_speed", "_behaviour", "_wp", "_chkV", "_behaviour" ];

_group			= [ _this, 0, objNull ] call BIS_fnc_param;
_markerArray	= [ _this, 1, [], [[]] ] call BIS_fnc_param;
_infGroup		= [ _this, 2, true, [ true ] ] call BIS_fnc_param; 
_doSAD			= [ _this, 3, true, [ true ] ] call BIS_fnc_param;

if ( T8U_var_DEBUG ) then { [ "patrolMarker.sqf", "INIT", _this ] spawn T8U_fnc_DebugLog; };

if ( isNull _group OR !( count _markerArray > 0 ) ) exitWith { false };

if ( _infGroup ) then
{
	_formation = ["STAG COLUMN", "WEDGE", "ECH LEFT", "ECH RIGHT", "VEE", "DIAMOND"] call BIS_fnc_selectRandom;
	_statement = "[ this ] spawn T8U_fnc_GetOutVehicle;";
	_range = 20;
	_speed = "LIMITED";
	_chkV = "CAManBase";
} else {
	_formation = "COLUMN";
	_statement = "";
	_range = 50;
	_speed = "LIMITED";
	_chkV = "B_Truck_01_covered_F";
};

_group setBehaviour "AWARE";
_group setSpeedMode _speed;
_group setFormation _formation;

{
	private [ "_wpPosFEP" ];
	_wpPosFEP = [];
	if ( ! _infGroup ) then 
	{
		private [ "_loop", "_wpPos", "_roadObj" ];
		_loop = true;
		_tmpMaxDist = 10;
		while { _loop } do 
		{    
			_wpPos = getMarkerPos _x;
			if ( T8U_var_DEBUG_marker ) then { [ _wpPos, "ICON", "mil_dot_noShadow" ] call T8U_fnc_DebugMarker; };
			_roadObj = [ _wpPos ] call BIS_fnc_nearestRoad;
			_wpPosFEP = ( getPos _roadObj ) findEmptyPosition [ 1 , _tmpMaxDist, _chkV ];
			if ( count _wpPosFEP < 2 ) then { _tmpMaxDist = _tmpMaxDist + 5; } else { _loop = false; };
			if ( _tmpMaxDist > 50 ) then { _loop = false; _wpPosFEP = ( getMarkerPos _x ) findEmptyPosition [ 1 , 30, _chkV ]; };
		};
	} else {
		_wpPosFEP = ( getMarkerPos _x ) findEmptyPosition [ 1 , 20, _chkV ];
	};

	[ _group, _wpPosFEP, "MOVE", "SAFE", _statement, _range, _speed, [ 5, 10, 15 ] ] call T8U_fnc_CreateWP;
	
	private [ "_mkr" ];
	if ( T8U_var_DEBUG_marker ) then { _mkr = [ _wpPosFEP, "ICON", "mil_destroy_noShadow" ] call T8U_fnc_DebugMarker; };
	
	if ( _doSAD ) then 
	{
		[ _group, _wpPosFEP, "SAD", "SAFE", _statement, _range, _speed, [ 15, 25, 35 ] ] call T8U_fnc_CreateWP;
		
		if ( T8U_var_DEBUG_marker ) then { _mkr setMarkerColor "ColorRed"; };
	};	
} forEach _markerArray;

sleep 1;

// Cycle in case we reach the end
[ _group, getMarkerPos ( _markerArray select 0 ), "CYCLE", "SAFE", _statement, 100 ] call T8U_fnc_CreateWP;

if ( T8U_var_DEBUG ) then { [ "patrolMarker.sqf", "Successfully Initialized", [ _group ] ] spawn T8U_fnc_DebugLog; };

// Return
true
