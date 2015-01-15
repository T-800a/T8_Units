/*
 =======================================================================================================================

	Script: overwatch.sqf
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
	null = [ group this, "MY_MARKER" ] execVM "overwatch.sqf"
	null = [ group this, "MY_MARKER", false, true ] execVM "overwatch.sqf"  // not an infantry group, debug enabled

 =======================================================================================================================
*/

private [	"_group", "_marker", "_infGroup", "_debugArray", "_originUnits", "_formation", "_statement", "_wpPos", "_loop", "_tmpAreaSize", "_hT", "_leaderPos", "_wpArray", "_loopMain", 
			"_newangle", "_maxDistance", "_tmpMaxDist", "_centerX", "_centerY", "_watchPos", "_watchPosASL", "_wpArrayOK", "_selectPos", "_overwatchPos", "_wp", "_behaviour" ];

_group			= [ _this, 0, objNull ] call BIS_fnc_param;
_marker			= [ _this, 1, "NO-MARKER-SET", [ "" ] ] call BIS_fnc_param;
_minDist		= [ _this, 2, 250, [ 123 ] ] call BIS_fnc_param;
_range			= [ _this, 3, 300, [ 123 ] ] call BIS_fnc_param;
_infGroup		= [ _this, 4, true, [ true ] ] call BIS_fnc_param;

if ( T8U_var_DEBUG ) then { [ "overwatch.sqf", "INIT", _this ] spawn T8U_fnc_DebugLog; };

if ( isNull _group OR { str ( getMarkerPos _marker ) == str ([0,0,0]) } ) exitWith { false };

if ( _infGroup ) then
{
	_formation = ["STAG COLUMN", "WEDGE", "ECH LEFT", "ECH RIGHT", "VEE", "DIAMOND"] call BIS_fnc_selectRandom;
	_statement = "[ this ] spawn T8U_fnc_GetOutVehicle;";
} else {
	_formation = "COLUMN";
	_statement = "";
};

_wpPos = [];
_debugArray = [];
_hT = getTerrainHeightASL ( getMarkerPos _marker ); 
_leaderPos = getPos ( leader _group );
_wpArray = [];
_loopMain = true;
_newangle = 0;
_maxDistance = ( _minDist + _range );
_tmpMaxDist = _minDist;
_centerX = ( getMarkerPos _marker ) select 0;
_centerY = ( getMarkerPos _marker ) select 1;
_hT = getTerrainHeightASL ( getMarkerPos _marker ); 

while { _loopMain } do 
{
    private [ "_x","_y","_wpPos", "_wpPosFEP", "_loop", "_markerName", "_markerFP" ];
    _newangle = _newangle + 5;
	_loop = true; 
	

	_x = _centerX - ( sin _newangle * _tmpMaxDist );
	_y = _centerY - ( cos _newangle * _tmpMaxDist );
	_wpPos = [ _x, _y ];		
	if ( surfaceIsWater _wpPos ) then { _loop = false; };
		
	_hO = getTerrainHeightASL _wpPos;
	if ( T8U_var_DEBUG_marker ) then { _markerFP = [ _wpPos, "ICON", "mil_dot_noShadow", 0.25, "ColorBlue" ] call T8U_fnc_DebugMarker; _debugArray pushBack _markerFP; };
		
	if ( _hO > _hT + 20 ) then 
	{  
		_loop = false;
		if ( T8U_var_DEBUG_marker ) then { _markerFP setMarkerSize [ 0.5, 0.5 ]; _markerFP setMarkerColor "ColorRed"; };
		_wpPos = [ ( _wpPos select 0), ( _wpPos select 1), ( _hO + 0.5 ) ];
		_wpArray pushBack _wpPos;
	} else { 
		_loop = false; 
	};
	
	if ( _newangle > 360 ) then { _newangle = 0; _tmpMaxDist = _tmpMaxDist + 25; };
	if ( _maxDistance < _tmpMaxDist ) then { _loopMain = false; };
};

_watchPos = getMarkerPos _marker;
_watchPosASL = [ ( _watchPos select 0), ( _watchPos select 1), _hT + 3 ];
_wpArrayOK = [];

{
	private [ "_intersectT", "_intersectL" ];
	_intersectT = terrainintersectasl [ _x, _watchPosASL ]; 
	_intersectL = lineintersects [ _x, _watchPosASL ]; 
	if ( !( _intersectL ) AND !( _intersectT ) ) then 
	{
		private [ "_okPos" ];
		if ( T8U_var_DEBUG_marker ) then { private [ "_markerFP" ]; _markerFP = [ _x, "ICON", "mil_destroy_noShadow", 0.5, "ColorYellow" ] call T8U_fnc_DebugMarker; _debugArray pushBack _markerFP; };
		_okPos = [ ( _x select 0 ), ( _x select 1 ), 0 ];
		_wpArrayOK = _wpArrayOK + [ _okPos ];
	};
} forEach _wpArray;

if ( T8U_var_DEBUG ) then { [ "overwatch.sqf", "_wpArrayOK", _wpArrayOK ] spawn T8U_fnc_DebugLog; };

_selectPos = _wpArrayOK call BIS_fnc_selectRandom;

if ( isNil "_selectPos" ) then { _selectPos = []; };

if ( T8U_var_DEBUG_marker ) then { [ _debugArray ] spawn { private [ "_dA" ]; _dA = _this select 0; sleep 5; { deleteMarker _x; } count _dA; }; };	

if ( count _selectPos > 0 ) then
{
	_overwatchPos = [ _selectPos select 0, _selectPos select 1, 0 ];

	if ( T8U_var_DEBUG ) then { [ "overwatch.sqf", "_overwatchPos", [ _overwatchPos ] ] spawn T8U_fnc_DebugLog; };
	if ( T8U_var_DEBUG_marker ) then { [ _overwatchPos, "ICON", "mil_circle_noShadow", 0.5, "ColorRed", 0.66, " do OV from here" ] call T8U_fnc_DebugMarker; };

	_group setBehaviour "AWARE";
	_group setSpeedMode "FULL";
	_group setFormation _formation;

	[ _group, _overwatchPos, "MOVE", "AWARE", "( group this ) setVariable [ 'overwatchOnPos', true, false ];", 50, "FULL", [ 5, 5, 5 ] ] call T8U_fnc_CreateWP;
	[ _group, _overwatchPos, "GUARD", "AWARE", _statement, 10, "FULL", [ 0, 0, 0 ] ] call T8U_fnc_CreateWP;	
	
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

	[ _group, _overwatchPos, "SAD", "SAFE", _statement, 50, "LIMITED", [ 10, 20, 30 ] ] call T8U_fnc_CreateWP;
	[ _group, _overwatchPos, "MOVE", "SAFE", "( group this ) setCurrentWaypoint [ ( group this ), ( ( count waypoints group this ) - 2 ) ];", 10, "LIMITED" ] call T8U_fnc_CreateWP;	
	
	if ( T8U_var_DEBUG_marker ) then { [ _overwatchPos, "ICON", "mil_destroy_noShadow", 0.5, "ColorRed", 0.66, " do SAD here" ] call T8U_fnc_DebugMarker; };
};

if ( T8U_var_DEBUG ) then { [ "overwatch.sqf", "Successfully Initialized", [ _group ] ] spawn T8U_fnc_DebugLog; };

// Return
true
