/*
 =======================================================================================================================

	T8 Units Script

	Funktion:	fn_createWaypointPositions.sqf
	Author:		T-800a
	E-Mail:		t-800a@gmx.net

		Dem Mathe :/

		punkt px um punkt ox drehen
		p'x = cos(theta) * (px-ox) - sin(theta) * (py-oy) + ox
		p'y = sin(theta) * (px-ox) + cos(theta) * (py-oy) + oy

		X^2/a^2+Y^2/b^2
		is less than 1, the point P lies inside the ellipse. If it equals 1, it is right on
		the ellipse. If it is greater than 1, P is outside.

 =======================================================================================================================
*/

#include <..\MACRO.hpp>

params [
	[ "_marker", "NO-MARKER-SET", [""]],
	[ "_infGroup", true, [true]],
	[ "_useRoad", false, [true]],
	[ "_inside", true, [true]],
	[ "_PatrolAroundDis", T8U_var_PatAroundRange, [123]],
	[ "_startAngle", 0, [123]]
];

if (( getMarkerPos _marker ) isEqualTo [0,0,0]) exitWith { if ( T8U_var_DEBUG ) then { [ "fn_createWaypointPositions.sqf", "NO MARKER", _this ] spawn T8U_fnc_DebugLog; }; false };

__DEBUG( __FILE__, "INIT", _this );
__DEBUG( __FILE__, "INIT > START TIME", diag_tickTime );

private _maxRunTime	= ( diag_tickTime + 10.0 );

private _centerX	= ( getMarkerPos _marker ) select 0;
private _centerY	= ( getMarkerPos _marker ) select 1;
private _areaSizeX	= ( getMarkerSize _marker ) select 0;
private _areaSizeY	= ( getMarkerSize _marker ) select 1;
private _markerDir	= ( markerDir _marker ) * ( -1);
private _angleNew	= _startAngle + 181;

private _markerShape = toUpper ( markershape _marker );

if ( _areaSizeX < 40 ) then { _areaSizeX = 40; };
if ( _areaSizeY < 40 ) then { _areaSizeY = 40; };

private _maxDistance = if ( _inside ) then { _areaSizeX - ( _areaSizeX * 0.2 )} else { _areaSizeX + _PatrolAroundDis };
private _wpCount = if ( _infGroup ) then { 5 + ( floor ( random 4 )) + ( floor ((( _areaSizeX + _areaSizeY ) / 2 ) / 100 ))} else { 4 + ( floor ((( _areaSizeX + _areaSizeY ) / 2 ) / 100 ))};
private _angle = ( 360 / ( _wpCount - 1 ) );
private _wpArray = [];
private _return = [];


switch ( _markerShape ) do
{
	case "RECTANGLE":
	{
		while { count _wpArray < _wpCount } do
		{
			private [ "_x", "_y", "_wpPos", "_wpPosFEP", "_tmpMaxDist", "_loop", "_toClose", "_loopI", "_cX", "_cY", "_n" ];

			
			_tmpMaxDist = ( _areaSizeX + _areaSizeY ) / 5;
			_wpPosFEP = [];
			_loop = true;
			_n = 0;

			if ( _inside ) then
			{
				while { _loop } do
				{
					_toClose = false;
					
					_x = _centerX - ( _areaSizeX - 10 ) + random ( ( _areaSizeX - 10 ) * 2 );
					_y = _centerY - ( _areaSizeY - 10 ) + random ( ( _areaSizeY - 10 ) * 2 );
					_cX	= cos ( _markerDir ) * ( _x - _centerX ) - sin ( _markerDir ) * ( _y - _centerY ) + _centerX;
					_cY = sin ( _markerDir ) * ( _x - _centerX ) + cos ( _markerDir ) * ( _y - _centerY ) + _centerY;
					_wpPos = [ _cX, _cY ];
					_loopI = true;

					_wpPosFEP = [ _wpPos, _maxDistance, _useRoad ] call T8U_fnc_findEmptyPos;

					if ( count _wpArray > 1 ) then
					{
						{
							if ( count _x > 0 AND { ( _wpPos distance _x ) < ( _areaSizeX + _areaSizeY ) / 5 } ) then { _toClose = true; };
						} forEach _wpArray;
					};
					
					if ( count _wpPosFEP > 1 AND { !surfaceIsWater _wpPos } AND { !_toClose }) then { _loop = false; };
					_n = _n + 1; if ( _n > 100 ) then { _loop = false; };
					_toClose = false;
				};
			} else {

				private [ "_areaSizeXT", "_areaSizeYT" ];
				_areaSizeXT = _areaSizeX + _PatrolAroundDis;
				_areaSizeYT = _areaSizeY + _PatrolAroundDis;
			
				while { _loop } do
				{
					
					_x = _centerX - ( sin _angleNew * _tmpMaxDist );
					_y = _centerY - ( cos _angleNew * _tmpMaxDist );

					_cX	= cos ( _markerDir ) * ( _x - _centerX ) - sin ( _markerDir ) * ( _y - _centerY ) + _centerX;
					_cY = sin ( _markerDir ) * ( _x - _centerX ) + cos ( _markerDir ) * ( _y - _centerY ) + _centerY;					
					
					_wpPos = [ _cX, _cY ];

					_wpPosFEP = [ _wpPos, _maxDistance, _useRoad ] call T8U_fnc_findEmptyPos;
				
					if ( ( ( _x < _centerX - _areaSizeXT OR _x > _centerX + _areaSizeXT ) OR ( _y < _centerY - _areaSizeYT OR _Y > _centerY + _areaSizeYT ) ) AND { ! ( surfaceIsWater _wpPos ) } AND { count _wpPosFEP > 0 } ) then { _loop = false; } else { _tmpMaxDist = _tmpMaxDist + 10; };
					if ( _tmpMaxDist > ( _areaSizeXT + _areaSizeYT ) * 1.15 ) then { _wpPosFEP = []; _loop = false; };
				};				
			};
			
			_angleNew = _angleNew + _angle;
			if ( str ( _wpPosFEP ) == str ([0.5,0.5,0]) ) then { _wpPosFEP = [] };
			
			if ( _useRoad ) then { if ( isOnRoad _wpPosFEP ) then { _wpArray pushBack _wpPosFEP; }; } else { _wpArray pushBack _wpPosFEP; };			
			if ( diag_tickTime > _maxRunTime ) exitWith { __DEBUG( __FILE__, "RUN TIME VIOLATION", diag_tickTime ); };
		};
	};

	case "ELLIPSE":
	{
		private [ "_lastPos", "_n" ];
		_lastPos = getMarkerPos _marker;
		_n = 0;

		while { count _wpArray < _wpCount } do
		{
			private [ "_x", "_y", "_wpPos", "_wpPosFEP", "_loop", "_toClose", "_loopI", "_cX", "_cY", "_tmpMaxDist" ];

			_tmpMaxDist = ( _areaSizeX + _areaSizeY ) / 5;
			_wpPosFEP = [];			
			_loop = true;
			_loopI = true;

			if ( _inside ) then
			{
				while { _loop } do
				{
					_toClose = false;
					
					while { _loopI } do
					{
						private [ "_in", "_dX", "_dY" ];
						_x = _centerX - _areaSizeX + random ( _areaSizeX * 2 );
						_y = _centerY - _areaSizeY + random ( _areaSizeY * 2 );
						_dX = abs ( _x - _centerX );
						_dY = abs ( _y - _centerY );

						_in = (( _dX *_dX ) / ( _areaSizeX * _areaSizeX )) + (( _dY * _dY ) / ( _areaSizeY * _areaSizeY ));

						if ( _in <= 1 ) then
						{
							_cX	= cos ( _markerDir ) * ( _x - _centerX ) - sin ( _markerDir ) * ( _y - _centerY ) + _centerX;
							_cY = sin ( _markerDir ) * ( _x - _centerX ) + cos ( _markerDir ) * ( _y - _centerY ) + _centerY;
							if !( surfaceIsWater [ _cX, _cY ] ) then { _loopI = false; };
						};
					};
					
					_wpPos = [ _cX, _cY ];
					_loopI = true;

					_wpPosFEP = [ _wpPos, _maxDistance, _useRoad ] call T8U_fnc_findEmptyPos;

					if ( count _wpArray > 1 ) then
					{
						{
							if ( count _x > 0 AND { ( _wpPos distance _x ) < ( _areaSizeX + _areaSizeY ) / 5 } ) then { _toClose = true; };
						} forEach _wpArray;
					};
					if ( count _wpPosFEP > 1 AND { !_toClose } ) then { _loop = false; };
					_n = _n + 1; if ( _n > 100 ) then { _loop = false; };
				};

				_lastPos = _wpPosFEP;
				
				if ( _useRoad ) then { if ( isOnRoad _wpPosFEP ) then { _wpArray pushBack _wpPosFEP; }; } else { _wpArray pushBack _wpPosFEP; };
					
			} else {
				
				while { _loop } do
				{
					private [ "_in", "_out", "_dX", "_dY", "_mod", "_areaSizeXT", "_areaSizeYT" ];

					_mod = _PatrolAroundDis;

					_x = _centerX - ( sin _angleNew * _tmpMaxDist );
					_y = _centerY - ( cos _angleNew * _tmpMaxDist );
					
					_dX = _x - _centerX;
					_dY = _y - _centerY;
					_areaSizeXT = _areaSizeX + _PatrolAroundDis;
					_areaSizeYT = _areaSizeY + _PatrolAroundDis;
//					_in = (( _dX *_dX ) / ( _areaSizeXT * _areaSizeXT)) + (( _dY * _dY ) / ( _areaSizeYT * _areaSizeYT));
					_out = (( _dX *_dX ) / ( _areaSizeXT * _areaSizeXT)) + (( _dY * _dY ) / ( _areaSizeYT * _areaSizeYT));

					_cX	= cos ( _markerDir ) * ( _x - _centerX ) - sin ( _markerDir ) * ( _y - _centerY ) + _centerX;
					_cY = sin ( _markerDir ) * ( _x - _centerX ) + cos ( _markerDir ) * ( _y - _centerY ) + _centerY;
					
					_wpPos = [ _cX, _cY ];
						
					if ( _out > 1 ) then { _loop = false; };  
	
					_tmpMaxDist = _tmpMaxDist + 10;
				};
				
				if ( ! surfaceIsWater _wpPos ) then 
				{ 
					_wpPosFEP = [ _wpPos, _maxDistance, _useRoad ] call T8U_fnc_findEmptyPos;
					
					_wpArray pushBack _wpPosFEP;
				} else {
					_wpArray pushBack [];
				};
			};
			
			_angleNew = _angleNew + _angle;
			if ( diag_tickTime > _maxRunTime ) exitWith { __DEBUG( __FILE__, "RUN TIME VIOLATION", diag_tickTime ); };
		};
	};

	case "ICON":
	{
		while { count _wpArray < _wpCount } do
		{
			private [ "_x", "_y", "_wpPos", "_wpPosFEP", "_loop", "_tmpMaxDist", "_a" ];

			_wpPosFEP = [];
			_loop = true;
			_a = true;
			_tmpMaxDist = _maxDistance;

			while { _loop } do
			{
				_x = _centerX - ( sin _angleNew * _tmpMaxDist );
				_y = _centerY - ( cos _angleNew * _tmpMaxDist );
				_wpPos = [ _x, _y ];

				_wpPosFEP = [ _wpPos, _maxDistance, _useRoad ] call T8U_fnc_findEmptyPos;

				if ( surfaceIsWater _wpPos OR { count _wpPosFEP < 2 } ) then
				{
					if ( _a ) then { _tmpMaxDist = _tmpMaxDist / 2; _a = false; } else { _tmpMaxDist = _tmpMaxDist + 10;  };
				} else { _loop = false; _a = true; };

				if ( _tmpMaxDist > _maxDistance * 2 ) then { _loop = false; _a = true; _wpPosFEP = []; };
			};

			_angleNew = _angleNew + _angle;
			
			_wpArray pushBack _wpPosFEP;
			
			if ( diag_tickTime > _maxRunTime ) exitWith { __DEBUG( __FILE__, "RUN TIME VIOLATION", diag_tickTime ); };
		};
	};
};


__DEBUG( __FILE__, "CREATED: _wpArray", _wpArray );

// 50/50 chance of switching positons from first to last ... patrols can be with and against the clock
if ( 50 < random 100 ) then 
{
	private [ "_i", "_n", "_newArray", "_newElement" ];
	_i = 0; 
	_newArray = [];
	_n = count _wpArray;
	while { _i < _n } do { _newElement = _wpArray call BIS_fnc_arrayPop; _i = _i + 1; _newArray = _newArray + [ _newElement ]; };
	_wpArray = _newArray;
	
	__DEBUG( __FILE__, "SHIFTED: _wpArray", _wpArray );
};


_wpArray = _wpArray - [];
{ if !( _x in _return ) then { _return pushBack _x; }; false } count _wpArray;

__DEBUG( __FILE__, "FINAL: _wpArray", _wpArray );

// RETURN
_return
