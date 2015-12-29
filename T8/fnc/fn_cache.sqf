/*
 =======================================================================================================================

	T8 Units Script

	Funktion:	fn_cache.sqf
	Author:		T-800a
	E-Mail:		t-800a@gmx.net

 =======================================================================================================================
*/

#include <..\MACRO.hpp>

private [	"_unitsArray", "_marker", "_owner", "_areaSizeX", "_areaSizeY", "_nearUnits", "_groupsAll", "_groups", "_compiledArray",
			"_unitsToDelete", "_unitsArrayOld", "_unitsArrayNew", "_b" ];

_unitsArray		= param [ 0, "NO-ARRAY-SET" ];
_marker			= param [ 1, "NO-MARKER-SET" ];
_owner			= param [ 2, "NO-SIDE-SET" ];
_owner			= toUpper _owner;

private [ "_created", "_creating", "_active" ];
_created		= __GetMVAR(  str( _unitsArray + "_created" ),	"ERROR" );
_creating		= __GetMVAR(  str( _unitsArray + "_creating" ),	"ERROR" );
_active			= __GetMVAR(  str( _unitsArray + "_active" ),	"ERROR" );

__DEBUG( __FILE__, "ZONE CACHING", "=======================================" );
__DEBUG( __FILE__, "ZONE",								_unitsArray );
__DEBUG( __FILE__, str( _unitsArray + "_created" ),		_created );
__DEBUG( __FILE__, str( _unitsArray + "_creating" ),	_creating );
__DEBUG( __FILE__, str( _unitsArray + "_active" ),		_active );

if ( _active	OR {( typeName _active ) isEqualTo ( typeName "" )}) exitWith	{ __DEBUG( __FILE__, "ZONE AKTIVE - NO CACHING", _this ); };
if ( !_created	OR {( typeName _created ) isEqualTo ( typeName "" )}) exitWith	{ __DEBUG( __FILE__, "COULD NOT CACHE", _this ); };

if ( typeName ( missionNamespace getVariable _unitsArray ) == "BOOL" ) exitWith { __DEBUG( __FILE__, "NO CACHING - EVERYBODY WAS DEAD LAST TIME", _this ); };

__DEBUG( __FILE__, "_unitsArray", _marker );

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
	_check = __GetOVAR( _x, "T8U_gvar_Origin", [] );
	if ( count _check > 0 ) then { _groups pushBack _x; };
} forEach _groupsAll;

_compiledArray = [];
_unitsToDelete = [];

{	// forEach -> _groups
	private [ "_commArray", "_originArray", "_memberArray", "_spawnPos", "_groupArray", "_typeOfArray", "_vehicles" ];
	
	_commArray		= __GetOVAR( _x, "T8U_gvar_Comm", [] );
	_originArray	= __GetOVAR( _x, "T8U_gvar_Origin", [] );
	_memberArray	= __GetOVAR( _x, "T8U_gvar_Member", [] );

	_spawnPos		= getPos ( leader _x );
	
	_typeOfArray	= [];
	_vehicles		= [];

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
	
	// _originArray = [ _markerArray, _type, _infGroup, _taskArray, _customFNC ];
	_groupArray = [ [ _typeOfArray, ( _originArray select 0 ), ( _originArray select 2 ), side _x, ( _originArray select 4 ) ], ( _originArray select 3 ),  _commArray, [ _spawnPos ]];

	_compiledArray pushBack _groupArray;
	_unitsToDelete = _unitsToDelete + _memberArray;
} forEach _groups;

_unitsArrayOld = __GetMVAR( _unitsArray, [] );

__DEBUG( __FILE__, "_unitsArrayOld", _unitsArrayOld );
__DEBUG( __FILE__, "_compiledArray", _compiledArray );

__SetMVAR( _unitsArray, _compiledArray );

_unitsArrayNew =  __GetMVAR( _unitsArray, [] );
__DEBUG( __FILE__, "_unitsArrayNew", _unitsArrayNew );

{ _x removeAllEventHandlers "Killed"; _x removeAllEventHandlers "FiredNear"; deleteVehicle _x; } forEach _unitsToDelete;
{ deleteGroup _x; } forEach _groups;

__SetMVAR( str( _unitsArray + "_created" ), false );

if ( T8U_var_DEBUG AND { T8U_var_DEBUG_hints } ) then { private [ "_msg" ]; _msg = format [ "Units at %1 are cached!<br />The array has %2 groups.", _unitsArray, ( count _compiledArray ) ]; [ _msg ] call T8U_fnc_BroadcastHint; };
if ( count _compiledArray < 1 ) then {  __SetMVAR( _unitsArray, true ); };


// reset houses for re-garrisoning ...
_b = nearestObjects [ ( getMarkerPos _marker), [ "HOUSE" ], ( _areaSizeX + _areaSizeY ) / 2 + ( _areaSizeX + _areaSizeY ) / 2 ];
{ __SetOVAR( _x, "occupied", false ); } forEach _b;