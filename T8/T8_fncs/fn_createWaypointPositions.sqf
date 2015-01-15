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

private [	"_marker", "_infGroup", "_inside", "_useRoad", "_centerX", "_centerY", "_areaSizeX", "_areaSizeY", "_markerShape", "_maxDistance",
			"_chkV", "_wpCount", "_angle", "_wpArray", "_markerDir" ];

_marker		= [ _this, 0, "NO-MARKER-SET", [ "" ] ] call BIS_fnc_param;
_infGroup	= [ _this, 1, true, [ true ] ] call BIS_fnc_param;
_useRoad	= [ _this, 2, false, [ true ] ] call BIS_fnc_param;
_inside		= [ _this, 3, true, [ true ] ] call BIS_fnc_param;

if ( str ( getMarkerPos _marker ) == str ([0,0,0]) ) exitWith { if ( T8U_var_DEBUG ) then { [ "fn_createWaypointPositions.sqf", "NO MARKER", _this ] spawn T8U_fnc_DebugLog; }; false };
if ( T8U_var_DEBUG ) then { [ "fn_createWaypointPositions.sqf", "EXEC", _this ] spawn T8U_fnc_DebugLog; };

if ( _infGroup ) then { _chkV = "CAManBase"; } else { _chkV = "B_Truck_01_covered_F"; };

_centerX	= ( getMarkerPos _marker ) select 0;
_centerY	= ( getMarkerPos _marker ) select 1;
_areaSizeX	= ( getMarkerSize _marker ) select 0;
_areaSizeY	= ( getMarkerSize _marker ) select 1;
_markerDir	= ( markerDir _marker ) * ( -1);

_markerShape = toUpper ( markershape _marker );

if ( _areaSizeX < 40 ) then { _areaSizeX = 40; };
if ( _areaSizeY < 40 ) then { _areaSizeY = 40; };

if ( _inside ) then { _maxDistance = _areaSizeX - ( _areaSizeX * 0.2 ); } else { _maxDistance = _areaSizeX + T8U_var_PatAroundRange; };

_wpCount = 5 + ( floor ( random 4 ) ) + ( floor ( ( ( _areaSizeX + _areaSizeY ) / 2 ) / 100 ) );
_angle = ( 360 / ( _wpCount - 1 ) );
_wpArray = [];

switch ( _markerShape ) do
{
	case "RECTANGLE":
	{
		while { count _wpArray < _wpCount } do
		{
			private [ "_x", "_y", "_wpPos", "_wpPosFEP", "_angleNew", "_tmpMaxDist", "_loop", "_toClose", "_loopI", "_cX", "_cY", "_n" ];

			_angleNew = count _wpArray * _angle;
			_tmpMaxDist = ( _areaSizeX + _areaSizeY ) / 5;
			_toClose = false;
			_loop = true;
			_n = 0;

			if ( _inside ) then
			{
				while { _loop } do
				{
					_x = _centerX - ( _areaSizeX - 10 ) + random ( ( _areaSizeX - 10 ) * 2 );
					_y = _centerY - ( _areaSizeY - 10 ) + random ( ( _areaSizeY - 10 ) * 2 );
					_cX	= cos ( _markerDir ) * ( _x - _centerX ) - sin ( _markerDir ) * ( _y - _centerY ) + _centerX;
					_cY = sin ( _markerDir ) * ( _x - _centerX ) + cos ( _markerDir ) * ( _y - _centerY ) + _centerY;
					_wpPos = [ _cX, _cY ];
					_loopI = true;

					if ( _useRoad ) then
					{
						_roadObj = [ _wpPos, ( _maxDistance / 4 ) ] call BIS_fnc_nearestRoad;
						_wpPosFEP = ( getpos _roadObj ) findEmptyPosition [ 1, 20, _chkV ];
					} else {
						_wpPosFEP = _wpPos findEmptyPosition [ 1, 20, _chkV ];
					};

					if ( count _wpArray > 1 ) then
					{
						{
							if ( count _x > 0 AND { ( _wpPos distance _x ) < ( _areaSizeX + _areaSizeY ) / 5 } ) then { _toClose = true; };
						} forEach _wpArray;
					};
					if ! ( surfaceIsWater _wpPos OR { _toClose } OR { count _wpPosFEP < 2 } ) then { _loop = false; };
					_n = _n + 1; if ( _n > 100 ) then { _loop = false; };
					_toClose = false;
				};
			} else {
			
				while { _loop } do
				{
					_x = _centerX - ( sin _angleNew * _tmpMaxDist );
					_y = _centerY - ( cos _angleNew * _tmpMaxDist );

					_cX	= cos ( _markerDir ) * ( _x - _centerX ) - sin ( _markerDir ) * ( _y - _centerY ) + _centerX;
					_cY = sin ( _markerDir ) * ( _x - _centerX ) + cos ( _markerDir ) * ( _y - _centerY ) + _centerY;					
					
					_wpPos = [ _cX, _cY ];

					if ( _useRoad ) then
					{
						_roadObj = [ _wpPos, ( _maxDistance / 4 ) ] call BIS_fnc_nearestRoad;
						_wpPosFEP = ( getpos _roadObj ) findEmptyPosition [ 1, 20, _chkV ];
					} else {
						_wpPosFEP = _wpPos findEmptyPosition [ 1, 20, _chkV ];
					};
				
					if ( ( ( _x < _centerX - _areaSizeX OR _x > _centerX + _areaSizeX ) OR ( _y < _centerY - _areaSizeY OR _Y > _centerY + _areaSizeY ) ) AND { ! ( surfaceIsWater _wpPos ) } AND { count _wpPosFEP > 0 } ) then { _loop = false; } else { _tmpMaxDist = _tmpMaxDist + 20; };
					if ( _tmpMaxDist > ( _areaSizeX + _areaSizeY ) * 1.15 ) then { _wpPosFEP = []; _loop = false; };
				};				
			};
			
			if ( str ( _wpPosFEP ) == str ([0.5,0.5,0]) ) then { _wpPosFEP = [] };
			
			_wpArray pushBack _wpPosFEP;
		};
	};

	case "ELLIPSE":
	{
		private [ "_lastPos", "_n" ];
		_lastPos = getMarkerPos _marker;
		_n = 0;

		while { count _wpArray < _wpCount } do
		{
			private [ "_x", "_y", "_wpPos", "_wpPosFEP", "_loop", "_toClose", "_loopI", "_cX", "_cY", "_angleNew", "_tmpMaxDist" ];

			_angleNew = count _wpArray * _angle;
			_tmpMaxDist = ( _areaSizeX + _areaSizeY ) / 5;
			
			_loop = true;
			_toClose = false;
			_loopI = true;

			if ( _inside ) then
			{
				while { _loop } do
				{				
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

					if ( _useRoad ) then
					{
						_roadObj = [ _wpPos, ( _maxDistance / 4 ) ] call BIS_fnc_nearestRoad;
						_wpPosFEP = ( getpos _roadObj ) findEmptyPosition [ 1, 20, _chkV ];
					} else {
						_wpPosFEP = _wpPos findEmptyPosition [ 1, 20, _chkV ];
					};

					if ( count _wpArray > 1 ) then
					{
						{
							if ( count _x > 0 AND { ( _wpPos distance _x ) < ( _areaSizeX + _areaSizeY ) / 5 } ) then { _toClose = true; };
						} forEach _wpArray;
					};
					if ! (  count _wpPosFEP < 2 OR { _toClose } ) then { _loop = false; };
					_n = _n + 1; if ( _n > 100 ) then { _loop = false; };
					_toClose = false;
				};

				_lastPos = _wpPosFEP;
				_wpArray pushBack _wpPosFEP;					
					
			} else {
				
				while { _loop } do
				{
					private [ "_in", "_out", "_dX", "_dY", "_mod", "_areaSizeXT", "_areaSizeYT" ];

					_mod = T8U_var_PatAroundRange;

					_x = _centerX - ( sin _angleNew * _tmpMaxDist );
					_y = _centerY - ( cos _angleNew * _tmpMaxDist );
					
					_dX = _x - _centerX;
					_dY = _y - _centerY;
					_areaSizeXT = _areaSizeX + T8U_var_PatAroundRange;
					_areaSizeYT = _areaSizeY + T8U_var_PatAroundRange;
//					_in = (( _dX *_dX ) / ( _areaSizeXT * _areaSizeXT)) + (( _dY * _dY ) / ( _areaSizeYT * _areaSizeYT));
					_out = (( _dX *_dX ) / ( _areaSizeX * _areaSizeX )) + (( _dY * _dY ) / ( _areaSizeY * _areaSizeY ));

					_cX	= cos ( _markerDir ) * ( _x - _centerX ) - sin ( _markerDir ) * ( _y - _centerY ) + _centerX;
					_cY = sin ( _markerDir ) * ( _x - _centerX ) + cos ( _markerDir ) * ( _y - _centerY ) + _centerY;
					
					_wpPos = [ _cX, _cY ];
						
					if ( _out > 1 ) then { _loop = false; };  
	
					_tmpMaxDist = _tmpMaxDist + 20;
				};
				
				if ( ! surfaceIsWater _wpPos ) then 
				{ 
					if ( _useRoad ) then
					{
						_roadObj = [ _wpPos, ( _maxDistance / 4 ) ] call BIS_fnc_nearestRoad;
						_wpPosFEP = ( getpos _roadObj ) findEmptyPosition [ 1, 20, _chkV ];
					} else {
						_wpPosFEP = _wpPos findEmptyPosition [ 1, 20, _chkV ];
					};
					_wpArray pushBack _wpPosFEP;
				} else {
					_wpArray pushBack [];
				};
			};
		};
	};

	case "ICON":
	{
		while { count _wpArray < _wpCount } do
		{
			private [ "_angleNew", "_x", "_y", "_wpPos", "_wpPosFEP", "_loop", "_tmpMaxDist", "_a" ];

			_angleNew = count _wpArray * _angle;
			_loop = true;
			_a = true;
			_tmpMaxDist = _maxDistance;

			while { _loop } do
			{
				_x = _centerX - ( sin _angleNew * _tmpMaxDist );
				_y = _centerY - ( cos _angleNew * _tmpMaxDist );
				_wpPos = [ _x, _y ];

				if ( _useRoad ) then
				{
					_roadObj = [ _wpPos, ( _maxDistance / 4 ) ] call BIS_fnc_nearestRoad;
					_wpPosFEP = ( getpos _roadObj ) findEmptyPosition [ 1, 20, _chkV ];
				} else {
					_wpPosFEP = _wpPos findEmptyPosition [ 1, 20, _chkV ];
				};

				if ( surfaceIsWater _wpPos OR { count _wpPosFEP < 2 } ) then
				{
					if ( _a ) then { _tmpMaxDist = _tmpMaxDist / 2; _a = false; } else { _tmpMaxDist = _tmpMaxDist + 10;  };
				} else { _loop = false; _a = true; };

				if ( _tmpMaxDist > _maxDistance * 2 ) then { _loop = false; _a = true; _wpPosFEP = []; };
			};

			_wpArray pushBack _wpPosFEP;
		};
	};
};

if ( T8U_var_DEBUG ) then { [ "fn_createWaypointPositions.sqf", "_wpArray", [ _wpArray, count _wpArray] ] spawn T8U_fnc_DebugLog; };

// 50/50 chance of switching positons from first to last ... patrols can be with and against the clock
if ( 50 < random 100 ) then 
{
	private [ "_i", "_n", "_newArray", "_newElement" ];
	_i = 0; 
	_newArray = [];
	_n = count _wpArray;
	while { _i < _n } do { _newElement = _wpArray call BIS_fnc_arrayPop; _i = _i + 1; _newArray = _newArray + [ _newElement ]; };
	_wpArray = _newArray;
	if ( T8U_var_DEBUG ) then { [ "fn_createWaypointPositions.sqf", "SHIFTED _wpArray", [ _wpArray, count _wpArray] ] spawn T8U_fnc_DebugLog; };
};

// check if Last Element Already exists - seems to be a circle problem dunno
private [ "_ln" ];
_ln = _wpArray call BIS_fnc_arrayPop;
if !( _ln in _wpArray ) then { _wpArray pushBack _ln; };

if ( T8U_var_DEBUG ) then { [ "fn_createWaypointPositions.sqf", "FINISHED _wpArray", [ _wpArray, count _wpArray] ] spawn T8U_fnc_DebugLog; };

// RETURN
_wpArray
