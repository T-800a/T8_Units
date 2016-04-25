/*
 =======================================================================================================================

	Script: fn_patrolMarker.sqf
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
	_this select 4: (optional) formation of group (String)
	_this select 5: (optional) behaviour of group (String)

	Example(s):
	tmp = [ group this, [ "marker01", "marker02", "marker03" ] ] execVM "fn_patrolMarker.sqf";
	tmp = [ group this, [ "marker01", "marker02", "marker03" ], true, false, true ] execVM "fn_patrolMarker.sqf";

 =======================================================================================================================
*/

#include <..\MACRO.hpp>

private [ "_group", "_markerArray", "_infGroup", "_doSAD", "_formation", "_statement", "_range", "_speed", "_behaviour", "_wp", "_chkV" ];

_group			= param [ 0, grpNull, [grpNull]];
_markerArray	= param [ 1, [], [[]]];
_infGroup		= param [ 2, true, [true]];
_teleport		= param [ 3, false, [false]];
_doSAD			= param [ 4, true, [true]];
_formation		= param [ 5, "RANDOM", [""]];
_behaviour		= param [ 6, "SAFE", [""]];

if ( T8U_var_DEBUG ) then { [ "fn_patrolMarker.sqf", "INIT", _this ] spawn T8U_fnc_DebugLog; };

if ( isNull _group OR !( count _markerArray > 0 ) ) exitWith { false };

if ( _infGroup ) then
{
	if(_formation == "RANDOM") then {
		_formation = ["STAG COLUMN", "WEDGE", "ECH LEFT", "ECH RIGHT", "VEE", "DIAMOND"] call BIS_fnc_selectRandom;
	};
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

private [ "_wpPosArray" ];
_wpPosArray = [];

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

	_wpPosArray pushBack _wpPosFEP;

	false
} count _markerArray;

{
	private [ "_mkr" ];

	[ _group, _x, "MOVE", _behaviour, _statement, _range, _speed, [ 5, 10, 15 ] ] call T8U_fnc_CreateWaypoint;
	if ( T8U_var_DEBUG_marker ) then { _mkr = [ _x, "ICON", "mil_destroy_noShadow" ] call T8U_fnc_DebugMarker; };

	if ( _doSAD ) then
	{
		[ _group, _x, "SAD", _behaviour, _statement, _range, _speed, [ 15, 25, 35 ] ] call T8U_fnc_CreateWaypoint;
		if ( T8U_var_DEBUG_marker ) then { _mkr setMarkerColor "ColorRed"; };
	};

	false
} count _wpPosArray;

sleep 1;

// Cycle in case we reach the end
[ _group, ( _wpPosArray select 0 ), "CYCLE", _behaviour, _statement, 100 ] call T8U_fnc_CreateWaypoint;

// teleport the group to the current waypoint so they can start their loop, only if the group is newly created
if ( _teleport ) then {[ _group ] call T8U_fnc_teleportGroupToCurrentWaypoint; };

if ( T8U_var_DEBUG ) then { [ "fn_patrolMarker.sqf", "Successfully Initialized", [ _group ] ] spawn T8U_fnc_DebugLog; };

// Return
true
