/*
 =======================================================================================================================

	T8 Units Script
	
	Funktion:	fn_trackAllUnits.sqf
	Author:		T-800a
	E-Mail:		t-800a@gmx.net

 =======================================================================================================================
*/

private [ "_mA" ];

_mA = [];

while {true} do 
{
	waitUntil { sleep 1; visibleMap };

	{
		private [ "_mN", "_m" ];
		_mN = format [ "unitMkr_%1", _x ];
		_m = createMarkerLocal [ _mN, getPos _x ];
		_m setMarkerShapeLocal "ICON";
		_m setMarkerTypeLocal "mil_triangle";
		_m setMarkerSizeLocal [ 0.5, 0.5 ];
		_m setMarkerColorLocal "ColorYellow";
		_mA set [count _mA, [ _m, _x ] ];
	} forEach allUnits;
			
	while { visibleMap } do
	{
		{
			private [ "_m", "_u" ];
			
			_m = _x select 0;
			_u = _x select 1;
			
			if ( ! isNil "_u" AND { ! isNull _u } ) then 
			{
				_m setMarkerPosLocal ( getPos _u );
				_m setMarkerDirLocal ( getDir _u );
			};
			
			if ( ! alive _u ) then 
			{
				_m setMarkerColorLocal "ColorBlack";
				_m setMarkerAlphaLocal 0.5;
			};			
			
		} forEach _mA;
		
		if ( !visibleMap ) exitWith {};
		
		sleep 0.1;
	};
	
	{ deleteMarkerLocal ( _x select 0 ); } forEach _mA;
	
	_mA = [];
};