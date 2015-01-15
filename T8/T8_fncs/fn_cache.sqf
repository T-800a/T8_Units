/*
 =======================================================================================================================

	T8 Units Script

	Funktion:	fn_cache.sqf
	Author:		T-800a
	E-Mail:		t-800a@gmx.net

 =======================================================================================================================
*/

private [	"_unitsArray", "_marker", "_owner", "_zoneDone", "_areaSizeX", "_areaSizeY", "_nearUnits", "_groupsAll", "_groups", "_compiledArray",
			"_unitsToDelete", "_unitsArrayOld", "_unitsArrayNew", "_b" ];

_unitsArray		= [ _this, 0, "NO-ARRAY-SET" ] call BIS_fnc_param;
_marker			= [ _this, 1, "NO-MARKER-SET" ] call BIS_fnc_param;
_owner			= toUpper ( [ _this, 2, "NO-SIDE-SET" ] call BIS_fnc_param );

_zoneDone = missionNamespace getVariable str( _unitsArray + "_created" );
_zoneAktiv = missionNamespace getVariable str( _unitsArray + "_active" );
if ( isNil "_zoneAktiv" ) then { _zoneAktiv = true; };

if ( _zoneAktiv ) exitWith { if ( T8U_var_DEBUG ) then { [ "fn_cache.sqf", "ZONE AKTIVE - NO CACHING", _this ] spawn T8U_fnc_DebugLog; }; };
if ( ! _zoneDone ) exitWith { if ( T8U_var_DEBUG ) then { [ "fn_cache.sqf", "COULD NOT CACHE", _this ] spawn T8U_fnc_DebugLog; }; };
if ( typeName ( missionNamespace getVariable _unitsArray ) == "BOOL" ) exitWith { if ( T8U_var_DEBUG ) then { [ "fn_cache.sqf", "NO CACHING - EVERYBODY WAS DEAD LAST TIME", _this ] spawn T8U_fnc_DebugLog; }; };

if ( T8U_var_DEBUG ) then { [ ">> %1 >>>>>>>>>> T8U_fnc_Cache >> %2 >> %3 ", time, _unitsArray, _marker  ] call BIS_fnc_error; };

_areaSizeX	= ( getMarkerSize _marker ) select 0;
_areaSizeY	= ( getMarkerSize _marker ) select 1;
_nearUnits = ( getMarkerPos _marker) nearEntities [ [ "All" ], ( _areaSizeX + _areaSizeY ) / 2 + ( _areaSizeX + _areaSizeY ) / 5 ];
_groupsAll = [];
_groups = [];
{
	if ( !( group _x in _groupsAll ) AND { str ( side _x ) == _owner } ) then { _groupsAll = _groupsAll + [ group _x ]; };
} forEach _nearUnits;

{
	private [ "_check" ];
	_check = _x getVariable "T8U_gvar_Origin";
	if ( ! isNil "_check" ) then
	{
		_groups pushBack _x;
	};
} forEach _groupsAll;

_compiledArray = [];
_unitsToDelete = [];

{	// forEach -> _groups
	private [ "_commArray", "_originArray", "_memberArray", "_groupArray", "_typeOfArray", "_vehicles" ];
	_commArray = _x getVariable "T8U_gvar_Comm";
	_originArray = _x getVariable "T8U_gvar_Origin";
	_memberArray = _x getVariable "T8U_gvar_Member";

	_typeOfArray = [];
	_vehicles = [];

	{	// forEach -> _memberArray
		if ( alive _x ) then
		{
			private [ "_typeOf", "_v", "_typeOfVehicle" ];

			_v = assignedVehicle _x;
			if ( side _v == side _x AND { alive _v } AND { !( _originArray select 2 ) } ) then
			{
				if ( !( _v in _vehicles ) ) then 
				{
					_vehicles pushBack _v;
					_typeOfVehicle = typeof _v;
					_typeOfArray pushBack _typeOfVehicle;
					_memberArray pushBack _v;
				};
			} else {
				_typeOf = typeof _x;
				_typeOfArray pushBack _typeOf;
			};
		};
	} forEach _memberArray;

	// _originArray = [ _posMkr, _type, _infGroup, _taskArray ];
	_groupArray = [ [ _typeOfArray, ( _originArray select 0 ), ( _originArray select 2 ), side _x, ( _originArray select 4 ) ], ( _originArray select 3 ),  _commArray  ];

	_compiledArray pushBack _groupArray;
	_unitsToDelete = _unitsToDelete + _memberArray;
} forEach _groups;

_unitsArrayOld = missionNamespace getVariable _unitsArray;

if ( T8U_var_DEBUG ) then { [ "fn_cache.sqf", "_unitsArrayOld", _unitsArrayOld ] spawn T8U_fnc_DebugLog; };
if ( T8U_var_DEBUG ) then { [ "fn_cache.sqf", "_compiledArray", _compiledArray ] spawn T8U_fnc_DebugLog; };

missionNamespace setVariable [ _unitsArray, _compiledArray ];

_unitsArrayNew = missionNamespace getVariable _unitsArray;
if ( T8U_var_DEBUG ) then { [ "fn_cache.sqf", "_unitsArrayNew", _unitsArrayNew ] spawn T8U_fnc_DebugLog; };

{ _x removeAllEventHandlers "Killed"; _x removeAllEventHandlers "FiredNear"; deleteVehicle _x; } forEach _unitsToDelete;
{ deleteGroup _x; } forEach _groups;

missionNamespace setVariable [ str( _unitsArray + "_created" ), false ];

if ( T8U_var_DEBUG AND { T8U_var_DEBUG_hints } ) then { private [ "_msg" ]; _msg = format [ "Units at %1 are cached!<br />The array has %2 groups.", _unitsArray, ( count _compiledArray ) ]; [ _msg ] call T8U_fnc_BroadcastHint; };
if ( count _compiledArray <= 0 ) then { missionNamespace setVariable [ _unitsArray, true ]; };


// reset houses for re-garrisoning ...
_b = nearestObjects [ ( getMarkerPos _marker), [ "HOUSE" ], ( _areaSizeX + _areaSizeY ) / 2 + ( _areaSizeX + _areaSizeY ) / 2 ];
{ _x setvariable [ "occupied", false, false ];  } forEach _b;