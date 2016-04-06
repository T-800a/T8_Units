/*
 =======================================================================================================================

	Script: fn_defendBase.sqf
	Author(s): T-800a
	Inspired and partly based on code by Binesi's BIN_taskDefend/Patrole

	Description:
	makes a group get in mil. buildings and units will man static weapons
	Group will first man Weapons, then Small Guard Cargo Towers, then HQ Cargo Buildings, then the Big Cargo Towers.
	The group leader +1 unit will do a SAD Waypoint at the center
	( if there are more guns then units then only the group leader will do this )

	Parameter(s):
	_this select 0: the group who should defend a base (group)
	_this select 1: the position of our base to defend (Markername / string) ( marker as center for our search ... )
	_this select 2: (optional) range to search for manable vehicle / static guns / buildings (integer)

	Example(s):
	null = [ group this, "MY_MARKER" ] execVM "fn_defendBase.sqf"
	null = [ group this, "MY_MARKER", 100 ] execVM "fn_defendBase.sqf"  // searches for static weapons within 100m

 =======================================================================================================================
*/

#include <..\MACRO.hpp>

private [ "_group", "_units", "_marker", "_areaSizeX", "_areaSizeY", "_range", "_originUnits", "_formation", "_statement", "_range", "_wp", "_ocBuild" ];

_group		= param [ 0, grpNull, [grpNull]];
_marker		= param [ 1, "NO-MARKER-SET", ["",[]]]; 

_ocBuild = [];

if ( T8U_var_DEBUG ) then { [ "fn_defendBase.sqf", "INIT", _this ] spawn T8U_fnc_DebugLog; };

if ((( typeName _marker ) isEqualTo "ARRAY" ) AND {( count _marker ) isEqualTo 0 }) exitWith { false };
if (( typeName _marker ) isEqualTo "ARRAY" ) then { _marker = _marker call BIS_fnc_selectRandom; };
if ( isNull _group OR { str ( getMarkerPos _marker ) == str ([0,0,0]) } ) exitWith { false };

_areaSizeX	= ( getMarkerSize _marker ) select 0;
_areaSizeY	= ( getMarkerSize _marker ) select 1;
_range = ( _areaSizeX + _areaSizeY ) / 2;
if ( _range < 30 ) then { _range = 30; };

_originUnits = ( units _group );

_formation = ["STAG COLUMN", "WEDGE", "VEE", "DIAMOND"] call BIS_fnc_selectRandom;

_group setBehaviour "AWARE";
_group setSpeedMode "LIMITED";
_group setFormation _formation;
_group setVariable [ "defendBase_CanMan", false, false ];

[ _group, getMarkerPos _marker, "MOVE", "SAFE", "[ this ] spawn T8U_fnc_GetOutVehicle; ( group this ) setVariable [ 'defendBase_CanMan', true, false ];", 10, "LIMITED" ] call T8U_fnc_CreateWaypoint;
[ _group, getMarkerPos _marker, "HOLD", "SAFE", "", 10, "LIMITED"] call T8U_fnc_CreateWaypoint;
[ _group, getMarkerPos _marker, "SAD", "SAFE", "( group this ) setVariable [ 'defendBase_CanMan', true, false ];", 50, "LIMITED", [ 5, 10, 15 ] ] call T8U_fnc_CreateWaypoint;
[ _group, getMarkerPos _marker, "MOVE", "SAFE", "( group this ) setCurrentWaypoint [ ( group this ), ( ( count waypoints group this ) - 2 ) ];", 100, "LIMITED" ] call T8U_fnc_CreateWaypoint;

waitUntil { sleep 1; ( _group ) getVariable [ "defendBase_CanMan", false ] };

_units = ( units _group ) - [ leader _group ];

_units = [ _units, _marker, _range ] call T8U_fnc_GetInGunner;

{ _ocBuild = [ _units, _marker, _range, _x ] call T8U_fnc_GetInBuilding; } forEach [ "Cargo_Patrol_base_F", "Cargo_HQ_base_F", "Cargo_Tower_base_F" ];

sleep 30; _group setCurrentWaypoint [ _group, 3 ];

if ( T8U_var_DEBUG ) then { [ "fn_defendBase.sqf", "Successfully Initialized", [ _group ] ] spawn T8U_fnc_DebugLog; };

waitUntil { sleep 2; ! ( count ( units _group ) > 0 ) };
// waitUntil { sleep 5; [ _group ] call T8U_fnc_ReleaseGroup };

if ( T8U_var_DEBUG ) then { [ "fn_defendBase.sqf", "TERMINATING", [ _group ] ] spawn T8U_fnc_DebugLog; };

{ 
	if ( alive _x ) then
	{
		[ _x, false ] call T8U_fnc_MoveOut;
	};
} count _originUnits;

{ _x setvariable [ "occupied", false, false ]; } count _ocBuild;
