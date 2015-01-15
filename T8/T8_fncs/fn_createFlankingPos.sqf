/*
 =======================================================================================================================

	T8 Units Script

	Funktion:	fn_createFlankingPos.sqf
	Author:		T-800a
	E-Mail:		t-800a@gmx.net

 =======================================================================================================================
*/

private [	"_unitCaller", "_unitTarget", "_cPos", "_tPos", "_hyp", "_cX", "_cY", "_tX", "_tY", "_katA", "_katG", "_mX", "_mY", "_aBase", "_switch", "_aReel", 
			"_aReelFP_A", "_aReelFP_B", "_oX_A", "_oY_A", "_oX_B", "_oY_B", "_fpX_A", "_fpY_A", "_fpX_B", "_fpY_B", "_flankingPos", "_loop", "_tmpAreaSize", "_flankingPosArray" ];

_unitCaller			= [ _this, 0, objNull, [objNull,[]], [2,3] ] call BIS_fnc_param;
_unitTarget			= [ _this, 1, objNull, [objNull,[]], [2,3] ] call BIS_fnc_param;
_modHyp				= [ _this, 2, 1, [123] ] call BIS_fnc_param;

_flankingPosArray	= [];

if ( typeName _unitCaller != "ARRAY" AND { isNull _unitCaller } ) exitWith { if ( T8U_var_DEBUG ) then { [ "fn_createFlankingPos.sqf", "INPUT Missing", _this ] spawn T8U_fnc_DebugLog; }; false };
if ( typeName _unitTarget != "ARRAY" AND { isNull _unitTarget } ) exitWith { if ( T8U_var_DEBUG ) then { [ "fn_createFlankingPos.sqf", "INPUT Missing", _this ] spawn T8U_fnc_DebugLog; }; false };

if ( typeName _unitCaller == "ARRAY" ) then { _cPos = _unitCaller; } else { _cPos = getPos _unitCaller; };
if ( typeName _unitTarget == "ARRAY" ) then { _tPos = _unitTarget; } else { _tPos = getPos _unitTarget; };

_hyp = _unitCaller distance _unitTarget;
if ( _hyp > 250 ) then { _hyp = 250; };
if ( _hyp < 25 ) then { _hyp = 25; };
_hyp = _hyp * _modHyp;

_cX = _cPos select 0;
_cY = _cPos select 1;

_tX = _tPos select 0;
_tY = _tPos select 1;

_katA = _tX - _cX;
_katG = _tY - _cY;

if ( _katA < 0 ) then { _mX = -1; _katA = _katA * -1; } else { _mX = 1; };
if ( _katG < 0 ) then { _mY = -1; _katG = _katG * -1; } else { _mY = 1; };

_aBase = atan ( _katG / _katA );

_switch = format [ "[%1|%2]", _mX, _mY ];
_aReel = switch ( _switch ) do
{
	case "[1|1]":	{ _aBase };
	case "[-1|1]":	{ 180 - _aBase };
	case "[-1|-1]":	{ 180 + _aBase };
	case "[1|-1]":	{ 360 - _aBase };
};

_aReelFP_A = _aReel + 90;
_aReelFP_B = _aReel - 90;

_oX_A = ( ( cos _aReelFP_A ) * _hyp );
_oY_A = ( ( sin _aReelFP_A ) * _hyp );

_oX_B = ( ( cos _aReelFP_B ) * _hyp );
_oY_B = ( ( sin _aReelFP_B ) * _hyp );

_fpX_A = _tX + _oX_A;
_fpY_A = _tY + _oY_A;

_fpX_B = _tX + _oX_B;
_fpY_B = _tY + _oY_B;

_flankingPos_A = [ _fpX_A, _fpY_A ];
_flankingPos_B = [ _fpX_B, _fpY_B ];

{
	private [ "_loop", "_tmpAreaSize", "_fp", "_fpFEP" ];

	_loop			= true;
	_tmpAreaSize	= 5;
	
	while { _loop } do
	{
		_fp = [  _x, _tmpAreaSize, random 360 ] call BIS_fnc_relPos;
		_fpFEP = _fp findEmptyPosition [ 1, 20, "B_Truck_01_covered_F" ];
		if ( count _fpFEP < 1 OR { surfaceIsWater _fpFEP } ) then { _tmpAreaSize = _tmpAreaSize + 5; } else { _loop = false; };
	};
	
	_flankingPosArray pushBack _fpFEP;
	
} forEach [ _flankingPos_A, _flankingPos_B ];

// Return Value
_flankingPosArray
