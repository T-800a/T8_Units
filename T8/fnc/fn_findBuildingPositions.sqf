/*
 =======================================================================================================================

	T8 Units Script
	
	Funktion:	fn_findBuildingPositions.sqf
	Author:		T-800a
	E-Mail:		t-800a@gmx.net

	[ nearestBuilding player ] spawn T8U_fnc_fn_findBuildingPositions;
	
 =======================================================================================================================
*/

#include <..\MACRO.hpp>

params [
	[ "_building", objNull, [objNull]]
];

private _buildingPos = [];
private _buildingDir = getDir _building;

if !( _building getvariable [ "occupied", false ] ) then
{
	private _loop = true;
	private _n = 0;

	while { _loop } do
	{
		if !(( _building buildingPos _n ) isEqualTo [0,0,0] ) then { _buildingPos pushBack ( _building buildingPos _n ); } else { _loop = false; };
		_n = _n + 1;
	};
};

hint str _buildingPos;
sleep 1;

T8U_var_DEBUG_darwLines = [];

{
	private _pos = _x;
	private _start = ATLToASL [( _pos select 0 ), ( _pos select 1 ), (( _pos select 2 ) +  1.2 )];
	private _above = ATLToASL [( _pos select 0 ), ( _pos select 1 ), (( _pos select 2 ) + 20.0 )];
	
	private _dis = 0;
	private _use = [];
	
	if ( lineIntersects [ _start, _above ]) then
	{
		{
			private _dir = ( _buildingDir + _x );
			private _end = [(( _start select 0 ) + sin _dir * 10 ), ((_start select 1) + cos _dir * 10 ), ( _start select 2 )];

			_window	= lineIntersects [ _start, _end ];
			createVehicle [ "Sign_Sphere10cm_F", ASLToATL _start, [], 0, "CAN_COLLIDE" ];	
			
			if ( ! _window ) then
			{
				if (( _end distance2D ( getPos _building )) > _dis ) then { _use = [ _start, _end, [0,1,0,1]]; _dis = ( _end distance2D ( getPos _building )); };
			};
			
			false
		} count [ 0, 90, 180, 270 ];

		if (( count _use ) > 0 ) then { T8U_var_DEBUG_darwLines pushBack _use; };
	};
	
	false
} count _buildingPos;


T8U_fnc_DEBUG_darwLines = 
{
	{
		drawLine3D [ ASLToATL ( _x select 0 ), ASLToATL ( _x select 1 ), ( _x select 2 )];
		
		false
	} count T8U_var_DEBUG_darwLines;	
};

[ "empty", "onEachFrame", "T8U_fnc_DEBUG_darwLines" ] call BIS_fnc_addStackedEventHandler;	
