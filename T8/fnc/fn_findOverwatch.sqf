/*
 =======================================================================================================================

	T8 Units Script
	
	Funktion:	fn_findOverwatch.sqf
	Author:		T-800a
	E-Mail:		t-800a@gmx.net
	
	
	_return = [ _basePos, _minDist, _range, _skipLos ] call T8U_fnc_FindOverwatch;

=======================================================================================================================
*/

#include <..\MACRO.hpp>

private [	"_basePos", "_minDist", "_range", "_skipLos", "_posArray", "_losArray", "_returnArray", "_wpPos", "_loopMain", "_newangle", "_heightDiff", "_radiusIncr",
			"_angleIncr", "_centerX", "_centerY", "_hT", "_watchPos", "_watchPosASL", "_maxDistance", "_tmpMaxDist" ];

_basePos			= param [ 0, "NO-MARKER-SET", [[], ""]];
_minDist			= param [ 1, 25, [ 123 ]];
_range				= param [ 2, 50, [ 123 ]];
_skipLos			= param [ 3, false, [ false ]];


if ( T8U_var_DEBUG ) then { [ "fn_findOverwatch.sqf", "INIT", _this ] spawn T8U_fnc_DebugLog; };
if (( typeName _basePos ) isEqualTo ( typeName "STR" ) AND { _basePos isEqualTo "NO-MARKER-SET" })	exitWith { if ( T8U_var_DEBUG ) then { [ "fn_findOverwatch.sqf", "ABORT", _this ] spawn T8U_fnc_DebugLog; }; };
if (( typeName _basePos ) isEqualTo ( typeName [] ) AND { count _basePos < 2 })						exitWith { if ( T8U_var_DEBUG ) then { [ "fn_findOverwatch.sqf", "ABORT", _this ] spawn T8U_fnc_DebugLog; }; };

_posArray			= [];
_losArray			= [];
_returnArray		= [];

_loopMain			= true;
_newangle			= 0;

_heightDiff		= if ( _skipLos ) then { 1 } else { 20 };
_radiusIncr		= if ( _skipLos ) then { 15 } else { 25 };
_angleIncr		= if ( _skipLos ) then { 15 } else { 5 };

if (( typeName _basePos ) isEqualTo ( typeName [] )) then 
{
	_centerX = _basePos select 0;
	_centerY = _basePos select 1;
	_hT = getTerrainHeightASL _basePos;
	_watchPos = _basePos;
} else 
{
	_centerX = ( getMarkerPos _basePos ) select 0;
	_centerY = ( getMarkerPos _basePos ) select 1;
	_hT = getTerrainHeightASL ( getMarkerPos _basePos );
	_watchPos = getMarkerPos _basePos;
};

_maxDistance = ( _minDist + _range );
_tmpMaxDist = _minDist;

while { _loopMain } do 
{
    private [ "_x","_y","_wpPos", "_markerFP" ];
    _newangle = _newangle + _angleIncr;

	_x = _centerX - ( sin _newangle * _tmpMaxDist );
	_y = _centerY - ( cos _newangle * _tmpMaxDist );
	_wpPos = [ _x, _y ];		
		
	_hO = getTerrainHeightASL _wpPos;
	if ( T8U_var_DEBUG_marker ) then { _markerFP = [ _wpPos, "ICON", "mil_dot_noShadow", 0.25, "ColorBlue" ] call T8U_fnc_DebugMarker; };
		
	if ( _hO > _hT + _heightDiff ) then 
	{  
		if ( T8U_var_DEBUG_marker ) then { _markerFP setMarkerSize [ 0.5, 0.5 ]; _markerFP setMarkerColor "ColorRed"; };
		_wpPos = [ ( _wpPos select 0), ( _wpPos select 1), ( _hO + 0.5 ) ];
		_posArray pushBack _wpPos;
	};
	
	if ( _newangle > 360 ) then { _newangle = 0; _tmpMaxDist = _tmpMaxDist + _radiusIncr; };
	if ( _maxDistance < _tmpMaxDist ) then { _loopMain = false; };
};

_watchPosASL = [ ( _watchPos select 0), ( _watchPos select 1), _hT + 3 ];


if ( _skipLos ) then
{
	_losArray = _posArray;
	{ _x set [ 2, 0 ]; } count _losArray;
	
} else {
	{
		private [ "_intersectT", "_intersectL" ];
		_intersectT = terrainintersectasl [ _x, _watchPosASL ]; 
		_intersectL = lineintersects [ _x, _watchPosASL ]; 
		if ( !( _intersectL ) AND !( _intersectT ) ) then 
		{
			private [ "_okPos" ];
			if ( T8U_var_DEBUG_marker ) then { [ _x, "ICON", "mil_destroy_noShadow", 0.5, "ColorYellow" ] call T8U_fnc_DebugMarker; };
			_okPos = [ ( _x select 0 ), ( _x select 1 ), 0 ];
			_losArray pushBack _okPos;
		};
		
		false
	} count _posArray;
};

if ( T8U_var_DEBUG ) then { [ "fn_findOverwatch.sqf", "_losArray", _losArray ] spawn T8U_fnc_DebugLog; };

{
	private [ "_trees", "_bushes", "_stones" ];
	_trees = []; { if (( str _x ) find ": t_" > -1 ) then { _trees pushBack _x; }; false } count nearestObjects [ _x, [], 25 ];
	_bushes = []; { if (( str _x ) find ": b_" > -1 ) then { _bushes pushBack _x; }; false } count nearestObjects [ _x, [], 25 ];
	_stones = []; { if (( str _x ) find "stone" > -1 ) then { _stones pushBack _x; }; false } count nearestObjects [ _x, [], 25 ];
	
	if ( T8U_var_DEBUG ) then { [ "fn_findOverwatch.sqf", "_trees", ( _trees + _bushes ) ] spawn T8U_fnc_DebugLog; };
	if ( T8U_var_DEBUG ) then { [ "fn_findOverwatch.sqf", "_stones", _stones ] spawn T8U_fnc_DebugLog; };
	
	if (( count ( _trees + _bushes ) > 5 ) OR ( count _stones > 5 )) then 
	{
		if ( T8U_var_DEBUG_marker AND { count ( _trees + _bushes ) > 5 }) then { [ _x, "ICON", "mil_circle_noShadow", 0.8, "ColorGreen" ] call T8U_fnc_DebugMarker; };
		if ( T8U_var_DEBUG_marker AND { count _stones > 5 }) then { [ _x, "ICON", "loc_Rock", 1, "ColorBlack" ] call T8U_fnc_DebugMarker; };

		_returnArray pushBack _x;
	};
	
	false
} count _losArray;

if ( count _returnArray < 1 ) exitWith { _losArray };

// Return
_returnArray
