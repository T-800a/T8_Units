/*
 =======================================================================================================================

	T8 Units Script

	Funktion:	fn_groupRegroup.sqf
	Author:		T-800a
	E-Mail:		t-800a@gmx.net
	
	NYI

 =======================================================================================================================
*/

#include <..\MACRO.hpp>

private [ "_group", "_pos" ];

_group		= param [ 0, grpNull, [grpNull]];
_pos		= getPos ( leader _group );

__DEBUG( __FILE__, "INIT", _this );
if ( isNull _group ) exitWith { false };


{ [ _x ] joinSilent _group } forEach ( units _group );
__DEBUG( __FILE__, "REGROUP DONE", _group );

// ReturnValue
_group
