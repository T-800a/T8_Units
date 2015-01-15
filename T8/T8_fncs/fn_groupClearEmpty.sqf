/*
 =======================================================================================================================

	T8 Units Script

	Funktion:	fn_groupClearEmpty.sqf
	Author:		T-800a
	E-Mail:		t-800a@gmx.net

 =======================================================================================================================
*/

private [ "_grpIgnore" ];

_grpIgnore = [];

while { true } do
{
	sleep 30;
	
	_grpIgnore = _grpIgnore - [ grpNull ];
	
	{
		private [ "_g" ];
		_g = _x;

		if ( !( _g in _grpIgnore ) AND { ( count units _g ) < 1 } ) then
		{
			private [ "_check" ];
			
			if ( T8U_var_DEBUG ) then { [ "fn_groupClearEmpty.sqf", "GROUP ADDED TO QUEUE", [ _g ] ] spawn T8U_fnc_DebugLog; };
			
			_grpIgnore pushBack _g;			
			
			//  _group setVariable ["DAC_Excluded", True];   true = nicht mehr im DAC ... false = im DAC ... nil könnte gelöscht werden
			_check = _g getVariable [ "DAC_Excluded", "deletethis" ];
			
			if ( typeName _check == typeName "deletethis" ) then
			{
				if ( !isNull _g ) then 
				{
					[ _g ] spawn
					{
						private [ "_g" ];
						_g = _this select 0;
						sleep 20;
						if ( T8U_var_DEBUG ) then { [ "fn_groupClearEmpty.sqf", "GROUP DELETED", [ _g ] ] spawn T8U_fnc_DebugLog; };
						if ( isNull _g ) exitWith {};
						deleteGroup _g;
					};
				};
			};
		};
	} forEach allGroups;
};
