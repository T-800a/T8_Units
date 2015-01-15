/*
 =======================================================================================================================

	Script: defend.sqf
	Author(s): T-800a
	Inspired and partly based on code by Binesi's BIN_taskDefend/Patrole

	Description:
	Creates a defensiv Position, Units will man static weapons, or guns of emtpy vehicles

	Parameter(s):
	_this select 0: the group to which to assign the waypoints (group)
	_this select 1: the position on which to base the defensiv position (Markername / string)
	_this select 2: (optional) range to search for manable vehicle / static guns (integer)

	Breakout Conditions:
	- all units have left the group 

	Example(s):
	null = [ group this, "MY_MARKER" ] execVM "defend.sqf"
	null = [ group this, "MY_MARKER", 100 ] execVM "defend.sqf"  // searches for static weapons within 100m

 =======================================================================================================================
*/

private [ "_group", "_marker", "_areaSizeX", "_areaSizeY", "_range", "_originUnits", "_formation", "_statement", "_wp" ];

_group		= [ _this, 0, objNull ] call BIS_fnc_param;
_marker		= [ _this, 1, "NO-MARKER", [ "" ] ] call BIS_fnc_param;

if ( T8U_var_DEBUG ) then { [ "defend.sqf", "INIT", _this ] spawn T8U_fnc_DebugLog; };

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
_group setVariable [ "defend_CanMan", false, false ];

[ _group, getMarkerPos _marker, "MOVE", "SAFE", "[ this ] spawn T8U_fnc_GetOutVehicle; ( group this ) setVariable [ 'defend_CanMan', true, false ];", 100, "LIMITED" ] call T8U_fnc_CreateWP;
[ _group, getMarkerPos _marker, "SAD", "SAFE", "( group this ) setVariable [ 'defend_CanMan', true, false ];", 30, "LIMITED", [ 10, 20, 30 ] ] call T8U_fnc_CreateWP;
[ _group, getMarkerPos _marker, "MOVE", "SAFE", "( group this ) setCurrentWaypoint [ ( group this ), ( ( count waypoints group this ) - 2 ) ];", 100, "LIMITED" ] call T8U_fnc_CreateWP;

waitUntil { sleep 1; ( _group ) getVariable "defend_CanMan" };

_units = ( units _group ) - [ leader _group ];
[ _units, _marker, _range, "LandVehicle" ] call T8U_fnc_GetInGunner;

if ( T8U_var_DEBUG ) then { [ "defend.sqf", "Successfully Initialized", [ _group ] ] spawn T8U_fnc_DebugLog; };

waitUntil { sleep 5; !( count ( units _group ) > 0 ) };

// for the new fn_groupRegroup.sqf ...		
// waitUntil { sleep 5; [ _group ] call T8U_fnc_ReleaseGroup };

if ( T8U_var_DEBUG ) then { [ "defend.sqf", "TERMINATING", [ _group ] ] spawn T8U_fnc_DebugLog; };

{
	if ( alive _x ) then 
	{
		[ _x ] orderGetIn false;
		_x leaveVehicle ( assignedVehicle _x );
	};
} forEach _originUnits;