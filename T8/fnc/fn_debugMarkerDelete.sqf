/*
 =======================================================================================================================

	T8 Units Script
	
	Funktion:	fn_debugMarkerDelete.sqf
	Author:		T-800a
	E-Mail:		t-800a@gmx.net
	
 =======================================================================================================================
*/

#include <..\MACRO.hpp>

if ( !T8U_var_DEBUG_marker ) exitWith {};

while { true } do
{
	sleep 30;
	{
		private [ "_s" ];
		_s = true;
		
		if (( getMarkerPos ( _x select 0 )) isEqualTo [0,0,0]) then { T8U_var_DebugMarkerCache = T8U_var_DebugMarkerCache - _x; _s = false; };
		
		if ( _s AND { ( _x select 1 ) < ( time - 120 ) } ) then
		{
			deleteMarker ( _x select 0 );
			T8U_var_DebugMarkerCache = T8U_var_DebugMarkerCache - _x;
		};
	} count T8U_var_DebugMarkerCache;
};