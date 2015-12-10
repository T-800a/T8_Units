/*
 =======================================================================================================================

	Script: fn_overwatch.sqf
	Author(s): T-800a
	Inspired and partly based on code by Binesi's BIN_taskDefend/Patrole

	Description:
	Searches for a possible Overwatch Position around a given Marker. If one is found, given group will move to this
	position and look at it. If no overwatch position is found group will do a SAD on given Marker.
	!! It will take some time to find a overwatch position because of the amount of possible positions the script checks !!
	selected Positions are 20m above the pos to watch at, and have neither terrain nor object intersection.
	selected positions are between 250m and 550m away from given Marker
	Marker to overwatch is best placed on the open, not over houses!

	Parameter(s):
	_this select 0: the group to which to assign the waypoints (Group)
	_this select 1: the position on which should be overwatched (Markername / String)
	_this select 2: (optional) is infantry group (Bool) Will force group to leave vehicle on waypoints!
	_this select 3: (optional) debug markers on or off (Bool)


	Example(s):
	null = [ group this, "MY_MARKER" ] execVM "fn_overwatch.sqf"
	null = [ group this, "MY_MARKER", false, true ] execVM "fn_overwatch.sqf"  // not an infantry group, debug enabled

 =======================================================================================================================
*/

#include <..\MACRO.hpp>

private [ "_group", "_marker", "_infGroup", "_originUnits", "_formation", "_statement", "_wpArray", "_selectPos", "_overwatchPos", "_wp", "_behaviour" ];

_group			= param [ 0, grpNull, [grpNull]];
_marker			= param [ 1, "NO-MARKER-SET", [""]];
_minDist		= param [ 2, 250, [123]];
_range			= param [ 3, 300, [123]];
_infGroup		= param [ 4, true, [true]];

if ( T8U_var_DEBUG ) then { [ "fn_overwatch.sqf", "INIT", _this ] spawn T8U_fnc_DebugLog; };

if ( isNull _group OR { str ( getMarkerPos _marker ) == str ([0,0,0]) } ) exitWith { false };

if ( _infGroup ) then
{
	_formation = ["STAG COLUMN", "WEDGE", "ECH LEFT", "ECH RIGHT", "VEE", "DIAMOND"] call BIS_fnc_selectRandom;
	_statement = "[ this ] spawn T8U_fnc_GetOutVehicle;";
} else {
	_formation = "COLUMN";
	_statement = "";
};

_wpArray = [];
_wpArray = [ _marker, _minDist, _range ] call T8U_fnc_FindOverwatch;


if ( T8U_var_DEBUG ) then { [ "fn_overwatch.sqf", "_wpArray", _wpArray ] spawn T8U_fnc_DebugLog; };

_selectPos = _wpArray call BIS_fnc_selectRandom;

if ( isNil "_selectPos" ) then { _selectPos = []; };

if ( count _selectPos > 0 ) then
{
	_overwatchPos = [ _selectPos select 0, _selectPos select 1, 0 ];

	if ( T8U_var_DEBUG ) then { [ "fn_overwatch.sqf", "_overwatchPos", [ _overwatchPos ] ] spawn T8U_fnc_DebugLog; };
	if ( T8U_var_DEBUG_marker ) then { [ _overwatchPos, "ICON", "mil_circle_noShadow", 0.5, "ColorRed", 0.66, " do OV from here" ] call T8U_fnc_DebugMarker; };

	_group setBehaviour "AWARE";
	_group setSpeedMode "FULL";
	_group setFormation _formation;

	[ _group, _overwatchPos, "MOVE", "AWARE", "( group this ) setVariable [ 'overwatchOnPos', true, false ];", 50, "FULL", [ 5, 5, 5 ] ] call T8U_fnc_CreateWaypoint;
	[ _group, _overwatchPos, "GUARD", "AWARE", _statement, 10, "FULL", [ 0, 0, 0 ] ] call T8U_fnc_CreateWaypoint;	
	
	waitUntil { sleep 5; _group getVariable "overwatchOnPos" };

	sleep 2;

	{
		if ( _infGroup ) then
		{
			_dir = [ _x, ( getMarkerPos _marker ) ] call BIS_fnc_relativeDirTo;
			[ _group, _x, _dir, _marker ] spawn 
			{
				private [ "_group", "_dir", "_unit" ];
				_group = _this select 0;
				_unit = _this select 1;
				_dir = _this select 2;
				_marker = _this select 3;
				
				while { sleep 5; ( count ( units _group ) ) > 0 AND ( alive _unit ) } do 
				{
					_unit setDir _dir;
					_unit setUnitPos "Middle";
					doStop _unit;
					waitUntil { sleep 0.5; ( behaviour _unit ) == "COMBAT" };
					_unit setUnitPos "AUTO";
					_unit switchMove "";
					sleep 60;
					waitUntil { sleep 5; ( behaviour _unit ) == "AWARE" };
					sleep 30;
					_unit doWatch ( getMarkerPos _marker ); 			
				};
			};
		};
		
		doStop _x;
		_x doWatch ( getMarkerPos _marker ); 
	} forEach ( units _group );

} else {
	
	_overwatchPos = ( getMarkerPos _marker );
	
	_group setBehaviour "AWARE";
	_group setSpeedMode "FULL";
	_group setFormation _formation;	

	[ _group, _overwatchPos, "SAD", "SAFE", _statement, 50, "LIMITED", [ 10, 20, 30 ] ] call T8U_fnc_CreateWaypoint;
	[ _group, _overwatchPos, "MOVE", "SAFE", "( group this ) setCurrentWaypoint [ ( group this ), ( ( count waypoints group this ) - 2 ) ];", 10, "LIMITED" ] call T8U_fnc_CreateWaypoint;	
	
	if ( T8U_var_DEBUG_marker ) then { [ _overwatchPos, "ICON", "mil_destroy_noShadow", 0.5, "ColorRed", 0.66, " do SAD here" ] call T8U_fnc_DebugMarker; };
};

if ( T8U_var_DEBUG ) then { [ "fn_overwatch.sqf", "Successfully Initialized", [ _group ] ] spawn T8U_fnc_DebugLog; };

// Return
true
