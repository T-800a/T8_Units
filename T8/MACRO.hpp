/*
 =======================================================================================================================

	T8 Units Script

	File:		MACRO.hpp
	Author:		T-800a
	E-Mail:		t-800a@gmx.net
	
	Open < T8\CONFIG.hpp > to change basic variables !

 =======================================================================================================================
*/

// uncomment to null-out DEBUG macro parsing
// #define __DEBUG(NAME,TEXT,VAR)
#define __DEBUG(NAME,TEXT,VAR)			if ( T8U_var_DEBUG ) then { [NAME,TEXT,VAR] call T8U_fnc_debugLog; }

#define __allowEXEC(VAR)				if ( VAR call T8U_fnc_checkEXEC ) exitWith {}

#define __GetMVAR(VAR,VAL)				missionNamespace getVariable [ VAR, VAL ]
#define __GetOVAR(OBJ,VAR,VAL)			OBJ getVariable [ VAR, VAL ]

#define __SetMVAR(VAR,VAL)				missionNamespace setVariable [ VAR, VAL, false ]
#define __SetMVARG(VAR,VAL)				missionNamespace setVariable [ VAR, VAL, true ]
#define __SetOVAR(OBJ,VAR,VAL)			OBJ setVariable [ VAR, VAL, false ]
#define __SetOVARG(OBJ,VAR,VAL)			OBJ setVariable [ VAR, VAL, true ]