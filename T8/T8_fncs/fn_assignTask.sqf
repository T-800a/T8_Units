/*
 =======================================================================================================================

	T8 Units Script

	Funktion:	fn_assignTask.sqf
	Author:		T-800a
	E-Mail:		t-800a@gmx.net
	
	Returns:	_groupHelper / the new group with assigned tasks

 =======================================================================================================================
*/

private [	"_unitCaller", "_unitHelper", "_unitTarget", "_time", "_groupCaller", "_groupHelper", "_infGroup", "_type", "_typeTask", "_posToGo", "_sFPlvb", "_sEP", "_wpArray", "_wpAdd" ];

_unitCaller		= [ _this, 0, objNull, [objNull] ] call BIS_fnc_param;
_unitHelper		= [ _this, 1, objNull, [objNull] ] call BIS_fnc_param;
_unitTarget		= [ _this, 2, objNull, [objNull] ] call BIS_fnc_param;
_typeTask		= [ _this, 3, "DC_ASSIST", [""] ] call BIS_fnc_param;
_time			= [ _this, 4, 10, [123] ] call BIS_fnc_param;

if ( T8U_var_DEBUG ) then { [ "fn_assignTask.sqf", "INIT", _this ] spawn T8U_fnc_DebugLog; };
if ( _unitCaller == objNull OR { _unitHelper == objNull } OR { _unitTarget == objNull } ) exitWith { if ( T8U_var_DEBUG ) then { [ "fn_assignTask.sqf", "ERROR WITH UNITS" ] spawn T8U_fnc_DebugLog; }; };
if ( T8U_var_DEBUG AND { T8U_var_DEBUG_marker } ) then { [ getPos _unitCaller, "ICON", "mil_start_noShadow", 1, "ColorBlack", 0.33 ] call T8U_fnc_DebugMarker; };

_groupCaller	= group _unitCaller;
_groupHelper	= group _unitHelper;

_infGroup		= ( _groupHelper getVariable [ "T8U_gvar_Origin", [ "error", false, "error" ] ] ) select 2;
_type			= ( _groupHelper getVariable [ "T8U_gvar_Origin", [ "error", false, "error" ] ] ) select 1;

_wpArray		= [];

_posToGo		= getPos _unitTarget;

/* wp statements: 
	- _sFPlvb:	- leave vehicle behind for later aquire
	- _sEP:		- leave vehicle on end Pos for Infgroup
				- dont leave vehicle on end Pos for non Infgroup		*/
_sFPlvb		= "[ group this, assignedVehicle this ] spawn { sleep 180; ( _this select 0 ) addVehicle ( _this select 1 ); }; [ this ] spawn T8U_fnc_GetOutVehicle;";
if ( _infGroup ) then { _sEP = format [ "( units ( group this ) ) orderGetIn false; [ group this, %1 ] spawn T8U_fnc_RedoOriginTask", _time ]; } else { _sEP = format ["[ group this, %1 ] spawn T8U_fnc_RedoOriginTask", _time ]; };

_wpAdd = 
{
	private [ "_g", "_p", "_wt", "_cm", "_s", "_r", "_a" ]; 
	
	_g	= _this select 0;
	_p	= _this select 1;
	_wt	= _this select 2;
	_cm	= _this select 3;
	_s	= _this select 4;
	_r	= _this select 5;
	
	_a = [ _g, _p, _wt, _cm, _s, _r ];

	_wpArray pushBack _a;
	
	// Return
	true
};

_groupHelper setVariable [ "T8U_gvar_Assigned", _typeTask, false ];

// WAIT for garrisoned groups to properly regroup!
if ( _type == "GARRISON" OR _type == "PATROL_GARRISON" ) then 
{
	private [ "_t", "_r" ];
	_r = false;
	_t = time + 30;

	waitUntil
	{
		sleep 1;
		_r = _groupHelper getVariable [ "T8U_gvar_Regrouped", false ];
		if ( isNil "_r" ) then { _r = false; };
		if ( time > _t ) exitWith { if ( T8U_var_DEBUG ) then { [ "fn_assignTask.sqf", "isNil _r", [] ] spawn T8U_fnc_DebugLog; }; };
		_r
	};
};

if ( isNull _groupHelper ) exitWith { if ( T8U_var_DEBUG ) then { [ "fn_assignTask.sqf", "EXIT >> GroupNull", [] ] spawn T8U_fnc_DebugLog; }; };

// clear old waypoints, regroup, ...
_groupHelper = [ _groupHelper ] call T8U_fnc_GroupClearWP;

sleep 1;

// DC_ASSIST, HOLD_POS, FLANK_ATTACK, CQC_SHOT

switch ( _typeTask ) do 
{ 
	case "DC_ASSIST": 
	{
		private [ "_d", "_v", "_veh", "_fpA", "_fp" ];

		_fpA	= [ _unitCaller, _unitTarget ] call T8U_fnc_CreateFlankingPos;
		_fp		= [ _fpA, getPos _unitHelper ] call BIS_fnc_nearestPosition;	
		_d = _unitHelper distance _fp;

		_v = nearestObjects [ ( getPos _unitHelper ), T8U_var_ReinforceVehicle, 150 ];
		{ if ( count ( crew _x ) > 0 ) then { _v = _v - [ _x ]; }; } forEach _v;

		if ( _infGroup AND { _d > 500 } ) then
		{
			if ( count _v > 0 ) then
			{
				private [ "_veh", "_parkPosition", "_debugText", "_markerParkPosition" ];

				_veh = _v call BIS_fnc_selectRandom;
				_groupHelper addVehicle _veh;
				{ if ( isFormationLeader _x ) then { _x assignAsDriver _veh; } else { _x assignAsCargo _veh; }; } foreach ( units _groupHelper );
				( units _groupHelper ) orderGetIn true;
				sleep 2;

				[ _groupHelper, _fp, "MOVE", "AWARE", _sFPlvb, 50 ] call _wpAdd;
				if ( T8U_var_DEBUG ) then { [ "fn_assignTask.sqf", "DC_ASSIST: INF >> BY CAR", [ _unitHelper ] ] spawn T8U_fnc_DebugLog; };
			} else {
				[ _groupHelper, _fp, "MOVE", "AWARE", "", 50 ] call _wpAdd;
				if ( T8U_var_DEBUG ) then { [ "fn_assignTask.sqf", "DC_ASSIST: INF >> BY FOOT", [ _unitHelper ] ] spawn T8U_fnc_DebugLog; };
			};

		} else {
			[ _groupHelper, _fp, "MOVE", "AWARE", "", 50 ] call _wpAdd;
			if ( T8U_var_DEBUG ) then { [ "fn_assignTask.sqf", "DC_ASSIST: VEH", [ _unitHelper ] ] spawn T8U_fnc_DebugLog; };
		};
		
		[ _groupHelper, _posToGo, "SAD", "COMBAT", _sEP, 25 ] call _wpAdd;
	};


	case "HOLD_POS": 
	{
		[ _groupHelper, _infGroup, _posToGo, _time ] spawn T8U_task_Hold;
		// [ _groupHelper, getPos _unitHelper, "MOVE", "COMBAT", _sEP, 25 ] call _wpAdd;
	};


	case "FLANK_ATTACK": 
	{
		private [ "_fpA", "_fpB", "_fp", "_sp"  ];
		_fpA	= [ _unitCaller, _unitTarget, 0.66 ] call T8U_fnc_CreateFlankingPos;
		_fpB	= [ _unitTarget, _unitCaller, 0.66 ] call T8U_fnc_CreateFlankingPos;
		_fp		= [ _fpA, getPos _unitHelper ] call BIS_fnc_nearestPosition;
		_sp		= [ _fpB, _fp ] call BIS_fnc_nearestPosition;
		
		[ _groupHelper, _sp, "MOVE", "COMBAT", "", 25 ] call _wpAdd;
		[ _groupHelper, _fp, "MOVE", "COMBAT", "", 25 ] call _wpAdd;
		[ _groupHelper, _posToGo, "SAD", "COMBAT", _sEP, 25 ] call _wpAdd;
	};


	case "CQC_SHOT": 
	{
		private [ "_fpA", "_fp" ];
		[ _groupHelper, _posToGo, "SAD", "COMBAT", _sEP, 25 ] call _wpAdd;
	};
	
	default
	{
		private [ "_msg" ]; _msg = format [ "The assigned task %1 does not exist! WTF?!<br /><br /> Call 0800 - T800A#WTFH for help. Not!", _type ]; [ _msg ] call T8U_fnc_BroadcastHint;
	};
};

{
	if ( T8U_var_DEBUG ) then { [ "fn_assignTask.sqf", "CREATE WP", [ _unitHelper, _x ] ] spawn T8U_fnc_DebugLog; };
	[
		_x select 0,
		_x select 1,
		_x select 2,
		_x select 3,
		_x select 4,
		_x select 5
	] call T8U_fnc_CreateWP;
	
	if ( T8U_var_DEBUG AND { T8U_var_DEBUG_marker } ) then { private [ "_dmt" ]; _dmt = format [ "%1 [%2]", _groupHelper, _x select 2 ]; [ _x select 1, "ICON", "waypoint", 1, "ColorBlack", 0.33, _dmt  ] call T8U_fnc_DebugMarker; };
	
} forEach _wpArray;

_groupHelper setVariable [ "T8U_gvar_Assigned", _typeTask, false ];

leader _groupHelper addEventHandler ["FiredNear", { [ _this ] call T8U_fnc_FiredEvent; }];
leader _groupHelper addEventHandler ["Killed", { [ _this ] spawn T8U_fnc_KilledEvent; }];
[ _groupHelper ] spawn T8U_fnc_OnFiredEvent;
if ( T8U_var_AllowCBM ) then { [ _groupHelper ] spawn T8U_fnc_CBM; };

_groupHelper
