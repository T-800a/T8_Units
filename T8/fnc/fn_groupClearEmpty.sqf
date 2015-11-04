/*
 =======================================================================================================================

	T8 Units Script

	Funktion:	fn_groupClearEmpty.sqf
	Author:		T-800a
	E-Mail:		t-800a@gmx.net

	+----- DAC & Groups ----------------------------------------------------------------------------------------------+
	_group setVariable ["DAC_Excluded", True];
		true		=> will be reused  by DAC
		false	=> currently in use by DAC
		nil		=> can be deleted safely

 =======================================================================================================================
*/

#include <..\MACRO.hpp>

while { true } do
{
	sleep 30;
	
	{
		if (( count units _x ) <= 0 AND { ( _x getVariable [ "DAC_Excluded", "RM" ] ) == "RM" } ) then
		{
			if ( T8U_var_DEBUG ) then { [ "fn_groupClearEmpty.sqf", "GROUP DELETED", [ _x ] ] spawn T8U_fnc_DebugLog; };
			deleteGroup _x;
			sleep 0.5;
		}
	} count allGroups;
};
