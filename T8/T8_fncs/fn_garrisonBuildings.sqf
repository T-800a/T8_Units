/*
 =======================================================================================================================

	T8 Units Script

	Funktion:	fn_garrisonBuildings.sqf
	Author:		T-800a
	E-Mail:		t-800a@gmx.net

 =======================================================================================================================
*/

private [ "_leader", "_marker", "_group", "_side", "_areaSizeX", "_areaSizeY", "_range", "_pos", "_units", "_buildingList", "_buildingPos", "_moveAround" ];

_leader		= [ _this, 0, objNull, [objNull] ] call BIS_fnc_param;
_marker		= [ _this, 1, "NO-MARKER", ["", []], [2,3] ] call BIS_fnc_param; 

_group = group _leader;
_side = side _leader;

if ( typeName _marker == typeName "testme" ) then
{
	_areaSizeX	= ( getMarkerSize _marker ) select 0;
	_areaSizeY	= ( getMarkerSize _marker ) select 1;
	_range = ( _areaSizeX + _areaSizeY ) / 2; if ( _range < 50 ) then { _range = 50; };
	
	_pos = getMarkerPos _marker;
} else {
	_pos = _marker;
	_range = 50;
};

if ( _side == CIVILIAN ) then { _units = ( units ( group _leader) ); } else { _units = ( units ( group _leader) ) - [ _leader ]; };

if ( T8U_var_DEBUG ) then { [ "fn_garrisonBuildings.sqf", "INIT", _this ] spawn T8U_fnc_DebugLog; };

if ( !( count _units > 0 ) OR { str ( _pos ) == str ([0,0,0]) } ) exitWith { _units };

_buildingList = _pos nearObjects [ "House", _range ];
_buildingPos = [];
_moveAround = [];

{
	private [ "_b" ];
	_b = _x;
	if !( _b getvariable [ "occupied", false ] ) then
	{
		private [ "_loop", "_n" ];
		_loop = true;
		_n = 0;
		while { _loop } do
		{
			if ( str( _b buildingPos _n ) != str( [0,0,0] ) ) then 
			{
				_buildingPos pushBack [ _b buildingPos _n, _b ];
			} else {
				_loop = false;
			}; 
			_n = _n + 1;
		};
	};
} forEach _buildingList;

if ( T8U_var_DEBUG ) then { [ "fn_garrisonBuildings.sqf", "_buildingList", _buildingList ] spawn T8U_fnc_DebugLog; };
if ( T8U_var_DEBUG ) then { [ "fn_garrisonBuildings.sqf", "_buildingPos", _buildingPos ] spawn T8U_fnc_DebugLog; };

_buildingPos = _buildingPos call BIS_fnc_arrayShuffle;

if ( count _buildingPos > 0 ) then 
{
	{
		private [ "_unit", "_b", "_p" ];
		_b = _x select 1;
		_p = _x select 0;
			
		if ( count _units > 0 ) then 
		{
			_unit = _units call BIS_fnc_arrayPop;
			[ _unit, _p ] spawn T8U_fnc_MoveToPos;
			_unit setVariable [ "T8U_uvar_OccupiedPos", [ _p, _b ], false ];
		} else {
			_moveAround pushBack [ _p, _b ];
		};
		_b setvariable [ "occupied", true, false ];	
		if ( count _moveAround > 9 ) exitWith { false };
		
		false
	} count _buildingPos;
};

if ( count _units > 0 OR { count _moveAround > 9 } ) then
{
	private [ "_coverArray" ];
	_coverArray = [ _pos, _range ] call T8U_fnc_GetCoverPos;
	_coverArray = _coverArray call BIS_fnc_arrayShuffle;
	{
		if ( count _units > 0 ) then 
		{
			_unit = _units call BIS_fnc_arrayPop;
			[ _unit, _x, true ] spawn T8U_fnc_MoveToPos;
			_unit setVariable [ "T8U_uvar_OccupiedPos", [ _x, "cover" ], false ];
		} else {
			_moveAround pushBack [ _x, "cover" ];
		};
		
		if ( count _moveAround > 19 ) exitWith { false };
		
		false
	} count _coverArray;
};

if ( T8U_var_DEBUG ) then { [ "fn_garrisonBuildings.sqf", "_moveAround", _moveAround ] spawn T8U_fnc_DebugLog; };

_group setVariable [ "T8U_gvar_garrisoning", true, false ];
if ( T8U_var_DEBUG ) then { [ "fn_garrisonBuildings.sqf", "FINISHED GARRISONING", [ _group ] ] spawn T8U_fnc_DebugLog; };


private [ "_loop", "_t", "_moveUnits", "_switchTime" ];
_loop = true;
_t = time;

if ( _side == CIVILIAN ) then { _moveUnits = ( units _group ); } else { _moveUnits = ( units _group ) - [ _leader ]; };

_switchTime = if ( _side == CIVILIAN ) then { 10 } else { 25 };

while { _loop } do 
{
	if ( ( _t + _switchTime + random _switchTime ) < time ) then
	{
		private [ "_u", "_newPos", "_oldPos" ];
		_u = _moveUnits call BIS_fnc_selectRandom;
		_newPos = [];
		_oldPos = [];
		if ( count _moveAround > 1 ) then { _newPos = [ _moveAround ] call BIS_fnc_arrayShift; };
		
		if ( count _newPos > 1 ) then
		{
			if ( T8U_var_DEBUG ) then { [ "fn_garrisonBuildings.sqf", "[ _u, _moveUnits, _newPos ]", [ _u, _moveUnits, _newPos ] ] spawn T8U_fnc_DebugLog; };
			
			if ( typeName ( _newPos select 1 ) == typeName "ABC" AND { ( _newPos select 1 ) == "cover" } ) then
			{
				[ _u, ( _newPos select 0 ), true ] spawn T8U_fnc_MoveToPos;
			} else {
				[ _u, ( _newPos select 0 ) ] spawn T8U_fnc_MoveToPos;
			};
			
			_oldPos = _u getVariable [ "T8U_uvar_OccupiedPos", [] ];
			_moveAround pushBack _oldPos;
			_u setVariable [ "T8U_uvar_OccupiedPos", _newPos, false ];
		};
		_t = time;
		
		if ( T8U_var_DEBUG ) then { [ "fn_garrisonBuildings.sqf", "OCCU POS VARS", [ _oldPos, _newPos, _moveAround ] ] spawn T8U_fnc_DebugLog; };
	};
	
	sleep 2;
//	if ( T8U_var_DEBUG ) then { [ "fn_garrisonBuildings.sqf", "Waiting...", [ _group ] ] spawn T8U_fnc_DebugLog; };
	
	if ( _side == CIVILIAN ) then 
	{

		if ( isNull _group OR ( count ( units _group ) ) < 1 ) then { _loop = false; if ( T8U_var_DEBUG ) then { [ "fn_garrisonBuildings.sqf", "Kill while", [ _group ] ] spawn T8U_fnc_DebugLog; }; };
	
	
	} else {
	
		if ( 
			isNull _group
			OR !alive _leader
			OR ( count ( units _group ) ) < 1
			OR !( _group getVariable [ "T8U_gvar_garrisoning", false ] )
		) then { _loop = false; if ( T8U_var_DEBUG ) then { [ "fn_garrisonBuildings.sqf", "Kill while", [ _group ] ] spawn T8U_fnc_DebugLog; }; };
		
		if ( ( group _leader ) getVariable [ "T8U_gvar_Assigned", "ERROR" ] != "NO_TASK" ) then { _loop = false; if ( T8U_var_DEBUG ) then { [ "fn_garrisonBuildings.sqf", "Kill while", [ _group ] ] spawn T8U_fnc_DebugLog; }; };	
	};
	
	if ( ! _loop ) exitWith {};
};

sleep 2;

// Remove occupation
{ _x setvariable [ "occupied", false, false ]; } count _buildingList;

if ( isNull _group OR { count ( units _group ) < 1 } ) exitWith { if ( T8U_var_DEBUG ) then { [ "fn_garrisonBuildings.sqf", "TERMINATING", [ _group ] ] spawn T8U_fnc_DebugLog; }; };

if ( _group getVariable [ "T8U_gvar_garrisoning", false ] ) then 
{
	if ( alive _leader ) then { [ _leader ] call T8U_fnc_GetOutCover; } else { waitUntil { sleep 2; _leader != leader _group }; sleep 2; };
	
	{ [ _x ] joinSilent _group } forEach ( units _group );
	[ _group ] call T8U_fnc_ForceNextWP;

} else {
	{ [ _x ] joinSilent _group } forEach ( units _group );
};
[ "fn_garrisonBuildings.sqf", "-- END --", [ _group ] ] spawn T8U_fnc_DebugLog;