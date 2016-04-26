/*
 =======================================================================================================================

	T8 Units Script
	
	Funktion:	fn_hint.sqf
	Author:		T-800a
	E-Mail:		t-800a@gmx.net

 =======================================================================================================================
*/

#include <..\MACRO.hpp>

private [ "_text" ];

_text = param [ 0, "", [""]];

hint parseText format [ "<t size='1' color='#FE9A2E' align='right'>[ T8 Units ]</t><br /><t size='1.2' color='#FE9A2E' align='left'>%1</t>", _text ];
