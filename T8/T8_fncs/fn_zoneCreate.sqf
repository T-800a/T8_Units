/*
 =======================================================================================================================

	T8 Units Script

	Funktion:	fn_zoneCreate.sqf
	Author:		T-800a
	E-Mail:		t-800a@gmx.net

 =======================================================================================================================
*/

private [ "_array", "_string", "_zoneCreating", "_zoneDone", "_done" ];
_array = _this select 0;
_string = _this select 1;

if ( T8U_var_DEBUG ) then { [ "fn_zoneCreate.sqf", "INIT", _this ] spawn T8U_fnc_DebugLog; };

if ( typeName ( missionNamespace getVariable _string ) == "BOOL" ) exitWith {};

missionNamespace setVariable [ str( _string + "_active" ), true ];

_zoneCreating = missionNamespace getVariable str( _string + "_creating" );
if ( isNil "_zoneCreating" ) then { _zoneCreating = false; };
if ( _zoneCreating ) exitWith { if ( T8U_var_DEBUG ) then { [ "fn_zoneCreate.sqf", "ZONE CREATION IN PROCESS", [ _string ] ] spawn T8U_fnc_DebugLog; }; };
missionNamespace setVariable [ str( _string + "_creating" ), true ];

_zoneDone = missionNamespace getVariable str( _string + "_created" );
if ( isNil "_zoneDone" ) then { _zoneDone = false; };
if ( _zoneDone ) exitWith { missionNamespace setVariable [ str( _string + "_creating" ), false ]; if ( T8U_var_DEBUG ) then { [ "fn_zoneCreate.sqf", "ZONE IS ALREADY CREATED", [ _string ] ] spawn T8U_fnc_DebugLog; }; };

_done = [ _array ] call T8U_fnc_Spawn;
if ( _done ) then
{
	missionNamespace setVariable [ str( _string + "_created" ), true ];
} else {
	missionNamespace setVariable [ str( _string + "_created" ), false ];
};

missionNamespace setVariable [ str( _string + "_creating" ), false ];

if ( T8U_var_DEBUG ) then { [ "fn_zoneCreate.sqf", "ZONE CREATED", [ _string, ( missionNamespace getVariable str( _string + "_created" )) ] ] spawn T8U_fnc_DebugLog; };
