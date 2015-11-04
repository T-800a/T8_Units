/*
 =======================================================================================================================

	T8 Units Script
	
	Funktion:	fn_track.sqf
	Author:		T-800a
	E-Mail:		t-800a@gmx.net
	
	Description: 
	Adds a map marker on group leaders position, updates every 3 sec, a small dotted path is shown.
	Inspired by Kronzkys track.sqf but 'dead simple' and for ARMA 3

	Parameter(s):
	_this select 0: the group to which to assign a marker


	Example(s):
	null = [ group this ] execVM "fn_track.sqf"

 =======================================================================================================================
*/

#include <..\MACRO.hpp>

waitUntil { !isNil "bis_fnc_init" };

private [ "_group", "_unit", "_markerColor", "_markerType", "_markerName", "_marker", "_tail", "_markerTailName", "_allowTail", "_onPlayer", "_markerAlpha", "_timeout", "_doLoop" ];

_group			= param [ 0, grpNull, [grpNull]];
_allowTail		= param [ 1, true, [true]];

sleep 2;


if ( isNull _group ) exitWith { [ "fn_track.sqf", "Missing Parameter", _this ] spawn T8U_fnc_DebugLog; false };

_unit = leader _group;
_markerColor = "ColorYellow";
_markerType = "o_inf";

if ( !isNull ( assignedVehicle _unit ) ) then { _markerType = "o_armor"; };

switch ( side _unit ) do 
{
	case EAST:			{ _markerColor = "ColorRed" };
	case WEST:			{ _markerColor = "ColorBlue" };	
	case RESISTANCE:	{ _markerColor = "ColorGreen" };
};

_markerName = format [ "%1_%2", _group, time ];
_markerAlpha = 1;
_timeout = 1;

_marker = createMarker [ _markerName, getpos _unit ];
_marker setMarkerType _markerType;
_marker setMarkerShape "ICON";
_marker setMarkerSize [ 0.75, 0.75 ];
_marker setMarkerColor _markerColor;
_marker setMarkerAlpha _markerAlpha;

_tail = [];
_oL = _unit;
_doLoop = true;

while { sleep _timeout; _doLoop } do
{	
	private [ "_task", "_markerText", "_suppression", "_fnc_sT" ];
	_fnc_sT = { private "_arr"; _arr = toArray _this; _arr resize 4; toString _arr };
	if ( !isNull ( assignedVehicle _oL ) ) then { _markerType = "o_armor"; _v = assignedVehicle _oL; } else { _markerType = "o_inf"; };
	
// UGLY AS FUCK !!! -.-
	_suppression = []; { private [ "_s" ]; _s = ( str ( getSuppression _x )) call _fnc_sT; if ( !isNil "_s" ) then { _suppression pushback call compile _s; }; false } count units _group;
	_task = _group getVariable [ "T8U_gvar_Assigned", " - " ]; if ( isNil "_task" ) then { _task = " - "; };
	_markerText = format [ " %1 [%2][%3][%4][%5]S:%6", _group, count ( units _group ), ( combatMode _group ) call _fnc_sT, ( behaviour _oL ) call _fnc_sT, _task call _fnc_sT, _suppression ]; 
	_marker setMarkerText _markerText;
	_marker setMarkerPos ( getpos ( leader _group ) );
	_marker setMarkerType _markerType;
	
	if ( _allowTail ) then 
	{
		_markerTailName = format [ "%1_%2", _group, random( time ) ];
		_markerTail = createMarker [ _markerTailName, getpos _oL ];
		_markerTail setMarkerType "mil_dot";
		_markerTail setMarkerShape "ICON";
		_markerTail setMarkerSize [ 0.75, 0.75 ];
		_markerTail setMarkerColor _markerColor;	
		_markerTail setMarkerAlpha 0.15;
		
		_tail = [ _tail, [ _markerTailName ], 0 ] call BIS_fnc_arrayInsert;
		
		if ( ( count _tail ) > 20 ) then { private [ "_markerRM" ]; _markerRM = _tail call BIS_fnc_arrayPop; deleteMarker _markerRM;  };
	};
	
	if ( ! alive _oL ) then { _oL = leader _group; _group = group _oL; };
	if ( _group != group _oL AND { alive _oL } ) then { _group = group _oL };
	if !( count ( units _group ) > 0 ) then { _doLoop = false; };
};

_marker setMarkerColor "ColorBlack";
_marker setMarkerAlpha 0.33;
_marker setMarkerSize [ 1, 1 ];
_marker setMarkerText "";

{ deleteMarker _x; } forEach _tail;